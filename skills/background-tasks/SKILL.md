---
name: background-tasks
description: Own the full lifecycle of background work — subagents, CI runs, deploys, PR reviewer bots, cron/scheduled jobs, anything running while attention is elsewhere. Use when starting background work, waiting on an external process, asked about progress of running work, or before reporting any monitored work as done or still running.
---

# Background Tasks: Own the Lifecycle

Anything you start — or wait on — is yours until it's verified complete or
explicitly handed off. Work is never silently dropped: be proactive and
persistent until done, or until a genuine roadblock, then alert the user
with the current state.

## Never trust, always verify

- Completion notifications are a convenience signal, not ground truth. For
  any work with external side effects (deploys, evals, CI runs, PRs), verify
  by artifact before reporting status — process lists, output-file mtimes,
  `gh pr/run` state, deployment lists — especially before saying "still
  running."
- A subagent notification whose status is "completed" but whose message
  claims it is "waiting" or "watching" something is a STALL: a completed
  agent watches nothing. Resume it or take over its remaining steps
  immediately.
- If the user asks about progress and you haven't verified within the ETA
  window, check artifacts first, then answer.

## ETA discipline

- When any background job reports an ETA (or you can estimate one),
  immediately schedule a fallback check (one-shot cron/wakeup) at ~2× the
  ETA. When it fires, verify actual state from artifacts, not notifications.
- If the wait spans other work, schedule a RECURRING check loop matched to
  the process's real cadence — not a one-shot — and keep it running until
  the work is verified done or blocked on the user, acting on each round
  unprompted. Delete the loop only then. One-shot checks leave gaps the
  user ends up filling.

## Worked case: the PR review loop

EVERY push to a PR branch (initial, review-fix follow-ups, threshold tweaks,
subagent pushes) triggers a fresh reviewer run. After each push:

1. **Learn the reviewer's typical latency** for the repo: recent runs of the
   review workflow, or comment timestamps vs push times.
2. **Check at ~1× and ~2× that latency.** Nothing by ~2× → check the
   workflow run itself (`gh run list`); a queued or failed reviewer is a
   finding too, not permission to stop.
3. **Read the whole review**: `gh pr view --comments` AND the inline
   comments API (`gh api repos/{owner}/{repo}/pulls/N/comments`) — summary
   comments alone miss inline findings.
4. **Address every finding**: fix it, or reply on the PR with the reasoning
   for not fixing.
5. **Loop** — each fix push starts a new round at step 1. Stop only when the
   latest round is clean, or you're blocked on the user; then alert them
   with the state.

Never report the work "done" while the latest review is unaddressed; verify
review state by artifact at completion-report time, not from memory of an
earlier round. (Failure mode this prevents: fixing review round N, pushing,
and walking away while round N+1 sits unread.)

## Roadblocks

Persist through retryable failures (transient errors, slow queues, flaky
runs). A genuine roadblock is something only the user can resolve: a
decision, credentials, a failing external system, conflicting instructions.
Hitting one: stop looping, alert the user with what's done, what's blocked,
and what you'll do once unblocked — then keep any watch loops alive if the
work can resume without you.
