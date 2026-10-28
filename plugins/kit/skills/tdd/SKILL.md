---
name: tdd
description: Test-first development with the red-green-refactor loop. Use when implementing logic, fixing a bug or changing behaviour, including code pasted inline where the request never mentions tests.
---

# Test-Driven Development

Write a failing test before the code that makes it pass. A bug fix starts with a test that reproduces the bug.

## Discover the stack first

Before the first test, find how this repository tests and use its commands for every step. Look at the build file (`package.json`, `build.gradle`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Makefile`) and prefer checked-in wrappers (`./gradlew`, `make test`, repo scripts) over global tools. Find how it runs one focused test and how it runs the full suite. Check where tests live and how the neighbouring tests are written, and which commands CI gates on. Never assume `npm test`.

## The loop

1. **Red.** Write one test for the next behaviour and run it. It must fail, and for the expected reason. A test that passes on its first run proves nothing: check that it exercises what you think it does.
2. **Green.** Write the least code that makes it pass.
3. **Refactor.** Clean up while the tests stay green, and run them after each step.

Run the focused test during the loop and the full suite before reporting done. Re-run a command only after the code has changed since its last clean run.

**Bug fixes (prove-it).** Write a test that reproduces the report and watch it fail. Then fix the code and run the full suite. For a complex bug, a subagent can write the reproduction test from the bug description alone, so the fix doesn't shape the test.

## Writing tests

- **Assert state, not interactions.** Check the outcome, not which internal methods were called. Interaction tests break when a refactor keeps the behaviour the same.
- **Real over doubles.** Prefer the real implementation, then a fake, then a stub, then a mock. Mock only where the real dependency is slow, non-deterministic or has side effects you can't control (external APIs, email).
- **DAMP over DRY.** Each test tells its whole story. Repeat setup rather than hide what the test checks behind shared helpers.
- **One concept per test**, named for the behaviour it verifies (`throws NotFoundError for a missing task`).
- **Size by resources.** Most tests are small: one process, no I/O, milliseconds. Medium tests cross a boundary on localhost (a test database, the API). Keep large end-to-end tests for critical user flows.
- **Isolate state.** Each test sets up and tears down its own state. Fix a test that passes alone but fails with others, or that depends on timing or order. Don't retry it.
- Test your own code, not the framework. Use snapshots only when they are small and someone reviews them.

Never skip, disable or weaken a test to make the suite pass.

## Browser changes

Unit tests don't cover code that runs in a browser, so verify it at runtime with the browser tools you have:

1. Reproduce the problem and take a screenshot.
2. Inspect the console, network, DOM and computed styles.
3. Fix it in the source.
4. Reload, confirm the console is clean, and run the tests.

## Done when

Every new behaviour has a test. Every bug fix has a reproduction test that failed before the fix. The repository's full suite passes.
