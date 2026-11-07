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

- `debug`, `ui`: while implementing
- `review`: findings on a change's bugs, shape and cost, run by `implement` on tasks marked for review or by hand on any diff or pull request. A project's review profile (`.claude/kit/review.md`, written by `/kit:setup`) adds its own rules as lenses on top of the kit's language rules for the changed files, and says where pull request context, tickets and posted comments come from
- `commit`, `git`: saving and shipping work
- `retro`: looking back on a session
- `tracker-snapshot`: writing a read-only snapshot of a tracker project (Linear, GitHub Issues) to `.tix/tracker.json`, for the Herdr work-map panel
- `agent-docs`: writing skills, `CLAUDE.md` or `AGENTS.md`

## Evals

Run `plugins/kit/evals/run.sh` with any `claude plugin eval` options, such as `--case 'review-*' --runs 1`. It judges with Sonnet, runs each case's scaffold, allows Bash, and puts the real `node` binary on `PATH`, since the eval sandbox cannot follow fnm's per-shell symlink. `git` inside a run needs a real binary ahead of `/usr/bin/git`, such as Homebrew's.

## Language rules

`plugins/kit/rules/<extension>.md` holds the rules for one language, scoped with `paths` frontmatter. Run `/kit:setup` in a project to pick languages and copy their rules into `.claude/rules/kit/`, where Claude Code loads each one whenever a matching file is read or edited. Project-specific exceptions go in the project's `CLAUDE.md`.
