# Codex Hook Notes

The Camillo memory hook posts completed turns to the ingest API.

There are no required environment variables. Optional overrides:

- `CAMILLO_MEMORY_ENDPOINT`: override the ingest URL. Default:
  `https://camillo.docker.home.arpa/ingest`
- `CAMILLO_MEMORY_WORKSPACE`: optional workspace ranking hint. Default is the
  basename of the git root, or the current-directory basename without a git root.
- `CAMILLO_MEMORY_TIMEOUT_MS`: HTTP timeout in milliseconds. Default: `1500`
- `CAMILLO_MEMORY_STATE_DIR`: local state directory for pending/sent turn
  markers. Default:
  `$XDG_STATE_HOME/codex/camillo` or `~/.local/state/codex/camillo`

Run `rake links` so `~/.codex/config.toml` and `~/.codex/skills/camillo`
are linked into place, then restart Codex.
