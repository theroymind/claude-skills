---
name: context
description: Loads the right context before a task and hands off cleanly between sessions. Use when starting a task in unfamiliar code, when output drifts from project conventions, when the spec and the code conflict or a requirement is missing, or when ending a session partway through a plan.
---

# Context Engineering

## Before a task

Read the files you'll change, their tests, the types involved, and one existing example of the pattern you're about to write. Load only the section of the spec the task needs. When something fails, work from the specific error, not the whole log.

## Conflicts and gaps

When the spec, the code and the instructions disagree, or the task needs a case the spec doesn't cover, look in the codebase for precedent first. If there is none, stop and ask, with options:

```
CONFUSION:
The spec calls for REST endpoints, but user queries use GraphQL (src/graphql/user.ts).
A) Follow the spec: add a REST endpoint
B) Follow the code: use GraphQL and update the spec
→ Which should I take?
```

Don't invent requirements; that decision belongs to the user.

## Inline plan

For a task with several steps, write a short numbered plan ending in "→ Executing unless you redirect" before you start.

## Session handoff

End a session at a completed task boundary, not at an arbitrary point. Before leaving, write these into the plan or task list:

1. The agreed scope and decisions.
2. The task status and the next task.
3. The files changed and the state of the working tree.
4. The verification commands and their results.
5. Open questions, risks and approvals still needed.

Commit only when the user or the repo's workflow allows it. Otherwise record that the changes are uncommitted.

A fresh session reads the rules, spec, plan, task status and `git status` before acting. It re-runs verification when the recorded baseline is missing, the code has moved, or the next task depends on it. It counts an approval only if a saved artifact records it, never because an earlier conversation mentioned it.

To write `CLAUDE.md`, `AGENTS.md` or other agent-facing docs, use `agent-docs`.
