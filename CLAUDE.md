This is jspiro's fork of [mattpocock/skills](https://github.com/mattpocock/skills).
jspiro's own skills live in `skills/personal/`; the other buckets are inherited
from upstream and kept merge-friendly — avoid editing upstream skill files
unless deliberately diverging.

Skills are organized into bucket folders under `skills/`:

- `personal/` — jspiro's own skills (the reason this fork exists)
- `engineering/` — daily code work (upstream)
- `productivity/` — daily non-code workflow tools (upstream)
- `misc/` — kept around but rarely used (upstream)
- `in-progress/` — upstream beta skills
- `deprecated/` — no longer used (upstream)

The upstream Claude Code plugin manifests (`.claude-plugin/`), changesets, and
release workflow were removed in this fork — distribution is via
`npx skills add jspiro/skills` only. Don't reintroduce them.

Every skill in `personal/` must be listed in the top-level `README.md` table
and in `skills/personal/README.md`, with the skill name linked to its
`SKILL.md`.

When syncing from upstream (`git pull upstream main`), expect conflicts in
`README.md` and this file — keep the fork's versions and take upstream's
changes everywhere else.

To (re)link every skill into the local harness skill directories
(`~/.claude/skills`, `~/.agents/skills`), run `scripts/link-skills.sh`. Each
entry is a symlink into this repo, so a `git pull` keeps installed skills
current; re-run the script after adding, removing, or renaming a skill.
