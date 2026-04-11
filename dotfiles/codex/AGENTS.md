# Git commits

Use a google-style subject single line max 50 chars, then a body that explains what
and why things were changed in the commit. Draw heavily from the
conversation, including tradeoffs that were explored and discarded. This
context is more important than details about how the code was changed,
since those can be reconstructed from the code itself.

The body should be specific enough that a future reader can understand the
engineering decision without reopening the chat. Include the problem framing,
the chosen boundary, and the important rejected alternatives. For example,
explain why a change used one orchestration script instead of many Puppet exec
resources, why behavior belongs in Puppet instead of dotfiles or a package
manager, why credentials are or are not managed, and what operational tradeoff
was accepted such as latest-each-run freshness versus quieter idempotent
reports.

Do not let the body collapse into a file inventory. Mention files only where
they clarify a boundary or surprising design choice. Prefer paragraphs that
capture intent, constraints, and consequences over restating code mechanics.

# Python code
- always use type annotations
- before committing, format with `uv run ruff format .` (add to development dependencies)
