# Modular

One owner per concept, dependencies one way, contracts at the boundaries.

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
- **Beyond the task.** A rename the new behaviour didn't need, a file the change's entry points never reach, or behaviour nothing in the ticket or feature asks for. Each makes the diff larger and slower to review. Keep the old name, and move the rest to its own change or into the ticket first. When the author may know a reason the diff doesn't show, ask it as a question.
- **No seam.** A change testable only by reaching into internals (private fields, module state, a mocked import) is missing a seam: the dependency it should take as a parameter.
