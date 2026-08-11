# jspiro's skills

Agent skills I use every day, plus the excellent set this repo is forked
from.

This is a fork of [mattpocock/skills](https://github.com/mattpocock/skills)
— all credit and thanks to [Matt Pocock](https://github.com/mattpocock) for
the original collection and the ideas behind it (grilling sessions ahead of
work, ubiquitous language docs, small composable skills you own and edit).
Read his README for the philosophy; it's worth it.

## My skills

Everything I've added lives in [`skills/personal/`](./skills/personal/):

| Skill | What it does |
| --- | --- |
| [`internalize`](./skills/personal/internalize/SKILL.md) | Turn corrective feedback into a durable CLAUDE.md rule — reflect the lesson back, iterate until it's right, persist it in the correct CLAUDE.md tier, red-team the written rule, then fix the work. |
| [`jspiro-git`](./skills/personal/jspiro-git/SKILL.md) | My git preferences: branch discipline, individual staging, SSH-signing with a locked-vault fallback, identity guardrails. Fork it and make it `yourname-git`. |

## Install

With the [skills CLI](https://skills.sh) (works with Claude Code, Codex,
Cursor, OpenCode, and many others):

```bash
# Pick skills interactively
npx skills@latest add jspiro/skills

# Or install a specific one, globally
npx skills@latest add jspiro/skills --skill internalize -g
```

Skills like `internalize` are personal-workflow skills — install them with
`-g` (global) rather than per-project.

## Everything else

The `engineering/`, `productivity/`, `misc/`, and `in-progress/` buckets are
Matt's, kept in sync with upstream as it suits me. If you want his set,
install from the source: `npx skills@latest add mattpocock/skills`, or use
his Claude Code plugin (`/plugin install mattpocock-skills`) — this fork
deliberately removes the plugin manifests and release automation so it never
masquerades as his distribution.
