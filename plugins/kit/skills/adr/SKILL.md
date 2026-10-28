---
name: adr
description: Records an architecture decision (ADR) with its context, alternatives and consequences. Use when choosing a framework, dependency, data model, auth strategy, API style or infrastructure, or when making any decision that is expensive to reverse.
---

# Architecture Decision Records

An ADR records *why*: the context, constraints and rejected alternatives that the code can't show, so nobody has to make the same decision again later.

## Steps

1. **Find the convention.** Look for existing ADRs, project instructions and ADR tooling (an `.adr-dir` file, `adr-tools`, MADR). Match the existing location, file format (Markdown or reStructuredText), numbering sequence, filename pattern and section headings. If the evidence conflicts, raise the conflict instead of adding another scheme. Only when there is no convention, use `docs/decisions/NNNN-title.md` and the template below.
2. **Write it.** Ground every claim in the code or the conversation, and flag anything you can't back up.
3. **Supersede, never delete.** When a decision changes, write a new ADR that references the old one, and set the old one's status to `Superseded by ADR-NNNN`.

```markdown
# ADR-0001: <the decision, as a short imperative>

## Status
Proposed | Accepted | Superseded by ADR-NNNN | Deprecated

## Date
YYYY-MM-DD

## Context
<The problem, and the requirements and constraints that bind the choice.>

## Decision
<What we chose.>

## Alternatives Considered
### <Option>
- Pros: ...
- Cons: ...
- Rejected because <a reason tied to the context>

## Consequences
<What becomes easier, what becomes harder, and what is newly required.>
```

## Prose review

Edit the wording for the reader without changing the decision or its limits:

1. Mark what must survive the edit: names, numbers and units, commands, paths, links, conditions, trade-offs and stated uncertainty.
2. Replace stock introductions, promotional adjectives and repeated summaries with concrete information. Never replace an unsupported claim with an invented example or a stronger guarantee. Keep the project's own terms.
3. Compare the result with the original and its sources. Restore any lost qualifier, check that commands still work, and raise open factual questions instead of polishing them away.
