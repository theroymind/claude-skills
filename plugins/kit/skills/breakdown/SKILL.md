---
name: breakdown
description: Breaks a spec into ordered, verifiable tasks in a plan and task list. Use when you have a spec or clear requirements to turn into tasks, when a task is too large to start, or when work could run in parallel.
---

# Task Breakdown

Turn the spec, and the `## Code Shape` from `architect` if one is recorded, into small tasks. Each task should be small enough to implement, test and verify in one focused session. This step writes plans, not code.

## Steps

1. **Check for an existing plan.** If `tasks/plan.md` or the task list still has unchecked tasks, update them in place when this is the same work. When it is different work, stop and ask, because those tasks may be mid-build in another session. Never overwrite, delete or bulk-close another plan's open tasks.
2. **Read** the spec, the relevant code and its patterns. Note risks and unknowns.
3. **Map the dependencies** between components and order the foundations first (schema → types → API → client → UI).
4. **Slice vertically.** Each task delivers one working path through the stack ("user can create a task": schema, API and UI together), not one layer ("all the endpoints"). When frontend and backend will be built in parallel, a contract task comes first.
5. **Write the tasks** in the format below, sized S or M. Split any task that touches more than about 5 files, needs more than three acceptance criteria, spans independent subsystems, or has "and" in its title.
6. **Order and checkpoint.** Dependencies come first and risky tasks early, and every task leaves the system working. Add a checkpoint (tests pass, build clean, core flow works, human review) after every 2–3 tasks.
7. **Present** the plan for approval. Once it is approved, suggest `/coordinate` to delegate the tasks, or work through them yourself with `build`.

Done when every task has acceptance criteria, a verification step and its dependencies, and the human has approved the plan.

## Task format

```markdown
## Task N: <short title>

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

- **Plan**: always `tasks/plan.md`, using the template below. Create `tasks/` if it doesn't exist.
- **Task list**: a checklist in `tasks/todo.md`, unless the project's `CLAUDE.md` or `AGENTS.md`, or the user, names an issue tracker (GitHub Issues, Linear, Jira, `bd`). With a tracker:
  - Create one tracker item per task, with the acceptance criteria and verification in its body.
  - Link dependencies with the tracker's blocking mechanism, and record checkpoints as items too.
  - Note the tracker in the plan, and make the plan's Task List an ordered index of item links instead of a second checklist.
  - Keep every task in the tracker; write no `tasks/todo.md`.

```markdown
# Implementation Plan: <name>

## Overview
<one paragraph>

## Architecture Decisions
- <decision and rationale>

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

## Parallel work

Independent slices, tests for finished features, and documentation can run in parallel. Migrations, changes to shared state, and dependency chains run in sequence. Features that share a contract get the contract defined first, then run in parallel.
