# Codex Hook Notes

The Camillo memory hook posts completed turns to the ingest API.

There are no required environment variables. Optional overrides:

- `CAMILLO_MEMORY_ENDPOINT`: override the ingest URL. Default:
  `https://camillo.docker.home.arpa/ingest`
- `CAMILLO_MEMORY_NAMESPACE`: override the namespace. Default:
  `repo:<basename of git root>`
- `CAMILLO_MEMORY_TIMEOUT_MS`: HTTP timeout in milliseconds. Default: `1500`
- `CAMILLO_MEMORY_STATE_DIR`: local state directory for pending/sent turn
  markers. Default:
  `$XDG_STATE_HOME/codex/camillo` or `~/.local/state/codex/camillo`

Run `rake links` so `~/.codex/config.toml` and `~/.codex/skills/camillo`
are linked into place, then restart Codex.
