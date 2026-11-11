# Web frontend

The extra items `review` walks when a change touches browser UI code: React, Vue, Angular or Svelte components, templates, and the hooks, composables, services and stores they use. Each section joins the lens of the same name, and every candidate goes through Verify like any other. UI drawn by a game or native engine is not covered here.

## Correct

- **Mirrored state.** A value that already lives in props or inputs, fetched data or the URL, copied into local state (`useState`, `ref`, a component field, a signal) and kept in sync by an effect, watcher or `ngOnChanges`. The copy is stale for a render after every change, and a refetch overwrites what the user typed. Derive it where it's read (in the render body, a `computed`, a `computed()` signal or a pipe); when the user edits it, hold only the draft and reset it from the source's identity.
- **Failure shown as empty.** Loading or a failed request rendered the same as no data: a total of `0`, an empty list, a blank field the user can save. Render loading, failed and loaded on purpose, and keep unknown as unknown until the component that displays it; a money or count field never defaults to `0` in a shared hook, composable, service or context.
- **Reload as refresh.** A page reload or a full navigation standing in for a refetch, which throws away the user's other state and is only as fast as the whole app's boot. Refetch the query, or write the result into the client cache or store.
- **Subscription without teardown.** A listener, interval, observable subscription or watcher started by a component and never released when it unmounts or is destroyed: an effect with no cleanup, a `subscribe` with no `takeUntilDestroyed` or `async` pipe, a `watch` or `addEventListener` with no matching stop in `onUnmounted`. Each mount adds another, and the old ones write to state that is gone. Return the cleanup, or tie it to the component's lifetime.
- **Tests that fake the data contract.** A component spec that hand-writes the return of a generated query hook or composable, or stubs the client or service, cannot catch a wrong query or a missing field. Seed the network or the data provider with the real document instead.

## Modular

- **Scattered state.** One feature's state and behaviour spread across many small hooks, composables, services or stores that each component wires together. The signs are a component calling several of the feature's hooks, hooks taking each other's return values as arguments, and the same set of calls repeated in sibling components. The component has become the owner by accident, and every consumer repeats the wiring. Name the concept they share and propose one hook or composable with a small interface, or a store scoped to the feature and provided by its root component: a zustand store in context, a Pinia store, or an Angular service provided at that component.

## Cheap

- **Query per row.** A row, card or list-item component that runs its own query makes one request per item its parent renders, an N+1 split across files. Fetch the fields in the parent's list query, as a fragment the row declares, and pass each row its slice.
