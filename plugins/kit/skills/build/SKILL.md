---
name: build
description: Implements a change in thin, verified slices. Use for a quick fix made directly, or when implementing a slice delegated by `coordinate`.
---

# Build

Build one thin slice at a time, and leave the system working after each one. Planned work and anything beyond a quick fix goes through `coordinate`, whose implementation agents follow this skill. Choose slices as described in `breakdown`'s Slicing: vertical by default.

## Steps

1. **Implement** the smallest complete piece.
2. **Test** it, writing a test first if nothing covers the piece (see `tdd`). Run the tests before you have written about 100 lines.
3. **Verify** with the repository's own commands: tests, build, type check where the stack has one, and lint. Re-run a command only after the code has changed since its last clean run.
4. **Commit** the slice (see `git`), then move on to the next one. Under `coordinate`, leave it uncommitted: the coordinator commits.

## Rules

- **Simplest thing that works.** Three similar lines are better than a premature abstraction. Wait for a third use before abstracting, and build nothing for hypothetical requirements. After writing, ask whether it could be fewer lines and whether each abstraction earns its complexity.
- **Stay in scope.** Touch only what the task needs. List anything else you notice under *Noticed but not touching* in your report, and offer to make tasks for it.
- **One logical change per increment.** A refactor, a feature and a config change are three commits.
- **Always compilable.** The build and existing tests pass after every slice.
- **Flag incomplete features**, so increments can merge without users seeing them. New options default to the safe, conservative behaviour.
- **Keep it revertable.** Prefer additive changes, give each migration a rollback, and delete and replace in separate commits.

## Done when

Every slice was tested and committed, the full suite and build pass, the feature works end to end, and nothing is left uncommitted (except under `coordinate`, which commits).
