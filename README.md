# jspiro's skills

Agent skills I use every day.

This is a fork of [mattpocock/skills](https://github.com/mattpocock/skills).
Due credit and thanks to [Matt Pocock](https://github.com/mattpocock) for
the original collection and distribution approach. His skills aren't
packaged here — get them from the source.

## A starting-point global CLAUDE.md

A lot of people don't know where to start with their global
`~/.claude/CLAUDE.md`. [`examples/CLAUDE.md`](./examples/CLAUDE.md) is my
actual global CLAUDE.md — my `~/.claude/CLAUDE.md` is a symlink to it, so
it's always current: planning flow, coding and linting rules, and the
skill-pointer pattern the skills below rely on. It's not installable;
copy it, keep what fits, delete what doesn't.

## Prerequisites

Using the CLAUDE.md below as-is? Install everything it references:

```bash
# The skills in this repo (git-prefs hands off to background-tasks, and the
# quality suite cross-references itself — install together)
npx skills@latest add jspiro/skills \
  --skill internalize --skill git-prefs --skill background-tasks \
  --skill mutation-testing --skill complexity-gate --skill code-comments \
  --skill repo-quality-sweep -g

# The mattpocock/skills my CLAUDE.md references
npx skills@latest add mattpocock/skills \
  --skill grill-me --skill grill-with-docs --skill to-spec --skill to-tickets \
  --skill tdd --skill code-review --skill improve-codebase-architecture \
  --skill triage -g
```

Skip any you won't use — but then delete the CLAUDE.md lines that mention
them. A pointer to a missing skill doesn't break anything; it's a silent
no-op, which means you'd believe a guardrail exists that doesn't.

## The skills

### [`internalize`](./skills/internalize/SKILL.md)

**The problem**: you correct the agent — "that's not what I wanted, do it
this way" — and it apologizes, fixes the one instance, and makes the same
mistake next session. The feedback never lands anywhere durable.

**What it does**: turns corrective feedback into a persisted rule. It
reflects the lesson back in its own words, iterates until you confirm it
learned the right thing, writes the rule to the correct CLAUDE.md tier
(global for personal preferences, project or subdirectory for repo
conventions) — or into a skill with a CLAUDE.md pointer when the lesson is
big or situational — red-teams the written rule (would it actually fire?
could it backfire?), then fixes the original work and summarizes what it
learned.

**How it runs**: on its own when it recognizes corrective feedback ("no, I
wanted...", "next time do X"), or explicitly — invoke `/internalize` after
giving feedback, or hand it the feedback inline:

```
/internalize stop putting summary tables in every response
```

### [`git-prefs`](./skills/git-prefs/SKILL.md)

**The problem**: everyone has git preferences — branch discipline, how to
stage, what commit messages look like, how signing is set up. Pasting all of
that into CLAUDE.md taxes every conversation's context window, including the
many that never touch git.

**What it does**: breaks the git knowledge out into a skill that loads only
when git work actually happens. One CLAUDE.md line ("for any git work,
follow the `git-prefs` skill") replaces a page of rules. Mine covers branch
and force-push discipline, individual staging, message style, identity
guardrails, a signing workflow that handles signing being unconfigured,
configured and working, or configured with the signer locked (e.g. a locked
1Password vault) — without ever blocking work — and a light after-pushing
rule: PR work is never dropped silently.

**How to use it**: install, add the one-liner to your CLAUDE.md, then edit
the rules to your own taste — it's a template for *your* preferences as much
as a skill.

### [`background-tasks`](./skills/background-tasks/SKILL.md)

**The problem**: agents start background work — subagents, CI runs, deploys,
PR reviewer bots — then trust the completion notification, or worse, walk
away. Work gets dropped silently, and "done" gets reported while a review
round sits unread.

**What it does**: makes the agent own the full lifecycle of anything it
starts or waits on. Never trust, always verify: status comes from artifacts
(`gh run list`, process lists, file mtimes), not notifications. ETA
discipline: schedule a fallback check at ~2× any ETA, and recurring watch
loops — not one-shots — when the wait spans other work. Includes the PR
review loop as a worked case: learn the reviewer's latency, check at 1×/2×,
read summary and inline comments, address every finding, loop until clean
or genuinely blocked — then alert with state, not silence.

**How it runs**: on its own whenever background work starts or the agent is
about to report monitored work as done or still running. `git-prefs` hands
off to it after any PR push.

## The quality suite

Four skills that together keep generated code honest: a complexity cap
enforced while code is written, mutation testing that proves the tests
constrain behavior, comment/docstring conventions, and an orchestrator
that retrofits all of it onto a legacy repo. Each is useful alone; the
value compounds when they run at the right lifecycle moments:

1. **While writing code** — `complexity-gate` caps every new or modified
   function at cyclomatic complexity ≤ 8 (decompose, don't nest);
   `code-comments` governs what gets a docstring and what never becomes
   a comment.
2. **After tests are green, before review** — `mutation-testing` runs
   scoped to the PR's changed logic files; every survived mutant is
   triaged (real gap → new test; equivalent → reviewed, reasoned
   suppression — never a unilateral one).
3. **Before pushing** — run every gate the PR's CI runs, locally
   (a `git-prefs` rule): typecheck, tests, changed-files complexity
   lint, scoped mutation when logic changed. CI confirms; it never
   informs.
4. **On demand, repo-wide** — `repo-quality-sweep` turns the atomic
   skills into a ranked worklist and a series of small
   behavior-preserving PRs, and a manually-dispatched audit workflow
   (full mutation run + CRAP report) tracks the baselines.

The wiring that makes them fire is a handful of pointer lines in
[`examples/CLAUDE.md`](./examples/CLAUDE.md)'s Coding section — each
names its trigger condition, so the skill loads exactly when it
applies. The skills ship reference implementations (working Stryker +
Vitest configs, a complexity-only ESLint config, a changed-files gate
script) so every repo gets the identical setup instead of a fresh
reinvention.

### [`mutation-testing`](./skills/mutation-testing/SKILL.md)

**The problem**: line coverage proves code *ran* under test, not that any
test *constrains* it. A refactor can silently change behavior nobody
asserted while every test stays green — exactly when "no behavior change"
is the whole claim.

**What it does**: runs mutation testing (StrykerJS for JS/TS; mutmut,
cargo-mutants, gremlins, PIT elsewhere) scoped to the PR's changed logic
files — minutes, not hours — then works the survived-mutant list with
explicit triage rules: pin exact strings only for contracts with external
state, assert shape for config validated downstream, and never rule a
mutant "equivalent" without actively trying to construct the
distinguishing input (one "redundant" URL guard turned out to block a
path-embedded payload). Documents the sharp edges hit in practice: pnpm
plugin discovery, stale incremental caches, sandbox recursion, and never
letting Stryker drive a heavyweight test runner that loads live secrets.

**How to use it effectively**: run it in the code-review slot — after
tests are green, before requesting review — never in the TDD inner loop.
Fire it on refactors and PRs touching validation/parsing/auth; skip
UI/copy/config diffs. Keep the full-repo run as an occasional audit that
never blocks a PR. Reference configs in `references/`.

### [`complexity-gate`](./skills/complexity-gate/SKILL.md)

**The problem**: functions accrete branches one innocent `if` at a time,
and review rarely holds the line. High complexity is where bugs live and
where tests stop being written — which is the CRAP insight
(complexity² × untestedness³).

**What it does**: caps cyclomatic complexity at ≤ 8 for every function
written or modified, enforced first by the agent as it writes and backed
by lint (ESLint `complexity` rule for JS/TS, ruff C901, gocyclo, clippy).
The load-bearing design is the two-entry-point split: a whole-repo
ADVISORY inventory (legacy code fails it; record the baseline) and a
changed-files GATE for CI, so PRs fail only on complexity they introduced
or touched. Pairs with a `crap-score` report to rank the riskiest
functions for audits.

**How to use it effectively**: when the gate fires on a legacy function
you touched, the default is to decompose it now — the firing gate IS the
sweep arriving there; the skill's decomposition playbook covers the moves
that work (type-guard once, load → render split, tables for same-shape
branches, a throwaway render harness to prove byte-identity). Never
`eslint-disable` to get green without explicit user sign-off. Reference
ESLint config and gate script in `references/`.

### [`code-comments`](./skills/code-comments/SKILL.md)

**The problem**: agents narrate their reasoning into comments ("found by
mutation testing", "per review"), restate what types already say, and
leave booleans like `corrected: boolean` undocumented — comment noise
that rots the moment it merges.

**What it does**: the JS/TS specifics on top of a simple core policy
(comments state only what the code cannot show; docstrings lead with what
the function DOES): JSDoc/TSDoc conventions, interface-and-member
documentation, `@ts-expect-error`-with-reason over `@ts-ignore`,
TODO(#ref) hygiene, and preferring language features (`#private`,
`as const`, extracted functions) over comments.

**How to use it effectively**: apply it while writing, and as the
comment pass of any cleanup — after refactoring, never before (don't
polish comments on code about to move).

### [`repo-quality-sweep`](./skills/repo-quality-sweep/SKILL.md)

**The problem**: the standards above exist but the legacy repo predates
them, and a big-bang cleanup PR is unreviewable and unmergeable.

**What it does**: a thin orchestrator over the atomic skills. Phase 0
builds a ranked worklist (CRAP report, mutation survivors, jscpd
duplication, knip dead exports, comment smells) and files it as a
checkbox issue so the sweep survives sessions. Phase 1 loops: one small
behavior-preserving PR per area, each file passed in order —
DRY → complexity → comments → verify (typecheck, tests, scoped mutation
run proving no new survivors). Phase 2 re-runs the inventory and reports
baseline deltas.

**How to use it effectively**: invoke it for "clean up / tidy / harden
this repo" requests instead of improvising. Keep sweep PRs under ~400
changed lines and never mix behavior changes in — a real bug found
mid-sweep becomes its own issue and PR.

## Install

With the [skills CLI](https://skills.sh) (works with Claude Code, Codex,
Cursor, OpenCode, and many others):

```bash
# Pick skills interactively
npx skills@latest add jspiro/skills

# Or install a specific one, globally
npx skills@latest add jspiro/skills --skill internalize -g
```

These are personal-workflow skills — install them with `-g` (global) rather
than per-project.

## Updating

Skills installed with the skills CLI are updated by it — it records each
skill's source repo and content hash in `~/.agents/.skill-lock.json`:

```bash
npx skills@latest update -g          # update all globally-installed skills
npx skills@latest update internalize # update one
```

It detects local edits by hash and prompts before overwriting; review those
prompts so your customizations survive.

If you work on your own skills, do what I do instead: clone your skills
repo and symlink each skill into `~/.claude/skills/` — edits are live
immediately, `git pull` is the update, and publishing is a commit and push.
