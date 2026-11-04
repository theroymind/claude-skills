# Artifact locations

Where the kit's skills read and write their artifacts.

## Defaults

| Artifact | Default location |
|---|---|
| Intent statements | `docs/intent/` |
| Ideas and directions | `docs/ideas/` |
| Specs and capability maps | `SPEC.md`, `SPEC-<capability-id>.md` and the map at the repo root |
| Plan, with its `## Code Shape` | `tasks/plan.md` |
| Task list | `tasks/todo.md` |
| Decision records | `docs/decisions/NNNN-title.md` |
| Vault notes and their rules | `docs/`, with the rules in `docs/README.md` |

## Project overrides

Before reading or writing an artifact, check the project's instructions for other locations: `CLAUDE.md`, `CLAUDE.local.md` and `AGENTS.md`. A location named there replaces the default. So does an issue tracker named there, for the task list.

- **Named locations win.** Use the path pattern the project gives, including its file naming. Never fall back to a default folder the project has ruled out, such as a `docs/` that holds committed team docs.
- **Shared folders need unique names.** When the project says several sessions or worktrees share the folder, every file name carries the ticket or capability slug. Never write `plan.md`, `todo.md` or `SPEC.md` there.
- **Uncommitted folders stay uncommitted.** When the location is git-ignored or excluded (`git check-ignore -q <path>` succeeds), write the files but never stage or commit them.
