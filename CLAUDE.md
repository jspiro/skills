jspiro's personal agent skills, distributed via
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
  skills CLI ignores them). `examples/CLAUDE.md` IS the user's live global
  CLAUDE.md — `~/.claude/CLAUDE.md` symlinks to it. Never break or redirect
  that symlink.
- The working tree is NOT kept clean in this repo, and that's intentional:
  the user makes live edits (especially to `examples/CLAUDE.md`) that may be
  personal and never meant to be committed. Never stage a file without
  reviewing its diff first, never stage all changes wholesale, and never
  treat an uncommitted change as unfinished work to commit, clean up, or
  revert. When a file mixes committable and personal changes, split them:
  write the committable version, stage and commit it, then restore the
  personal edits to the working tree.
- `~/.claude/skills/<name>` entries for these skills are symlinks into this
  clone — editing a skill here is live immediately; commit and push after
  editing (diff-reviewed, per above).
- Keep committed content generic (no personal emails, hosts, or company
  references); personal detail may live in the working tree uncommitted.
