---
paths:
  - "**/*.odin"
---

# Odin

How to write Odin that stays plain and lets the compiler do the checking. The project's `CLAUDE.md` wins where it differs: a project that chose a global state or a single-file package on purpose keeps that choice.

## Memory

- **Group allocations by lifetime.** Permanent data, per-frame data and per-batch data each get an allocator (an arena for the short-lived ones) that is freed all at once. Short-lived work allocates from the frame or temp allocator and frees nothing itself.
- **Pass allocators explicitly.** A procedure that allocates takes `allocator := context.allocator` and a struct that owns memory stores the allocator it was given. Where the package enforces it, `#+vet explicit-allocators` turns an implicit allocation into a vet failure.
- **The temp allocator is reset in one known place**, such as the end of the frame. Code that relies on it trusts that reset rather than calling `free_all` itself.
- **Change `context` for a whole call tree** when a thread has rules of its own: an audio thread sets `allocator = mem.panic_allocator()`, so an allocation fails loudly instead of being a comment.

## Let the compiler check completeness

- **Full `switch` on unions and enums.** A new variant then fails to compile until every switch handles it. Write `#partial switch` only where ignoring the other cases is the intent.
- **Tagged unions for things of several types**, such as events or commands: `Event :: union { Event_Key_Down, Event_Mouse_Move }`.
- **`#all_or_none` on structs of procedures** that backends fill in, so a new procedure breaks every backend that hasn't implemented it.
- **`distinct` for IDs and handles**: `Texture :: distinct Handle` and `Sound :: distinct Handle` can't be swapped by mistake. Prefer generational handles (`core:container/handle_map`) to pointers for objects that are created and destroyed, so a stale handle looks up as `nil`.
- **Enumerated arrays and `bit_set`** instead of maps and integer flags: `[Keyboard_Key]bool`, `bit_set[Load_Option]`, `if .Premultiply in options`. Add `#sparse` when the enum's values aren't contiguous.

## Choose at compile time

When a choice is fixed per build (platform, backend), select it with `#config` and `when`, define the chosen type directly (`when BACKEND == "gl" { Render_State :: GL_State }`), and end the chain with `#panic` naming the valid values. Keep a runtime interface only where the program really switches at runtime, and then give it typed state rather than `typeid` plus casts.

## Types and zero values

- **Make `{}` a valid default.** Odin zero-initialises everything, so design structs whose zero value means "default" or "none", and take options as `options := Options{}`.
- **`Maybe(T)` when zero is itself a real value**: `scissor: Maybe(Rect)`.

## State and visibility

- **Pass state explicitly** in game and application code: `update :: proc(game: ^Game_State, ...)`. A package-level global is a choice for a library facade, made on purpose.
- **Pass typed data to callbacks.** Capture the typed pointer when the API allows it; `context.user_ptr` is the last resort, for APIs with no other way in.
- **Visibility through attributes.** `@(private="package")`, `@(private="file")` or `#+private package` at the top of a file. A leading `_` is only a naming habit and still exports the name.
- **Split files by feature.** The package is the directory, so files cost nothing to split: `audio.odin`, `input.odin`, `text.odin`. State that several files need is `@(private="package")`, not file-private.
- **Sub-packages for parts that stand alone**, such as a font cache, with their own allocator field, so they build and test in isolation.

## Errors

- **`@(require_results)`** where ignoring the result is almost always a bug: allocation, file I/O, parsing.
- **`#optional_ok`** only where a failure is logged and the returned value is safe to use anyway, such as a zero texture handle that draws nothing.
- **`loc := #caller_location`** on procedures that assert, so the failure points at the caller's line.

## Small idioms

- `#reverse for` with `unordered_remove` to remove items while iterating.
- `#load("file.png")` to build an asset into the binary.
- `proc "contextless"` for procedures that need no `context`, such as ones called from C.
- A nil backend that does nothing, for headless tests and graceful fallback.
- An unused import is deleted, never silenced with `_ :: pkg`.
