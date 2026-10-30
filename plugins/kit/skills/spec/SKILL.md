---
name: spec
description: Writes the spec for a chosen direction (objective, success criteria and scope) and saves it before any code. Use when starting a feature, project or significant change that has no spec yet, or when one request bundles several independently shippable capabilities.
---

# Spec

The spec is the agreed record of what we're building, for whom, and how we'll know it's done. Skip it for one-line fixes and for unambiguous, self-contained changes. Project facts (stack, commands, conventions) belong in `CLAUDE.md` and the code's shape in `architect`'s Code Shape, so a spec holds neither. If the project already uses OpenSpec or another spec system, keep its format and storage.

## Steps

1. **Gather** the inputs: `align`'s intent statement and `refine`'s direction, from the conversation, `docs/intent/` or `docs/ideas/`. When who it's for, why, or what done means is still unknown, run `align` first.
2. **Split** a bundled request. When it holds capabilities that ship and test independently (their own consumers or data, acceptance criteria that fall into separate groups, one part you could cut without rewriting the others), propose a Capability map and get it approved as a review ([asking](../../references/asking.md)) before writing any spec. Then run the remaining steps once per capability, in dependency order.
3. **Surface assumptions** about whatever the inputs leave open (platform, data, auth, existing patterns), and ask about the uncertain ones as choices ([asking](../../references/asking.md)), your assumption as the recommended option. Fill no ambiguity in silently.
4. **Make criteria testable.** "Make the dashboard faster" becomes "LCP under 2.5s on 4G, initial data load under 500ms". Confirm any target you chose.
5. **Write** the spec from the Template and save it as `SPEC.md`, or `SPEC-<capability-id>.md` beside a capability map.
6. **Approve.** Review the spec ([asking](../../references/asking.md)), every section and its open questions: on approval, continue to `architect`; for changes, revise and review again. Start no `architect` work and no code until it is approved.

## Template

```markdown
# Spec: <feature>

## Objective
<What we're building, for whom, and why now. User stories where they help.>

## Success Criteria
- [ ] <specific, testable condition>

## Out of Scope
- <thing> — <reason>

## Constraints
<Limits the work must respect: budgets, compatibility, data rules, and changes to ask about first, such as schema changes or new dependencies.>

## Open Questions
- <question that needs human input>
```

## Capability map

```markdown
# Capability Map: <initiative>

| Id | Responsibility | Depends on |
|---|---|---|
| identity | Accounts, sessions, SSO | — |
| billing | Plans, invoices, payments | identity |
| notifications | Email and webhook fan-out | identity |

Build order: identity → billing, notifications
```

- **Ids** are kebab-case and never renamed mid-initiative. Later skills pick work by them, and `architect` uses them as module names.
- **Dependencies** point one way. Two capabilities that need each other are one capability.
- **Storage**: the map at the project root, each capability's spec beside it. The map is the index of which specs exist.

## Keeping it current

When a decision or the scope changes, update the spec first, then the code. Commit the spec with the code, and link each PR to the spec section it implements.

## Done when

The human has approved a spec whose every success criterion is testable and whose Out of Scope is filled.
