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

My CLAUDE.md references skills from
[mattpocock/skills](https://github.com/mattpocock/skills)
(`npx skills@latest add mattpocock/skills`):

- Current upstream: `grill-me`, `grill-with-docs`, `tdd`, `triage`,
  `improve-codebase-architecture`.
- From older versions of his repo (I still run the old copies): `to-prd`,
  `to-issues`, `review`. Nearest current equivalents: `to-spec`,
  `to-tickets`, `code-review`.

The skills in this repo only reference each other (`git-prefs` hands off to
`background-tasks`), with one aside: `internalize` mentions
`revise-claude-md`, which ships with Claude Code's `claude-md-management`
plugin. Everything degrades gracefully if a referenced skill is absent.

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
