---
name: internalize
description: Turn user corrective feedback into a durable rule — in the right CLAUDE.md tier, or a skill with a CLAUDE.md pointer when the lesson is situational — then address the feedback. Use when the user corrects how Claude worked ("no, I wanted...", "don't do that", "that's not what I asked", "next time do X"), gives a preference meant to apply going forward, or invokes /internalize. Not for one-off task tweaks with no future relevance, and not for session-summary CLAUDE.md maintenance (use revise-claude-md for that).
---

# Internalize Feedback

When the user says you did something differently than they wanted, extract the
right lesson, persist it where it will actually prevent a repeat, then fix the
work. Order: **Q&A → check over prose → destination → propose → red-team →
summarize → fix**.

## 0. Identify the feedback

- **Invoked with arguments** (`/internalize <feedback>`): the arguments ARE the
  feedback. Prefer this reading over guessing from conversation history, even
  if recent messages contain other corrections.
- **Invoked bare or triggered proactively**: the feedback is the user's most
  recent correction. If it's ambiguous which of the last few messages is the
  lesson, ask — don't guess.

## 1. Q&A — learn the user's take BEFORE proposing anything

Do not draft a rule yet. Put YOUR read of what happened in front of the
user as a question and let them correct it. Cover, in order:

- **Your read of what you did wrong**, as the question's options:
  single-select (radio) when there are competing interpretations of one
  act; multi-select when the failure is several things conflated or
  decomposes into parts. Always include the user's own framing if they
  gave one.
- **Scope and boundaries**: where the lesson applies and where it must NOT
  fire.
- **Whether a rule is warranted at all** — a one-off may not need
  persisting.

Present your read in the message text first, then call AskUserQuestion
with a one-line question and label options. Never make an option or
preview the only place a proposal's text appears; previews are for
comparing genuinely different variants. Iterate until the user confirms
your read.

## 1b. Prefer a check over prose

If a permission rule, hook, lint rule, pre-commit, test, or CI gate can
enforce the lesson cheaply and reliably, build that instead; the
`prompting-prefs` skill says how to document it. Skip this when the check
would be flaky or larger than a few dozen lines.

## 2. Choose the destination

| Lesson is about | Destination |
|---|---|
| Personal preference, workflow, communication style — true in any repo | `~/.claude/CLAUDE.md` |
| This repo's conventions, architecture, process | `<repo>/CLAUDE.md` |
| One domain within the repo (tests, prompts, e2e, ...) that has its own CLAUDE.md | that subdirectory's `CLAUDE.md` |
| Situational knowledge — a procedure, a rule set, anything only some conversations need | a skill (new, or extend an existing one), plus a one-line pointer in the CLAUDE.md tier above |
| Situational, but shorter to state than a skill pointer | CLAUDE.md, grouped with similar items; move the group into a skill once that saves context |

If genuinely ambiguous (e.g. "is this preference personal or team-wide?"),
include a destination question in the step-1 interview instead of guessing.

Grep the candidate file(s) for a related rule. If one exists and was
violated, reword or strengthen it so it would have prevented this instance,
and note that the old wording failed.

## 3. Propose the edit

Name the destination in one line, then make the edit with Write or Edit so
the user approves the diff itself. If the user declines, revise and
propose again; do not record the rule anywhere else. Use AskUserQuestion
only to choose between competing variants. If the correction contradicts
an existing rule, show the conflict and ask which wins.

Write the rule per the `prompting-prefs` skill, so a future agent with zero
context of this conversation follows it.

## 4. Red-team — second pass on the written rule

Re-read the rule exactly as it now stands in the file, pretending you have zero
memory of this conversation, and simulate re-encountering the original
situation (and near-variants of it):

- **Would the rule actually fire?** Is the trigger condition recognizable from
  inside the situation, or only in hindsight?
- **Would it produce the behavior the user wanted?** Or does it stop one step
  short (names the problem but not the required action, or vice versa)?
- **Where is it ambiguous?** Find at least one reading of the rule that a
  well-meaning agent could follow while still repeating the mistake.
- **Does it conflict with or duplicate neighboring rules** in the same file, or
  in the other CLAUDE.md tiers?
- **How could the rule itself backfire?** Overcorrection, collateral damage
  to an adjacent case, or letter-not-spirit compliance. If the rule is only
  safe within limits, write the limits into it.

Amend the rule to close any gap you find. If closing a gap requires a decision
only the user can make, ask now rather than papering over it.

## 5. Summarize — say what you learned

Before touching the original work, give a short summary:
- **Lesson**: the rule as written, quoted verbatim.
- **Where**: which CLAUDE.md and section, and whether it was added or a
  revision of an existing rule.
- **Next**: what you're about to change to address the immediate feedback.

## 6. Fix — address the feedback

Redo or correct the original work per the feedback. If the fix reveals the rule
was mis-stated (the real lesson turns out different), go back and amend the
recorded rule and say so.
