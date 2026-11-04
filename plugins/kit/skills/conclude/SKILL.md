---
name: conclude
description: Records what a conversation settled as approved, committed notes in the project's vault. Use at the end of an align, refine, teach or design conversation, when the user says "conclude", "record this" or "write this up in the vault", or when align or refine hands off to save.
---

# Conclude

Turn the understanding a conversation reached into durable vault notes the user approved, so later briefs link to them instead of paraphrasing the talk. It records what was decided; it decides nothing new. Writing tasks with acceptance criteria is `breakdown`'s job: add a task only when the conversation agreed one outright.

## Steps

1. **Gather** what the conversation settled, from the end of the last `conclude` run in this conversation (its ref-and-summary report is in the transcript), or the whole conversation if it hasn't run: each decision with the options it rejected and why, each change to a spec, and each open thread. Every item traces to something the user said or accepted.
2. **Read the rules.** The vault rules are the file `CLAUDE.md` names for them, else `docs/README.md`: the note types, their properties, the folders, the templates and how a decision changes. The tracker is the command `CLAUDE.md` names for the vault (such as `tix`), with its create, set, supersede and link commands. Run its list and show commands to find existing notes the items touch.
3. **Propose** the note changes as a review ([asking](../../references/asking.md)). Show one numbered line per note: new or existing, type, ref, title, a one-line summary, and for an existing note what changes. A new note's ref is the predicted slug when the tracker names notes from their titles, and "assigned on creation" otherwise. See Note changes for what goes where. End the turn asking for approval, and write nothing until the user approves.
4. **Write** the approved changes through the tracker. Create each note with its create command (such as `tix doc add --type decision TITLE`). Set every property the template leaves blank or provisional (the summary, status, who decided, and links such as a decision's tasks) with the tracker's set command, such as `tix set REF summary="…" status=accepted decided_by=user`, and use its supersede and dependency commands for those links. The summary reads on its own as a card. Write the body by hand, below the properties, stating the why. With no tracker named, write markdown under `docs/` in the folders and templates the project already uses.
5. **Commit** only the note files this run touched, in one commit: those you wrote, and those the tracker changed as a side effect (such as the old decision `tix supersede` rewrites). Run `git add -- <paths>`, then `git commit -- <paths>`, naming each path both times. Other changes in the tree, staged or not, stay as they were. Write the message by `commit`'s rules and the project's: the repo's style, a `Ticket:` line when a task is in play, and no signature. Then report each note's ref and its summary.

## Note changes

- **Types.** Use only the note types the project's rules define, with the properties and folders they set. When an item fits no type, say so in the proposal instead of inventing one.
- **Decision.** One choice per note, with what it rejected and why, in the section the template names (such as `## Rejected`).
- **Changed decision.** A new decision note, with the old one marked superseded through the tracker's supersede command. The old note's text stays exactly as it was.
- **Spec change.** An edit to the existing spec's body, not a new note.
- **Open threads.** All of them go into one idea note, not one note each.
- **Properties.** Every property the tracker has a command for changes through that command: summary, status, links, supersession, dependencies. Hand edits are for prose.

## Done when

Every approved note change is written through the tracker with a standalone summary and a body stating the why, those note files and nothing else are in one commit, and the user has each note's ref and summary.
