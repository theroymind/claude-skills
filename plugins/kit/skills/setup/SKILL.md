---
name: setup
description: Copies the kit's language rules into this project's .claude/rules, for the languages you choose.
disable-model-invocation: true
---

# Setup

Copies the kit's language rules into the project, so Claude Code loads each one whenever it reads or edits a file of that language. Each rule is `${CLAUDE_PLUGIN_ROOT}/rules/<extension>.md` and is scoped by its `paths` frontmatter. Run it again to add a language or to pick up a newer version of a rule.

## Steps

1. **List** the rules in `${CLAUDE_PLUGIN_ROOT}/rules/`, and for each one count the project's files with that extension (`git ls-files -- '*.<extension>'`).
2. **Ask** which languages to set up, as a choice ([asking](../../references/asking.md)), with `multiSelect` on: one option per rule, the ones the project already uses first and marked recommended.
3. **Copy** each chosen rule to `.claude/rules/kit/<extension>.md` in the project root. When a copy is already there and differs, show the diff and ask, as a choice, whether to replace it; an unchanged copy is left alone.
4. **Report** in one line per language what was added, replaced or left alone. Point out that project-specific exceptions belong in the project's `CLAUDE.md`, which the rules defer to, and that `.claude/rules/kit/` is ready to commit.

## Done when

Every chosen rule is in `.claude/rules/kit/`, matching the plugin's copy unless the user chose to keep their own.
