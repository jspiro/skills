---
name: git-prefs
description: The user's git preferences — applies to commits, amends, cherry-picks, reverts, rebases, branches, pushes, staging, and history rewrites (commit-tree, filter-branch, filter-repo). Enforces author identity = `git config user.email`. Suggests committing after each task.
---

# Git rules

## Workflow

- After a task is done, suggest committing the work — suggest, don't do.
  Commits, pushes, and merges run only on explicit approval, and approval
  covers that action once, not the rest of the session. In particular:
  editing an installed skill never implies committing or pushing it.
- Stay on feature branches; never commit on `main`. Return to `main` after merge.
- Where branch work happens depends on where the changes are:
  - **Starting NEW work** (nothing relevant uncommitted yet): use a git
    worktree (`git worktree add <dir>/<branch> <branch>`, honoring the
    repo's directory convention, e.g. `.worktrees/`) and leave the primary
    checkout on its default branch — other agent sessions may share the
    primary, and a branch switch underneath them lands their commits on
    the wrong branch.
  - **Committing changes that already exist in the primary working tree**:
    ask the user whether to (a) move them into a worktree branch or
    (b) check out a branch in the primary and commit them in place as
    usual. Never copy them into a worktree — the same change living in
    two places guarantees pull friction at merge. If moving, verify each
    file is byte-identical on the branch before removing it from the
    primary, leaving unstaged only what is not going into the branch.
- Unexpected working-tree edits or unfamiliar commits in the primary
  checkout are another session's live work — never stage, stash, reset, or
  "tidy" them, and don't build on top of them.
- Pull with rebase (`git pull --rebase`). In a repo that intentionally
  carries long-lived uncommitted edits, suggest `git config
  rebase.autostash true` (repo-local) once — it auto-stashes and restores
  them around each pull instead of erroring.
- Force-push: `--force-with-lease` only, on feature branches. Never plain `--force`. Never to `main`.
- Before `git push`: `git fetch origin` and confirm the current branch tracks a remote.
- Before any push that will face CI, run the project's own gates locally on
  the changed files first — typecheck, tests, lint/complexity, scoped
  mutation testing when logic changed. Run EVERY gate the PR runs, not a
  subset (a gate skipped locally is the one that fails remotely). CI
  confirms, it never informs: pushing to learn what a local run would have
  said wastes a full CI round trip.

## Commits

- Commit message: clear descriptive subject, body lines for detail when it helps. No Conventional Commits prefixes (`feat:` / `fix:` / etc.).
- Run `git status` first. Unexpected staged changes → stop, surface to the user.
- Stage paths individually. No `git add -A` / `git add .`.
- Before staging a file, review its full diff (`git diff <file>`) and decide
  whether parts should stay unstaged. Local-only edits (personal notes,
  machine-specific tweaks) are legitimate and may live in the working tree
  indefinitely — an unclean tree is not a mess to tidy. When a file mixes
  committable and local-only changes, or its changes belong in different
  commits, split at the HUNK level: save `git diff <file>` to a patch,
  trim it to the hunks being committed, and stage with
  `git apply --cached <patch>` — the working tree never changes
  (`git add -p` is interactive and usually unavailable). Never edit the
  file to temporarily remove content, commit, and re-add it: churning the
  tree to serve staging risks committing the mutilated intermediate.
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
