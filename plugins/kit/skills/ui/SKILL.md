---
name: ui
description: Builds UI by composition from small agnostic primitives, theme tokens and variants, in any framework or engine. Use when creating, changing or reviewing UI code — components, panels, HUD, screens, overlays, layout, styling or theme.
---

# UI

UI here is **composed**: small primitives that know nothing about the domain, assembled at the call site into the thing the screen needs. The look comes from shared **defaults**: theme tokens and variants, so an element file specifies structure and content, never its own spacing, colour or type.

The concrete primitives, token files, variant tool and lint gates belong to the project. Its `CLAUDE.md` or a project UI skill names them. Read two or three existing primitives before inventing a shape, and follow the one they share.

## Composition

**The case-or-part test.** Before adding to a component, ask: am I adding a *case* or a *part*?

- A **case** is another value that changes which styles apply. It becomes a **variant** in the component's variant layer (`cva`, a theme variant table), never a markup conditional.
- A **part** is another region, block or decoration. It becomes a **sibling component** the caller composes, never a prop, flag or named slot.

```
Card                                    Card { title, has_footer, footer_text, header_size }
  CardHeader                              ← a form to fill in, structure hidden behind props
    CardTitle  "Tasks"
  CardContent
    TaskList   tasks
```

- **Primitives are agnostic.** A slot draws a bordered box; a bar draws a ratio. Domain compositions (an item slot = slot + icon + count + cooldown) live in the app or game layer, built from primitives.
- **Layer decorations as siblings in the tree** (a depth stack, `zstack`, overlapping children) rather than as callbacks or render props (`overlay_fn`, `content_fn`) injected into a primitive. Everything that draws is a visible node.
- **Children over content props.** Content flows in as children; a prop holding markup, or an array of objects each rendering a chunk, is a subcomponent the caller writes in a loop.
- **Compound parts share state through context** (`provide`/`inject`, a context object, a parent handle). The parent provides read-only state plus mutator functions; each part reads it. The call site stays pure structure.
- **Generic by default.** New primitives go into the shared UI kit, theme-driven, with no product content baked in. Keep an element local only when it's bound to one feature's mechanics.

### Extraction triggers

Any one means split now. They are smells, not metrics:

- A boolean prop that toggles layout or presence rather than styling.
- A branch that swaps a whole subtree.
- A named slot standing in for a part.
- The same style cluster repeated in one file.
- Markup you scroll to read, or nesting deep enough to lose track of which element a close belongs to.
- Three or more boolean props: a variant if they only restyle, subcomponents if they change structure.

## Defaults and tokens

- Elements use the theme's spacing, sizing, colour and type tokens, and the design scale's steps. A missing step becomes a new token in the theme, used everywhere.
- When the defaults look wrong for an element, fix the primitive or the theme so every element benefits.
- When the user asks for one-off styling on a single element, name the existing token that covers it, or propose a new theme token, before hand-tuning that element.
- Colour comes from semantic tokens (`primary`, `muted`, `danger`), never a raw palette value.

## State

- **The view reads state and emits intents.** A component never writes the model or a prop it was given. It emits an event or command, or binds two-way through the framework's model mechanism.
- **Derive, don't sync.** A value computable from other state is a derived value (`computed`, a getter). A watcher or effect that writes state to keep it in step is a derived value in disguise.
- **Effects have explicit sources and clean up what they start**: timers, listeners, subscriptions, animation loops.
- **Pass reactive inputs as getters or refs**, so a helper doesn't capture one frame's value and silently stop updating.
- **Large snapshots replaced wholesale** (simulation frames, big arrays) stay shallow and immutable; deep reactivity on them is wasted work.
- Work driven off a per-frame source is throttled or debounced.

## Markup

- Markup holds a property access, a single call, or a simple ternary. Anything longer becomes a named derived value or function.
- Lists over domain data key on the item's own stable id, never the loop index.
- Event handlers are a single call; a handler with a body is a named function.
- A frequent toggle hides and shows; a rarely present or expensive subtree mounts and unmounts.

## Component API

- Boolean props read as questions: `is_selected`, `has_footer`, `can_recall`.
- Events are bare verbs or nouns (`select`, `confirm`, `delete`). Two-way bindings use the framework's update convention.
- Declare every prop and event with types. A prop is optional only when the component renders correctly without it, and then it has a default.
- Primitives accept a caller style override and merge it through the project's merge helper, so the caller wins over the variant default.

## Done when

- Every new part is a composed sibling, every new case is a variant, and no extraction trigger remains.
- Element files carry no raw spacing, colour or type values; any new value is a theme token.
- No component writes state it doesn't own, and no effect keeps state in sync.
- Every list keys on a domain id, and markup holds no logic past a single call.
- The project's lint and check gates pass. The user verifies the visuals, and you tell them so.
