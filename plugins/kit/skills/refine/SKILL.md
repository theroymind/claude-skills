---
name: refine
description: Generates variations on how to solve a known problem, stress-tests them and converges on one direction. Use when the problem is clear but the approach is open, when the user wants options, or says "ideate", "refine this idea" or "stress-test this idea".
---

# Refine

Open up the ways to solve a problem the user already understands, then converge on the simplest direction that solves it. Be a sharp, honest partner: when an idea is weak, say so specifically. When who it's for or what success looks like is still unknown, run `align` first; when the direction is already chosen, go to `spec`.

## Steps

1. **Frame** the problem as one "How might we…" sentence, from `align`'s intent statement or the idea in `$ARGUMENTS`.
2. **Expand** into 5–8 numbered variations, each with the assumption it rests on. Pick the lenses that fit (inversion, a removed constraint, another audience, 10x simpler, 10x scale); [frameworks.md](frameworks.md) has more. In a codebase, ground the variations in its architecture and prior art, and cite files. Review them ([asking](../../references/asking.md)), asking which ones resonate.
3. **Cluster** the ones that resonated into 2–3 genuinely different directions.
4. **Stress-test** each direction for user value, feasibility and differentiation, and name the assumptions that would kill it. The rubric is in [refinement-criteria.md](refinement-criteria.md).
5. **Choose** with a choice: one option per direction, its core assumption and biggest risk in the description.
6. **Record** the chosen direction in the Direction format, in a review that ends by asking whether to go on to `spec`, save it to `docs/ideas/<name>.md`, or stop.

## Direction

```markdown
# <Direction name>

**Problem:** <How might we…>
**Direction:** <what and why, in one paragraph>
**MVP:** <the smallest version that tests the riskiest assumption>
**Assumptions to validate:**
- <assumption> — <how to test it>
**Not doing:**
- <thing> — <reason>
```

The Not doing list is the most valuable part, because it makes the trade-offs explicit. `spec` takes this record as its input.

## Done when

The user has chosen a direction, and its record names the MVP, each killing assumption with a way to test it, and a Not doing list.
