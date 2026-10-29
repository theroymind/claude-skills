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
3. **Dispatch** one general-purpose agent per slice, using the Brief.
4. **Verify** each report. Run the repo's test and check commands yourself; this is the one gate run that counts. Then run the built-in `code-review` skill once on the diff, at `medium`, or `high` only when the slice touches determinism, memory ownership or a state machine. It already checks `CLAUDE.md`, so add nothing to it. Check scope yourself from `git diff --stat` against the brief's out-of-scope list. Send gate failures and real findings back to the implementing agent with SendMessage, then verify again. Anything beyond the findings (a user decision that changes the slice, a retune, new behaviour) goes to a fresh agent with its own brief that starts from `git diff`, so long-lived agents don't keep re-reading their whole context.
5. **Commit** the task once every slice passes, with one commit per task on the current branch.
6. **Report** to the user: what each slice did, the decisions agents made, the things they flagged, and what the user must check by hand, such as visuals or feel. Leave the task's boxes unchecked.
7. **Approve** with `AskUserQuestion`: approve, or request changes. On approval, check the task's boxes off, commit that change, and go back to step 1. For changes, brief an agent with the fix and repeat from step 4.

## Brief

Subagents load the repo's `CLAUDE.md` on their own. The brief points to it and spends its length on what `CLAUDE.md` can't know:

- **Where**: the repo path, and a note that this is slice N of task X.
- **Read first**: the task entry, the plan sections it cites, the parts of `## Code Shape` this slice implements, and the existing files to build on, with the procedures and types they should reuse. The Code Shape is the contract: the agent builds those types and boundaries as written.
- **Scope**: numbered changes, each concrete enough to check off.
- **Out of scope**: the other slices, later tasks, and files this slice must leave alone.
- **Open decisions**: the questions the plan leaves open. The agent picks the simplest sound option and reports it. If the plan's shape doesn't fit, the agent stops and reports that rather than working around it.
- **Method**: follow `build` and `tdd`.
- **Tests**: which behaviour to cover, and which existing tests are likely to break and must be updated without weakening them.
- **Gates**: the exact test and check commands, all passing before the agent reports.
- **Hands off**: no commits and no checking off boxes. Leave the changes in the working tree.
- **Report**: one short message with each decision made, anything unclear or wrong in the plan, tests whose meaning changed, and the one-line gate result. Skip files and signatures, since the coordinator reads the diff.

For a dependent slice, add what the earlier slice built, such as its new types, procedures and results, and tell the agent to run `git diff`.
