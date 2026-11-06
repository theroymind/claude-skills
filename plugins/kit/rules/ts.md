---
paths:
  - "**/*.ts"
  - "**/*.tsx"
---

# TypeScript

How to write TypeScript the compiler can still check. The project's `CLAUDE.md` wins where it differs: a project that chose a schema library, a naming scheme or `enum` on purpose keeps that choice.

## Keep the checker on

- **`unknown` over `any`.** Narrow it with a type guard, or parse it with the project's schema library at the boundary. `any` turns checking off, and the failure shows up somewhere unrelated.
- **No non-null `!`.** It turns a type error into a runtime `TypeError` far from the line that caused it. Prefer, in order: a type guard, an early return, optional chaining with a real fallback, a schema parse.
- **`as X` only where you know something the compiler can't.** Data from outside the process is parsed, never cast. `as unknown as X` exists to defeat a compiler objection and is almost always wrong. `as const` is a different operator and is fine. Test fixtures may assert a deliberately partial type.

## Closed sets

- **No `enum`.** Use an `as const` object and derive the union from it: `type Status = (typeof STATUS)[keyof typeof STATUS]`. Numeric enums map both ways, and `const enum` behaves differently under bundlers.
- **Discriminated unions for values of several kinds**, switched on the tag, with a `never` check in the `default` branch. A new member then fails to compile until every switch handles it.

## Promises

- **Every promise is awaited, returned or caught.** A `.then()` with no `.catch()` fails the same way an empty `catch` does: nothing happens and nobody is told.
- **Clear an in-flight flag in `finally`.** A flag cleared after the `try/catch` works only while the `catch` swallows; the first rethrow or early return leaves it set forever.

## Names

- **Spell names out.** Not `cfg`, `res`, `req`, `btn`, `idx`, `val`, `arr`, `obj`, `msg`, `tmp`. A single letter is fine in a one-line callback, and `e` in a `catch`. Abbreviations the team says out loud (`id`, `url`, `api`) are words.
- **Booleans read as predicates**: `isLoading`, `hasError`, `canEdit`, `shouldRetry`. A bare `loading` or `open` reads as a value. Third-party props you don't control keep their names.
- **Domain words over placeholders.** Not `data`, `item`, `result`, `thing`, `handleThing` where the domain has a word. Rename at the destructure: `const { data: patients } = usePatientsQuery()`.
- **A new name follows its siblings.** Read the file and folder it lands in first. A flag added beside `markX` and `resetX` is `markY`, not `recordY`.
