---
name: commit
description: Pull latest, stage, and commit all current changes
allowed-tools: Bash(git:*)
---

# Commit

Pull the latest from master, stage all changes, and create a commit.

## Steps

1. **Read** `git status`, `git diff` (staged and unstaged) and `git log --oneline -5` in parallel, to understand the changes and the commit style.
2. **Stage** all changes with `git add .`.
3. **Write the message**:
   - First line: a concise summary of what changed and why.
   - For non-trivial changes, a blank line and then a short body with context.
   - The style of the repo's recent commits.
4. **Commit** the changes.
5. **Pull** the latest from master with rebase (`git pull origin master --rebase`) and resolve any conflicts.

## Rules

- **No signature.** Never add Co-Authored-By or any other signature to commit messages.
- **New commits only.** Create a new commit each time, never amending an existing one.
