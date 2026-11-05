# claude-skills

Personal Claude Code plugins. The `kit` plugin holds the engineering workflow skills.

## Building a feature

Two skills:

```
feature → implement
```

| Skill | Use when | Produces |
|---|---|---|
| `feature` | You want to plan a feature, or log an idea | A short feature doc and its tasks, each with a `scope` and a `review` flag |
| `implement` | There are tasks to build | One commit per task: small tasks built in the session, medium and large ones by an implementor, reviewed when the task says so |

For a quick fix (a few lines, nothing to decide), go straight to `build`.

## Along the way

- `tdd`, `debug`, `perf`, `ui`: while implementing
- `review`: findings on a change's bugs, shape and cost, run by `implement` on tasks marked for review or by hand on any diff
- `commit`, `git`: saving and shipping work
- `context`: starting in unfamiliar code or handing off a session
- `reorganize`: restructuring a project's file layout
- `retro`: looking back on a session
- `agent-docs`: writing skills, `CLAUDE.md` or `AGENTS.md`

## Language rules

`plugins/kit/rules/<extension>.md` holds the rules for one language, scoped with `paths` frontmatter. Run `/kit:setup` in a project to pick languages and copy their rules into `.claude/rules/kit/`, where Claude Code loads each one whenever a matching file is read or edited. Project-specific exceptions go in the project's `CLAUDE.md`.
