---
name: review
description: Reviews a change or module for bugs, shape and cost through four lenses (correct, modular, composed, performance) and returns ranked findings, no edits. Use on a diff, a PR, a branch or a module when the user asks for a review, a second opinion on structure or approach, or whether a change fits the architecture; `implement` runs it once on a finished feature that has a task marked for review.
argument-hint: [diff | PR | branch | path]
---

# Review

Reads a change the way a second engineer would and returns **findings**: each one located, verified in the code, and paired with the concrete move that fixes it. The review changes nothing; the caller decides what to apply. It looks for bugs (does the code do what its callers assume, on every input they can send?), shape (is the code modular and composed?) and cost (what does it do at scale?). Review inline. Dispatch a `kit:reviewer` agent with the target only when the context already holds other work the reading would crowd; `implement` always does. A finding an agent you dispatched by hand sends back enters your table once it passes step 4 in your own reading.

## Lenses

Each lens is a catalogue of what to look for, in its own file. Read the file for every lens you walk; a reviewer whose brief names its lenses reads only those.

- [Correct](references/correct.md): does the code do what its callers assume, for every input they can send, including the ones today's data never sends.
- [Modular](references/modular.md): one owner per concept, dependencies one way, contracts at the boundaries.
- [Composed](references/composed.md): small parts assembled at the call site, over one big part configured by flags.
- [Performance](references/performance.md): static reasoning about what the code does at scale, no profiling.

## Steps

1. **Scope.** Take the target from `$ARGUMENTS`: a diff, a PR number, a branch, or a path. When the target is a pull request or merge request, follow [pull requests](references/pull-request.md) first; it sets up the worktree, the ticket and the readiness checks. With no target, review the working tree against the base branch (`git diff <base>...HEAD` plus uncommitted changes). Read `git diff --stat`, then every hunk. Then read past the diff: each changed public surface's callers and callees, far enough to see every boundary the change crosses. If the change belongs to a feature or ticket, read it; its acceptance criteria, types and boundaries are the contract the change is held to. When the target is a module rather than a change, list what it owns before reading for problems: each group of functions and the state it keeps. A list of three or more groups is a Modular candidate, which the report carries as a finding or as a "Seen, no action" line with its reason. Done when every changed file and every boundary it crosses has been read.
2. **Load the profile.** Find the project's review profile at the location in [artifacts](../../references/artifacts.md) and apply it as [profile](references/profile.md) says. With none, the four lenses are the whole review. Then, for each changed file whose path matches a kit [language rule](../../rules/) by its `paths` frontmatter, read the project's copy in `.claude/rules/kit/` if it has one, else the kit's; each one is an extra lens. When the change touches browser UI code (a React, Vue, Angular or Svelte component, template, hook, composable, service or store), read [web frontend](references/web-frontend.md); its sections join the lenses of the same name. Done when every file the profile names for the changed paths, every matching language rule, and the web frontend reference when it applies, have been read.
3. **Look through each lens.** Walk the change once per lens (Correct, Modular, Composed, Performance, each with its web frontend items when they apply, then each language rule and each lens the profile adds) and write down every candidate, with the line that triggered it. The Correct pass is a hunt, not a glance: for each procedure, pick the inputs its callers can send and the ones today's data never does, and follow them through. The Modular and Composed passes read each changed call site with the entries around it, since a new `case` or registry entry is judged against its neighbours. Done when every lens has its candidates, or a line saying what it checked and found nothing.
4. **Verify.** Every candidate passes all four checks or is dropped; the review's value is that every finding is real.
   - **Real.** Confirm the problem in the code: trace a concrete call path or input that hits it. For a cost candidate, name the scale at which it matters (per frame, per request, per row, n of what). A candidate that only a run you can't make would confirm goes in a note under the table that says what would confirm it; a Bug is always traced.
   - **Introduced.** Read the finding's lines in the diff hunk, which shows what the change put there; the file alone cannot. A problem on a line the change left alone is a Follow-up. Code the change deleted is cited by its old line (`file.js:old 44`). A comment the change made false is anchored to the line that made it false.
   - **Fix resolves.** Every identifier in the Fix exists where the fix puts it.
   - **Not settled.** A finding that reverses a decision already recorded for this work (the feature doc, the plan, the ticket, or where the profile says decisions live) is dropped.
5. **Check claims.** Every comment, doc line and test name the change adds is a claim to falsify. Check an inward claim (about the code it sits on) against that code. Search for an outward one (another module, a caller, a ticket, a library's guarantee), since nothing in the diff can disprove it. A claim you cannot confirm is a finding: cite it or delete it.
6. **Rank.** Order by consequence:
   1. **Blocking:** a finding that would stop a merge on its own, such as a pull request's failing CI.
   2. **Bug:** one today's inputs can hit.
   3. **Latent:** a bug today's data can't reach; say what unlocks it, such as a planned change.
   4. A boundary the change damages: a contract broken, a dependency reversed, a leak of internals.
   5. Coupling that will spread.
   6. Cost at a scale the project reaches.
   7. Local shape.

   The first three open the finding's Issue with their label. Keep the findings worth acting on; a nit that changes nothing for the next reader is cut. Then read the list once for two findings that contradict each other, and settle them. Done when the list is in this order, with no contradictions.
7. **Report** in the Findings format, and end the turn without editing. Under `implement`, the report is the whole of what you send back. For a pull request, end as [pull requests](references/pull-request.md) says. Otherwise end the turn asking which findings to apply, as a review ([asking](../../references/asking.md)): "Reply with the numbers to apply."

## Findings

One table, ranked and numbered, so the caller can answer with numbers. Size is the size of the fix: S (a line or two), M (one function or file), L (several files or a boundary). Issue is the problem and its consequence in one sentence; Fix is the move in one sentence. A finding that needs more gets a short note under the table, keyed by its number. A finding that spans several files or several groups of functions always gets one, listing each file, or each group with its functions.

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
- A Follow-up goes on its own line under the table, never in it.
- Escape a `|` inside a cell as `\|` so the table holds together.
- A project rule from the profile is cited by its file in the Issue.
- Clean is a valid result: "No findings" with one line on what was checked.
