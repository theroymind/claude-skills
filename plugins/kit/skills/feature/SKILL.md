---
name: feature
description: Plans a feature in one conversation, from research to a short feature doc and its tasks. Use when the user asks to plan, scope or design a feature, hands over a ticket URL to plan from, or wants to log an idea.
argument-hint: [feature, ask or ticket URL]
---

# Feature

One conversation that ends in two things: a feature doc anyone can read in a minute, and the tasks that build it. An idea, meaning a one-off thought the user isn't ready to work out, skips the conversation: write it as an idea note and stop. A task that already exists goes to `implement`.

## Steps

1. **Research.** When the ask is a ticket URL or id from an outside tracker, read that ticket first with the session's tracker tools: its title, description and criteria become the ask, and its id and URL become the feature's external ref. Before asking anything, find what the ask touches: the project's intent and pillars, the features, ideas and tasks in progress near it, the architecture docs `CLAUDE.md` names for each module it would change, and that code and its recent commits. Read notes through the tracker `CLAUDE.md` names, such as `tix ls --all` and `tix docs ls`, then `tix context REF` on each note near the ask, and otherwise the files [artifacts](../../references/artifacts.md) locates. Done when you can name every note and file the feature overlaps or contradicts.
2. **Talk it through.** Ask one question at a time with `AskUserQuestion` as a choice ([asking](../../references/asking.md)), with your best guess as the recommended option. Cover:
   - who it's for and what they get
   - the approach
   - how it fits the project's pillars, when it has them (a failing pillar cuts or softens the feature)
   - the types, modules and boundaries it adds or changes, sized against where the project is heading

   Done when you can predict the user's next three answers and nothing is left open.
3. **Write the feature doc.** Use plain, casual words, in the two sections of Notes.
4. **Break it into tasks.** Each task is one slice (Slicing) and has the same two sections. Its description names the files it likely touches, what to check by hand, and in one line why it does or doesn't get a review. Set its dependencies, `scope` and `review` (Task sizing).
5. **Review.** Show the doc and every task in the chat in full and end the turn asking for approval as a review ([asking](../../references/asking.md)). Revise until the user approves.
6. **Save.** Write through the tracker: for tix, `tix add --type feature TITLE` (or the project's own name for its top type), with `--external-id ID --external-url URL` when the ask has an external ref, then `tix add --type task --parent FEATURE TITLE`, `tix dep` and `tix set`, with the prose written by hand under the properties. Without a tracker, write the files where [artifacts](../../references/artifacts.md) says. Run the tracker's lint and commit the notes.

## Notes

- **Feature doc.** `## Description` says what the user or player gets, why it fits, how it works (the types, where the code goes, what it reuses), and anything decided along the way. `## Acceptance criteria` is a checklist of things you can see or test. Settle every question in the conversation, so the doc holds only answers.
- **Task.** A `feature` link to its feature, `scope`, `review`, its dependencies, and the same two sections.
- **Idea.** A summary and free text. It becomes a feature once it's worked out.
- **Lifetime.** A feature and its tasks live only while they're being built: `implement` deletes them once the feature is done, so the code, and any architecture docs the project keeps, stay the only truth.

## Slicing

- **Vertical** by default: each task is one complete path through the stack and leaves the project working.
- **Core first**: simulation or core logic before the UI or client on top of it.
- **Risk first**: prove the uncertain piece before building on it.
- Tasks that don't need each other's output have no dependency between them.

## Task sizing

| `scope` | Means | `review` |
|---|---|---|
| `small` | A few files in one place, nothing to decide | `false` |
| `medium` | One package or boundary, a decision or two | `true` when it changes a core type, crosses a package boundary, or carries logic with edge cases such as math, state or ordering |
| `large` | Several packages, or new core types | `true` |

Split a large task when it splits cleanly along Slicing.

## Done when

The user approved the doc and its tasks, they're saved, the lint passes and the notes are committed.
