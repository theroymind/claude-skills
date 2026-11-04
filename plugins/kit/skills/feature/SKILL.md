---
name: feature
description: Plans, starts or resumes feature work by finding where it stands and entering the right pipeline skill. Use when the user asks to plan, scope or build one or more features, even when the project already has a spec.
argument-hint: [feature or ask]
---

# Feature

The entry point for building a feature. Each stage hands off to the next, so this skill only picks where to enter.

## Steps

1. **Read the state.** The ask (`$ARGUMENTS` or the conversation), then the intent statements, ideas, specs, the `## Code Shape` in the plan, and the open tasks, each from its location ([artifacts](../../references/artifacts.md)). When `CLAUDE.md` names a tracker command (such as `tix ready` and `tix show`), read tasks through it rather than by opening files; otherwise read the task list file. When `CLAUDE.md` names a warm-up command and the ask names a task, run it for that task and read the pack before anything else: its cards and diffs say where the work stands.
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
