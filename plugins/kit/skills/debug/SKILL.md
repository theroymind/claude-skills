---
name: debug
description: Root-cause debugging. Use when a test fails, a build breaks, something that worked has stopped working, behaviour doesn't match expectations, or an unexpected error appears.
---

# Debugging

When something breaks, stop feature work and keep the evidence: error output, logs and repro steps. Don't build on a failing test or a broken build. Work through the steps in order.

1. **Reproduce.** Make it fail on demand with the repository's focused-test command (see `tdd`). Run the failing test on its own to rule out interference from other tests. If it won't reproduce, work out which kind of failure it is:
   - *Timing*: add timestamps around the suspect area, widen race windows with delays, run under load.
   - *Environment*: compare runtime versions, OS, environment variables and data (empty versus populated). Try a clean environment such as CI.
   - *State*: look for state leaking between tests or requests (globals, singletons, shared caches). Run the scenario alone and then after other operations.
   - *Random*: add targeted logging and an alert on the error signature, record the conditions, and come back when it recurs.
2. **Localize.** Find the failing layer: UI, API, database, build tooling, an external service, or the test itself. For a regression, run `git bisect run <focused test command>` between a known-good commit and `HEAD`.
3. **Reduce.** Strip code, config and input down to the smallest case that still fails.
4. **Fix the root cause.** Keep asking why until you reach the cause, not just the place where it shows. If a list shows duplicate rows, fix the query that produces them; don't deduplicate in the UI. If the test is wrong rather than the code, fix the test. Never skip it.
5. **Guard.** Add a regression test that fails without the fix and passes with it.
6. **Verify.** Run the focused test, the full suite and the build, then check the original scenario end to end.

Done when you can state the root cause, the regression test exists, and the full suite and build pass. Keep the fix free of unrelated changes, so it stays clear what fixed the bug.

## Triage hints

- **A test fails after your change.** If you changed the code it covers, decide whether the test or the code is wrong. If you didn't, suspect a side effect through shared state, imports or globals. If the test was already flaky, look at timing, ordering and external dependencies.
- **The build fails.** For a type error, read the code at the cited location. For an import error, check that the module exists and its exports match. Then check config syntax, installed dependencies and the runtime version.
- **Runtime.** For a `null` or `undefined` access, trace where the value comes from. For a network or CORS error, check the URL, headers and server config. For a blank screen, check the error boundary and the console. For wrong behaviour with no error, log the data at each step.

Take temporary logging out once the regression test guards the fix, and always remove logs that contain sensitive data. Error boundaries and error logging that records request context stay.
