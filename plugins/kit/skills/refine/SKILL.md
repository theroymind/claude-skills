---
name: refine
description: Generates variations of one idea, stress-tests them, and converges on a one-pager. Use when the user has an idea and wants options or a sharper version of it, or says "ideate", "refine this idea" or "stress-test this idea".
---

# Idea Refine

Act as a sharp, honest thinking partner: take the raw idea (`$ARGUMENTS`), open it up, converge on the strongest direction, and produce a one-pager. Push toward the simplest version that solves the real problem. Start from the user and work back to the technology. When an idea is weak, say so, specifically and kindly. Treat this as a conversation, not a template. If the user isn't sure what they want at all, use `align`; if a direction is already chosen and needs requirements, use `spec`.

## Phase 1: Understand and expand

1. **Restate** the idea as a "How might we…" problem statement.
2. **Ask 3–5 sharpening questions** with `AskUserQuestion`: who it's for, what success looks like, the real constraints, what has been tried, and why now. Don't move on until you know who it's for and what success looks like.
3. **Generate 5–8 variations**, each with a reason for existing. Use whichever lenses fit: inversion, removing a constraint, a different audience, combining with an adjacent idea, a 10x simpler version, a 10x scale version, an expert's view. [frameworks.md](frameworks.md) has more; pick from them rather than running them all. Inside a codebase, ground the variations in its architecture and prior art, and cite files.

Wait for the user's reaction before converging.

## Phase 2: Evaluate and converge

1. **Cluster** the ideas that resonated into 2–3 genuinely different directions.
2. **Stress-test** each one for user value (a painkiller or a vitamin?), feasibility (cost, and the hardest part) and differentiation (would anyone switch to it?). The full rubric is in [refinement-criteria.md](refinement-criteria.md).
3. **Surface the assumptions** behind each one: what you're betting is true, what would kill it, and what you're choosing to ignore for now.

## Phase 3: Sharpen and ship

Write the one-pager:

```markdown
# <Idea name>

## Problem Statement
<One-sentence "How might we" framing>

## Recommended Direction
<The chosen direction and why, in at most 2–3 paragraphs>

## Key Assumptions to Validate
- [ ] <assumption> — <how to test it>

## MVP Scope
<The smallest version that tests the core assumption: what's in and what's out>

## Not Doing (and Why)
- <thing> — <reason>

## Open Questions
- <question to answer before building>
```

The Not Doing list is the most valuable part, because it makes the trade-offs explicit. Ask whether to save the one-pager to `docs/ideas/<idea-name>.md`, and save it only if they say yes.

Done when the user has confirmed the direction, and the one-pager names the user, the success criteria, each assumption with a way to test it, the MVP scope and a Not Doing list. Example sessions are in [examples.md](examples.md).
