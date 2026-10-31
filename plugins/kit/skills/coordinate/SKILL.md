---
name: coordinate
description: Implements planned work as coordinator, delegating each slice of a task to an implementation agent and verifying the result. The default way to implement anything beyond a quick fix; use when picking up a task from the task list or implementing a planned feature.
argument-hint: [task]
---

# Coordinate

The default way to implement: quick fixes go to `build`, everything else comes here. You are the **coordinator**. Implementation agents write the code. You pick the work, write their briefs, check what they did, and keep the user in the loop. Keep your context free for that: read only what you need to write a sharp brief and judge the result.

## Steps

1. **Find the task.** Use `$ARGUMENTS` if given. Otherwise take the first unchecked task in the project's task list (the one `CLAUDE.md` points to, usually `tasks/todo.md`). Tell the user which task you picked, in one line. If the task creates new modules, core types or boundaries and the plan's `## Code Shape` doesn't cover them, run `architect` scoped to this task first, and continue only once the user has answered its decisions.
2. **Slice it.** Read the task and the parts of the plan it cites. Split it into thin slices along real boundaries, as described in `breakdown`'s Slicing: for example simulation or core logic first, then the UI or client on top of it. A slice that depends on another slice's output runs after it. Independent slices can run in parallel.
3. **Dispatch** one `kit:implementor` agent per slice, using the Brief. It runs on Opus whatever model you are on, so a cheaper or faster model can coordinate. Its report arrives once, as the notification that the agent finished; see Messaging.
4. **Verify** each report. Run the repo's test and check commands yourself; this is the one gate run that counts. Read the diff against the brief: scope from `git diff --stat` against the out-of-scope list, and the changes themselves for the decisions the report names. That read is the review for most slices. Run the built-in `code-review` skill, at `medium`, only when the slice earns a second pair of eyes: it touches determinism, memory ownership, a state machine, concurrency, auth or data loss, or the diff is over about 300 lines. It already checks `CLAUDE.md`, so add nothing to it. Send gate failures and real findings back to the implementing agent with SendMessage, then verify again. Anything beyond the findings (a user decision that changes the slice, a retune, new behaviour) goes to a fresh agent with its own brief that starts from `git diff`, so long-lived agents don't keep re-reading their whole context.
5. **Commit** the task once every slice passes, with one commit per task on the current branch.
6. **Report** as a review ([asking](../../references/asking.md)): what each slice did, the decisions agents made, the things they flagged, and what the user must check by hand, such as visuals or feel. Leave the task's boxes unchecked.
7. **Approve** from the reply. On approval, check the task's boxes off, commit that change, and go back to step 1. For changes, brief an agent with the fix and repeat from step 4.

## Brief

The implementor already knows its method (`build`, `tdd`), that it leaves the tree uncommitted, and how to report, and it loads the repo's `CLAUDE.md` on its own. The brief spends its length on what neither can know:

- **Where**: the repo path, and a note that this is slice N of task X.
- **Read first**: the task entry, the plan sections it cites, the parts of `## Code Shape` this slice implements, and the existing files to build on, with the procedures and types they should reuse. The Code Shape is the contract: the agent builds those types and boundaries as written.
- **Scope**: numbered changes, each concrete enough to check off.
- **Out of scope**: the other slices, later tasks, and files this slice must leave alone.
- **Open decisions**: the questions the plan leaves open. The agent picks the simplest sound option and reports it. If the plan's shape doesn't fit, the agent stops and reports that rather than working around it.
- **Tests**: which behaviour to cover, and which existing tests are likely to break and must be updated without weakening them.
- **Gates**: the exact test and check commands, all passing before the agent reports.
- **Report**: the final message of the agent's turn, nothing sent separately: each decision made, anything unclear or wrong in the plan, tests whose meaning changed, and the one-line gate result. Skip files and signatures, since the coordinator reads the diff.

For a dependent slice, add what the earlier slice built, such as its new types, procedures and results, and tell the agent to run `git diff`.

## Messaging

One message per direction, and every message carries work:

- **Reports come to you.** An agent's final message is its report, delivered once as the notification that it finished. Read it, then go straight to Verify.
- **Only send work.** Message an agent only with findings to fix or a follow-up to build. An acknowledgement wakes the agent for nothing, and its reply is one more notification for you to read.
- **A second copy is the same report.** If an agent also messaged you its report, the finish notification repeats it. Carry on from where you were; nothing new has arrived.
