# Variants

A variant is one of several forms of the same concept: ways to run a session, payment methods, storage backends, sign-in providers, unit types. The variants share the concept's concerns, such as who owns its state and how it starts, updates, saves, fails and stops. Each concern a variant handles its own way is a branch somewhere in the code. A design's cost is the number of places the next variant touches.

## Shapes

How a variant differs from the others, cheapest first:

- **Data.** The same code with other values: a row in a table, a config entry, a parameter. A new variant touches one place.
- **Part.** The same code with a part swapped or left out, passed in by the caller: solo play as a host without a port, a cache without a backing store. There is one path, and the part is its only variation.
- **Type.** Behaviour that is truly different: a union, interface or trait whose variants each carry the concept's operations. Give each variant's operations one home, such as one file, one implementation or one table keyed by type, so a new variant adds a home instead of a case at every branch.

Never add a **parallel path**: a second constructor, flow, save loop or `has_x` branch beside the first. Each later concern is then written once per path, and the paths drift.

## Table

When a change adds a variant beside existing ones, fill this table before choosing a shape. Use one row per variant, the existing ones and the new one, and one column per shared concern. Drop columns that don't apply, and add the domain's own.

| Variant | Owns the state | Start | Update | Save | Fail | Stop |
|---|---|---|---|---|---|---|

- **Each cell that differs between rows is a branch.** For each one, choose the cheapest shape that removes it, or write the reason it stays, such as a cost avoided.
- **The existing variant as a special case.** Ask whether an existing variant is the new one with a part left out. Write down the answer, and the reason when it is no.
- **The next variant's cost.** Name the next variant the project's ideas or roadmap bring, and count the places it touches in the chosen shape. A shape that branches on the variant's type in more than two places fails.

## Signals in code

- The same `switch`, `if x.type ==`, `instanceof` or type test on one type in more than two places.
- An optional field (nullable, `Maybe`, `has_x`) checked across many functions, because one variant leaves it empty.
- Two constructors or two flows for one job, one per variant.
- A union or interface over two near-twin types, branched on at each use. Wrapping a split in a safer type is the same split, not a fix.

## Enforcement

A project can count branch sites per type in its checks, such as `switch-spread` in `kit:archcheck` for Odin. A type over the limit carries an allowance at its current count, and the allowance only goes down.
