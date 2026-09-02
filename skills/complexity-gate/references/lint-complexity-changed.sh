#!/usr/bin/env bash
# Cyclomatic-complexity gate, scoped to the files changed vs a base ref.
#
# `pnpm lint:complexity` (eslint over the whole repo) is an advisory
# inventory — legacy functions over the cap fail it until they're touched,
# so it cannot gate CI. THIS script is the gate: it lints only the files
# the current branch changed, so a PR fails only on complexity it
# introduced or touched.
#
# Usage: lint-complexity-changed.sh [base-ref]   (default: origin/main)
set -euo pipefail

base="${1:-origin/main}"

# --diff-filter=d: skip deleted files (nothing to lint).
files=()
while IFS= read -r f; do
  files+=("$f")
done < <(git diff --name-only --diff-filter=d "$base"...HEAD -- '*.ts' '*.tsx' '*.mts' '*.mjs')

if [ "${#files[@]}" -eq 0 ]; then
  echo "No changed lintable files vs $base."
  exit 0
fi

echo "Linting ${#files[@]} changed file(s) vs $base:"
printf '  %s\n' "${files[@]}"
# --no-warn-ignored: changed files matching eslint's ignore list (generated
# code, sandboxes) are silently skipped instead of emitting warnings.
npx eslint --no-warn-ignored "${files[@]}"
