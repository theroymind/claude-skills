# Spec: conclude

## Objective

At the end of a conversation where the user and the coordinator reached an understanding (`align`, `refine`, a teach-me or tell-it-back session, a design discussion), `conclude` turns that understanding into durable notes in the project's vault, passes them through the project's write gates, and commits them. Later work starts from those notes: an implementor's brief links to them instead of paraphrasing the conversation, so the agreed what and why reach the implementor in the user's own terms and survive the session.

It is the hinge between talking and building. The conversation decides; `conclude` records; `coordinate` and `breakdown` read what was recorded.

User stories:

- As the user, when we've agreed on how a feature works, I run `/conclude` and the decisions, spec changes and ideas from the conversation land as notes I approved, checked for duplicates and conflicts, and committed.
- As the user, when `align` or `refine` finishes, its save step is `conclude`, so there's one way notes get written.
- As the coordinator writing a brief, I link to the notes `conclude` wrote, by ref, rather than restating them.

## Success Criteria

- [ ] `plugins/kit/skills/conclude/SKILL.md` exists, follows `agent-docs`, and is listed in the README's Along the way section.
- [ ] It reads the conversation and proposes a set of note changes: for each, new or existing, the note type, ref, title and one-line summary, and for an existing note what changes. It writes nothing until the user approves the list.
- [ ] It decides note types from the project's own vault rules (`docs/README.md` or the file `CLAUDE.md` names): one choice per decision note with what it rejected, a spec change in the spec's body, an open thread as an idea. It never writes a note type the project doesn't define.
- [ ] It creates and changes notes through the tracker command `CLAUDE.md` names (for tix: `tix doc add`, `tix add`, `tix set`, `tix supersede`, `tix dep`), and writes only prose by hand, below the properties the tool wrote.
- [ ] Every note it writes or changes has a summary that reads on its own as a card and a body that states the why.
- [ ] It stages exactly the notes it touched and runs the gate command `CLAUDE.md` names (for odin-tbc: `tix gate --staged`).
- [ ] On a lint failure it fixes the note and re-runs the gate without asking.
- [ ] On a judge refusal (duplicate or conflict) it stops and asks the user with `AskUserQuestion`: fold into the named existing note, supersede it, or drop the new note. It acts on the answer and re-runs the gate.
- [ ] Once the gate passes it commits exactly the notes it wrote or the tracker changed, by path, in one commit with `commit`'s message rules (not through `commit`, which stages the whole tree), and reports each note's ref and summary.
- [ ] `align`'s hand-off and `refine`'s Record step offer `conclude` as the way to save, replacing their own save instructions.
- [ ] `coordinate`'s Brief, under Read first, lists the vault refs the slice builds on so the implementor reads them with the tracker's show command.
- [ ] An eval in `plugins/kit/evals/` runs `conclude` on a recorded conversation against a fixture vault and checks the proposed note list before approval, the notes and properties written after it, and that a planted duplicate triggers the question instead of a write.

## Out of Scope

- A local-model quality gate (is there a why, does the summary make sense): a separate change to `tix gate`; `conclude` runs whatever gate the project names.
- Writing tasks with full acceptance criteria and verification: that is `breakdown`. `conclude` may add a task only when the conversation agreed one outright.
- Changing coordinate's brief beyond Read first, or how it slices work.
- Scaffolding files in target folders: undecided, and separate from recording the conversation.
- Teach-me or tell-it-back skills themselves: `conclude` works after any conversation.

## Constraints

- Tracker-agnostic: it reads the tracker, vault rules and gate command from `CLAUDE.md`, like `feature` and `coordinate` do. With no tracker named it writes markdown under `docs/` in the project's existing layout; with no gate named it skips the gate step and says so.
- Depends on `tix gate` from Railyard's `feat/vault-gates` branch being installed for odin-tbc's use, and odin-tbc's `CLAUDE.md` naming it as the gate command.
- Never edits a note's properties by hand where the tracker has a command for it, and never rewrites a superseded decision's text.
- Commits follow the project's commit rules (for odin-tbc: no attribution trailer).

## Open Questions

None. Settled: conclude covers the conversation since the last `conclude` run in it, or the whole conversation if none.
