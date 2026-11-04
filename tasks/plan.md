# Implementation Plan: conclude

## Overview

Build the `conclude` skill from [SPEC-conclude.md](../SPEC-conclude.md): at the end of a conversation it proposes vault notes, writes the approved ones through the project's tracker, passes them through the project's gate and commits them. Then route `align` and `refine` through it, have `coordinate` briefs link the notes it wrote, and cover it with an eval. odin-tbc is the first project it runs on.

## Code Shape

Skipped: the work is skill markdown with no types or modules to shape.

## Task List

Tasks with criteria are in [todo.md](todo.md).

### Phase 1: The skill
- [ ] Task 1: The user runs `/conclude` and the approved notes land through the tracker in one commit
- [ ] Task 2: Notes pass the project's gate before they're committed
- [ ] Task 3: odin-tbc names its gate command
### Checkpoint: conclude works in odin-tbc
- [ ] A real `/conclude` in odin-tbc proposes, writes, gates and commits; Eric reviews

### Phase 2: Wiring
- [ ] Task 4: `align` and `refine` save through `conclude`
- [ ] Task 5: `coordinate` briefs link the vault notes a slice builds on
### Checkpoint: wired
- [ ] The existing align, refine and coordinate evals still pass; Eric reviews

### Phase 3: Eval
- [ ] Task 6: An eval checks `conclude`'s proposal, writes and refusal question
### Checkpoint: done
- [ ] The conclude eval passes; Eric reviews the series

## Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| `tix gate` isn't merged in Railyard yet | Med | Task 3 installs from `feat/vault-gates`; the skill reads the gate command from `CLAUDE.md`, so nothing in it names tix |
| The judge calls sonnet on every new note, about 10 s each | Low | Only added notes face the judge; a conclude writes a handful |
| `conclude` over-records: every passing remark becomes a note | Med | The approval list is the brake; the skill records only what the conversation settled, and leaves open threads as one idea note |
| The eval needs a vault and a gate inside the sandbox | Med | Use a small fixture vault and a stub gate script named in its `CLAUDE.md`, not real tix or sonnet |

## Open Questions

None.
