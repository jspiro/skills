# jspiro's skills

Agent skills I use every day.

This is a fork of [mattpocock/skills](https://github.com/mattpocock/skills).
Due credit and thanks to [Matt Pocock](https://github.com/mattpocock) for
the original collection and distribution approach. His skills aren't
packaged here — get them from the source.

## Skills

| Skill | What it does |
| --- | --- |
| [`internalize`](./skills/internalize/SKILL.md) | Turn corrective feedback into a durable CLAUDE.md rule — reflect the lesson back, iterate until it's right, persist it in the correct CLAUDE.md tier, red-team the written rule, then fix the work. |
| [`git-prefs`](./skills/git-prefs/SKILL.md) | Git preferences: branch discipline, individual staging, signing-aware workflow (configured, unconfigured, or signer locked), identity guardrails. Edit to taste. |

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
