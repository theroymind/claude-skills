---
name: commit
description: Commits the current changes, split into one commit per logical change, and rebases onto the default branch. Use when the user asks to commit, or to split a messy working tree into atomic commits.
allowed-tools: Bash(git:*)
---

# Commit

Stage all changes, create a commit, and rebase it onto the latest default branch.

## Steps

1. **Read** `git status`, `git diff` (staged and unstaged) and `git log --oneline -5` in parallel, to understand the changes and the commit style.
2. **Stage** all changes with `git add .`. When they hold more than one logical change (a refactor, a feature and a config change are three), commit each separately instead: stage one by path, and one change within a file with `git apply --cached` on a trimmed `git diff`. Aim for about 100 lines a commit; about 300 is fine for one logical change, and anything near 1000 gets split.
3. **Write the message**:
   - First line: a concise summary of what changed and why.
   - For non-trivial changes, a blank line and then a short body with context.
   - The style of the repo's recent commits.
   - When the change is for a tracked task or ticket (one named in the conversation, the brief or the branch), a final line `Ticket: <id>` after a blank line, so the tracker can find the commit. Use the task's note name or ticket id exactly.
4. **Commit** the changes.
5. **Pull** the default branch with rebase (`git pull --rebase origin <default>`, where `<default>` comes from `git symbolic-ref --short refs/remotes/origin/HEAD` without its `origin/` prefix) and resolve any conflicts.

## Rules

- **No signature.** Never add Co-Authored-By or any other signature to commit messages. The `Ticket` trailer is a reference, not a signature.
- **New commits only.** Create a new commit each time, never amending an existing one.
