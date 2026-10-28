---
name: git
description: Commit, branch and release discipline. Use when committing, splitting a messy working tree into atomic commits, branching, opening a PR, or cutting a release (version bump, tag, changelog).
---

# Git Workflow and Versioning

## Commits

- **Atomic.** Each commit does one logical thing and leaves the build and tests green. Refactors, formatting changes and behaviour changes go in separate commits, ideally separate PRs. A trivial rename can ride along with a feature.
- **Small.** Aim for about 100 lines. About 300 is fine for one logical change. Split anything that gets near 1000.
- **Often.** Commit each verified slice, so a broken next step reverts to the last good state instead of losing work.
- **Messages say why.** Match the repo's existing style (`git log --oneline -10`). If there is no style to match, use `<type>: <summary>` with one of `feat`, `fix`, `refactor`, `test`, `docs` or `chore`. Add a body explaining why when the diff doesn't show it.
- **Before committing**, read `git diff --staged`, check it for secrets, and run the repo's test, lint and type-check commands. Keep build output, `.env` files and personal IDE config out of commits. Lockfiles and migrations go in.

To split a messy working tree, stage one logical change at a time by path and commit it after its checks pass. When one file holds two changes, stage one of them with `git apply --cached` on a trimmed `git diff` patch.

## Branches

Keep the default branch deployable. Feature branches are short-lived: merge them within 1–3 days and delete them afterwards. Name them `feature/`, `fix/`, `chore/` or `refactor/` followed by a short description. Ship incomplete work behind a flag instead of keeping it on a long-lived branch. Never force-push a shared branch. Give each parallel agent its own worktree (`git worktree add ../repo-x feature/x`).

## Change summaries

After a change, and in a PR description, summarise it in three parts:

- What changed, file by file.
- What you deliberately left alone: out-of-scope issues you noticed.
- What the reviewer should check: assumptions, new dependencies.

## Releases

For anything with consumers:

- **Semantic version.** MAJOR for a break that consumers must change their code for, MINOR for a backward-compatible feature, PATCH for a backward-compatible fix. Any change to observable behaviour that consumers relied on is MAJOR, however small the diff (Hyrum's Law). When unsure, treat the change as breaking.
- **Tag** each release (`git tag -a v1.4.0 -m "Release 1.4.0"`, then push the tag). Derive the version from the tag instead of hand-editing it in several files.
- **Changelog** for people, not a commit dump. Put the newest entry first, group entries under `Added / Changed / Fixed / Deprecated / Removed / Security`, describe each by its impact on users, and write it in the same change as the code. A breaking change gets a migration note and a deprecation window.
