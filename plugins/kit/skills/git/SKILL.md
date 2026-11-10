---
name: git
description: Commit, branch and release discipline. Use when committing, splitting a messy working tree into atomic commits, branching, opening a PR, or cutting a release (version bump, tag, changelog).
---

# Git

## Commits

- **Atomic.** Each commit does one logical thing and leaves the build and tests green. Refactors, formatting changes and behaviour changes go in separate commits. A trivial rename can ride along with a feature.
- **Small.** Aim for about 100 lines. About 300 is fine for one logical change. Split anything that gets near 1000.
- **Often.** Commit each verified slice, so a broken next step reverts to the last good state instead of losing work.
- **Messages say why.** Match the repo's existing style (`git log --oneline -10`). If there is no style to match, use `<type>: <summary>` with one of `feat`, `fix`, `refactor`, `test`, `docs` or `chore`. Add a body explaining why when the diff doesn't show it.
- **Before committing**, read `git diff --staged`, check it for secrets, and run the repo's test, lint and type-check commands. Keep build output, `.env` files and personal IDE config out of commits. Lockfiles and migrations go in.

To split a messy working tree, stage one logical change at a time by path and commit it after its checks pass. When one file holds two changes, stage one of them with `git apply --cached` on a trimmed `git diff` patch.

## Branches

Name branches `feature/`, `fix/`, `chore/` or `refactor/` followed by a short description. Give each parallel agent its own worktree under `.claude/worktrees/`, which the repo's `.gitignore` lists (`git worktree add .claude/worktrees/x feature/x`).

## Change summaries

After a change, and in a PR description, say what changed and why, the decisions made, what you deliberately left alone, and what the reviewer should check.

## Releases

Tag each release and derive the version from the tag instead of hand-editing it in several files. Write the changelog entry in the same change as the code.
