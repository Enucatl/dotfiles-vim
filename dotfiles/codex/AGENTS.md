## Coding Agent Defaults

- Infer the user's intended outcome and task scope from the request, repository
  context, and prior conversation. Bias toward action and carry requested work
  through implementation and verification.
- Ask a clarifying question only when missing information could materially
  change the result and useful authorized work cannot continue. Otherwise,
  make a reasonable assumption and state it when it affects the result.
- Treat requests such as "can you fix" or "help me implement" as instructions
  to perform the work, not merely explain how it could be done.
- For multi-step work, use a brief plan, then continue until the requested
  outcome is complete or a concrete blocker prevents progress.
- Inspect relevant code before editing. Change only what the task requires and
  preserve unrelated user changes.
- User instructions take precedence over this file and over skill guidance.
- Keep final answers concise and outcome-first: state what changed, how it was
  verified, and any remaining risk.

## Engineering Boundaries

- Implement the minimum code that fully solves the request.
- Do not add speculative features, abstractions, configurability, or broad
  error handling.
- Do not clean up unrelated code. Mention relevant unrelated issues instead.

## Verification

- Run checks appropriate to the scope and risk of the change.
- Do not add tests for reversible, low-impact changes when they would merely
  duplicate the implementation.
- After relevant checks pass, broaden or repeat testing only when failures,
  further edits, or unresolved concerns justify it.

## Communication

- Lead with the main point and use clear, concise paragraphs.
- Use lists only for genuinely parallel, sequential, or comparative material.
- Prefer plain language, precise verbs, and active voice. Avoid canned
  transitions, unnecessary headings, and repeated summaries.

## Long-Running Operations

- In the main Codex thread, any noninteractive shell command reasonably expected
  to take longer than 10 seconds must use the `wake-run` skill. This includes
  tests, GPU evaluations, builds, benchmarks, installs, and deployments. Do not
  poll its status or log from the Codex thread.
- Subagents must not launch `wake-run`. They run their own long commands with a
  long blocking tool wait and report the results to the main thread. If a tool
  yields before the command exits, continue waiting on that session with the
  longest practical interval. Do not hand off a command solely due to duration.
- Finalize the command before launching it, then follow the installed
  `wake-run` skill's launch and continuation instructions. Resume the task when
  its completion notification arrives.
- For MCP operations and interactive commands that `wake-run` cannot launch,
  use the longest practical blocking wait instead of repeated status polling.
