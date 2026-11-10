# Pull requests

The branch of `review` for a pull request or merge request: the context it loads before the lenses, who it is written for, how a large one is split, and how it ends.

## Before the lenses

1. **Context.** Run the profile's Context step. With none, use the forge's CLI (`gh pr view` and `gh pr diff`, or `glab mr view` and `glab mr diff`) and check the head out in a new worktree under `.claude/worktrees/`, so the user's checkout is never touched. Done when you hold the title, description, author, base, head sha, diff, CI state, conflict state, the worktree path, and the full body of every unresolved discussion.
2. **Ticket.** Fetch the ticket the branch or description names, through the profile's Ticket step or the tracker the project's instructions name. Its acceptance criteria outrank the author's description.
3. **Readiness.** Each of these is a **Blocking:** finding with no file: failing CI, conflicts with the base, and an unresolved discussion no hunk addresses. To call a discussion addressed, judge from its full body and cite the hunk that addresses it.
4. **Fit.** An acceptance criterion with no code or test behind it is a finding. So is a statement in the description that the diff contradicts; the diff wins. Work beyond the ticket gets a note.

## Author

Compare the author with the user (`gh api user`, or `glab api user`).

- **Self.** Report everything that survives Rank.
- **Peer.** Every finding spends the author's attention. Keep the ones they would be glad to hear about. Cut local shape, anything a linter or type checker already reports, and anything the author already named in the description, a comment or a discussion. Aim for 3 to 8 findings, cutting from the bottom and never a Bug or Blocking one.
- **Questions.** When the fact is verified but your judgment of it is not, write the Issue as the question you'd ask: "is the nil case reachable here? I found no caller that avoids it."

## Large changes

Past about 300 changed lines, or across several layers, split the lenses across `kit:reviewer` agents: one with Correct and the profile's lenses, one with Modular, Composed and Cheap. Give each the worktree path, the ticket's criteria and its lenses. Run at most two at a time and wait for both before going on. Merge their findings, collapsing two on the same line and concern into one, then run Verify on every merged finding yourself: an agent's line number is a claim.

## Report

After the Findings table:

- **Self.** End asking which findings to apply, as a review ([asking](../../../references/asking.md)): "Reply with the numbers to apply."
- **Peer, with a Posting step.** End asking which to post, as a review: "Reply with the numbers to post." Post only the numbers chosen, through the profile's Posting step. A finding with no file, or a Follow-up, cannot be posted on a line and is never offered.
- **Peer, with no Posting step.** End with the table for the user to paste. Nothing is posted.
