---
name: agent-docs
description: Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md.
---

# Agent Docs

Reference for writing any document an agent reads: a skill, an `AGENTS.md` or `CLAUDE.md`, a doc reached by a pointer. The aim is the same for each: the agent takes the same process every run.

When the document is a skill, also read [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md) for frontmatter, layout, the invocation choice and router skills.

## The two loads

Every line spends one of two budgets:

- **Context load**: always-loaded material, such as a `CLAUDE.md` line or a skill description, costs tokens and attention on every turn whether or not it fires.
- **Cognitive load**: material with no pointer relies on the human remembering it exists. Spend it where human judgement matters, and remove it where it doesn't.

## Context pointers

A **context pointer** is a line in context that names out-of-context material and says when to reach it. A skill's description is one; so is a `CLAUDE.md` line naming a doc. Its wording, not its target, decides how reliably the agent reaches the material. When a must-have target is missed, sharpen the pointer first, and inline the material only if that fails.

- **Say what the material is and list its branches**, the distinct cases that should trigger reaching it.
- **One trigger per branch.** Synonyms for one branch are that branch written twice.
- **Front-load the leading word**, and cut identity the body already carries.

## Information hierarchy

A document holds **steps** (ordered actions) and **reference** (rules and facts consulted on demand). Place each piece by how soon the agent needs it:

1. **In-file step**: what the agent does, in order.
2. **In-file reference**: consulted on demand. A flat set of peer rules is fine.
3. **Disclosed reference**: a separate file behind a pointer, loaded only when the pointer fires.

- **Progressive disclosure.** Inline what every branch needs, and push behind a pointer what only some branches reach. Reference left inline buries the steps; reference pushed too far hides what the agent needs.
- **Co-location.** Keep a concept's definition, rules and caveats under one heading, so reading one part brings the rest.
- **Sprawl.** A document can be too long even when every line is live. Disclose reference, or split by branch, so each path carries only what it needs.

## Steps and completion criteria

Every step ends on a **completion criterion**, the condition that tells the agent the step is done.

- **Checkable.** A vague bound ("understanding reached") invites **premature completion**, since the later steps pull attention forward. Sharpen the bound first. Only when it can't be sharpened and you see the rush, hide the later steps by splitting the sequence across a real context boundary, such as a subagent dispatch.
- **Exhaustive.** "Every modified model accounted for" forces the digging that "produce a change list" doesn't. It binds flat reference too: "every rule applied".

## When to split

A split spends one of the two loads, so split only when the cut earns it:

- **By sequence**: where the steps still ahead tempt the agent to rush the one in front of it. Merging sequences does the reverse.
- **By invocation**: see [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md).

## Leading words

A **leading word** is a compact concept the model already knows (_lesson_, _fog of war_, _tracer bullets_), repeated as a token so it anchors a whole behaviour in few words. A coined word works only once you define it, so reach for an existing one first. In the body it steers execution; in a pointer, when the same word lives in your prompts and your code, it steers invocation.

- **Collapse restatements into one.** "Fast, deterministic, low-overhead" becomes a _tight_ loop; "a loop you believe in" becomes one that goes _red_ on the bug.
- **State the positive.** A prohibition puts the banned behaviour in context and makes it more available. Write the target ("write one-line comments"). Keep a prohibition only as a hard guardrail, paired with the positive target.

## Pruning

- **Single source of truth.** Each meaning lives in one place. Duplication costs tokens and upkeep, and inflates a meaning's prominence.
- **The environment is a source too**: build scripts, config files, the directory layout, `--help` output. A document restating it is a cache, worth its load only when the lookup is expensive. Write down what the agent can't find by looking: the unwritten convention, the reason behind a choice, the gotcha no config admits.
- **Relevance.** Cut exposition that never bears on the task, and lines gone stale. Stale layers settle because adding feels safe and removing feels risky.
- **No-ops.** An instruction the model already follows by default pays load to say nothing. The test is whether it changes behaviour against the default, settled by running the document, not by debate. Delete the whole sentence. A leading word too weak to beat the default (_be thorough_) is a no-op too: name the specific behaviour instead.
- **Enforced rules.** A rule a hook, linter or check already enforces needs at most the line that says how to resolve its failure.
