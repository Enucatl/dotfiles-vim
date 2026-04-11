# Git commits

Use a subject single line max 50 chars, then a body that explains what
and why things were changed in the commit. Draw heavily from the
conversation, including tradeoffs that were explored and discarded. This
context is more important than details about how the code was changed,
since those can be reconstructed from the code itself.

# Python code
- always use type annotations
- before committing, format with `uv run ruff format .` (add to development dependencies)
