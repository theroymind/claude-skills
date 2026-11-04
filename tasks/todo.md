# conclude: tasks

See [plan.md](plan.md) and [SPEC-conclude.md](../SPEC-conclude.md). The repo has no build; verification is the kit evals (`claude plugin eval plugins/kit`, or one case) and manual runs.

## Task 1: The user runs `/conclude` and the approved notes land through the tracker in one commit

**Description:** Write `plugins/kit/skills/conclude/SKILL.md` following `agent-docs`. It reads the conversation since the last `conclude` run in it (or the whole conversation), proposes note changes as a list (new or existing, type, ref, title, one-line summary, and what changes for an existing note), and waits for approval. It picks note types from the project's vault rules (`docs/README.md` or the file `CLAUDE.md` names), writes through the tracker command `CLAUDE.md` names (prose by hand below the tool's properties), and commits exactly those note files by path in one commit, with `commit`'s message rules but not `commit` itself (it stages the whole tree), reporting each ref and summary. With no tracker named it writes markdown under `docs/` in the project's layout. List it in the README.

**Acceptance criteria:**
- [x] It writes nothing before the user approves the proposed list, and the list shows type, ref, title and summary per note.
- [x] Notes are created and changed through the tracker's commands; every note has a standalone summary and a body stating the why; no type outside the project's rules.
- [x] One commit holding only the notes written or changed, then a report of each note's ref and summary.

**Verification:**
- [x] Manual check: in a scratch copy of odin-tbc, after a short design exchange, `/conclude` proposes a decision note, writes it with `tix doc add --type decision` on approval, and commits it

**Dependencies:** None
**Files likely touched:** `plugins/kit/skills/conclude/SKILL.md`, `README.md`
**Estimated scope:** S

## Task 2: Notes pass the project's gate before they're committed

**Description:** Between writing and committing, `conclude` stages exactly the notes it touched and runs the gate command `CLAUDE.md` names. A lint failure it fixes and re-runs without asking. A judge refusal (duplicate or conflict) stops it: `AskUserQuestion` with fold into the named note, supersede it (through the tracker's supersede command), or drop the new note; it acts and re-runs. With no gate named it skips the step and says so.

**Acceptance criteria:**
- [ ] The gate runs on the staged notes before any commit, and the commit happens only once it passes.
- [ ] A lint failure is fixed and the gate re-run with no question to the user.
- [ ] A refusal asks the three-way question naming the existing note, and the chosen action happens before the gate re-runs.

**Verification:**
- [ ] Manual check: in a scratch copy of odin-tbc, a conclusion that restates `turn-order-is-a-wait-counter` reaches the question instead of a commit

**Dependencies:** Tasks 1, 3
**Files likely touched:** `plugins/kit/skills/conclude/SKILL.md`
**Estimated scope:** S

## Task 3: odin-tbc names its gate command

**Description:** Install tix from Railyard's `feat/vault-gates` branch (Eric runs `make install`), and add `tix gate --staged` to odin-tbc's `CLAUDE.md` Commands as the vault write gate, plus the `required_sections` the gate agent suggested to `.tix/config.yml` once the failing notes (`model-test`, `ui-library`) are fixed or their type's list loosened.

**Acceptance criteria:**
- [ ] odin-tbc's `CLAUDE.md` names `tix gate --staged` as the gate for vault writes.
- [ ] `tix lint --all` exits 0 in odin-tbc.

**Verification:**
- [ ] Tests pass: odin-tbc's `make check test`
- [ ] Manual check: `tix gate --staged` with nothing staged exits 0

**Dependencies:** None
**Files likely touched:** odin-tbc `CLAUDE.md`, `.tix/config.yml`, `docs/model-test.md`, `docs/ui-library.md`
**Estimated scope:** S

## Checkpoint: conclude works in odin-tbc

- [ ] A real `/conclude` in odin-tbc proposes, writes, gates and commits
- [ ] Eric reviews

## Task 4: `align` and `refine` save through `conclude`

**Description:** `align`'s hand-off offers `conclude` instead of saving to `docs/intent/` itself, and `refine`'s Record step offers `conclude` instead of its own `tix doc add` instructions. Their other steps stay as they are.

**Acceptance criteria:**
- [ ] Neither skill holds its own instructions for writing a note; both name `conclude` as the way to save.
- [ ] The `align-vague-ask` and `refine-options` evals still pass.

**Verification:**
- [ ] Tests pass: `claude plugin eval` on `align-vague-ask` and `refine-options`

**Dependencies:** Task 2
**Files likely touched:** `plugins/kit/skills/align/SKILL.md`, `plugins/kit/skills/refine/SKILL.md`
**Estimated scope:** S

## Task 5: `coordinate` briefs link the vault notes a slice builds on

**Description:** Under Read first in coordinate's Brief, list the vault refs (specs, decisions, ideas) the slice builds on, for the implementor to read with the tracker's show command, and the specific commits the coordinator chose from the warm-up pack rather than the whole pack's path.

**Acceptance criteria:**
- [ ] Read first names vault refs and chosen commit hashes, and tells the implementor to read them with the tracker's show command and `git show`.
- [ ] The `coordinate-next-task` and `coordinate-csv-parse` evals still pass.

**Verification:**
- [ ] Tests pass: `claude plugin eval` on the two coordinate cases

**Dependencies:** None
**Files likely touched:** `plugins/kit/skills/coordinate/SKILL.md`
**Estimated scope:** S

## Checkpoint: wired

- [ ] The align, refine and coordinate evals pass
- [ ] Eric reviews

## Task 6: An eval checks `conclude`'s proposal, writes and refusal question

**Description:** Add `plugins/kit/evals/conclude-*` cases with a small fixture vault whose `CLAUDE.md` names a tracker and a stub gate script (refuses a note that duplicates a planted decision, passes otherwise). One case checks the proposal comes before any write; one checks the written notes and properties after approval; one checks the planted duplicate triggers the question instead of a commit.

**Acceptance criteria:**
- [ ] Three cases with graders, passing on the current skill.
- [ ] The duplicate case fails if the skill commits without asking.

**Verification:**
- [ ] Tests pass: `claude plugin eval` on the conclude cases

**Dependencies:** Task 2
**Files likely touched:** `plugins/kit/evals/conclude-*/`, a fixture vault under them
**Estimated scope:** M

## Checkpoint: done

- [ ] The conclude eval passes
- [ ] Eric reviews the series
