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
3. **Write the feature doc.** Use plain, casual words, in the sections of Notes, starting from the project's feature template when it has one.
4. **Break it into tasks.** Each task is one slice (Slicing), starting from the project's task template when it has one. Write its description, files and criteria as Notes says. Set its dependencies, `scope` and `review` (Task sizing).
5. **Save as drafts.** Write each note once, straight to the tracker as a draft, which keeps it out of `tix ready` until approved: for tix, `tix add --draft --type feature TITLE` (or the project's own name for its top type), with `--external-id ID --external-url URL` when the ask has an external ref, then `tix add --draft --type task --parent FEATURE --description D --acceptance A... --file PATH... --set scope=S --set review=R --set summary=TEXT TITLE` and `tix dep`. Done when the tracker's lint passes on every draft. Without a tracker, go to step 6 and write the files at step 7.
6. **Review.** Show the feature doc in full, then one line per task: id, title, `scope`, `review`, dependencies and summary. End the turn asking for approval as a review ([asking](../../references/asking.md)), naming `tix show REF` for a task's full text and offering to print any tasks the user names in full. Apply changes to the drafts in place (`tix set`, `tix ac set`, `tix dep`, `tix undep`), lint, and show the summary again, until the user approves. Without a tracker, show the doc and every task in full.
7. **Approve.** Move every draft to the project's open status (for tix, `tix set REF status=S`, with S the status key the config maps to `open`, such as `todo`). Without a tracker, write the files where [artifacts](../../references/artifacts.md) says. Commit the notes.

## Notes

- **The template wins.** When the project has a template for a note type, its sections and the guidance written in them are the rules, and the bullets below fill in only what it leaves out.
- **One job per part.** Nothing in a note says what another part already says. If a sentence in a description would pass as a criterion, make it one and cut it from the description.
- **Feature doc.** `## Description` says what the user or player gets, why it fits, how it works (the types, where the code goes, what it reuses), and anything decided along the way, in prose of at most three short paragraphs. `## Acceptance criteria` is a checklist of things you can see or test. Every check by hand goes here, such as "In the boss fight you see the camera glide over the mage's shoulder": the user confirms these when the feature finishes. Settle every question in the conversation, so the doc holds only answers.
- **Task.** A `feature` link to its feature, `scope`, `review`, its dependencies, and these sections:
  - `## Description`: two to four sentences of prose for whoever builds it, saying what changes, why, the one decision that isn't obvious, and in half a sentence why it does or doesn't get a review. No lists.
  - `## Files`, when the project's tracker reads one (tix's `files_heading`): the paths it likely touches, one per item.
  - `## Acceptance criteria`: three to seven criteria, each one thing the agent building it can test, small enough to tick as soon as it lands, in roughly the order it gets built.
- **Criteria, not subtasks.** Ticked criteria are the progress a tracker's views show. Make a subtask only for a piece that needs its own dependency, its own review, or could be built in parallel.
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
| `small` | A few files in one place, nothing to decide | `none` |
| `medium` | One package or boundary, a decision or two | `pending` when it changes a core type, crosses a package boundary, or carries logic with edge cases such as math, state or ordering |
| `large` | Several packages, or new core types | `pending` |

`review` is `none` (no review), `pending` (a review is due) or `done` (it passed); `implement` moves `pending` to `done`.

Split a large task when it splits cleanly along Slicing.

## Done when

The user approved the doc and its tasks, no draft of them is left, the lint passes and the notes are committed.
