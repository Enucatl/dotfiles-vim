# Codex Configuration

Run `rake links` so `~/.codex/config.toml` and the agent skills under
`~/.agents/skills` are linked into place, then restart Codex. Skills in
`dotfiles/agents/skills` are picked up automatically; this includes `wake-run`,
vendored from <https://github.com/Enucatl/codex-wake-run>.

The same `rake links` task links `~/.codex/AGENTS.md` to
`~/.claude/CLAUDE.md` so Claude Code loads these global instructions from any
working directory. Recent Claude Code versions read project `AGENTS.md` files
directly. The task also links the compatible `archify`, `git-commit-message`,
`homelab-logs`, and `python-code` skills from `~/.agents/skills` into
`~/.claude/skills` when installed. `wake-run` stays Codex-only because it
depends on Codex's task queue.

Puppet also installs the Ponytail Claude Code plugin from the same delayed
release selected for Codex; `~/.claude/settings.json` enables it globally.
