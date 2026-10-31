# Review-policy arms, 2026-10-31

Five runs per arm, same case, Opus implementor, Haiku judge. Hidden tests: 22.

| Arm | Hidden tests | Harness graders | code-review fired | Cost per run (mean) | Duration per run (mean) |
|---|---|---|---|---|---|
| none | 22/22 in 5/5 | 5/5 pass | 0/5 | $0.46 | 71s |
| conditional (master) | 22/22 in 5/5 | 5/5 pass | 0/5 | $0.44 | 79s |
| always | 22/22 in 5/5 | 5/5 pass | 4/5 | $0.69 | 129s |

Findings sent back by code-review in the always arm (4 runs): missing boundary tests
(CRLF after a closing quote, doubled quote at end of field, quoted field at EOF) and one
redundant flag. None changed parse behaviour: every run already passed the hidden tests
before review.

The conditional rule never fired, even though the task is a state machine the rule names.

Verdict: on this task, review added about 50% cost and 80% wall time and caught no defect.
The case is not hard enough to separate the arms on correctness; it does measure overhead.
