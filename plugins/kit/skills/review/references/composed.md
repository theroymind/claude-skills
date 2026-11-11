# Composed

Small agnostic parts, assembled at the call site into the thing needed, over one big part configured by flags. The test is **case or part**: a *case* is another value that selects behaviour, and belongs in a variant, a strategy or a lookup table; a *part* is another region of work, and belongs in a sibling the caller composes.

- **Flags.** A boolean parameter that switches which code runs is two functions welded together; the caller should call the one it means. Three boolean parameters is a type that hasn't been named.
- **Repeated type switch.** The same branch on a value's type (`__typename === 'Clerk'`, `case record when Clerk`) copied across files, each choosing a different operation for the same types, with an `else` that assumes the only other type. Put the per-type operations in one map the feature owns, keyed by type, and look them up.
- **Growing options.** An options object gaining fields with each feature is a part being smuggled in as configuration.
- **Inheritance for reuse.** A subclass that exists to share code, not to be substituted, is composition done with the wrong tool: hold the shared piece, don't extend it.
- **Reaching out.** A function that fetches its own dependencies (a global, a singleton, a service locator, the clock, the filesystem) can't be composed with a different one. Take them as parameters.
- **Pure core, effects at the edge.** Logic that interleaves computation with I/O, time or randomness can be neither tested in isolation nor reused. Separate the decision from the act.
- **Long functions.** A function that does a sequence of distinct things reads as a script; each thing is a part with a name. The smell is the comment that introduces each section.
