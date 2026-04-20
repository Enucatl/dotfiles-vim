## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Git commits

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

## Python code style
- always use type annotations
- before committing, format with `uv run ruff format .` (add to development dependencies)
