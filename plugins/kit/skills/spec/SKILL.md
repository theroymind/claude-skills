---
name: spec
description: Writes the spec for a chosen direction (objective, scope, success criteria and boundaries) and saves it before any code. Use when starting a new project, feature or significant change that has no spec yet, or when one request bundles several independently testable capabilities that need a capability map first.
---

# Spec-Driven Development

The spec is the shared source of truth for what we're building, why, and how we'll know it's done, agreed before any code is written. Skip it for one-line fixes and for changes that are unambiguous and self-contained. A simple change still gets a two-line spec with acceptance criteria.

If the project already uses OpenSpec or another spec system, keep that system's format and storage. This skill still owns the clarifying questions, the content and the approval gates.

## Phase 0: Scope check, for bundled capabilities only

Most requests describe one capability; for those, go straight to Phase 1. Break the request down first when it bundles capabilities that can be tested independently. Signs of that: the capabilities have their own consumers or data (identity, billing, notifications), the acceptance criteria fall into groups that could ship separately, or one part could be cut without rewriting the others.

Propose a capability map, not a project plan:

```markdown
# Capability Map: <initiative>

| Module id | Responsibility | Depends on |
|---|---|---|
| identity | Accounts, sessions, SSO | — |
| billing | Plans, invoices, payments | identity |
| notifications | Email and webhook fan-out | identity |
| reporting | Usage dashboards | billing, notifications |

Build order: identity → billing, notifications → reporting
```

- Module ids are kebab-case and never renamed mid-initiative. Specs and later skills pick work by these ids.
- Dependencies point one way. Two modules that need each other are one module.
- The contract between two modules belongs in the provider module's spec, and `architect` shapes it.

The human approves the map before any module spec is written. Then run spec → `architect` → `breakdown` → `build` for each module in dependency order. Save the map at the project root and each module's spec next to it as `SPEC-<module-id>.md`. The map is the index of which specs exist.

## Phase 1: Specify

1. **Surface your assumptions** before writing any spec content, and ask the human to correct them:
   ```
   ASSUMPTIONS I'M MAKING:
   1. This is a web application, not native mobile
   2. Authentication uses session cookies, not JWT
   3. The database is PostgreSQL (from the existing Prisma schema)
   → Correct me now or I'll proceed with these.
   ```
   Ask clarifying questions until the requirements are concrete. Never fill in an ambiguity silently.
2. **Turn vague requirements into testable criteria.** "Make the dashboard faster" becomes "LCP under 2.5s on 4G, initial data load under 500ms, CLS under 0.1. Are these the right targets?"
3. **Write the spec** from the template below and save it in the repository (`SPEC.md` unless the project says otherwise). Commands are complete, with their flags. Code Style is one real snippet plus the key conventions, not paragraphs of description.
4. **Stop.** Summarize the spec, list its open questions, ask the human to approve it or request changes, and end your turn. Don't run `architect` or `breakdown`, or write code, until the human approves in a later turn.

```markdown
# Spec: <project or feature>

## Objective
<What we're building, why, and for whom. User stories or acceptance criteria.>

## Tech Stack
<Framework, language, key dependencies with versions>

## Commands
<Build, test, lint, dev: full commands>

## Project Structure
<Directory layout with what lives where>

## Code Style
<One example snippet and the key conventions>

## Testing Strategy
<Framework, where tests live, coverage expectations, which test levels cover which concerns>

## Boundaries
- Always: <e.g. run tests before commits>
- Ask first: <e.g. schema changes, new dependencies, CI config>
- Never: <e.g. commit secrets, edit vendored code>

## Success Criteria
<Specific, testable conditions for done>

## Open Questions
<Anything unresolved that needs human input>
```

## After approval

The approved spec goes to `architect` for the shape of the code, then to `breakdown` for the task list. Keep the spec current: when a decision or the scope changes, update the spec first and then the code. Commit the spec with the code, and link each PR to the spec section it implements.
