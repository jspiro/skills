<!--
My live global CLAUDE.md — ~/.claude/CLAUDE.md is a symlink to this file.
Not installable — copy it, keep what fits, delete what doesn't.
The working tree may carry personal, intentionally-uncommitted edits to
this file; diffs are reviewed before anything is staged or pushed.
Slash commands like /grill-me, /tdd, /triage refer to skills from
https://github.com/mattpocock/skills; `internalize`, `git-prefs`,
`background-tasks`, and the quality skills (`mutation-testing`,
`complexity-gate`, `code-comments`, `repo-quality-sweep`) are in this repo.
-->

# General

Make plans and responses concise and direct, but don't sacrifice grammar.

Rules here and in skills MUST say what to do, in plain, precise language,
using RFC 2119 terms (MUST, MUST NOT, SHOULD, MAY) outside prose. State a
reason only when the goal cannot be stated as an instruction. Prefer a
static check (permission rule, hook, lint, test, CI) over a written rule
when one is cheap and reliable. Keep this file to short, always-relevant
rules; situational knowledge goes in a skill with a pointer in the Skills
section below.

You are AI, not a human, so don't estimate work in human hours unless that's
the exercise. You will do the work, so the real tradeoffs are more about
change surface area, cost in terms of tokens to do it, correctness.
I generally prefer minimal necessary changes so long as it's a good solution,
followed by best possible solution, followed by cost, all things equal.

- Always suggest CLI tools that may be useful in a task.
- Always RTFM or use a web search tool instead of guessing or inferring.
- Always prefer brew for packages, and avoid pip unless in a venv.

## Planning

Provide three different approaches and plans, make a recommendation, ask me
which to go with. At the end of each plan, run /grill-with-docs if there's a
codebase, or /grill-me if it's a productivity or other one-off task.
Interview me in detail using the AskUserQuestion tool.

Technical implementation, UI & UX, concerns, tradeoffs, etc. — be very
in-depth and continue interviewing me continually until it's complete.

Then run /to-spec and /to-tickets to generate the plan, and /tdd before
starting work.

After completing work, run /code-review and /improve-codebase-architecture
to look for opportunities to tighten up the code before pushing to a PR.

Whenever we're starting new or undefined work in a codebase, run /triage on
the available issues.

## Coding

- Comments state only what the code cannot show: a non-obvious constraint,
  subtlety, or trap, placed above the line they apply to. Never narrate
  your reasoning or what review prompted a change; that belongs in the
  commit message. Every non-trivial function gets a docstring that leads
  with what it DOES (a good name alone suffices only when the arguments
  are self-describing too); every non-obvious field gets a line saying
  what it holds. When in doubt about a line comment, no comment.
- Custom code is almost always worse than library code.
- Never suppress a failing quality gate (lint rule, complexity cap, test,
  CI check) to get green — fix the cause, or present the suppression to me
  as a decision with the fix cost attached. A disable comment I didn't
  approve is cheating, not unblocking.
- Keep cyclomatic complexity ≤ 8 for every function you write or modify.
- Any tool that modifies, deletes, or overwrites files MUST implement
  `--dry-run` first, on by default, with `--no-dry-run` to execute.
- When I report a bug and the project has a testing framework, don't start
  by trying to fix it. Instead, start by writing tests that reproduce the
  bug, commit the tests, then have subagents try to fix the bug and prove it
  with the passing tests.

### Shell commands

I MUST be able to judge each command from the permission prompt in a few
seconds.

- Every Bash call's `description` MUST state the command's purpose in
  plain words.
- One purpose per command. A short related sequence (stage then commit, a
  pipe) MAY share a line. Small embedded programs (a regexp, a short awk)
  are fine.
- A check and the action its result decides MUST be separate commands.
- A destructive step (`rm -rf`, `find -delete`, `git reset --hard`) MUST
  NOT be buried in a command that also does other things. Run it alone, in
  the least destructive form that works.
- Create and edit files with Write/Edit, not shell.
- Sequence commands that need my approval as late as possible, so the most
  work completes before the first prompt. Defer cleanup when that doesn't
  degrade the result.
- Files you created under `/tmp` MAY be deleted freely. Never move other
  files to `/tmp` to delete them without a prompt.

### Linting

- Always run linters for all scripts you write before running.
- Always use shellcheck when creating and editing shell scripts and before
  running scripts you write and edit.
- Always add newlines to the end of text files and remove trailing whitespace.
- Format lines to 100 characters or less.
- Python should be linted with ruff using practical rules, and formatted
  with black.

## Skills

Load the named skill when its trigger applies:

- `internalize`: when I correct how you worked or state a preference meant
  to apply going forward (I may also invoke /internalize directly,
  optionally with the feedback inline).
- `git-prefs`: any git work.
- `background-tasks`: any background work you start or wait on (subagents,
  CI runs, deploys, PR reviewer bots, cron jobs). After any push to a PR
  branch, its review loop runs until the round is clean or blocked on me.
- `complexity-gate`: writing code, or setting up a project's linting.
- `mutation-testing`: after any refactor; before merging a PR that touches
  pure logic, validation, or parsing; whenever test coverage is in doubt.
  Skip it for UI/copy/config-only diffs.
- `code-comments`: JS/TS comment and docstring conventions.
- `repo-quality-sweep`: when asked to clean up, tidy, or harden an existing
  codebase (DRY, complexity, comments, dead code).
