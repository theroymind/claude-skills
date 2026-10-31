---
name: refine
description: Generates variations on how to solve a known problem, stress-tests them and converges on one direction. Use when the problem is clear but the approach is open, when the user wants options, or says "ideate", "refine this idea" or "stress-test this idea".
---

# Refine

Open up the ways to solve a problem the user already understands, then converge on the simplest direction that solves it. Be a sharp, honest partner: when an idea is weak, say so specifically. When who it's for or what success looks like is still unknown, run `align` first; when the direction is already chosen, go to `spec`.

## Steps

1. **Frame** the problem as one "How might we…" sentence, from `align`'s intent statement or the idea in `$ARGUMENTS`. Then list the premises the ask carries that every variation would inherit (an ask for "a readout of unposted needs" presumes the player should see unposted needs), and confirm the load-bearing ones with `AskUserQuestion` ([asking](../../references/asking.md)) before expanding. A premise the user rejects reframes the problem.
2. **Expand** into 5–8 numbered variations, each with the assumption it rests on. Pick the lenses that fit (inversion, a removed constraint, another audience, 10x simpler, 10x scale); [frameworks.md](frameworks.md) has more. In a codebase, ground the variations in its architecture and prior art, and cite files. Show them in the chat and end the turn asking which resonate ([asking](../../references/asking.md)). Steps 3–6 wait for the reply, even when the ask says to pick one.
3. **Cluster** the ones that resonated into 2–3 genuinely different directions.
4. **Stress-test** each direction against the rubric in [refinement-criteria.md](refinement-criteria.md): user value, feasibility, differentiation, and the assumption that would kill it.
5. **Choose** with `AskUserQuestion` ([asking](../../references/asking.md)): one option per direction, your recommendation first, and in each description the killing assumption and the rubric dimension it is weakest on, so the stress-test is visible in the card.
6. **Record** the chosen direction in the Direction format, or in the project's own note format when the ask or the repo names one (a `templates/` folder, an existing decisions or ideas directory). Decide nothing the direction leaves open: list those under Open decisions for `spec` to ask. Show the record in the chat and end the turn asking whether to go on to `spec`, save it (to `docs/ideas/<name>.md` or the project's place), or stop.

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
**Open decisions:**
- <rule or behaviour the direction forces but doesn't settle> — <your guess>
```

The Not doing list is the most valuable part, because it makes the trade-offs explicit. `spec` takes this record as its input and asks the Open decisions.

## Done when

The user has chosen a direction, and its record names the MVP, each killing assumption with a way to test it, and a Not doing list.
