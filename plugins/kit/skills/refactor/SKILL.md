---
name: refactor
description: Finds one large piece of a codebase to simplify, weighs at least two shapes for it, and hands the chosen one to `feature`. Use when the user asks what to refactor, where complexity can be cut, or to simplify a system or module.
argument-hint: [area or module]
---

# Refactor

Ends in one decision: a system built two ways that should be built one way, the shape that unifies it, and what that shape gives up, handed to `feature` to plan. Judge a candidate by the branches, modes, duplicate paths and special-case rules it removes. Line counts barely move, and they often go up once the tests are written, so never sell a refactor on them. A cleanup inside one file goes to `build`.

## Steps

1. **Survey.** Size every package and its largest files, group the biggest package's files by feature, and read the architecture docs and import rules `CLAUDE.md` names. With an area in the ask, survey only that area. Done when you can name the largest clusters and the rules that bind each one.
2. **Find the splits.** In each large cluster, look for one concept built two ways (Signals). Count each signal with a search and cite every site as `file:line`. Done when every cluster has a counted list of sites or is dropped for having none.
3. **Find why it exists.** For the strongest split, read the docs, rules and commits that introduced it. A split made on purpose, such as a cost avoided or a constraint met, binds every shape in step 5. Done when you can state the reason in one sentence, or have checked the docs and history and found none.
4. **Drop what can't be checked.** Drop a candidate whose change only a check this environment can't run would verify, such as playing the app, real hardware or a benchmark that opens a window, and keep the reason for the proposal.
5. **Shape the alternatives.** Write at least two shapes that remove the split, drawing on the shapes in [variants](../../references/variants.md), each converging the two ways in a different place, and compare them (Comparison). Recommend the shape that removes the split and also a cost the common path pays today. Rule out a shape that cures the split by making the special case a fully separate path, since the common path's bugs then show up only there. Done when every shape answers the reason from step 3.
6. **Audit the skipped work.** For the recommended shape, list every early return, nil check, `has_` branch and guard that let the special case skip work, and say what that code does once nothing skips it: a log that now grows unread, a step that now runs mid-update, a mutation that now reaches shared state. Done when every guard the shape removes has a line.
7. **Propose.** Show it as a review ([asking](../../references/asking.md)): the split with its counted sites, why it exists, the comparison table, the recommendation, what it gives up, the audit, and one line per dropped candidate saying why. End the turn asking the user to pick a shape or push back. On pushback, add the objection as a constraint and go back to step 5.
8. **Hand off.** Load `feature` with the chosen shape as the ask, carrying the sites, what it gives up, and the audit. The audit's riskiest item is the first slice, and each of its lines becomes a criterion or a test.

## Signals

- **Optional core field.** A field the special case leaves empty (`Maybe`, nullable, `has_world`), checked across many procs.
- **Twin constructors.** Two ways to make one type, one doing extra setup the other's callers live without.
- **Union of near-twins.** A union or interface over two types that do one job, switched on or type-tested at each use.
- **Duplicate flow.** One flow, such as save, pause or shutdown, written once per mode.
- **Support code for the exception.** Fields and procs that exist only so the special case can reach what the common case has directly.
- **Rules for the exception.** Lines in the architecture docs that exist only to explain the special case.

## Comparison

One row per shape, these columns:

| Shape | Runtime cost per mode | Removes | Adds | Gives up |
|---|---|---|---|---|

- **Runtime cost per mode.** What each mode pays after the change (worlds stepped, copies held, threads run), set against the reason from step 3.
- **Adds.** The new mode, flag or indirection the shape introduces. A shape that adds nothing usually moved the split rather than removed it.
- **Gives up.** Behaviour or coverage a user or test loses, with the way to get it back elsewhere when there is one.

## Done when

The user picked a shape, and `feature` has it as the ask with its sites, what it gives up and the audit.
