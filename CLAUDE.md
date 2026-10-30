jspiro's personal agent skills, distributed via
`npx skills add jspiro/skills`. Forked from mattpocock/skills (history
retained, content removed) — don't reintroduce upstream files, plugin
manifests, or release automation. Keep it lightweight.

- Skills live flat under `skills/<name>/SKILL.md`.
- Every skill gets a short section in `README.md`, name linked to its
  `SKILL.md`. After any content change, check whether the README needs a
  matching update before committing.
- `examples/` holds copyable, non-installable files (no `SKILL.md`, so the
  skills CLI ignores them). `examples/CLAUDE.md` IS the user's live global
  CLAUDE.md — `~/.claude/CLAUDE.md` symlinks to it. Never break or redirect
  that symlink.
- The working tree is intentionally unclean: it carries personal edits
  (especially to `examples/CLAUDE.md`) that are never committed. Don't
  treat them as unfinished work to commit, tidy, or revert. Stage at the
  hunk level per `git-prefs`.
- `~/.claude/skills/<name>` entries for these skills are symlinks into this
  clone — editing a skill here is live immediately. After editing, propose
  a commit+push (diff-reviewed, per above) and wait for approval; never
  run them unasked.
- Keep committed content generic (no personal emails, hosts, or company
  references); personal detail may live in the working tree uncommitted.
