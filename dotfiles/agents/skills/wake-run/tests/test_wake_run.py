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
