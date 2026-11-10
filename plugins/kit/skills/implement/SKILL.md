---
name: implement
description: Builds a feature's planned tasks, independent ones in parallel, routed by scope. A small task is built in the session; a medium or large one goes to an implementor agent. The feature gets one review at the end from parallel reviewers. Use when picking up the next task or building a feature's tasks.
argument-hint: [task]
---

# Implement

Builds the tasks `feature` wrote in batches of ready tasks, in parallel, commits each task once, and reviews the feature once at the end. A change too small to need a task goes to `build`.

## Steps

1. **Pick the batch.** With `$ARGUMENTS`, the batch is that one task. Otherwise it is every task the tracker's ready command (`CLAUDE.md` names it, such as `tix ready`) lists for the feature: a ready task has no unfinished dependency, so the batch builds in parallel. Read each with its feature through the show command (`tix show REF --with-parent`). Mark each started (`tix start REF...`), and the feature too while it is still to do, so trackers and panels show them being worked on. Then tell the user which tasks you picked, in one line.
2. **Build the batch** at once, each task by its `scope`:
   - `medium` or `large`: dispatch one `kit:implementor` per task, all before building anything yourself. Write each Brief to a file outside the repo, such as `<scratchpad>/<task>.md`, and pass the agent only that path. A large task with independent parts gets one implementor per part; a part that builds on another runs after it, and its brief says what the earlier part built. Tasks or parts that list the same file build one after the other: the one more tasks depend on goes first, and the other joins the next batch. The ones building at once each get their own git worktree under `.claude/worktrees/` (`git worktree add -b <branch> .claude/worktrees/<task>`), merged back in Verify. Add `.claude/worktrees/` to the repo's `.gitignore` first if it isn't there.
   - `small`: load `kit:build` with the Skill tool and build it yourself while the implementors run, ticking each criterion (`tix tick REF N`) as soon as its code and tests pass.
3. **Verify** once the batch's builds finish, since a gate run while another agent is mid-edit in the same tree fails for nothing. Merge the worktrees back one at a time, and run the repo's test and check commands yourself on the merged tree after each merge, before the next: a merge that needed a conflict resolved is code no agent tested. These are the gate runs that count. Check each task from its report and its ticked criteria. Read its diff only where the report flags something, where a gate fails, or when its `review` is `none`, since the feature's reviewers read the rest. Untick (`tix untick REF N`) any ticked criterion the change doesn't meet. Send gate failures back to the task's implementor with SendMessage, or fix them yourself on a small task, then verify again. When a criterion isn't met and the fix isn't obvious, don't tick it or work around it: report the gap and ask with `AskUserQuestion` before going on ([asking](../../references/asking.md)). When unsure whether a gap matters, ask; a question costs less than a wrong assumption.
4. **Commit** each task once, in its own commit. Tick any criterion the change meets that is still unticked, mark the task done (`tix done REF`), and commit the task's code and ticks together with a `Ticket: REF` trailer. Every commit runs the repo's hooks, and `tix done` runs without `--force`: a hook that is too slow, or a criterion only the user can check, is a finding for the Report. When `CLAUDE.md` says where the project documents its architecture, such as a `CLAUDE.md` in each package, a change that moves a module's shape updates that doc in the same commit.
5. **Report** the batch in the chat: per task, what changed, the decisions made, anything flagged, and what the user must check by hand, such as visuals or feel. Name each commit as `git show HASH` and each task as `tix show REF`. End the turn asking for approval as a review ([asking](../../references/asking.md)).
6. **Approve** from the reply. For changes to a task, set it back to started (`tix start REF`), then brief a fresh implementor that starts from `git show HASH`, or fix it yourself on a small task, then repeat from step 3 and commit the fix with the same trailer. On approval, go back to step 1 for the next batch; once the feature has no ready task left, go to Review.
7. **Review** the feature once, after its last task is approved, when any of its tasks has `review` `pending`. Mark the feature in review (`tix review FEATURE`). Dispatch the reviewers at once, each a `kit:reviewer` with the repo path, the feature ref, the feature's commit range, and the one lens it walks: Correct, Modular, Composed, Cheap, plus one more for the language rules and the lenses the project's review profile adds, when the change has any. Merge the findings, drop duplicates, and rank them. Fix the ones worth acting on with fresh implementors in parallel, one per group of findings that share no files, or yourself when small; run the gates, and commit the fixes with the feature's `Ticket:` trailer. Set `review=done` on every task the review covered and the feature back to started (`tix start FEATURE`). Report the findings, what was fixed and what was left, and ask for approval as in step 5. When the user asks for a review per task instead, review each task after Verify the same way, over its uncommitted diff, before its commit.
8. **Finish the feature** once every task is done and the user confirms the feature's criteria: fold anything that must outlast the feature into the project's architecture docs, when it has them, delete the feature's doc and its tasks, and commit that as `Finish <feature>` with a `Ticket: REF` trailer. Its decisions and alternatives were brainstorming and go with it.

## Brief

The implementor already knows its method (`build`), leaves the tree uncommitted, and loads the repo's `CLAUDE.md` on its own. The brief covers what it can't know:

- **Where**: the repo or worktree path and the task ref.
- **Read first**: the task and its feature by ref, read with the tracker's show command (`tix show REF --with-parent` reads both), never paraphrased. Then the commits worth reading with `git show HASH`, and the existing files, procedures and types to build on. The feature's description is the contract: the agent builds its types and boundaries as written.
- **Scope**: the task's criteria, numbered, and the tracker's tick command, such as `tix tick REF N...`, with `tix ac ls --open REF` to list what is still unticked.
- **Out of scope**: other tasks, including the ones building beside it in the same tree, and files this task leaves alone.
- **Open choices**: anything the feature left to judgement. The agent picks the simplest sound option and reports it. If the feature's shape doesn't fit, it stops and reports that.
- **Tests**: the behaviour to cover, and existing tests likely to break, which get updated without being weakened.
- **Gates**: the exact test and check commands, all passing before it reports.

## Messaging

- An agent's final message is its report, delivered once as the notification that it finished. Read it, then wait for the rest of the batch before Verify.
- Message an agent only with work: findings to fix or a follow-up to build. An acknowledgement wakes it for nothing.
- If an agent also messaged its report, the finish notification is the same report. Carry on.

## Done when

Every task picked is committed, ticked, done and approved, the feature's review has run with its fixes committed, and a finished feature is deleted with its tasks.
