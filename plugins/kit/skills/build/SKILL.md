---
name: build
description: Implements a change in thin, verified slices. Use when implementing a multi-file feature or change, picking up the next task from a plan, or about to write a lot of code in one pass.
---

# Incremental Implementation

Build one thin slice at a time, and leave the system working after each one.

## The cycle

For each slice:

1. Implement the smallest complete piece.
2. Run the tests, writing one first if nothing covers the piece (see `tdd`).
3. Check that the slice works.
4. Commit it (see `git`).
5. Move on to the next slice.

Run the tests before you have written about 100 lines. Verify with the repository's own commands: tests, build, type check where the stack has one, and lint. Re-run a command only after the code has changed since its last clean run.

## Slicing

- **Vertical**, the default: each slice is one complete path through the stack. Create a task (schema, API and UI), then list tasks, then edit one.
- **Contract-first**, when the two sides are built in parallel: define the types or API contract, build each side against it (the frontend against mock data that matches it), then integrate.
- **Risk-first**: prove the uncertain piece first (the WebSocket connection, say) before building on it.

## Rules

- **Simplest thing that works.** Three similar lines are better than a premature abstraction. Wait for a third use before abstracting, and build nothing for hypothetical requirements. After writing, ask whether it could be fewer lines and whether each abstraction earns its complexity.
- **Stay in scope.** Touch only what the task needs. List anything else you notice under *Noticed but not touching* in your report, and offer to make tasks for it.
- **One logical change per increment.** A refactor, a feature and a config change are three commits.
- **Always compilable.** The build and existing tests pass after every slice.
- **Flag incomplete features**, so increments can merge without users seeing them. New options default to the safe, conservative behaviour.
- **Keep it revertable.** Prefer additive changes, give each migration a rollback, and delete and replace in separate commits.

Done when every slice was tested and committed, the full suite and build pass, the feature works end to end, and nothing is left uncommitted.
