---
name: internalize
description: Turn user corrective feedback into a durable rule — in the right CLAUDE.md tier, or a skill with a CLAUDE.md pointer when the lesson is big or situational — then address the feedback. Use when the user corrects how Claude worked ("no, I wanted...", "don't do that", "that's not what I asked", "next time do X"), gives a preference meant to apply going forward, or invokes /internalize. Not for one-off task tweaks with no future relevance, and not for session-summary CLAUDE.md maintenance (use revise-claude-md for that).
---

# Internalize Feedback

When the user says you did something differently than they wanted, extract the
right lesson, persist it where it will actually prevent a repeat, then fix the
work. Order: **Q&A → propose → persist → red-team → summarize → fix**.

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

Present your read in the message text first, then call AskUserQuestion to
collect the answer. Option `preview` blocks are for single-select questions
whose options carry genuinely different texts to compare (variant A vs B);
never make a preview the only place a single proposal's text appears — a
question about text the user cannot see is the failure this phase
prevents. Iterate until the user confirms your read matches theirs.

## 2. Propose — state the rule

Only now restate the lesson as the rule you'd write: show the exact text in
the message body (a fenced block), name the destination, then collect
approve/revise with AskUserQuestion (previews only for competing variants). Do not persist until the user confirms the lesson is stated
right — a wrong generalization recorded is worse than none. If the
correction contradicts an existing CLAUDE.md rule, surface the conflict and
ask which wins.

## 3. Persist — write the rule

**Choose the destination:**

| Lesson is about | Destination |
|---|---|
| Personal preference, workflow, communication style — true in any repo | `~/.claude/CLAUDE.md` |
| This repo's conventions, architecture, process | `<repo>/CLAUDE.md` |
| One domain within the repo (tests, prompts, e2e, ...) that has its own CLAUDE.md | that subdirectory's `CLAUDE.md` |
| Substantial or situational knowledge — a procedure, a rule set, anything over ~10 lines, or knowledge only some conversations need | a skill (new, or extend an existing one), plus a one-line pointer in the CLAUDE.md tier above |

CLAUDE.md lines load into every conversation; a skill loads only when
triggered. Short, always-relevant rules stay in CLAUDE.md; bulk and
situational scope go to a skill — but never exile a two-line rule to a skill,
where it won't be loaded at the moment it applies. When the destination is a
skill, the pointer line is what makes it reachable: name the trigger
condition in it ("for any git work, follow the `git-prefs` skill").

If genuinely ambiguous (e.g. "is this preference personal or team-wide?"),
include a destination question in the step-1 interview instead of guessing.

**Before adding, check for an existing rule:**
- Grep the candidate file(s) for related rules. If one exists and was violated,
  don't duplicate it — reword/strengthen it so it would have prevented this
  instance, and note that the old wording failed.
- Respect the target file's structure: add to the matching existing section
  (e.g. a project file's agent-guidance or code-style section) rather than
  appending to the bottom.

**Write the rule so a future agent with zero context of this conversation
follows it:**
- Imperative, specific, testable. Name the trigger condition, not just the
  behavior: "When X, do Y" beats "Prefer Y".
- Include a one-line WHY when the rule looks arbitrary without it.
- Include a concrete example if the rule is easy to misread.
- No references to "this conversation", today's date, or the specific incident.

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
- **How could the rule itself backfire?** Imagine situations where following it
  produces a worse outcome than the original mistake: overcorrection (the rule
  fires where it shouldn't and blocks good behavior), collateral damage (it
  fixes this case but degrades an adjacent one), or perverse compliance
  (satisfying the letter of the rule while defeating its purpose). If the rule
  is only safe within limits, write the limits into the rule.

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
