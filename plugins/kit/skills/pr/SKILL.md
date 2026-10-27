---
name: pr
description: Push the current branch and open a GitHub pull request for it
allowed-tools: Bash(git:*), Bash(gh:*)
---

# Open a Pull Request

Turn the current branch into a reviewable PR against the repo's default branch.

## Steps

1. Find the base with `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`. If the current branch is the base, stop and ask for a branch name.
2. Read `git log --oneline <base>..HEAD` and `git diff <base>...HEAD` to see what the PR contains.
3. Push with `git push origin HEAD`. After a rebase or amend, use `git push --force-with-lease origin HEAD`.
4. If `gh pr view` finds a PR for this branch, the push updated it. Otherwise create one:

```sh
gh pr create --head "$(git branch --show-current)" --title "<under 70 chars>" --body "$(cat <<'EOF'
## Summary
<1-3 bullets: what changed and why>
EOF
)"
```

5. Reply with the PR URL.

## Rules

- Never force push the default branch.
- No signature or attribution in the title or body.
