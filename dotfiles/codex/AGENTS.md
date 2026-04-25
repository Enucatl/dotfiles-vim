## Coding Agent Defaults

- Prefer outcome-first execution: clarify the goal, constraints, success criteria, allowed side effects, verification, and final answer shape.
- Keep process lightweight. State assumptions or tradeoffs when they affect the implementation; ask only when ambiguity blocks a safe choice.
- For multi-step work, make a brief plan with verification for each step, then execute until the goal is verified.
- Use tools precisely. Inspect before editing, change only what the task requires, and preserve unrelated user changes.
- Keep final answers compact: what changed, how it was verified, and any remaining risk.

## Engineering Boundaries

- Implement the minimum code that solves the request.
- Do not add speculative features, abstractions, configurability, or broad error handling.
- Do not clean up unrelated code. Mention unrelated issues instead.

## Git Commits

Use a Google-style subject, single line, max 50 characters.

The commit body should explain what changed and why. Draw from the conversation: problem framing, chosen boundary, rejected alternatives, and operational tradeoffs. Prefer intent and consequences over a file inventory.

## Python

- Use type annotations.
- Before committing, run `uv run ruff format .`.
