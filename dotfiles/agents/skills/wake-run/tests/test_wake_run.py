"""Behavior checks for the wake-run launcher's result and shell contracts."""

from __future__ import annotations

import importlib.util
import os
import subprocess
from pathlib import Path

import pytest

SCRIPT = Path(__file__).resolve().parents[1] / "scripts" / "wake_run.py"
SPEC = importlib.util.spec_from_file_location("wake_run", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
wake_run = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(wake_run)


def test_wake_message_contains_result_without_agent_instructions() -> None:
    """Keep the queued follow-up limited to facts about the completed run."""
    message = wake_run.build_wake_message(7, Path("run.log"))

    assert (
        message
        == "[Wake Run Result]\n\nStatus: Failed\nExit code: 7\nLog file: run.log"
    )


def test_default_log_stays_outside_project(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    """Place default run artifacts in a private system temp directory."""
    project = tmp_path / "project"
    project.mkdir()
    monkeypatch.setattr(wake_run.tempfile, "tempdir", str(tmp_path))
    monkeypatch.setattr(wake_run, "preflight_codex_queue", lambda _: "codex")

    class Worker:
        pid = 123

    monkeypatch.setattr(wake_run.subprocess, "Popen", lambda *args, **kwargs: Worker())
    result = wake_run.arm_watcher(
        thread_id="thread",
        command="true",
        cwd=project,
        log_dir=None,
        codex_bin="codex",
    )

    log_dir = Path(result["log_file"]).parent
    assert log_dir.parent == tmp_path
    assert log_dir.name.startswith("codex-wake-run-")
    assert list(project.iterdir()) == []
    if os.name != "nt":
        assert log_dir.stat().st_mode & 0o077 == 0


@pytest.mark.skipif(os.name == "nt", reason="POSIX shell behavior")
def test_posix_command_uses_sh_even_when_user_shell_differs(
    monkeypatch: pytest.MonkeyPatch,
) -> None:
    """Run POSIX commands with the shell promised by the skill."""
    monkeypatch.setenv("SHELL", "/bin/false")
    invocation = wake_run.build_experiment_invocation("printf 'ok'")

    result = subprocess.run(invocation, capture_output=True, text=True, check=False)

    assert result.returncode == 0
    assert result.stdout == "ok"


@pytest.mark.skipif(os.name != "nt", reason="Windows PowerShell behavior")
@pytest.mark.parametrize(
    ("command", "expected_exit_code"),
    [
        ("cmd.exe /c exit 7", 7),
        ("cmd.exe /c exit 7; Write-Output ok", 0),
        ("cmd.exe /c exit 0; Write-Error failed", 1),
    ],
)
def test_powershell_reports_final_command_status(
    command: str, expected_exit_code: int
) -> None:
    """Ignore a stale native exit code when the final command sets status."""
    invocation = wake_run.build_experiment_invocation(command, platform="nt")

    result = subprocess.run(invocation, capture_output=True, text=True, check=False)

    assert result.returncode == expected_exit_code
