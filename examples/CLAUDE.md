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

When I correct how you worked, or state a preference meant to apply going
forward, use the `internalize` skill to persist the lesson (I may also
invoke /internalize directly, optionally with the feedback inline).

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

Then run /to-spec and /to-tickets to generate the plan, and /tdd before
starting work.

After completing work, run /code-review and /improve-codebase-architecture
to look for opportunities to tighten up the code before pushing to a PR.

For any background work you start or wait on (subagents, CI runs, deploys,
PR reviewer bots, cron jobs), follow the `background-tasks` skill: own the
lifecycle, verify by artifact, never drop work silently. After any push to
a PR branch, that skill's PR review loop applies until the latest review
round is clean or blocked on me.

Whenever we're starting new or undefined work in a codebase, run /triage on
the available issues.

When asked to clean up, tidy, or harden an existing codebase (DRY,
complexity, comments, dead code), follow the `repo-quality-sweep` skill —
it sequences the atomic quality skills into small behavior-preserving PRs.

## Coding

- Comments state only what the code cannot show: a non-obvious constraint,
  subtlety, or trap. Never narrate your reasoning, triage history, or what
  tool/review prompted a change ("found by mutation testing", "per PR #N
  review") — that context belongs in the commit message, not the code.
  Every non-trivial function gets a docstring that leads with what it DOES
  (input → result); design rationale comes after, if at all. A good name
  may stand alone only when the arguments are self-describing too. The
  same bar applies to interfaces/classes and their MEMBERS: document each
  field unless it's dead clear (a bare `corrected: boolean` says nothing
  about what was corrected). Put comments above the line they apply to. When in doubt about a line
  comment, no comment. For JS/TS work, the `code-comments` skill has the
  JSDoc/TSDoc and directive-comment conventions.
- Custom code is almost always worse than library code.
- Never suppress a failing quality gate (lint rule, complexity cap, test,
  CI check) to get green — fix the cause, or present the suppression to me
  as a decision with the fix cost attached. A disable comment I didn't
  approve is cheating, not unblocking.

- **Composing commands — decompose, simplify, defer:**
  1. **Decompose.** Split a command line when it is destructive, when it
     is complex (a long chain), or when its steps serve wholly unrelated
     goals rather than one sequence. In particular, a check (gate, test,
     inspection) never shares a line with an action its result should
     decide — run the check, read it, then act. A related sequence may
     stay together (stage + commit, a pipe, a build feeding its own
     test). A destructive step is always its own stage: inspect what's
     affected → reversible prep → the destructive step alone → verify.
     Not to excess — don't write intermediate files just to split a
     command.
  2. **Simplify.** Try the least-destructive command that does the job
     first; escalate to a risky command (one that may need approval) only
     when the simpler forms genuinely can't do it:
     - `rm <dir>/*` then `rmdir` instead of `rm -rf`
     - `rm -r` without `-f` unless forcing is proven necessary
     - per-file operations instead of blanket ones
     - git specifics: the `git-prefs` skill
  3. **Defer.** If a known-dangerous command is still needed after that,
     don't run it: finish everything else and present it at the end.
     A permission prompt on such a command can't be retracted and stalls
     the turn until I answer; unattended, the work dies.

- CRITICAL: For dangerous shell scripts and tools (anything that modifies,
  deletes, or overwrites files), add --dry-run/--no-dry-run BEFORE writing
  any destructive logic. --dry-run MUST be the default. This is
  non-negotiable and must be the FIRST thing implemented, not added later.
- When I report a bug and the project has a testing framework, don't start
  by trying to fix it. Instead, start by writing tests that reproduce the
  bug, commit the tests, then have subagents try to fix the bug and prove it
  with the passing tests.
- After any refactor, and before merging a PR that touches pure logic,
  validation, or parsing, follow the `mutation-testing` skill (scoped run on
  the changed files, after tests are green); also whenever test coverage is
  in doubt. Skip it for UI/copy/config-only diffs.
- Keep cyclomatic complexity ≤ 8 for every function you write or modify —
  the `complexity-gate` skill has the rule's edges and per-ecosystem lint
  setup (reference implementations included); load it when writing code or
  setting up a project's linting.

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
