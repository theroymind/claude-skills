---
name: architect
description: Aligns with the user on the code's shape before implementing it — the modules, core types, data flow, and which pieces become generic building blocks because the project's future vision will reuse them. Use after the spec or task is agreed and before writing code or dispatching implementation agents; when a plan names components but not their types and boundaries; when designing or changing an API, module interface or type contract; or when the user asks to discuss architecture, structure, or approach.
---

# Align Architecture

Agreeing on *what* to build leaves the code's **shape** open: the modules, the types, and the generic building blocks. This skill produces an **architect's overview** of that shape and gets the user's decisions on it, sized against where the project is going, not only the task in front of you.

## Notation

Write the overview in neutral notation any engineer can read whatever the language:

```
module guests        → navigation, fixtures, economy
Guest      { motives: Motive → int, room: ref Room, state: Guest_State }
Guest_State  one of: Arriving | Walking { to: Tile } | Using { fixture: ref Fixture, remaining: ticks }
choose_fixture(guest, reachable: list Fixture) → ref Fixture
Store<T>   { capacity: T → int, held: T → int, reserved: T → int }
```

`ref X` is a reference that survives storage moves, `maybe X` is optional, `A → B` is a mapping or, after a module name, its dependencies, `one of` is a tagged union, `<T>` is a generic parameter. Drop into the project's own syntax only where a decision turns on a language feature (generics, ownership, unions, interfaces).

## Layout

The overview is read in a terminal, where long aligned lines wrap and lose their columns. Use markdown tables and lists, never space-aligned text:

```markdown
### Modules
| Module | Depends on | Owns |
|---|---|---|
| `jobs` | hotel | Job, Job_Board, posting and claiming |
| `crew` | jobs, navigation, hotel, economy | Crew, hire, fire, crew AI, wages |

### Types
| Type | Shape | Notes |
|---|---|---|
| `Site` | `+= crew: Pool<Crew>, jobs: Job_Board` | |
| `Crew_State` | `one of: Idle \| Walking { job } \| Working { job, remaining }` | |
| `Room` | `+= clean_job: maybe ref Job` | one Clean job per room, no board scan |

### Flows
1. **Tick order:** commands → clock → dirt → arrivals → guests → crew → movement
2. **Room gets cleaned:** dirt passes threshold → `post_job` → idle crew claims → walks → works → job removed

### Decisions
1. **Where does the claim live?**
   - **a.** On `Job_Board` as `ref Job → maybe ref Crew` — board stays the one source of truth *(recommended)*
   - **b.** On `Job` as `claimed_by` — simpler, but every job type carries it
```

- One row per module or type; `+=` marks fields added to an existing type. Put the reason or a decision cross-reference in Notes, not inline.
- Escape `|` as `\|` inside table cells.
- Short lists (commands, balance constants) go in a bullet each, not one long line.
- Each decision is a question, its options lettered beneath it, the recommendation marked.

## Steps

1. **Read the vision.** Collect what comes after this work from the spec, intent docs, roadmap, later plan phases, and the conversation. Write it as a list of named future features (e.g. "co-op", "second map", "tier 3 guests"). Read the existing code's types too, so the shape extends them. If the vision is thin, ask the user where this is heading before sketching. Done when every future feature that could touch this work is named.

2. **Sketch the shape.** Write the overview in three parts:
   - **Module map**: each module, what it owns, and which modules it depends on. Dependencies point one way.
   - **Core types**: every type and main operation an implementer would create.
   - **Flows**: each core-loop item or acceptance criterion traced as data moving through the modules. An item no flow delivers is a gap in the shape.

   Done when every type an implementation task will create appears in the overview.

3. **Find the seams.** Mark each type and module generic or specific:
   - **Generic**: name its consumers, the current ones plus the future features from step 1, and show the generic form (`Pool<T>`, one `Store` behind docks, machines and counters, one job union serving several features).
   - **Specific**: say what extracting it later would cost, so the user can pull the extraction forward if their vision needs it.
   - Flag any generic shape with a single consumer and no named future one.
   - Hold every dependency arrow in the module map to the **Boundaries** rules below.

4. **Present.** Show the overview in the **Layout** below, then number the decisions where a real choice exists: 2–3 options each, the trade-off measured against the named future features, and a recommendation. Make each one answerable in a single line (`1a, 2b`).

5. **Record.** Write the agreed overview into the plan under `## Code Shape` (`tasks/plan.md` unless the project says otherwise), each decision as: decision · options rejected · decided by (user/agent). The overview is the contract implementation agents build against; an agent that needs a different shape stops and reports the change.

**Done when** the user has answered every numbered decision, every generic shape names its consumers, and the overview covers every type the tasks will create. Then run `breakdown` against the recorded shape.

## Boundaries

A boundary is any dependency arrow: one module calling another, a save file, a network message, a script or mod API. Its contract is the types and operations the consumer sees.

- **Contract first.** The boundary's types and operations appear in the overview before either side is implemented.
- **Expose deliberately.** Every observable behaviour at a boundary becomes something a consumer depends on (Hyrum's Law): ordering, timing, error text, default values. Keep internals off it.
- **Validate where data enters.** External input (files, the network, user input, third-party data) is checked once at the boundary it crosses. Past that point, code trusts the types.
- **One error strategy per boundary.** Every operation on it fails the same way, whether that's a result value, an error code or an assertion.
- **Extend by addition.** A boundary grows with new optional fields, new operations or new union variants. Changing or removing what consumers already use is a breaking decision for the user, numbered in step 4.
- **Distinct identity types.** IDs that mean different things get different types, so one can't be passed where another is expected.
