---
name: prompting-prefs
description: How to write rules, skills, CLAUDE.md entries, and agent prompts — plain contextual language, say what not why, self-documenting rules, static checks before prose, context cost. Use when creating or editing a skill, a CLAUDE.md, a hook or subagent prompt, or when persisting a lesson through internalize.
---

# Prompting preferences

## Say what, not why

- State the instruction. Add a reason only when the goal cannot be stated
  as an instruction, or the rule is easy to misread.
- Word a rule so it implies its reason ("run a destructive command alone
  so the prompt shows only it") rather than adding a rationale sentence.
  When a principle serves several rules, state it here, not in each rule.
- Narrate reasoning only in interactive discussion, in comments where the
  explanation is non-obvious, or in documents whose purpose is to justify.

## Language

- Plain and precise, with words that fit the context: "evict" for a cache
  entry, "delete" for a file. Metaphors and color belong in prose, not in
  rules.
- Use RFC 2119 terms (MUST, MUST NOT, SHOULD, MAY) when they are more
  precise than the plain sentence, not by default.
- Imperative, specific, testable. Name the trigger: "When X, do Y" beats
  "Prefer Y".
- A rule is one to three sentences; a skill step a few lines. No references
  to a conversation, a date, or the incident that prompted the rule.

## Where a rule lives

- Prefer a static check (permission rule, hook, lint, test, CI) when one is
  cheap and reliable. Document it where it lives (script header, README)
  and leave at most a one-line pointer in CLAUDE.md; a hook that fires on
  its own needs none.
- CLAUDE.md holds short, always-relevant rules and one pointer per skill
  naming its trigger. Situational knowledge goes in a skill, unless
  describing it takes fewer words than a pointer; then it goes in the
  CLAUDE.md Situational section and moves to a skill once the group grows.
- Keep a rule in CLAUDE.md when it must apply at a moment no skill would
  be loaded.
- A skill's description loads into every conversation; keep it to one or
  two sentences that name the triggers.

## Structure

- Before adding a rule, grep the target for an existing one; strengthen it
  rather than duplicating.
- Add to the matching section of the target file rather than appending to
  the bottom.
