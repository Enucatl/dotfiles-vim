#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path
from urllib import error, request

DEFAULT_ENDPOINT = "https://camillo.docker.home.arpa/ingest"
DEFAULT_TIMEOUT_MS = 1500


def main() -> int:
    payload = load_json_stdin()
    if not payload:
        return 0

    event_name = str(payload.get("hook_event_name") or "")
    if event_name == "UserPromptSubmit":
        capture_prompt(payload)
        return 0
    if event_name == "Stop":
        post_completed_turn(payload)
        return 0
    return 0


def load_json_stdin() -> dict[str, object]:
    raw = sys.stdin.read().strip()
    if not raw:
        return {}
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return {}
    return data if isinstance(data, dict) else {}


def capture_prompt(payload: dict[str, object]) -> None:
    turn_id = str(payload.get("turn_id") or "").strip()
    prompt = str(payload.get("prompt") or "").strip()
    if not turn_id or not prompt:
        return

    state_dir = state_root() / "pending"
    state_dir.mkdir(parents=True, exist_ok=True)
    record = {
        "session_id": str(payload.get("session_id") or "").strip(),
        "turn_id": turn_id,
        "prompt": prompt,
        "cwd": str(payload.get("cwd") or "").strip(),
        "captured_at": int(time.time()),
    }
    write_json_atomically(state_dir / f"{turn_id}.json", record)


def post_completed_turn(payload: dict[str, object]) -> None:
    turn_id = str(payload.get("turn_id") or "").strip()
    assistant = str(payload.get("last_assistant_message") or "").strip()
    if not turn_id or not assistant:
        return

    sent_dir = state_root() / "sent"
    sent_dir.mkdir(parents=True, exist_ok=True)
    sent_marker = sent_dir / f"{turn_id}.done"
    if sent_marker.exists():
        return

    pending_path = state_root() / "pending" / f"{turn_id}.json"
    pending = read_json(pending_path)
    if not pending:
        return

    user_prompt = str(pending.get("prompt") or "").strip()
    if not user_prompt:
        return

    session_id = str(
        payload.get("session_id") or pending.get("session_id") or ""
    ).strip()
    body = {
        "namespace": resolve_namespace(str(payload.get("cwd") or ""), pending),
        "session_id": session_id or None,
        "user_msg": user_prompt,
        "ai_msg": assistant,
    }

    try:
        response_body = post_json(resolve_endpoint(), body, timeout_ms())
    except Exception as exc:  # noqa: BLE001
        log_failure(f"camillo ingest failed for turn {turn_id}: {exc}")
        return

    write_text_atomically(sent_marker, response_body)
    try:
        pending_path.unlink()
    except FileNotFoundError:
        pass


def resolve_endpoint() -> str:
    endpoint = os.environ.get("CAMILLO_MEMORY_ENDPOINT", "").strip()
    return endpoint or DEFAULT_ENDPOINT


def timeout_ms() -> int:
    raw = os.environ.get("CAMILLO_MEMORY_TIMEOUT_MS", "").strip()
    if not raw:
        return DEFAULT_TIMEOUT_MS
    try:
        return max(250, int(raw))
    except ValueError:
        return DEFAULT_TIMEOUT_MS


def state_root() -> Path:
    base = os.environ.get("CAMILLO_MEMORY_STATE_DIR", "").strip()
    if base:
        return Path(base).expanduser()
    xdg_state = os.environ.get("XDG_STATE_HOME", "").strip()
    if xdg_state:
        return Path(xdg_state).expanduser() / "codex" / "camillo"
    return Path.home() / ".local" / "state" / "codex" / "camillo"


def resolve_namespace(cwd: str, pending: dict[str, object]) -> str:
    override = os.environ.get("CAMILLO_MEMORY_NAMESPACE", "").strip()
    if override:
        return override

    git_root = find_git_root(cwd or str(pending.get("cwd") or ""))
    if git_root is not None:
        return f"repo:{git_root.name}"

    fallback = Path(cwd).expanduser()
    return f"repo:{fallback.name or 'unknown'}"


def find_git_root(cwd: str) -> Path | None:
    if not cwd:
        return None
    try:
        completed = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=cwd,
            check=True,
            capture_output=True,
            text=True,
            timeout=1,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    root = completed.stdout.strip()
    return Path(root) if root else None


def post_json(url: str, body: dict[str, object], timeout_ms_value: int) -> str:
    data = json.dumps(body, separators=(",", ":"), ensure_ascii=True).encode("utf-8")
    req = request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    timeout_s = timeout_ms_value / 1000.0
    try:
        with request.urlopen(req, timeout=timeout_s) as resp:
            response_text = resp.read().decode("utf-8", errors="replace").strip()
            if resp.status < 200 or resp.status >= 300:
                raise RuntimeError(f"HTTP {resp.status}")
            return response_text or ""
    except error.HTTPError as exc:
        raise RuntimeError(f"HTTP {exc.code}") from exc


def read_json(path: Path) -> dict[str, object]:
    try:
        raw = path.read_text(encoding="utf-8")
    except FileNotFoundError:
        return {}
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return {}
    return data if isinstance(data, dict) else {}


def write_json_atomically(path: Path, payload: dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", dir=path.parent, delete=False
    ) as handle:
        json.dump(payload, handle, separators=(",", ":"), ensure_ascii=True)
        handle.write("\n")
        tmp_path = Path(handle.name)
    tmp_path.replace(path)


def write_text_atomically(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "w", encoding="utf-8", dir=path.parent, delete=False
    ) as handle:
        handle.write(text)
        if text and not text.endswith("\n"):
            handle.write("\n")
        tmp_path = Path(handle.name)
    tmp_path.replace(path)


def log_failure(message: str) -> None:
    digest = hashlib.sha256(message.encode("utf-8")).hexdigest()[:8]
    print(f"[camillo:{digest}] {message}", file=sys.stderr)


if __name__ == "__main__":
    raise SystemExit(main())
