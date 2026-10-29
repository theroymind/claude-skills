---
name: breakdown
description: Breaks a spec into ordered, verifiable tasks in a plan and task list. Use when you have a spec or clear requirements to turn into tasks, when a task is too large to start, or when work could run in parallel.
---

# Breakdown

Turn the approved spec and `architect`'s `## Code Shape` into small tasks, each one implementable, testable and verifiable in one focused session. This step writes plans, not code.

## Steps

1. **Check for an existing plan.** If `tasks/plan.md` or the task list still has unchecked tasks, update them in place when this is the same work. When it is different work, ask before touching them, because those tasks may be mid-build in another session. Never overwrite, delete or bulk-close another plan's open tasks.
2. **Read** the spec, the Code Shape and the code they touch. Note risks and unknowns.
3. **Slice** the work vertically, as described in Slicing: the first task delivers the thinnest path a user or caller can exercise end to end, and each later task widens that path (an edge case, hardening, a UI entry point). Title every task by what someone can do once it lands ("Admin downloads the filtered report as CSV"). A layer-only task (all the queries, a helper with no caller) is a slice that isn't finished yet.
4. **Write the tasks** in the Task format, sized S or M. Split any task that touches more than about 5 files, needs more than three acceptance criteria, spans independent subsystems, or has "and" in its title.
5. **Order and checkpoint.** Dependencies come first and risky tasks early, and every task leaves the system working. Add a checkpoint (tests pass, build clean, core flow works, human review) after every 2–3 tasks.
6. **Approve** with `AskUserQuestion`: approve and run `coordinate`, or request changes.

## Slicing

- **Vertical**, the default: each slice is one complete path through the stack. "User can create a task" is schema, API and UI together, not "all the endpoints".
- **Contract-first**, when two sides are built in parallel: define the types or API contract first, build each side against it (the frontend against mock data that matches it), then integrate.
- **Risk-first**: prove the uncertain piece (the WebSocket connection, say) before building on it.
- **Parallel or sequential**: independent slices, tests for finished features and documentation can run in parallel. Migrations, changes to shared state and dependency chains run in sequence.

## Task format

```markdown
## Task N: <what a user or caller can do once it lands>

**Description:** One paragraph on what this task accomplishes.

**Acceptance criteria:**
- [ ] <specific, testable condition>

**Verification:**
- [ ] Tests pass: <the repository's focused-test command>
- [ ] Build succeeds: <the repository's build command>
- [ ] Manual check: <what to check by hand>

**Dependencies:** <task numbers, or None>
**Files likely touched:** <paths>
**Estimated scope:** S (1–2 files) | M (3–5 files)
```

## Output files

- **Plan**: always `tasks/plan.md`, from the template below. Create `tasks/` if it doesn't exist, and keep any `## Code Shape` that `architect` already wrote there.
- **Task list**: a checklist in `tasks/todo.md`, unless the project's `CLAUDE.md` or `AGENTS.md`, or the user, names an issue tracker (GitHub Issues, Linear, Jira, `bd`). With a tracker:
  - Create one tracker item per task, with the acceptance criteria and verification in its body.
  - Link dependencies with the tracker's blocking mechanism, and record checkpoints as items too.
  - Note the tracker in the plan, and make the plan's Task List an ordered index of item links instead of a second checklist.
  - Keep every task in the tracker; write no `tasks/todo.md`.

```markdown
# Implementation Plan: <name>

## Overview
<one paragraph, linking the spec>

## Code Shape
<written by `architect`; when it was skipped, the one-line reason>

## Task List
### Phase 1: <name>
- [ ] Task 1: ...
### Checkpoint: <name>
- [ ] Tests pass, build clean

## Risks and Mitigations
| Risk | Impact | Mitigation |
|---|---|---|

## Open Questions
- <question that needs human input>
```

## Done when

Every task has acceptance criteria, a verification step and its dependencies, and the human has approved the plan.
