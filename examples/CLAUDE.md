<!--
A copy of my real global CLAUDE.md (~/.claude/CLAUDE.md), lightly sanitized.
Not installable — copy it, keep what fits, delete what doesn't.
Slash commands like /grill-me, /tdd, /triage refer to skills from
https://github.com/mattpocock/skills; `git-prefs` and `background-tasks`
are in this repo.
-->

# General

Make plans and responses concise and direct, but don't sacrifice grammar.

When adding knowledge to a CLAUDE.md that is substantial (over ~10 lines, a
procedure, a rule set) or situational (only some conversations need it),
put it in a skill instead and leave a one-line pointer here naming the
trigger ("for any git work, follow the `git-prefs` skill"). CLAUDE.md lines
cost every conversation's context; skills load on demand. Short,
always-relevant rules still belong directly in CLAUDE.md.

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

Then run /to-prd and /to-issues to generate the plan, and /tdd before
starting work.

After completing work, run /review and /improve-codebase-architecture to
look for opportunities to tighten up the code before pushing to a PR.

For any background work you start or wait on (subagents, CI runs, deploys,
PR reviewer bots, cron jobs), follow the `background-tasks` skill: own the
lifecycle, verify by artifact, never drop work silently. After any push to
a PR branch, that skill's PR review loop applies until the latest review
round is clean or blocked on me.

Whenever we're starting new or undefined work in a codebase, run /triage on
the available issues.

## Coding

- Add high-signal comments and those where subtleties exist; put comments
  above the line they apply to.
- Custom code is almost always worse than library code.
- CRITICAL: For dangerous shell scripts and tools (anything that modifies,
  deletes, or overwrites files), add --dry-run/--no-dry-run BEFORE writing
  any destructive logic. --dry-run MUST be the default. This is
  non-negotiable and must be the FIRST thing implemented, not added later.
- When I report a bug and the project has a testing framework, don't start
  by trying to fix it. Instead, start by writing tests that reproduce the
  bug, commit the tests, then have subagents try to fix the bug and prove it
  with the passing tests.

### Source Control

For any git work, follow the `git-prefs` skill.

### Linting

- Always run linters for all scripts you write before running.
- Always use shellcheck when creating and editing shell scripts and before
  running scripts you write and edit.
- Always add newlines to the end of text files and remove trailing whitespace.
- Format lines to 100 characters or less.
- Python should be linted with ruff using practical rules, and formatted
  with black.
