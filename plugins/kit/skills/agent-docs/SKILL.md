---
name: agent-docs
description: Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md.
---

# Agent Docs

Reference for writing any document an agent reads: a skill, an `AGENTS.md` or `CLAUDE.md`, a doc reached by a pointer. The aim is the same for each: the agent takes the same process every run.

## Pointers

A **pointer** is an always-loaded line that names material outside the context and says when to reach it: a skill's description, or a `CLAUDE.md` line naming a doc. Its wording decides how reliably the agent reaches the material. When a must-have target is missed, sharpen the pointer first, and inline the material only if that fails.

- **Say what the material is and list its branches**, the distinct cases that should trigger reaching it.
- **One trigger per branch.** Synonyms for one branch are that branch written twice.

## Pruning

- **No-ops.** An instruction the model already follows by default pays its load to say nothing. The test is whether it changes behaviour against the default, settled by running the document. Delete the whole sentence. A phrase too weak to beat the default (_be thorough_) is a no-op too: name the specific behaviour instead.
- **The environment is a source**: build scripts, config files, the directory layout, `--help` output. Write down what the agent can't find by looking: the unwritten convention, the reason behind a choice, the gotcha no config admits. Restate the environment only when the lookup is expensive.
- **Enforced rules.** A rule a hook, linter or check already enforces needs at most the line that says how to resolve its failure.
- **State the positive.** A prohibition puts the banned behaviour in context. Write the target ("write one-line comments"). Keep a prohibition only as a hard guardrail, paired with the positive target.

## Completion criteria

Every step ends on the condition that tells the agent the step is done.

- **Checkable.** A vague bound ("understanding reached") invites stopping early, since the later steps pull attention forward.
- **Exhaustive.** "Every modified model accounted for" forces the digging that "produce a change list" doesn't. It binds flat reference too: "every rule applied".

## Skill layout

Every skill uses one skeleton:

- **Title**: `# <Name>`, the skill's name in title case.
- **Intro**: one to three sentences on what the skill produces and when to skip it.
- **`## Steps`**: one numbered list, each item `1. **Verb.** text`, with no blank lines between items. Sub-cases are bullets under their step. A step whose detail runs past a short paragraph keeps only the action and names the reference section that holds the rest.
- **Reference sections**: `##` headings named for their subject, holding bullets (`- **Term.** text`), a table or a template. Reference only some branches reach goes in a separate file behind a pointer.
- **`## Done when`**: the last section, whenever the skill has a completion criterion.
- **Questions**: every question to the user is a _choice_ or a _review_, and the step that asks names which, linking [`references/asking.md`](../../references/asking.md).

## Invocation

- **User-invoked** is the default: set `disable-model-invocation: true`, and write the `description` as a one-line summary for the human, with no trigger list. It costs no context, and only the human typing its name can reach it.
- **Model-invoked** only when the agent must reach the skill on its own, or another skill must. Omit `disable-model-invocation`, and write the description as a pointer. It stays loaded on every turn.
- **Shared reference** that two user-invoked skills both need goes in a plain file both point at, since neither can invoke the other.
