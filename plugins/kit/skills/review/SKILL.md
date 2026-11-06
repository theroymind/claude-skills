---
name: review
description: Reviews a change or module for bugs, shape and cost and returns ranked findings, no edits. Four lenses — correct (bugs traced on a concrete input, including ones today's data hides), modular (one owner per concept, one-way dependencies, contracts at boundaries), composed (small parts assembled at the call site instead of one part configured by flags), and cheap (static reasoning about work at scale, no profiling). Use on a diff, a PR, a branch or a module when the user asks for a review, a second opinion on structure or approach, or whether a change fits the architecture; `implement` runs it on tasks marked for review.
argument-hint: [diff | PR | branch | path]
---

# Review

Reads a change the way a second engineer would and returns **findings**: each one located, verified in the code, and paired with the concrete move that fixes it. The review changes nothing; the caller decides what to apply. It looks for bugs (does the code do what its callers assume, on every input they can send?), shape (is the code modular and composed?) and cost (what does it do at scale?). To keep the reading out of a busy context, dispatch a `kit:reviewer` agent with the target instead of reviewing inline; `implement` always does.

## Steps

1. **Scope.** Take the target from `$ARGUMENTS`: a diff, a PR number, a branch, or a path. When the target is a pull request or merge request, follow [pull requests](references/pull-request.md) first; it sets up the worktree, the ticket and the readiness checks. With no target, review the working tree against the base branch (`git diff <base>...HEAD` plus uncommitted changes). Read `git diff --stat`, then every hunk. Then read past the diff: each changed public surface's callers and callees, far enough to see every boundary the change crosses. If the change belongs to a feature or ticket, read it; its acceptance criteria, types and boundaries are the contract the change is held to. When the target is a module rather than a change, list what it owns before reading for problems: each group of functions and the state it keeps. Done when every changed file and every boundary it crosses has been read.
2. **Load the profile.** Find the project's review profile at the location in [artifacts](../../references/artifacts.md) and apply it as [profile](references/profile.md) says. With none, the four lenses below are the whole review. Then, for each changed file whose path matches a kit [language rule](../../rules/) by its `paths` frontmatter, read the project's copy in `.claude/rules/kit/` if it has one, else the kit's; each one is an extra lens. Done when every file the profile names for the changed paths, and every matching language rule, has been read.
3. **Look through each lens.** Walk the change once per lens (Correct, Modular, Composed, Cheap, then each language rule and each lens the profile adds) and write down every candidate, with the line that triggered it. The Correct pass is a hunt, not a glance: for each procedure, pick the inputs its callers can send and the ones today's data never does, and follow them through.
4. **Verify.** Every candidate passes all three checks or is dropped; the review's value is that every finding is real.
   - **Real.** Confirm the problem in the code: trace a concrete call path or input that hits it. For a cost candidate, name the scale at which it matters (per frame, per request, per row, n of what).
   - **Introduced.** Read the finding's lines in the diff hunk, which shows what the change put there; the file alone cannot. A problem on a line the change left alone is a follow-up. Code the change deleted is cited by its old line (`file.js:old 44`). A comment the change made false is anchored to the line that made it false.
   - **Fix resolves.** Every identifier in the Fix exists where the fix puts it.
   - **Not settled.** A finding that reverses a decision already recorded for this work (the feature doc, the plan, the ticket, or where the profile says decisions live) is dropped.
5. **Check claims.** Every comment, doc line and test name the change adds is a claim to falsify. Check an inward claim (about the code it sits on) against that code. Search for an outward one (another module, a caller, a ticket, a library's guarantee), since nothing in the diff can disprove it. A claim you cannot confirm is a finding: cite it or delete it.
6. **Rank.** Order by consequence: a bug that today's inputs can hit, a bug that waits on a planned change, then a boundary the change damages (a contract broken, a dependency reversed, a leak of internals), then coupling that will spread, then cost at a scale the project reaches, then local shape. Keep the findings worth acting on; a nit that changes nothing for the next reader is cut. Then read the list once for two findings that contradict each other, and settle them.
7. **Report** in the Findings format, and end the turn without editing. Under `implement`, the report is the whole final message. For a pull request, end as [pull requests](references/pull-request.md) says. Otherwise end the turn asking which findings to apply, as a review ([asking](../../references/asking.md)): "Reply with the numbers to apply."

## Correct

Does the code do what its callers assume, for every input they can send, including the ones today's data never sends. Each candidate is traced on a concrete input before it becomes a finding.

- **Holds only today.** Code that is right because a constant is 1, a list has one element, a level is the only level, or an enum has its current members. Name the constant or data that makes it pass, and what breaks when it changes: a loop that ignores its index, a lookup that returns the first match, a height that assumes one floor. Propose the real handling or an assertion that fails loudly when the assumption breaks.
- **Two definitions of one rule.** A fact computed in two places (a count, a threshold, a "can this happen" check) with different conditions in each, so the two can disagree. Trace one input through both.
- **Edges.** Empty, one, the boundary value, the last index, negative, zero, the maximum: for each loop and slice, say what happens at the ends.
- **Order of operations.** A fallible step before a branch that doesn't need it; a check after the write it should guard; a state read before the update that changes it.
- **Races.** Async work whose answer can arrive after its input changed and overwrite a newer one; an action that can start again while the first is in flight (a double submit); an in-flight flag that a failure path never clears. Name the two events and the order that breaks it.
- **Bypassed guard.** New code that calls the layer beneath an existing guard (a gate hook, a policy, a permission check) because it needs a field the guard doesn't return, so it skips the guard's other conditions and misses every later change to it. Read the guard as it is on the base now, not as it was when the branch started. Call the guard too, or extend it to return what's needed.
- **Timer as sequencing.** A fixed delay standing in for an event (an animation's end, a navigation, a server write), or a page reload standing in for a refetch. It is right only on a fast machine. Wait on the event itself, refresh with a refetch or a cache write, and clear any timer that outlives its owner.
- **State.** For each state machine or lifecycle, the transition that isn't handled, the state nothing resets, the resource nothing releases.
- **Mirrored state.** A value that already lives in props, fetched data or the URL, copied into local state and kept in sync by an effect or watcher. The copy is stale for a render after every change, and a refetch overwrites what the user typed. Derive it where it's read; when the user edits it, hold only the draft and reset it from the source's identity.
- **Swallowed failure.** A caught error that carries on as if the work succeeded: an empty `catch`, a `rescue` returning `nil`, an error branch mapped to `:ok`. Ask what the caller should see when it fails, then rethrow, return a typed error, tell the user, or report it and say why continuing is safe. Catch only the error that is expected. A guard fails closed.
- **Failure shown as empty.** Loading or a failed request rendered the same as no data: a total of `0`, an empty list, a blank field the user can save. Render loading, failed and loaded on purpose, and keep unknown as unknown until the edge that displays it; a money or count field never defaults to `0` in a shared hook or context.
- **Numbers.** Float equality, depth or z values that coincide, integer division, unit mismatches, overflow at the project's actual sizes.
- **Tests sized to the risk.** A test that passes for the wrong reason (it asks for n and checks element 0; it mocks the thing under test), or logic with branching the tests never reach. Each missing test names the realistic failure it would catch, or it isn't asked for, and is anchored to the line of the branch it would cover. A test that fakes the data contract its unit depends on (a hand-written return from a generated query hook, a stubbed client or scope) cannot catch a wrong query or a missing field; seed the network or the database with the real document instead. Tests the change adds that would all fail for one bug, or that prove what a cheaper test already proves, are redundant; propose merging them only when the merged test catches every failure the originals did.

## Modular

One owner per concept, dependencies one way, contracts at the boundaries. The rules of a boundary live in `architect`'s Boundaries section (`../architect/SKILL.md`); this lens checks the change against them.

- **Several owners in one file.** A module whose functions fall into distinct groups (validate, charge, compute, orchestrate), each a section with its own helpers and state, is several modules in one file: every change to one group is a change to the file every group's caller depends on. Name the groups and propose the split, keeping the public names through a facade.
- **Reaching in.** A change that reads another module's private state, its file layout, its ordering or its error text, is coupling to something the owner may change. The move: ask the owner for an operation that gives the fact needed.
- **A new arrow.** Every new import or call across modules is a dependency arrow. One that points against the existing direction, or closes a cycle, is a finding whatever the convenience.
- **Unchecked shape.** Data from outside the process (a network response, a payload, a parsed file) cast to a type wider than what was asked for, so the compiler trusts fields that were never fetched. Use the type generated for that exact request, or narrow it with a guard or schema parser at the boundary.
- **Literal beside its constant.** A value that already has an owner (a route, a query or event name, a status string) typed again as a raw literal. A typo compiles and fails silently, and a rename misses it. Import the owner's constant or helper.
- **Shape wider than its callers.** A new shared return shape or interface every implementer must adopt, where only one varies a field and the rest hard-code it. The field belongs on the one that varies, and the edits made only to fit the shape go away with it.
- **Contract drift.** A boundary that now exposes more than the consumer needs (a whole record where an id would do, a mutable collection where a copy or an iterator would do) widens what consumers can depend on.
- **Scattered flag checks.** One feature flag read in many files, each making its own local decision and its own combination with other conditions. Removing or combining the flag means finding every copy. Resolve it once, in one hook, policy or service that returns named capabilities (`canOpenPlanDrawer`), and have call sites ask for those.
- **Generic with one consumer.** A new generic shape (`Pool<T>`, a plugin registry, an options object with one caller) with a single consumer and no named future one is speculation that every reader must now understand.
- **Duplicate with two consumers.** The same logic appearing in a second place is an extraction that is due; the third is overdue. Two similar lines are not a duplicate.
- **Scattered state.** One feature's state and behaviour spread across many small hooks, composables or services (React hooks, Vue composables, Angular services, Svelte stores) that each component wires together. The signs are a component calling several of the feature's hooks, hooks taking each other's return values as arguments, and the same set of calls repeated in sibling components. The component has become the owner by accident, and every consumer repeats the wiring. Name the concept they share and propose one hook with a small interface, or a store scoped to the feature: a store provided by the feature's root component, such as a zustand store in context, a Pinia store, or an Angular service provided at that component.
- **Beyond the task.** A rename the new behaviour didn't need, a file the change's entry points never reach, or behaviour nothing in the ticket or feature asks for. Each makes the diff larger and slower to review. Keep the old name, and move the rest to its own change or into the ticket first. When the author may know a reason the diff doesn't show, ask it as a question.
- **No seam.** A change testable only by reaching into internals (private fields, module state, a mocked import) is missing a seam: the dependency it should take as a parameter.

## Composed

Small agnostic parts, assembled at the call site into the thing needed, over one big part configured by flags. The test is **case or part**: a *case* is another value that selects behaviour, and belongs in a variant, a strategy or a lookup table; a *part* is another region of work, and belongs in a sibling the caller composes.

- **Flags.** A boolean parameter that switches which code runs is two functions welded together; the caller should call the one it means. Three boolean parameters is a type that hasn't been named.
- **Repeated type switch.** The same branch on a value's type (`__typename === 'Clerk'`, `case record when Clerk`) copied across files, each choosing a different operation for the same types, with an `else` that assumes the only other type. Put the per-type operations in one map the feature owns, keyed by type, and look them up.
- **Growing options.** An options object gaining fields with each feature is a part being smuggled in as configuration.
- **Inheritance for reuse.** A subclass that exists to share code, not to be substituted, is composition done with the wrong tool: hold the shared piece, don't extend it.
- **Reaching out.** A function that fetches its own dependencies (a global, a singleton, a service locator, the clock, the filesystem) can't be composed with a different one. Take them as parameters.
- **Pure core, effects at the edge.** Logic that interleaves computation with I/O, time or randomness can be neither tested in isolation nor reused. Separate the decision from the act.
- **Long functions.** A function that does a sequence of distinct things reads as a script; each thing is a part with a name. The smell is the comment that introduces each section.

## Cheap

Static reasoning about what the code does at scale. Every finding names the scale that makes it matter. A finding whose fix is a trade-off recommends measuring rather than asserting.

- **Work in the hot path.** Allocation, string building, regex compilation, logging, synchronous I/O inside a per-frame, per-request or per-row loop.
- **Shape mismatch.** A lookup in a list where a map is due, nested loops over the same collection, a sort or a full scan inside a loop, a recomputation of a value the loop doesn't change.
- **Chatty boundary.** One call per item across a process, network or database boundary (N+1). Batch, join or prefetch. The loop may be in another file: a row, card or list-item component that runs its own query makes one request per item its parent renders. Fetch the fields in the parent's list query, as a fragment the row declares, and pass each row its slice.
- **Unbounded growth.** A cache with no eviction, a listener never removed, a collection that only ever grows, a retry with no cap.
- **Needless copies.** Cloning a structure to read it, serialising to compare, converting between representations at every step instead of once at the edge.
- **Serial waits.** Independent async work awaited one after the other; blocking work on the main or event thread.

## Findings

One table, ranked and numbered, so the caller can answer with numbers. Size is the size of the fix: S (a line or two), M (one function or file), L (several files or a boundary). Issue is the problem and its consequence in one sentence; Fix is the move in one sentence. A finding that needs more gets a short note under the table, keyed by its number.

```markdown
## Findings

| # | File | Size | Issue | Fix |
|---|------|------|-------|-----|
| 1 | `src/crew.js:42` | M | `crew.tick` iterates `board._jobs`, so the board can't change its storage without breaking crew. | Add `board.next_open(kind)` and call it here. |
| 2 | `src/grid.js:118` | S | `cells.map(c => () => draw(c))` allocates a closure per cell, per frame, over 4,000 cells. | Draw in the loop directly, or build the closures once when the grid changes. |

Seen, no action: the `Hotel` import in `economy.js` is unused since this change.

Follow-up: `src/payroll.js:12` rounds each wage before summing, which predates this change.
```

- A finding without a concrete change is an observation; cut it or find the move.
- Bugs go first, with Issue starting **Bug:**; a bug that today's data can't reach starts **Latent:** and says what unlocks it.
- Escape a `|` inside a cell as `\|` so the table holds together.
- A problem the change didn't introduce goes on a **Follow-up** line under the table, never in it.
- **Blocking:** opens the Issue of a finding that would stop a merge on its own, such as a pull request's failing CI; it ranks above bugs.
- A project rule from the profile is cited by its file in the Issue.
- Clean is a valid result: "No findings" with one line on what was checked.

## Done when

Every changed file and crossed boundary has been read, every lens the profile adds has been walked, every finding is real, introduced by the change and carries a location and a change, every claim the change adds has been checked, the list is ranked, and nothing was edited.
