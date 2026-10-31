---
name: review
description: Reviews a change or module for bugs, shape and cost and returns ranked findings, no edits. Four lenses — correct (bugs traced on a concrete input, including ones today's data hides), modular (one owner per concept, one-way dependencies, contracts at boundaries), composed (small parts assembled at the call site instead of one part configured by flags), and cheap (static reasoning about work at scale, no profiling). Use on a diff, a PR, a branch or a module when the user asks for a review, a second opinion on structure or approach, or whether a change fits the architecture; `coordinate` runs it on every slice.
argument-hint: [diff | PR | branch | path]
---

# Review

Reads a change the way a second engineer would and returns **findings**: each one located, verified in the code, and paired with the concrete move that fixes it. The review changes nothing; the caller decides what to apply. It looks for bugs (does the code do what its callers assume, on every input they can send?), shape (is the code modular and composed?) and cost (what does it do at scale?). To keep the reading out of a busy context, dispatch a `kit:reviewer` agent with the target instead of reviewing inline; `coordinate` always does.

## Steps

1. **Scope.** Take the target from `$ARGUMENTS`: a diff, a PR number, a branch, or a path. With none, review the working tree against the base branch (`git diff <base>...HEAD` plus uncommitted changes). Read `git diff --stat`, then every hunk. Then read past the diff: each changed public surface's callers and callees, far enough to see every boundary the change crosses. If the plan holds a `## Code Shape`, read the part this change implements; it is the contract the change is held to. When the target is a module rather than a change, list what it owns before reading for problems: each group of functions and the state it keeps. Done when every changed file and every boundary it crosses has been read.
2. **Look through each lens.** Walk the change once per lens (Correct, Modular, Composed, Cheap) and write down every candidate, with the line that triggered it. The Correct pass is a hunt, not a glance: for each procedure, pick the inputs its callers can send and the ones today's data never does, and follow them through.
3. **Verify.** For each candidate, confirm the problem in the code rather than the diff: trace a concrete call path or input that hits it. For a cost candidate, name the scale at which it matters (per frame, per request, per row, n of what). A candidate that doesn't survive is dropped; the review's value is that every finding is real.
4. **Rank.** Order by consequence: a bug that today's inputs can hit, a bug that waits on a planned change, then a boundary the change damages (a contract broken, a dependency reversed, a leak of internals), then coupling that will spread, then cost at a scale the project reaches, then local shape. Keep the findings worth acting on; a nit that changes nothing for the next reader is cut.
5. **Report** in the Findings format, and end the turn without editing. Under `coordinate`, the report is the whole final message. Standalone, end the turn asking which findings to apply, as a review ([asking](../../references/asking.md)): "Reply with the numbers to apply."

## Correct

Does the code do what its callers assume, for every input they can send, including the ones today's data never sends. Each candidate is traced on a concrete input before it becomes a finding.

- **Holds only today.** Code that is right because a constant is 1, a list has one element, a level is the only level, or an enum has its current members. Name the constant or data that makes it pass, and what breaks when it changes: a loop that ignores its index, a lookup that returns the first match, a height that assumes one floor. Propose the real handling or an assertion that fails loudly when the assumption breaks.
- **Two definitions of one rule.** A fact computed in two places (a count, a threshold, a "can this happen" check) with different conditions in each, so the two can disagree. Trace one input through both.
- **Edges.** Empty, one, the boundary value, the last index, negative, zero, the maximum: for each loop and slice, say what happens at the ends.
- **Order of operations.** A fallible step before a branch that doesn't need it; a check after the write it should guard; a state read before the update that changes it.
- **State.** For each state machine or lifecycle, the transition that isn't handled, the state nothing resets, the resource nothing releases.
- **Numbers.** Float equality, depth or z values that coincide, integer division, unit mismatches, overflow at the project's actual sizes.
- **Weak or missing tests.** A test that passes for the wrong reason (it asks for n and checks element 0; it mocks the thing under test), or logic with branching the tests never reach.

## Modular

One owner per concept, dependencies one way, contracts at the boundaries. The rules of a boundary live in `architect`'s Boundaries section (`../architect/SKILL.md`); this lens checks the change against them.

- **Several owners in one file.** A module whose functions fall into distinct groups (validate, charge, compute, orchestrate), each a section with its own helpers and state, is several modules in one file: every change to one group is a change to the file every group's caller depends on. Name the groups and propose the split, keeping the public names through a facade.
- **Reaching in.** A change that reads another module's private state, its file layout, its ordering or its error text, is coupling to something the owner may change. The move: ask the owner for an operation that gives the fact needed.
- **A new arrow.** Every new import or call across modules is a dependency arrow. One that points against the existing direction, or closes a cycle, is a finding whatever the convenience.
- **Contract drift.** A boundary that now exposes more than the consumer needs (a whole record where an id would do, a mutable collection where a copy or an iterator would do) widens what consumers can depend on.
- **Generic with one consumer.** A new generic shape (`Pool<T>`, a plugin registry, an options object with one caller) with a single consumer and no named future one is speculation that every reader must now understand.
- **Duplicate with two consumers.** The same logic appearing in a second place is an extraction that is due; the third is overdue. Two similar lines are not a duplicate.
- **No seam.** A change testable only by reaching into internals (private fields, module state, a mocked import) is missing a seam: the dependency it should take as a parameter.

## Composed

Small agnostic parts, assembled at the call site into the thing needed, over one big part configured by flags. The test is **case or part**: a *case* is another value that selects behaviour, and belongs in a variant, a strategy or a lookup table; a *part* is another region of work, and belongs in a sibling the caller composes.

- **Flags.** A boolean parameter that switches which code runs is two functions welded together; the caller should call the one it means. Three boolean parameters is a type that hasn't been named.
- **Growing options.** An options object gaining fields with each feature is a part being smuggled in as configuration.
- **Inheritance for reuse.** A subclass that exists to share code, not to be substituted, is composition done with the wrong tool: hold the shared piece, don't extend it.
- **Reaching out.** A function that fetches its own dependencies (a global, a singleton, a service locator, the clock, the filesystem) can't be composed with a different one. Take them as parameters.
- **Pure core, effects at the edge.** Logic that interleaves computation with I/O, time or randomness can be neither tested in isolation nor reused. Separate the decision from the act.
- **Long functions.** A function that does a sequence of distinct things reads as a script; each thing is a part with a name. The smell is the comment that introduces each section.

## Cheap

Static reasoning about what the code does at scale. Every finding names the scale that makes it matter; `perf` owns measurement, and a finding whose fix is a trade-off recommends measuring rather than asserting.

- **Work in the hot path.** Allocation, string building, regex compilation, logging, synchronous I/O inside a per-frame, per-request or per-row loop.
- **Shape mismatch.** A lookup in a list where a map is due, nested loops over the same collection, a sort or a full scan inside a loop, a recomputation of a value the loop doesn't change.
- **Chatty boundary.** One call per item across a process, network or database boundary (N+1). Batch, join or prefetch.
- **Unbounded growth.** A cache with no eviction, a listener never removed, a collection that only ever grows, a retry with no cap.
- **Needless copies.** Cloning a structure to read it, serialising to compare, converting between representations at every step instead of once at the edge.
- **Serial waits.** Independent async work awaited one after the other; blocking work on the main or event thread.

## Findings

Ranked and numbered, so the caller can answer with numbers. Each finding carries a location, the evidence, the consequence, and the move:

```markdown
## Findings

1. **Crew reads the job board's internal list** — `src/crew.js:42`
   `crew.tick` iterates `board._jobs` to find idle work, so the board can't change its storage without breaking crew. Change: add `board.next_open(kind)` and call it here.
2. **One render allocates a closure per cell** — `src/grid.js:118`
   `cells.map(c => () => draw(c))` runs per frame over 4,000 cells. Change: draw in the loop directly, or build the closures once when the grid changes.

Seen, no action: the `Hotel` import in `economy.js` is unused since this change.
```

- A finding without a concrete change is an observation; cut it or find the move.
- Bugs go first, marked **Bug** in the title; a bug that today's data can't reach is marked **Latent** and says what unlocks it.
- Clean is a valid result: "No findings" with one line on what was checked.

## Done when

Every changed file and crossed boundary has been read, every finding is verified in the code with a location and a change, the list is ranked, and nothing was edited.
