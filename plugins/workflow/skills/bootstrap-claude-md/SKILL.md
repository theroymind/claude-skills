---
name: bootstrap-claude-md
description: Write or update this repo's CLAUDE.md from the personal template
disable-model-invocation: true
---

# Bootstrap CLAUDE.md

There is no global `CLAUDE.md`. Each repo carries its own standards, so local sessions, subagents and cloud sessions all see the same rules. [`TEMPLATE.md`](TEMPLATE.md) is the single source for those standards.

1. Read `TEMPLATE.md` and the repo's existing `CLAUDE.md`, if there is one.
2. Fill each `<placeholder>` from the repo itself: the build manifest or Makefile for commands, existing code for style, and `git config init.defaultBranch` or the remote HEAD for the branch. Ask the user only for what the repo can't tell you, such as the architecture rules.
3. If `CLAUDE.md` already exists, merge the template into it. Keep every project-specific line. Where a project line and a template line say the same thing, keep the project's wording.
4. Make sure `.claude/settings.json` enables `workflow@theroymind` and lists the `theroymind` marketplace (`github` source, `theroymind/claude-skills`).
5. Show the user the diff.
