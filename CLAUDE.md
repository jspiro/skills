Two-skill repo: jspiro's personal agent skills, distributed via
`npx skills add jspiro/skills`. Forked from mattpocock/skills (history
retained, content removed) — don't reintroduce upstream files, plugin
manifests, or release automation. Keep it lightweight.

- Skills live flat under `skills/<name>/SKILL.md`.
- Every skill gets a section in the top-level `README.md` (problem / what it
  does / how to use), name linked to its `SKILL.md`.
- After ANY content change (skill added/edited, example added, layout
  change), check whether `README.md` needs a matching update before
  committing — the README is the product page; stale docs are worse than
  none.
- `examples/` holds copyable, non-installable files (no `SKILL.md`, so the
  skills CLI ignores them). `examples/CLAUDE.md` mirrors the user's global
  `~/.claude/CLAUDE.md`, sanitized — when the real one changes materially,
  offer to refresh the copy.
- `~/.claude/skills/<name>` entries for these skills are symlinks into this
  clone — editing a skill here is live immediately; commit and push after
  editing.
- Keep skills generic (no personal emails, hosts, or company references);
  machine-specific detail belongs in the user's private CLAUDE.md, not here.
