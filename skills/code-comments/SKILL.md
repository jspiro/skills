---
name: code-comments
description: JS/TS-specific comment and docstring conventions (JSDoc/TSDoc, directive comments, TODO hygiene). Use when writing or reviewing comments in JavaScript/TypeScript code, or setting up comment-related lint rules.
---

# JS/TS Comment Conventions

The core policy lives in global CLAUDE.md: comments state only what the
code cannot show (constraint, subtlety, trap); docstrings lead with what
the function DOES; no reasoning/provenance narration. These are the JS/TS
specifics on top of it.

## JSDoc / TSDoc

- Wrap docstrings and comments at 100 columns — use the full width rather
  than wrapping early at ~80.

- `/** ... */` on every non-trivial function, exported or not — editors
  surface it on hover and at call sites. A good name may stand alone only
  when the arguments are self-describing too; an options object or any
  argument with semantics (units, ranges, "null means X") forces a
  docstring.
- Never duplicate what the type system already says: no `@param {string}`
  type annotations in TS, no `@returns` that restates the return type.
  Use `@param`/`@returns` prose only when the *semantics* need explaining
  (units, valid ranges, "null means X").
- `@throws` is worth writing — TS types can't express it.
- `@deprecated <use-instead>` is machine-read (strikethrough in editors,
  lintable) — use the tag, not a prose note.
- `@example` beats a paragraph for tricky call shapes.
- Interfaces, classes, and their MEMBERS get `/** */` docs too, unless a
  member is dead clear from name + type. Booleans and status-ish fields
  almost never are (`corrected: boolean` — corrected from what, to what?);
  say what true means and relative to what.

## Directive comments

- `@ts-expect-error` over `@ts-ignore` — it errors when the suppression
  becomes unnecessary, so it self-cleans. Always with a reason:
  `// @ts-expect-error <why>`.
- Every `eslint-disable*` carries a reason on the same line. Same for
  `// Stryker disable` (see the `mutation-testing` skill's triage rules).
- Lint support: `@typescript-eslint/ban-ts-comment` (require descriptions),
  `eslint-plugin-tsdoc` (validate TSDoc syntax).

## TODOs

- A TODO without a tracking ref rots: `// TODO(#123): ...` or don't write
  it — file the issue instead. `unicorn/expiring-todo-comments` can
  enforce expiry if a team wants teeth.

## Prefer language features over comments

- `#private` fields / `private` keyword over `@private` tags.
- A well-named extracted function over a section comment inside a long one
  (pairs with the `complexity-gate` skill).
- `as const`, branded types, and enums over comments explaining "don't
  pass other strings here".
