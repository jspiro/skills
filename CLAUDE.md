Two-skill repo: jspiro's personal agent skills, distributed via
`npx skills add jspiro/skills`. Forked from mattpocock/skills (history
retained, content removed) — don't reintroduce upstream files, plugin
manifests, or release automation. Keep it lightweight.

- Skills live flat under `skills/<name>/SKILL.md`.
- Every skill must appear in the top-level `README.md` table, name linked to
  its `SKILL.md`.
- `~/.claude/skills/<name>` entries for these skills are symlinks into this
  clone — editing a skill here is live immediately; commit and push after
  editing.
- Keep skills generic (no personal emails, hosts, or company references);
  machine-specific detail belongs in the user's private CLAUDE.md, not here.
