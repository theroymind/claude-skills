#!/bin/sh
set -eu

if [ $# -lt 1 ]; then
	echo "usage: land.sh <worktree> [gate command...]" >&2
	echo "  lands the committed branch of .claude/worktrees/<worktree> on the main tree's branch:" >&2
	echo "  rebases it, runs the gates when the rebase moved it, fast-forwards, removes the worktree" >&2
	exit 2
fi

name="$1"
shift

main_tree=$(git worktree list --porcelain | sed -n '1s/^worktree //p')
tree="$main_tree/.claude/worktrees/$name"

fail() {
	echo "land: $1" >&2
	exit 1
}

[ -d "$tree" ] || fail "no worktree at $tree"

branch=$(git -C "$tree" branch --show-current)
target=$(git -C "$main_tree" branch --show-current)
[ -n "$branch" ] || fail "$tree is not on a branch"
[ -n "$target" ] || fail "the main tree is not on a branch"

if [ -n "$(git -C "$tree" status --porcelain)" ]; then
	fail "$name has uncommitted changes: commit them in $tree first"
fi

if [ "$(git -C "$tree" rev-list --count "$target..$branch")" -eq 0 ]; then
	fail "$branch has no commit that $target lacks"
fi

target_head=$(git -C "$main_tree" rev-parse "$target")
fork_point=$(git -C "$tree" merge-base "$branch" "$target")

if [ "$fork_point" != "$target_head" ]; then
	if ! git -C "$tree" rebase --quiet "$target"; then
		fail "the rebase onto $target stopped on a conflict: resolve it in $tree, run git rebase --continue, then land again"
	fi
	if [ $# -gt 0 ]; then
		echo "land: $target moved since $branch forked, running the gates on the rebased tree"
		if ! (cd "$tree" && "$@"); then
			fail "the gates failed on the rebased tree in $tree: fix, commit, then land again"
		fi
	fi
fi

if ! git -C "$main_tree" merge --quiet --ff-only "$branch"; then
	fail "could not fast-forward $target in $main_tree: an uncommitted file there overlaps this change"
fi

git -C "$main_tree" worktree remove "$tree"
git -C "$main_tree" branch --quiet -d "$branch"
echo "landed $branch on $target at $(git -C "$main_tree" rev-parse --short "$target")"
