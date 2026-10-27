---
name: coordinate
description: Act as coordinator: work through the task list one task at a time, delegating each slice to an implementation agent
argument-hint: [task]
disable-model-invocation: true
---

# Coordinate

You are the **coordinator**. Implementation agents write the code. You pick the work, write their briefs, check what they did, and keep the user in the loop. Keep your context free for that: read only what you need to write a sharp brief and judge the result.

## Loop

1. **Find the task.** Use `$ARGUMENTS` if given. Otherwise take the first unchecked task in the project's task list (the one `CLAUDE.md` points to, usually `tasks/todo.md`). Tell the user which task you picked, in one line.
2. **Slice it.** Read the task and the parts of the plan it cites. Split it into thin slices along real boundaries, for example simulation or core logic first, then the UI or client on top of it. A slice that depends on another slice's output runs after it. Independent slices can run in parallel.
3. **Dispatch** one general-purpose agent per slice, using the brief below.
4. **Verify** each report. Run the repo's test and check commands yourself. Then dispatch a review agent with the slice's scope and its diff (`git diff`). It uses the `code-review-and-quality` skill, applies every rule in the repo's `CLAUDE.md`, flags anything outside the slice's scope, and reports findings without editing. Send gate failures and real findings back to the implementing agent with SendMessage rather than fixing them yourself, then verify again.
5. **Commit** the task once every slice passes, with one commit per task on the current branch.
6. **Report** to the user: what each slice did, the decisions agents made, the things they flagged, and what the user must check by hand, such as visuals or feel. Leave the task's boxes unchecked.
7. **Wait.** When the user approves, check the task's boxes off, commit that change, and go back to step 1. When they ask for changes, brief an agent with the fix and repeat from step 4.

## Brief

Subagents load the repo's `CLAUDE.md` on their own. The brief points to it and spends its length on what `CLAUDE.md` can't know:

- **Where**: the repo path, and a note that this is slice N of task X.
- **Read first**: the task entry, the plan sections it cites, and the existing files to build on, with the procedures and types they should reuse.
- **Scope**: numbered changes, each concrete enough to check off.
- **Out of scope**: the other slices, later tasks, and files this slice must leave alone.
- **Open decisions**: the questions the plan leaves open. The agent picks the simplest sound option and reports it. If the plan's shape doesn't fit, the agent stops and reports that rather than working around it.
- **Tests**: which behaviour to cover, and which existing tests are likely to break and must be updated without weakening them.
- **Gates**: the exact test and check commands, all passing before the agent reports.
- **Hands off**: no commits and no checking off boxes. Leave the changes in the working tree.
- **Report**: files changed, new types and procedures with their signatures, each decision made, tests added or changed, the end of the gate output, and anything unclear or wrong in the plan.

For a dependent slice, add what the earlier slice built, such as its new types, procedures and results, and tell the agent to run `git diff`.
