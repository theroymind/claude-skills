---
name: commit
description: Pull latest, stage, and commit all current changes
allowed-tools: Bash(git:*)
---

# Commit

Stage all changes, create a commit, and rebase it onto the latest default branch.

## Steps

1. **Read** `git status`, `git diff` (staged and unstaged) and `git log --oneline -5` in parallel, to understand the changes and the commit style.
2. **Stage** all changes with `git add .`.
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
