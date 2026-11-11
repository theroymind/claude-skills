# Artifact locations

Where the kit's skills read and write their artifacts.

## Defaults

A project with a `.tix/config.yml` keeps its features, tasks and ideas where that file says, and they are read and written through `tix`, never by path. The table is for a project without one, and it matches the vault `tix init` writes.

| Artifact | Default location |
|---|---|
| Intent and pillars | `docs/intent.md`, `docs/pillars.md` |
| Feature docs | `docs/features/<feature>/<feature>.md` |
| Tasks | `docs/features/<feature>/tasks/<task>.md` |
| Ideas | `docs/ideas/<idea>.md` |
| Note templates | `docs/templates/` |
| Review profile | `.claude/kit/review.md` |

## Project overrides

Before reading or writing an artifact, check the project's instructions for other locations: `CLAUDE.md`, `CLAUDE.local.md` and `AGENTS.md`. A location named there replaces the default. So does an issue tracker named there, for features and tasks.

- **Named locations win.** Use the path pattern the project gives, including its file naming. Never fall back to a default folder the project has ruled out, such as a `docs/` that holds committed team docs.
- **Shared folders need unique names.** When the project says several sessions or worktrees share the folder, every file name carries the ticket or capability slug. Never write a generic name such as `plan.md` there.
- **Uncommitted folders stay uncommitted.** When the location is git-ignored or excluded (`git check-ignore -q <path>` succeeds), write the files but never stage or commit them.
