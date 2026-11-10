---
name: retro
description: Conduct a retrospective on a coding session
disable-model-invocation: true
---

# Retro

Suggest improvements to the coding agent's **environment** that would make future runs go better.

## Steps

1. **Load the style guide** by calling the Skill tool with `agent-docs`.
2. **Read** the primary sources for the session the user specifies. If the user doesn't specify a session, default to the current one. For past sessions, start with `sh ${CLAUDE_SKILL_DIR}/sessions.sh [count] [project directory]`. It prints each recent session's user messages, agent dispatches and tool-call counts. Open a full `.jsonl` log only for the parts the summary leaves unclear.
3. **Find candidates** for improvement in each of the Categories.
4. **Present** the candidates numbered in the chat, in order of severity, and end the turn asking which numbers to apply ([asking](../../references/asking.md)).

## Categories

- **Navigation**: how easy was it for the agent to find the right files? Are there hidden dependencies between files? Would a **navigation pointer** make it easier? _Use when_ the session took a long time to find a piece of information.
- **Automated checks**: are there automated checks that could catch errors the agent made? Linting, typing, tests, filesystem linters? Read the repo's own check command first (its `package.json`/build-tool `lint`/`check` scripts, its CI workflow), so a check that already exists but sits unwired or silently broken is the finding, not a reinvention. A repo with no **guardrail** (no pre-commit hook and no CI job running its lint/typecheck/test command) is itself a finding: an un-linted repo is a standing missed opportunity, not a neutral default. _Use when_ the agent made a mistake an automated check could have caught, or the repo has no guardrail at all.
- **Coding standards**: should a rule be added, removed or clarified? Classify the violation first: a **mechanical** one (a fixed syntactic pattern, a banned API, an import shape, a file-location rule) gets a deterministic check: a custom rule in the repo's own linter, a new pre-commit hook, or a new CI job, whichever the repo's language and existing guardrail make cheapest. Default to building the check over writing the rule. Write a rule only for a genuine **judgement call** (cross-file consistency, "matches the surrounding style"), in the package's `CLAUDE.md` or the review profile. _Use when_ the agent or a reviewer missed a mistake.
- **Root CLAUDE.md**: are there steering instructions that belong in a package `CLAUDE.md`, a rule file, the review profile or an automated check instead? _Use when_ the root `CLAUDE.md` is particularly large, in the repo or the user's global scope.
- **Tool economy**: did the agent make expensive tool calls that could be streamlined? Is there any custom tooling (CLI's, MCP's) that is particularly token-inefficient? _Use when_ the agent made an expensive tool call.
- **No-ops**: look for instructions in steering files that don't modify the agent's behavior. _Use when_ the steering files are large and unwieldy.
- **Information access**: look for opportunities to increase the agent's access to information. Teeing dev server logs, readonly access to third-party services. _Use when_ a crucial piece of information was not available to the agent.

## Files

- `CLAUDE.md`, root and per package: always loaded. The root names commands and architecture; a package doc holds the rules and gotchas a newcomer would break.
- `.claude/rules/`: language rules, loaded by path.
- `.claude/kit/review.md`: the review profile, read by `review`.
- Docs and skills: reference reached through a pointer. Look for existing ones before writing new ones, and follow `agent-docs`.
