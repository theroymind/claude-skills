---
name: feature
description: Plans, starts or resumes feature work by finding where it stands and entering the right pipeline skill. Use when the user asks to plan, scope or build one or more features, even when the project already has a spec.
argument-hint: [feature or ask]
---

# Feature

The entry point for building a feature. Each stage hands off to the next, so this skill only picks where to enter.

## Steps

1. **Read the state.** The ask (`$ARGUMENTS` or the conversation), `docs/intent/`, `docs/ideas/`, `SPEC*.md`, `## Code Shape` in `tasks/plan.md`, and open tasks in `tasks/todo.md` or the project's tracker.
2. **Pick the stage** from the first row of Stages that matches.
3. **Enter it.** Say in one line which stage and why, then invoke that skill.

## Stages

| State | Start at |
|---|---|
| Quick fix: a few lines, nothing to decide | `build` |
| Open tasks for this work | `coordinate` |
| Code Shape recorded, no tasks | `breakdown` |
| Approved spec, no Code Shape | `architect` |
| Clear what to build, no spec | `spec` |
| Clear problem, approach still open | `refine` |
| No who, why or definition of done | `align` |
