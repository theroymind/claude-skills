# Review skill benchmarks, 2026-10-31

Two versions of `kit:review`. v1 had Modular / Composed / Cheap lenses. v2 added the Correct lens (bug hunt, **Latent** tag), "Several owners in one file" under Modular, and a step-1 line to list what a module owns. Graders were loosened between runs: the botlands target findings are accepted at any rank (bugs outrank them by design), the collider grader accepts the anchor-rule duplication or the shared→client sprite-cache dependency, and no-fabrication fails only on clear evidence.

Scores are passed runs / runs. Botlands v1 was scored on the strict (rank-bound) graders; v2 on the loosened ones.

| Case | v1 with | v1 without | v2 with | v2 without |
|---|---|---|---|---|
| review-bug-first | 3/3 | 0/3 | 3/3 | 0/3 |
| review-clean-change | 1/3 | 3/3 | 3/3 | 2/3 |
| review-planted-smells | 3/3 | 0/3 | 3/3 | 0/3 |
| botlands-shared-server-handlers | 0/3 | 0/3 | 1/3 (dep-direction 3/3) | 0/3 (dep-direction 0/3) |
| botlands-collider-composition | 0/3 | 0/3 | 1/3 (structure 3/3) | 3/3 |
| botlands-skill-execution-internal | 0/3 | 0/3 | 1/3 (split 2/3) | 0/3 (split 0/3) |
| odin-draw-live | 0/2 | 0/2 | 0/2 (format/latent noise) | 0/2 |

v2 "with" failures on botlands are all `no-fabrication` votes from the haiku judge; every citation spot-checked against the fixture was accurate. That grader was rewritten after the run.

What the skill changed on the real code:
- Handlers: with the skill, every run names the shared→server dependency as a numbered finding with a move (schema stays in shared, command moves to server). Without, it appears only as an aside or not at all.
- Skill-execution: 2 of 3 skill runs propose the four-way split; no baseline run mentions structure.
- Collider: both arms find the mask-alignment bug and the shared→client dependency; the skill adds nothing measurable here.
- draw.odin: the skill runs lead with a real hover-outline bug, tag the levels-on-one-plane and Surface_Slot.index issues as Latent, and propose the labels/geometry/draw split.

Cost: the skill adds roughly nothing on botlands (both arms $0.5–1.0 per run) and $0.10–0.15 on the toy cases.
