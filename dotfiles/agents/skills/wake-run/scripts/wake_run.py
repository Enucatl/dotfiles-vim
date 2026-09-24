#!/usr/bin/env python3
"""Detach a long-running command and wake the originating Codex thread on exit."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import uuid
from pathlib import Path

WAKE_HEADER = "[Wake Run Result]"


def build_wake_message(
    exit_code: int | None, log_file: Path, *, launch_error: str | None = None
) -> str:
    """Summarize a completed run without issuing instructions to the agent."""
    status = "Completed" if exit_code == 0 and launch_error is None else "Failed"
    exit_text = str(exit_code) if exit_code is not None else "Not started"
    lines = [
        WAKE_HEADER,
        "",
        f"Status: {status}",
        f"Exit code: {exit_text}",
        f"Log file: {log_file}",
    ]
    if launch_error:
        lines.extend(["", f"Launch error: {launch_error}"])
    return "\n".join(lines)


def resolve_powershell() -> str:
    for candidate in ("pwsh", "powershell.exe", "powershell"):
        resolved = shutil.which(candidate)
        if resolved:
            return resolved
    raise RuntimeError("PowerShell is required to run wake-run commands on Windows.")


def resolve_codex_executable(codex_bin: str, *, platform: str | None = None) -> str:
    platform = platform or os.name
    candidate = Path(codex_bin).expanduser()
    if candidate.is_file():
        return str(candidate.resolve())
    if platform == "nt" and candidate.parent == Path(".") and not candidate.suffix:
        for suffix in (".exe", ".cmd", ".bat", ".ps1", ""):
            resolved = shutil.which(codex_bin + suffix)
            if resolved:
                return resolved
    else:
        resolved = shutil.which(codex_bin)
        if resolved:
            return resolved
    raise RuntimeError(f"Codex CLI not found: {codex_bin}")


def build_codex_invocation(
    resolved_codex: str,
    args: list[str],
    *,
    platform: str | None = None,
    powershell_bin: str | None = None,
) -> list[str]:
    platform = platform or os.name
    suffix = Path(resolved_codex).suffix.lower()
    if platform == "nt" and suffix == ".ps1":
        powershell_bin = powershell_bin or resolve_powershell()
        return [
            powershell_bin,
            "-NoLogo",
            "-NoProfile",
            "-NonInteractive",
            "-File",
            resolved_codex,
            *args,
        ]
    return [resolved_codex, *args]


def build_experiment_invocation(
    command: str, *, platform: str | None = None, powershell_bin: str | None = None
) -> list[str]:
    """Build a shell invocation that reports the command's final status."""
    platform = platform or os.name
    if platform == "nt":
        powershell_bin = powershell_bin or resolve_powershell()
        wrapped = (
            f"& {{ {command} }}; "
            "$wakeRunOk = $?; "
            "$wakeRunExit = $LASTEXITCODE; "
            "if (-not $wakeRunOk) { "
            "if ($null -ne $wakeRunExit -and $wakeRunExit -ne 0) { exit $wakeRunExit }; "
            "exit 1 }; "
            "exit 0"
        )
        return [
            powershell_bin,
            "-NoLogo",
            "-NoProfile",
            "-NonInteractive",
            "-Command",
            wrapped,
        ]
    return ["/bin/sh", "-c", command]


def preflight_codex_queue(codex_bin: str) -> str:
    resolved = resolve_codex_executable(codex_bin)
    result = subprocess.run(
        build_codex_invocation(resolved, ["queue", "--help"]),
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError("This Codex CLI does not support `codex queue`.")
    return resolved


def queue_wakeup(thread_id: str, message: str, codex_bin: str) -> None:
    resolved = resolve_codex_executable(codex_bin)
    result = subprocess.run(
        build_codex_invocation(
            resolved, ["queue", "--thread", thread_id, "--message", message]
        ),
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        detail = (result.stderr or result.stdout or "unknown error").strip()
        raise RuntimeError(
            f"codex queue failed with exit code {result.returncode}: {detail}"
        )


def run_worker(
    *, thread_id: str, command: str, cwd: Path, log_file: Path, codex_bin: str
) -> int:
    log_file.parent.mkdir(parents=True, exist_ok=True)
    exit_code: int | None = None
    launch_error: str | None = None
    with log_file.open("ab", buffering=0) as log:
        log.write(f"$ {command}\n".encode("utf-8", errors="replace"))
        try:
            process = subprocess.Popen(
                build_experiment_invocation(command),
                cwd=str(cwd),
                stdin=subprocess.DEVNULL,
                stdout=log,
                stderr=subprocess.STDOUT,
            )
            exit_code = process.wait()
        except Exception as exc:
            launch_error = f"{type(exc).__name__}: {exc}"
            log.write(
                f"\n[wake-run] launch failed: {launch_error}\n".encode(
                    "utf-8", errors="replace"
                )
            )
    message = build_wake_message(exit_code, log_file, launch_error=launch_error)
    try:
        queue_wakeup(thread_id, message, codex_bin)
    except Exception as exc:
        with log_file.open("ab", buffering=0) as log:
            log.write(
                f"\n[wake-run] wake-up failed: {type(exc).__name__}: {exc}\n".encode(
                    "utf-8", errors="replace"
                )
            )
        return 70
    if launch_error is not None:
        return 127
    return exit_code if exit_code is not None else 1


def detached_popen_kwargs() -> dict[str, object]:
    kwargs: dict[str, object] = {
        "stdin": subprocess.DEVNULL,
        "stdout": subprocess.DEVNULL,
        "stderr": subprocess.DEVNULL,
        "close_fds": True,
    }
    if os.name == "nt":
        kwargs["creationflags"] = getattr(subprocess, "DETACHED_PROCESS", 0) | getattr(
            subprocess, "CREATE_NEW_PROCESS_GROUP", 0
        )
    else:
        kwargs["start_new_session"] = True
    return kwargs


def arm_watcher(
    *, thread_id: str, command: str, cwd: Path, log_dir: Path, codex_bin: str
) -> dict[str, object]:
    resolved_codex = preflight_codex_queue(codex_bin)
    run_id = uuid.uuid4().hex[:12]
    log_file = (log_dir / f"{run_id}.log").resolve()
    log_file.parent.mkdir(parents=True, exist_ok=True)
    worker_args = [
        sys.executable,
        str(Path(__file__).resolve()),
        "--worker",
        "--thread-id",
        thread_id,
        "--command",
        command,
        "--cwd",
        str(cwd),
        "--log-file",
        str(log_file),
        "--codex-bin",
        resolved_codex,
    ]
    worker = subprocess.Popen(worker_args, **detached_popen_kwargs())
    return {
        "status": "armed",
        "run_id": run_id,
        "worker_pid": worker.pid,
        "log_file": str(log_file),
    }


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run a command in a detached watcher and wake the current Codex thread on exit."
    )
    parser.add_argument(
        "--command", required=True, help="Exact shell command to execute."
    )
    parser.add_argument(
        "--cwd", default=os.getcwd(), help="Working directory for the command."
    )
    parser.add_argument(
        "--log-dir", help="Directory for run logs; defaults to <cwd>/.codex-wake-run."
    )
    parser.add_argument("--codex-bin", default="codex", help="Codex CLI executable.")
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--thread-id", help=argparse.SUPPRESS)
    parser.add_argument("--log-file", help=argparse.SUPPRESS)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    cwd = Path(args.cwd).expanduser().resolve()
    if args.worker:
        if not args.thread_id or not args.log_file:
            raise SystemExit("worker mode requires --thread-id and --log-file")
        return run_worker(
            thread_id=args.thread_id,
            command=args.command,
            cwd=cwd,
            log_file=Path(args.log_file).expanduser().resolve(),
            codex_bin=args.codex_bin,
        )
    thread_id = os.environ.get("CODEX_THREAD_ID", "").strip()
    if not thread_id:
        raise SystemExit(
            "CODEX_THREAD_ID is missing; run wake-run from a Codex shell command."
        )
    log_dir = (
        Path(args.log_dir).expanduser().resolve()
        if args.log_dir
        else cwd / ".codex-wake-run"
    )
    result = arm_watcher(
        thread_id=thread_id,
        command=args.command,
        cwd=cwd,
        log_dir=log_dir,
        codex_bin=args.codex_bin,
    )
    print(json.dumps(result, ensure_ascii=False), flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
