---
paths:
  - "**/*.tsx"
  - "**/*.jsx"
  - "**/use*.ts"
  - "**/use*.js"
---

# React

How to write React components and hooks that render once per change and read as an outline. The project's `CLAUDE.md` wins where it differs: its design system, data library and store decide the concrete components, and its rules on those come first.

## Effects are for what React can't see

- **Derive during render.** A value computable from props and state you already hold is computed in the body, not copied into state by an effect. That copy renders twice and shows a stale value for a frame. `useMemo` is the step up only when a profile shows the computation is expensive.
- **Reset on identity with `key`.** When every piece of a component's state must reset as a prop changes, the parent renders it with `key={id}`. When only some state resets, store the previous prop in state and compare during render: `if (items !== prevItems) { setPrevItems(items); setSelection(null); }`.
- **User actions run in their handler**, not in an effect keyed off a flag the handler sets. That effect also runs on mount, and again whenever anything else sets the flag.
- **Effects subscribe**: window events, `matchMedia`, sockets, timers, observers. Reading the current value once before subscribing is correct, since it may have changed before the effect committed. Every subscription returns its cleanup.
- **Dependencies are primitives.** An object, array or function literal in a dependency array is new every render, so the effect runs every render, and loops if it sets state.
- **A hand-rolled fetch keyed off changing input ignores stale answers**: an `ignore` flag set in the cleanup, or an `AbortController`. Query libraries do this themselves.

## Memoization

- **None by default.** `useMemo` and `useCallback` earn their dependency array only when the value feeds another dependency array or a memoized child, or when a profile shows the cost.
- **A memoized child gets stable props.** Inline objects, arrays and arrow functions break its comparison every render. Hoist constants to module scope; hold callbacks with `useCallback`.
- **Missing memoization is found with a profiler**, not by reading.

## Components

- **One job.** Describe the component in one sentence without "and". Length alone is not the test: a long table that renders a table is fine.
- **Split when the JSX stops reading as an outline**: nesting past four levels, five or more styled elements in one return, or the same markup shape written twice with different data. Each region becomes a named subcomponent in its own folder under the parent, with its styles beside it, and the parent's return reads as the list of parts.
- **Pass content, don't configure it.** Take `children`, named slots or compound parts instead of props that decide what renders. A prop that sets a region's text, picks which elements appear, or sets the state of a child it renders (a title, a description, a button's `disabled`) is structure passed through a prop. The caller should render that part itself. A generic name (`Card`, `Panel`, `Row`) with content-shaped props (`label`, `content`, `icon`) or an internal `renderX` that picks the element is a slot the caller should own.
- **Props say what the component does**, not where the caller is: `showSummary`, not `isOnReviewPage`.
- **Judge props by what they do, not how many there are.** A prop that feeds behavior the component owns is fine, such as a focus key, an id it loads data for, or a handler on its own input. A prop that shapes the rendered output means that region is a part the caller should compose.
- **Prefer compound components** (`<Modal.Header>`, `<Modal.Body>`, `<Modal.Actions>`) for any component with several regions. The parent owns shared state and behavior and passes them to its parts through context. The caller assembles the parts and sets each one's content and state directly. Never wrap one compound component in another. When a component renders parts that already compose, delete the wrapper and move what it added into those parts.
- **Each conditional branch is one line**: `{isEmpty && <ListEmpty />}`, not a large inline block.
- **Hooks or compound components over render props** and function children, which nest badly and hide the structure.

## Where state lives

Climb only when the current rung hurts: inline in the component; a custom hook once it is shared or hides the render; composition with context once props would pass through three components that don't use them; a store once the shared value changes often, since context re-renders every consumer on each change.

## Async UI

- **Loading, failed and loaded are each rendered on purpose.** `data?.rows ?? []` satisfies the type, but an empty table is not an error message.
- **A list that can be empty has an empty state.** A fixed array, such as a set of tabs, does not.
- **A control that starts a write is disabled while it is in flight**, and until the inputs the write needs are filled. A spinner alone doesn't block a second click.
- **Buttons inside a `<form>` declare `type`**, and the form's `onSubmit` calls `preventDefault()`. The default `type="submit"` reloads the page, and jsdom doesn't navigate, so specs pass anyway.
- **Keys are stable ids.** An index key is wrong for any list that is filtered, sorted, paginated or edited, or whose rows hold state: the state follows the position, not the item. With no id, derive one from the content.
- **Window long lists** when rows routinely reach the hundreds, or each row runs its own query or draws something heavy.

## Accessibility

- **Clickable things are buttons and links**, never `<div onClick>`. An element that truly can't be one needs a `role`, `tabIndex={0}`, and Enter and Space handlers.
- **Every control has a name**: an associated `<label>`, an `aria-label` on an icon-only button naming the action rather than the icon, `alt` on images (`alt=""` when decorative).
- **No ARIA that native HTML already says.** No `role="button"` on a `<button>`, no `aria-label` repeating visible text, no `aria-hidden` on anything focusable. `aria-expanded`, `aria-selected` and `aria-checked` are bound to state, and `aria-labelledby` points at an id that renders.

## Tests

- **Query interactive elements by role**: `getByRole("button", { name: /save/i })`. A `getByText` on a button passes when it is a `div` no keyboard reaches. `ByText` is for static copy; `ByTestId` only where no accessible handle exists.
- **Children render real.** Mock only what can't mount in the test environment, such as a canvas or a map, and seed data through the network or the data provider rather than by mocking a generated query hook.
- **Never mock the unit under test**, including the hook that holds all of a component's logic.
- **Each assertion could fail if the named behaviour broke.** Not a value captured before the action, not what the mock was configured to return, not a synchronous check wrapped in `waitFor`.
- **Test what branches**: conditional rendering, handlers, derived values, hooks, error and empty paths. A component that only maps props to markup needs no spec.
