---
name: implement
description: Builds a planned task, routed by its scope. A small task is built in the session; a medium or large one goes to an implementor agent, plus a reviewer when the task asks for one. Use when picking up the next task or building a feature's tasks.
argument-hint: [task]
---

# Implement

Builds one task at a time from the tasks `feature` wrote, and commits each one once. A change too small to need a task goes to `build`.

## Steps

1. **Pick the task.** Use `$ARGUMENTS` if given, otherwise the tracker's ready command `CLAUDE.md` names, such as `tix ready`. Read it with the show command (`tix show REF`) and read its feature the same way. Tell the user which task you picked, in one line.
2. **Build it** by the task's `scope`:
   - `small`: load `kit:build` with the Skill tool and build it yourself, ticking each criterion (`tix tick REF N`) as soon as its code and tests pass.
   - `medium` or `large`: dispatch one `kit:implementor`. Write its Brief to a file outside the repo, such as `<scratchpad>/<task>.md`, and pass the agent only that path. A large task with independent parts can get one implementor per part; a part that builds on another runs after it, and its brief says what the earlier part built.
3. **Verify.** Run the repo's test and check commands yourself; this is the gate run that counts. Read `git diff` against the task's criteria and the brief's out of scope list, and untick (`tix untick REF N`) any ticked criterion the diff doesn't meet. Send gate failures back to the implementor with SendMessage, or fix them yourself on a small task, then verify again. When a criterion isn't met and the fix isn't obvious, don't tick it or work around it: report the gap and ask with `AskUserQuestion` before going on ([asking](../../references/asking.md)). When unsure whether a gap matters, ask; a question costs less than a wrong assumption.
4. **Review** when the task has `review: true`. Dispatch one `kit:reviewer` with the repo path and the brief's path, or the task ref for a small task. Send the findings worth acting on back to the implementor, or fix them yourself on a small task, then verify again.
5. **Commit** once. Tick any criterion the change meets that is still unticked, mark the task done (`tix done REF`), and commit the code and the ticks together with a `Ticket: REF` trailer. When `CLAUDE.md` says where the project documents its architecture, such as a `CLAUDE.md` in each package, a change that moves a module's shape updates that doc in the same commit.
6. **Report** in the chat: what changed, the decisions made, anything flagged, the review's findings with what was fixed and what was left, and what the user must check by hand, such as visuals or feel. Name the commit as `git show HASH` and the task as `tix show REF`. End the turn asking for approval as a review ([asking](../../references/asking.md)).
7. **Approve** from the reply. For changes, brief a fresh implementor that starts from `git show HASH`, or fix it yourself on a small task, then repeat from step 3 and commit the fix with the same trailer. On approval, go back to step 1 for the feature's next ready task.
8. **Finish the feature** once every task is done and the user confirms the feature's criteria: fold anything that must outlast the feature into the project's architecture docs, when it has them, delete the feature's doc and its tasks, and commit that as `Finish <feature>` with a `Ticket: REF` trailer. Its decisions and alternatives were brainstorming and go with it.

## Brief

The implementor already knows its method (`build`), leaves the tree uncommitted, and loads the repo's `CLAUDE.md` on its own. The brief covers what it can't know:

- **Where**: the repo path and the task ref.
- **Read first**: the task and its feature by ref, read with the tracker's show command, never paraphrased. Then the commits worth reading with `git show HASH`, and the existing files, procedures and types to build on. The feature's description is the contract: the agent builds its types and boundaries as written.
- **Scope**: the task's criteria, numbered, and the tracker's tick command, such as `tix tick REF N`.
- **Out of scope**: other tasks, and files this task leaves alone.
- **Open choices**: anything the feature left to judgement. The agent picks the simplest sound option and reports it. If the feature's shape doesn't fit, it stops and reports that.
- **Tests**: the behaviour to cover, and existing tests likely to break, which get updated without being weakened.
- **Gates**: the exact test and check commands, all passing before it reports.

## Messaging

- An agent's final message is its report, delivered once as the notification that it finished. Read it, then go straight to Verify.
- Message an agent only with work: findings to fix or a follow-up to build. An acknowledgement wakes it for nothing.
- If an agent also messaged its report, the finish notification is the same report. Carry on.

## Done when

Every task picked is committed, ticked, done and approved, and a finished feature is deleted with its tasks.
