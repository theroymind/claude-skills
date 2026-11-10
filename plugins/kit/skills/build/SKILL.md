---
name: build
description: Implements a change in thin, verified slices. Use for a quick fix made directly, or when building a task for `implement`.
---

# Build

Build one thin slice at a time, and leave the system working after each one. Planned work goes through `implement`, whose implementation agents follow this skill.

## Steps

1. **Implement** the smallest complete piece.
2. **Test** the behaviour that merits it: logic a reader could get wrong, a contract other code relies on, a case that has broken before. Skip tests that only cover lines or restate the code, since they break on every refactor and catch nothing. A bug fix starts with a test that reproduces the bug and fails before the fix. Run the tests before you have written about 100 lines.
3. **Simplify.** Reread the diff top to bottom as a newcomer would. Cut every line, parameter, branch and type the task doesn't need; inline a helper that only renames one line; rename anything you had to stop and think about; flatten nesting into early returns. Done when each procedure reads as a short sequence of named steps and nothing left can go without losing behaviour. Run the tests again.
4. **Verify** with the repository's own commands: tests, build, type check where the stack has one, and lint. Re-run a command only after the code has changed since its last clean run.
5. **Commit** the slice with `commit`, then move on to the next one. Under `implement`, leave it uncommitted: `implement` commits the task once.
6. **Report** what changed and why, the decisions made, what you noticed but didn't touch, and what the user or reviewer should check.

## Rules

- **Simplest thing that works.** Three similar lines are better than a premature abstraction. Wait for a third use before abstracting, and build nothing for hypothetical requirements.
- **Plain over clever.** Write the version a reader already knows how to read: straight-line control flow, one idea per line, intermediate values named for what they mean, concrete types before generic ones. Choose the familiar language feature over the compact idiom. When the simple version and the fast version differ, write the simple one unless the task names the cost.
- **One path per behaviour.** Extend the existing code path rather than growing a parallel one that does nearly the same thing.
- **Stay in scope.** Touch only what the task needs. List anything else you notice under *Noticed but not touching* in your report, and offer to make tasks for it.

## Done when

Every behaviour that merits a test has one, every bug fix has its reproduction test, the full suite and build pass, the feature works end to end, and nothing is left uncommitted (except under `implement`, which commits).
