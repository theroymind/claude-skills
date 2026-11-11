---
name: implement
description: Builds a feature's planned tasks, independent ones in parallel, routed by scope. A small task is built in the session; a medium or large one goes to an implementor agent. The feature gets one review at the end from parallel reviewers. Use when picking up the next task or building a feature's tasks.
argument-hint: [task]
---

# Implement

Builds the tasks `feature` wrote in batches of ready tasks, in parallel, commits each task once, and reviews the feature once at the end. A change too small to need a task goes to `build`.

## Steps

1. **Pick the batch.** With `$ARGUMENTS`, the batch is that one task. Otherwise it is every ready task of the feature, which builds in parallel since none waits on another. Show each with its feature, start each one, and start the feature too while it is still to do. Then tell the user which tasks you picked, in one line.
2. **Build the batch** at once, each task by its `scope`:
   - `medium` or `large`: dispatch one `kit:implementor` per task (Dispatch), all before building anything yourself.
   - `small`: load `kit:build` with the Skill tool and build it yourself while the implementors run, ticking each criterion as soon as its code and tests pass.
3. **Verify** once the batch's builds finish. Merge any worktrees back (Worktrees), then check each task from its report and its ticked criteria. Read its diff only where the report flags something, where a gate fails, or when its `review` is `none`, since the feature's reviewers read the rest. Untick any ticked criterion the change doesn't meet. Send gate failures back to the task's implementor, or fix them yourself on a small task, then verify again. When a criterion isn't met and the fix isn't obvious, report the gap and ask as a choice ([asking](../../references/asking.md)) before going on.
4. **Commit** each task once, in its own commit. Tick any criterion the change meets that is still unticked, mark the task done, and commit the task's code and ticks together with a `Ticket: REF` trailer (Gates says which run counts). When `CLAUDE.md` says where the project documents its architecture, a change that moves a module's shape updates that doc in the same commit.
5. **Report** the batch in the chat: per task, what changed, the decisions made, anything flagged, and what the user must check by hand, such as visuals or feel. Name each commit as `git show HASH` and each task by its show command. End the turn asking for approval as a review ([asking](../../references/asking.md)).
6. **Approve** from the reply. For changes to a task, start it again, then brief a fresh implementor that starts from `git show HASH`, or fix it yourself on a small task, then repeat from step 3 and commit the fix with the same trailer. On approval, go back to step 1 for the next batch; once the feature has no ready task left, go to step 7.
7. **Review** the feature once, after its last task is approved, when any of its tasks has `review` `pending` (Feature review).
8. **Finish the feature** once every task is done and the user confirms the feature's criteria: fold anything that must outlast the feature into the project's architecture docs, when it has them, delete the feature's doc and its tasks, and commit that as `Finish <feature>` with a `Ticket: REF` trailer.

## Tracker

The steps name tracker actions by verb. With tix they are the commands below; another tracker that `CLAUDE.md` names has its own.

| Verb | tix |
|---|---|
| ready tasks of a feature | `tix ready --parent FEATURE`, which lists each task's `scope` and `review` |
| show a task with its feature | `tix show REF --with-parent` |
| start | `tix start REF...` |
| tick, untick | `tix tick REF N...`, `tix untick REF N...` |
| unticked criteria | `tix ac ls --open REF` |
| done | `tix done REF`, never forced: a criterion only the user can check is a finding for the Report |
| in review | `tix review FEATURE` |
| set a property | `tix set REF review=done` |

## Dispatch

- **One brief file per agent**, written outside the repo, such as `<scratchpad>/<task>.md`. The agent is given only that path.
- **How it launches** follows the session. When the session's instructions say how to launch agents, such as in terminals of their own, launch that way, and the brief names a report file. Otherwise use the Agent tool, and the report is the agent's final message.
- **One report, read once.** Wait for the whole batch's reports before Verify. Message an agent only with work, such as findings to fix: an acknowledgement wakes it for nothing.
- **A large task with independent parts** gets one implementor per part. A part that builds on another runs after it, and its brief says what the earlier part built.
- **Tasks or parts that list the same file** build one after the other: the one more tasks depend on goes first, and the other joins the next batch.

## Brief

The implementor already knows its method (`build`), leaves the tree uncommitted, and loads the repo's `CLAUDE.md` on its own. The brief covers what it can't know:

- **Where**: the repo or worktree path, the task ref, and the report file when the session uses one.
- **Read first**: the show command for the task with its feature, never a paraphrase of them, since it prints the criteria numbered. Then the commits worth reading with `git show HASH`, and the existing files, procedures and types to build on.
- **Tick**: the tick command, and the one that lists unticked criteria.
- **Out of scope**: other tasks, including the ones building beside it in the same tree, and files this task leaves alone.
- **Open choices**: anything the feature left to judgement. The agent picks the simplest sound option and reports it.
- **Tests**: the behaviour to cover, and existing tests likely to break, which get updated without being weakened.
- **Gates**: the exact test and check commands, all passing before it reports.

## Worktrees

Agents building at once in the same repo each get a git worktree under `.claude/worktrees/` (`git worktree add -b <branch> .claude/worktrees/<task>`); add that folder to the repo's `.gitignore` first if it isn't there. A batch of one agent, or of agents in different repos, builds in the main tree. In Verify, merge the worktrees back one at a time and remove each.

## Gates

The gates are the repo's test and check commands. Run them only on code no run has covered:

- An implementor runs them before it reports, so a task built alone in the main tree needs no second run before its commit.
- After each worktree merge, run them yourself on the merged tree before the next merge: a merge is code no agent tested.
- Never run them while another agent is mid-edit in the same tree, since that fails for nothing.
- When the repo's pre-commit hook runs the gates, the commit is the run for a small task you built yourself. Every commit goes through the hooks; a hook that is too slow is a finding for the Report.

## Feature review

1. Mark the feature in review.
2. Dispatch the reviewers at once, each a `kit:reviewer` with the repo path, the feature ref, the feature's commit range, and the one lens it walks: Correct, Modular, Composed, Cheap, plus one more for the language rules and the lenses the project's review profile adds, when the change has any.
3. Merge the findings, drop duplicates, and rank them.
4. Fix the ones worth acting on with fresh implementors in parallel, one per group of findings that share no files, or yourself when small. Run the gates, and commit the fixes with the feature's `Ticket:` trailer.
5. Set `review=done` on every task the review covered and start the feature again.
6. Report the findings, what was fixed and what was left, and ask for approval as in step 5 of Steps.

When the user asks for a review per task instead, review each task after Verify the same way, over its uncommitted diff, before its commit.

## Done when

Every task picked is committed, ticked, done and approved, the feature's review has run with its fixes committed, and a finished feature is deleted with its tasks.
