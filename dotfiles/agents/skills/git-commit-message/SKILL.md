---
name: git-commit-message
description: Write clear Git commit messages when creating, reviewing, or revising commits.
metadata:
  short-description: Write useful Git commit messages
---

# Git Commit Messages

Use this skill whenever a task involves composing or improving a Git commit
message. Inspect the staged diff and, when useful, recent commits in the same
repository before drafting the message. Preserve an established repository
convention when one exists, unless the user asks for a different style.

## Subject

- Keep the subject to 50 characters or fewer when possible; treat 72 characters
  as a hard maximum.
- Capitalize the first word.
- Do not end it with a period or other unnecessary punctuation.
- Use the imperative mood so it completes: “If applied, this commit will ...”.
- Summarize the change, rather than describing the conversation or listing files.

## Body

Omit the body when the subject gives enough context. Otherwise, separate it
from the subject with one blank line and wrap prose at 72 characters.

Use the body to explain what problem the change solves and why this approach
was chosen. Avoid narrating implementation details that the diff already makes
clear. Include relevant side effects, constraints, or trade-offs. Put issue or
review references at the bottom when the repository uses them.

Return the complete proposed message in a form ready to paste into Git. Do not
create or amend a commit unless the user explicitly requests that operation.

The guidance is based on [How to Write a Git Commit Message](https://cbea.ms/git-commit/).
