# jspiro's skills

Agent skills I use every day.

This is a fork of [mattpocock/skills](https://github.com/mattpocock/skills).
Due credit and thanks to [Matt Pocock](https://github.com/mattpocock) for
the original collection and distribution approach. His skills aren't
packaged here — get them from the source.

## A starting-point global CLAUDE.md

[`examples/CLAUDE.md`](./examples/CLAUDE.md) is my actual global
CLAUDE.md (`~/.claude/CLAUDE.md` symlinks to it): planning flow, coding
and linting rules, and the skill-pointer lines the skills below rely on.
It's not installable; copy it, keep what fits, delete what doesn't.

## Prerequisites

Using the CLAUDE.md as-is? Install everything it references:

```bash
# The skills in this repo (they cross-reference each other — install together)
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

Skip any you won't use, but delete the CLAUDE.md lines that mention them:
a pointer to a missing skill is a silent no-op, so you'd believe a
guardrail exists that doesn't.

## The skills

### [`internalize`](./skills/internalize/SKILL.md)

You correct the agent, it fixes the one instance, and it makes the same
mistake next session. This skill turns the correction into a persisted
rule: it confirms its read of the lesson with you, writes the rule to the
right CLAUDE.md tier (or a skill plus a pointer when the lesson is big or
situational), red-teams the written rule, then fixes the original work.

Fires on corrective feedback ("no, I wanted...", "next time do X"), or
explicitly:

```
/internalize stop putting summary tables in every response
```

### [`git-prefs`](./skills/git-prefs/SKILL.md)

Git preferences belong in a skill that loads only for git work, not in a
CLAUDE.md every conversation pays for. One pointer line replaces a page
of rules. Mine covers branch and force-push discipline, hunk-level
staging, message style, identity guardrails, a signing workflow that
keeps working when the signer is locked, and a PR-description shape.
Edit the rules to your own taste; it's a template for your preferences.

### [`background-tasks`](./skills/background-tasks/SKILL.md)

Agents start background work (subagents, CI, deploys, reviewer bots),
trust the completion notification, and drop work silently. This skill
makes the agent own the lifecycle: verify status by artifact, schedule a
fallback check at ~2× any ETA, use recurring watch loops rather than
one-shots, and alert with state when blocked. The PR review loop is the
worked case; `git-prefs` hands off to it after any push.

## The quality suite

Four skills that keep generated code honest, each useful alone and wired
to fire at a lifecycle moment by a pointer line in
[`examples/CLAUDE.md`](./examples/CLAUDE.md): `complexity-gate` while
writing, `mutation-testing` after tests are green and before review,
`code-comments` as the comment pass, and `repo-quality-sweep` to retrofit
all of it onto a legacy repo. They ship reference configs so every repo
gets the identical setup.

### [`mutation-testing`](./skills/mutation-testing/SKILL.md)

Line coverage proves code ran under test, not that any test constrains
it. This skill runs mutation testing (StrykerJS; mutmut, cargo-mutants,
gremlins, PIT elsewhere) scoped to the PR's changed logic files, then
works the survived-mutant list with explicit triage rules and the sharp
edges hit in practice. Run it in the code-review slot, never in the TDD
inner loop; skip UI/copy/config diffs.

### [`complexity-gate`](./skills/complexity-gate/SKILL.md)

Caps cyclomatic complexity at ≤ 8 for every function written or
modified, enforced by the agent as it writes and backed by lint. The
design is a two-entry-point split: a whole-repo advisory inventory and a
changed-files gate for CI, so PRs fail only on complexity they touched.
Includes a decomposition playbook and a `crap-score` audit recipe. Never
`eslint-disable` to get green without explicit sign-off.

### [`code-comments`](./skills/code-comments/SKILL.md)

Agents narrate reasoning into comments and leave fields like
`corrected: boolean` undocumented. This skill holds the JS/TS specifics
on top of the core policy (comments state only what the code cannot
show; docstrings lead with what the function does): JSDoc/TSDoc, member
documentation, directive comments, TODO hygiene. Apply it while writing
and as the comment pass of a cleanup, after refactoring, never before.

### [`repo-quality-sweep`](./skills/repo-quality-sweep/SKILL.md)

A thin orchestrator for retrofitting the standards above onto a legacy
repo without a big-bang PR. It builds a ranked worklist as a checkbox
issue, then loops one small behavior-preserving PR per area (DRY →
complexity → comments → verify), and re-runs the inventory to report
deltas. Invoke it for "clean up / tidy / harden this repo" requests.

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
