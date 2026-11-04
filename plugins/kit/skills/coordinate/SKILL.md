---
name: coordinate
description: Implements planned work as coordinator, delegating each slice of a task to an implementation agent and verifying the result. The default way to implement anything beyond a quick fix; use when picking up a task from the task list or implementing a planned feature.
argument-hint: [task]
---

# Coordinate

The default way to implement: quick fixes go to `build`, everything else comes here. You are the **coordinator**. Implementation agents write the code. You pick the work, write their briefs, check what they did, and keep the user in the loop. Keep your context free for that: read only what you need to write a sharp brief and judge the result.

## Steps

1. **Find the task.** Use `$ARGUMENTS` if given. Otherwise take the next task from the project's tracker when `CLAUDE.md` names one (its ready command, such as `tix ready`, then its show command for the task's criteria), or the first unchecked task in the task list ([artifacts](../../references/artifacts.md)). Tell the user which task you picked, in one line. If no series is open, start one: write the current `HEAD` hash to a series file outside the repo, such as `<scratchpad>/series.md`. A series is the run of tasks the user asked for, or every task of the plan or parent the first task belongs to. If the task creates new modules, core types or boundaries and the plan's `## Code Shape` doesn't cover them, run `architect` scoped to this task first, and continue only once the user has answered its decisions.
2. **Slice it.** Read the task and the parts of the plan it cites. Split it into thin slices along real boundaries, as described in `breakdown`'s Slicing: for example simulation or core logic first, then the UI or client on top of it. A slice that depends on another slice's output runs after it. Independent slices can run in parallel.
3. **Dispatch** one `kit:implementor` agent per slice. Write the slice's Brief once, to a file outside the repo such as `<scratchpad>/<task>-slice-<N>.md`, and pass the agent only that path. Add the path to the series file. It runs on Opus whatever model you are on, so a cheaper or faster model can coordinate. Its report arrives once, as the notification that the agent finished; see Messaging.
4. **Verify** each report. Run the repo's test and check commands yourself; this is the one gate run that counts. Read the diff against the brief: scope from `git diff --stat` against the out-of-scope list, and the changes themselves for the decisions the report names. Note any concerns from that read in the series file, under the slice's brief path, for the review in step 8. Don't dispatch a reviewer here. Send gate failures back to the implementing agent with SendMessage, then verify again. Anything beyond a gate failure (a user decision that changes the slice, a retune, new behaviour) goes to a fresh agent with its own brief that starts from `git diff`, so long-lived agents don't keep re-reading their whole context.
5. **Commit** the task once every slice passes, with one commit per task on the current branch.
6. **Report** in the chat: what each slice did, the decisions agents made, the things they flagged, and what the user must check by hand, such as visuals or feel. End the turn asking for approval ([asking](../../references/asking.md)). For each task, name its title, its commit as `git show HASH`, and where its criteria live: the tracker's show command, such as `tix show REF`, or the task list's path. Leave the task's boxes unchecked.
7. **Approve** from the reply. On approval, check the task's boxes off and commit that change. Go back to step 1 while the series has tasks left. For changes, brief an agent with the fix and repeat from step 4.
8. **Review** once the series' last task is approved. Dispatch one `kit:reviewer` agent with the repo path, the commit range from the series file's base hash to `HEAD`, and the series file's path. The brief files carry each slice's scope and `## Code Shape`, so the reviewer judges the series against the same contracts the implementors built to. Its findings arrive as its finish notification. Brief a fresh `kit:implementor` with the findings worth acting on, verify its work as in step 4, and commit the fixes as one commit. Report the findings, what was fixed and what was left, then close the series by deleting the series file.

## Brief

The implementor already knows its method (`build`, `tdd`), that it leaves the tree uncommitted, and how to report, and it loads the repo's `CLAUDE.md` on its own. The brief spends its length on what neither can know:

- **Where**: the repo path, and a note that this is slice N of task X.
- **Read first**: the vault refs the slice builds on (the spec, decisions, ideas and the task), to read with the tracker's show command `CLAUDE.md` names, such as `tix show REF`, linked by ref rather than paraphrased; without a tracker, their file paths. Then the commits you picked as relevant, from the warm-up pack when `CLAUDE.md` names a warm-up command or the history otherwise, to read with `git show HASH` before the files. Then the plan sections the task cites, the parts of `## Code Shape` this slice implements, and the existing files to build on, with the procedures and types they should reuse. The Code Shape is the contract: the agent builds those types and boundaries as written.
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
