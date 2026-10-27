---
name: commit
description: Pull latest, stage, and commit all current changes
allowed-tools: Bash(git:*)
---

# Commit Changes

Pull the latest from master, stage all changes, and create a commit.

## Steps

1. Run `git status`, `git diff` (staged + unstaged), and `git log --oneline -5` in parallel to understand the changes and commit style.

2. Stage all changes with `git add .`

3. Analyze the diff and write a commit message:
   - First line: concise summary of what changed and why
   - If the changes are non-trivial, add a blank line then a short body with context
   - Follow the style of recent commits in the repo

4. Commit the changes.

5. Pull the latest from master with rebase (`git pull origin master --rebase`) and resolve any conflicts.

## Rules

- Never add Co-Authored-By or any signature to commit messages
- Do not amend existing commits — always create new ones
