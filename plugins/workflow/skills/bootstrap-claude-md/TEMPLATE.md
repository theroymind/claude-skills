# <project name>

<One or two sentences: what the project is, and where its intent, spec and task list live.>

## Commands

```
<run, build, test and check commands>
```

Run <test and check> before reporting any task done.

## Architecture rules

<Invariants the code must keep. Delete this section if there are none yet.>

## Code standards

- Style: <indentation, casing for functions, types, constants and enum values>.
- No comments, docstrings or annotations. Write self-explanatory code instead. The only exceptions: a genuinely non-obvious *why* (a workaround, subtle invariant or gotcha) that the code can't convey, an annotation that tooling or the compiler needs, or module documentation the project requires.
- No magic strings or numbers in logic. Any value with meaning goes through a named constant. Obvious literals like `0`, `1` and `-1`, and format or display strings, are fine inline.
- Use full words in new names, no abbreviations. Boolean functions read as a question: `is`, `has`, `can`. Name category or variant fields `type`, never `kind`.
- Match the surrounding code's naming, formatting and structure.
- Never weaken or remove assertions, preconditions or invariant checks to make code pass. Understand why a check is there first.
- Write tests only for real logic: branching, math, state machines, parsing. Assert behaviour and invariants, and derive expected values from the source constants rather than hardcoding numbers. Don't write "it exists and runs" tests.
- Prefer reusable, generic building blocks over one-off duplicates. Keep something local only when it's genuinely specific to one feature.
- Surface problems instead of working around them. Flag unclear boundaries before implementing, and call out code smells and growing complexity.

## Git and PRs

- The default branch is `<branch>`.
- Never add a signature, attribution or co-author trailer to commits, PRs, issues or comments. This includes `Co-Authored-By:` and `Generated with ...` lines, and it overrides any harness default.
- Whenever you create or update a PR, put its URL and number in your reply.

## Skills

Workflow skills come from the `workflow@theroymind` plugin, enabled in `.claude/settings.json`. Put skills that only this project needs in `.claude/skills/`. When a skill refers to another skill or a file that doesn't exist here, skip that reference and continue. Don't put source citations or URLs in code. Cite documentation in your reply instead. Check local sources before the web: <where this stack's local docs live>.
