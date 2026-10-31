# claude-skills

Personal Claude Code plugins. The `kit` plugin holds the engineering workflow skills.

## Building a feature

Run `/feature` and it picks up wherever the work stands. Each stage hands off to the next:

```
align → refine → spec → architect → breakdown → coordinate
```

| Skill | Use when | Produces |
|---|---|---|
| `align` | The ask is vague: no who, why or definition of done | Confirmed intent |
| `refine` | The problem is clear but the approach is open | A chosen direction |
| `spec` | You know what to build | `SPEC.md` |
| `architect` | The spec is approved and the code's shape isn't settled | `## Code Shape` in `tasks/plan.md` |
| `breakdown` | The shape is recorded and there are no tasks yet | `tasks/plan.md`, `tasks/todo.md` |
| `coordinate` | There are tasks to implement | Verified, committed slices |

Start at the first stage that applies; skip the ones already settled. For a quick fix (a few lines, nothing to decide), go straight to `build`.

## Along the way

- `tdd`, `debug`, `perf`, `ui`: while implementing
- `review`: findings on a change's bugs, shape and cost, run by `coordinate` on every slice or by hand on any diff
- `commit`, `git`: saving and shipping work
- `adr`: recording a decision
- `context`: starting in unfamiliar code or handing off a session
- `reorganize`: restructuring a project's file layout
- `retro`: looking back on a session
- `agent-docs`: writing skills, `CLAUDE.md` or `AGENTS.md`
