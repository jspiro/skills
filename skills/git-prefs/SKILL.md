---
name: git-prefs
description: The user's git preferences — applies to commits, amends, cherry-picks, reverts, rebases, branches, pushes, staging, and history rewrites (commit-tree, filter-branch, filter-repo). Enforces author identity = `git config user.email`. Suggests committing after each task.
---

# Git rules

## Workflow

- After a task is done, suggest committing the work.
- Stay on feature branches; never commit on `main`. Return to `main` after merge.
- Pull with rebase (`git pull --rebase`).
- Force-push: `--force-with-lease` only, on feature branches. Never plain `--force`. Never to `main`.
- Before `git push`: `git fetch origin` and confirm the current branch tracks a remote.

## Commits

- Commit message: clear descriptive subject, body lines for detail when it helps. No Conventional Commits prefixes (`feat:` / `fix:` / etc.).
- Run `git status` first. Unexpected staged changes → stop, surface to the user.
- Stage paths individually. No `git add -A` / `git add .`.
- Don't `git add` files you didn't generate.
- Untracked files that shouldn't be tracked: propose a `.gitignore` entry only if the file is project-relevant (build artifact, env template, anything other devs would also generate). Personal files (editor noise, local notes) — leave alone; they belong in `~/.gitignore_global` or nowhere.
- Empty commits OK when intentional (e.g., CI trigger). Never use `wip`/`WIP` subjects.

## Signing

Check how signing is set up before assuming anything:
`git config commit.gpgsign` and `git config gpg.format` (and
`gpg.ssh.program` to spot an agent like 1Password).

- **Signing not configured** (`commit.gpgsign` unset/false): commit normally.
  Never add `-S` or suggest enabling signing unprompted.
- **Signing configured and working**: commit normally; the config does the
  signing. Don't disable it.
- **Signing configured but the signer is unavailable** — the signing agent is
  locked or unreachable (1Password: `failed to fill whole buffer` /
  `failed to write commit object`; gpg: `signing failed: No secret key` or a
  pinentry timeout; missing hardware key). This is NOT a reason to stop work:
  - Keep committing **unsigned** (`git commit --no-gpg-sign`) so progress
    continues. The commit content/identity is unchanged — only the signature
    is deferred.
  - Remind the user once, with the unlock step for their setup (1Password:
    `op signin`; gpg: unlock the key/pinentry; hardware key: plug it in) and
    note you'll re-sign the unsigned commits afterwards.
  - Once the signer is available, **re-sign** the unsigned run by rebasing:
    `git rebase --exec 'git commit --amend --no-edit -S' <first-unsigned>^`
    (interactive rebase is unavailable in this env — use `--exec`). Verify
    afterwards with `git log --show-signature`.
- Only the local feature branch's own unsigned commits get re-signed; never
  rewrite already-pushed/shared history beyond a `--force-with-lease` on the
  feature branch.

## After pushing to a PR

A push is not the end of the work: every push (initial or follow-up)
triggers a fresh review round from human or bot reviewers. Own it — stay
proactive and persistent, addressing findings until the PR is clean or you
hit a roadblock only the user can clear, then alert them with the state.
Never let PR work drop silently. Full lifecycle discipline (latency checks,
verify-by-artifact, recurring watch loops): the `background-tasks` skill.

## Identity (don't override)

- Author/committer must be `git config user.email`. Verify with `git var GIT_AUTHOR_IDENT`.
- No `--author`, `-c user.email/name`, `GIT_AUTHOR/COMMITTER_*` env vars, `commit-tree`, `filter-branch --env-filter`, or `filter-repo --email-callback/--name-callback/--mailmap`.
- On `--amend`: if `git log -1 --pretty=%ae` ≠ `git config user.email`, require `--reset-author` or stop.
- Never run `git config … user.email|user.name` (any scope). The user's `~/.gitconfig` is theirs.

## When something doesn't fit

Surface the conflict — don't work around. No baked-in escape hatches.
