---
name: code-prefs
description: The user's coding preferences — comments and docstrings in any language (with JS/TS specifics), library over custom code, file hygiene, lint setup. Use when writing or reviewing code, or setting up a project's linting.
---

# Coding preferences

## Comments and docstrings

- A comment states only what the code cannot show: a non-obvious
  constraint, subtlety, or trap. Put it above the line it applies to. When
  in doubt about a line comment, no comment.
- Never narrate reasoning, triage history, or what tool or review prompted
  a change; that belongs in the commit message.
- Every non-trivial function gets a docstring that leads with what it DOES
  (input → result); design rationale comes after, if at all. A name alone
  suffices only when the arguments are self-describing too; an argument
  with semantics (units, ranges, "null means X") needs a docstring.
- Document interface, class, and struct members unless the name and type
  make them clear. Booleans and status fields almost never are
  (`corrected: boolean`: corrected from what, to what?); say what true
  means and relative to what.
- Prefer a language feature over a comment: an extracted, well-named
  function over a section comment inside a long one; a type (`as const`,
  branded types, enums) over "don't pass other strings here"; visibility
  keywords over `@private` tags.
- A TODO carries a tracking ref (`TODO(#123): ...`) or becomes a filed
  issue instead.
- Every lint, type-check, or mutation-testing suppression carries a reason
  on the same line.

### JS/TS

- `/** ... */` on every non-trivial function, exported or not.
- Never duplicate the type system: no `@param {string}` in TS, no
  `@returns` that restates the return type. Use `@param`/`@returns` prose
  only for semantics.
- Write `@throws`; use the `@deprecated <use-instead>` tag rather than a
  prose note; use `@example` for tricky call shapes.
- `@ts-expect-error <why>` over `@ts-ignore`.
- Lint support: `@typescript-eslint/ban-ts-comment` (require
  descriptions), `eslint-plugin-tsdoc`, `unicorn/expiring-todo-comments`.

## Code

- Custom code is almost always worse than library code.
- Keep cyclomatic complexity ≤ 8 per function; the `complexity-gate` skill
  has the edges and lint setup.

## Files and linting

- Run the linter on every script you write before running it.
- Text files end with a newline and carry no trailing whitespace. Lines,
  including comments and docstrings, wrap at 100 columns.
