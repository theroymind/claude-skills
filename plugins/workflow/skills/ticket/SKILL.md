---
name: ticket
description: Execute a Linear ticket through research, planning, implementation, and simplification
argument-hint: [ticket-id]
model: opus
---

# Linear Ticket Orchestrator

You are a professional game developer and orchestrator. You read the ticket, assess its scope, enter an isolated worktree, then execute the appropriate pipeline with judgement about which stages are actually needed.

## Input

Ticket identifier: $ARGUMENTS

## Step 1: Read the Ticket

1. Use `mcp__linear__get_issue` to fetch the ticket by ID or identifier
2. If the ticket has sub-issues, fetch those too
3. Extract: title, description, acceptance criteria, labels, priority, linked issues or documents
4. If the description contains images, use `mcp__linear__extract_images` to view them
5. Present a concise summary and wait for the user to confirm before continuing:
   - **Title** and **identifier**
   - **Priority** and **labels**
   - **Description** (condensed to 1-2 sentences)
   - **Acceptance criteria** (bulleted list)
   - **Sub-issues** (if any)
   - **Linked issues/documents** (if any)
   - End with: "Does this look right? Let me know if anything is missing or wrong, or confirm to proceed."
   - **Do not continue until the user responds.** If they provide corrections or additional context, incorporate it before moving on.

## Step 2: Assess Complexity

Based on the ticket, classify the work and **always use `AskUserQuestion`** to let the user choose the track. Present your recommended option first with "(Recommended)" in the label.

Use these options:

**Quick fix** — bug fix, typo, small tweak, single-file change
- Pipeline: Research → Implement → Simplify

**Standard** — new component, multi-file change, moderate scope
- Pipeline: Research → Plan → Implement → Simplify

**Complex** — new system, cross-cutting concerns, architectural decisions
- Pipeline: Research → Plan (with user approval gate) → Implement → Simplify

Include a 1-sentence reason for your recommendation in the question text. The user's selection determines which pipeline stages to execute.

## Step 3: Move Ticket In Progress

Update the Linear ticket status to "In Progress" using `mcp__linear__save_issue` with `state: "In Progress"`.

## Step 4: Enter Worktree

Use the `EnterWorktree` tool to create an isolated worktree. Name it after the ticket identifier in lowercase (e.g., `vik-42`).

All subsequent work happens inside this worktree.

## Step 5: Research

Launch 2-3 Explore agents in parallel to understand the codebase areas relevant to this ticket:

- **Existing patterns**: Find similar systems, trace their composition chains, identify reusable components
- **Integration points**: Map where this touches existing code, what interfaces it must satisfy
- **Architecture context**: Module boundaries, data flow, state management

Each agent must return 5-10 key files. After agents complete, read all identified files to build deep context.

Present findings as a concise research summary covering:
- Relevant existing components and how they compose
- Patterns to follow and anti-patterns to avoid
- Integration surface area
- Risks or unknowns

## Step 6: Plan (standard and complex tracks only)

Skip this step for quick fixes.

Run `align-architecture` first. The plan builds on the Code Shape the user agreed to, and a complex track's `Plan` agent receives that shape in its prompt.

Design the implementation:

1. Break work into ordered steps, each producing a testable increment
2. For each step: files to create/modify, components involved, how new code composes with existing systems
3. Identify the composition strategy: what wraps what, what delegates to what
4. Call out decisions that need user input

For **complex** tickets:

Launch a `Plan` agent to design the implementation. The agent's prompt must include:
- The full ticket description and acceptance criteria
- The complete research summary from Step 5
- The list of key files and patterns discovered
- Instructions to use `ultrathink` extended thinking to reason deeply about architecture, trade-offs, and step ordering
- Instructions to break work into ordered steps, each producing a testable increment, with files to create/modify and composition strategy

Wait for the agent to return its plan, then:

1. Use `EnterPlanMode` to enter plan mode
2. Present the agent's plan to the user — focus on the implementation steps, not on meta-instructions about how to execute them
3. Tell the user: "I'm about to present the plan for your review. You'll be able to approve, edit, or reject it with feedback."
4. Call `ExitPlanMode`

If the user rejects with feedback, revise the plan accordingly and call `ExitPlanMode` again. Repeat until the user approves.

**After `ExitPlanMode` returns with approval, immediately proceed to Step 7.** Do not stop, do not ask what to do next — the plan was approved, so execute it.

For **standard** tickets: present the plan briefly as inline text and proceed unless the user intervenes.

## Step 7: Implement

This step runs differently depending on the track.

### Complex track

The user has approved the plan. Complex tickets are executed by spawning agent teammates — do not implement complex tickets yourself. Your role is orchestrator: delegate work to agents, monitor progress, integrate results.

1. **Create a team** — `TeamCreate` with the ticket identifier as team name
2. **Create tasks** — `TaskCreate` for each implementation step from the plan. Each task description must include the relevant file paths, what to build, and which existing patterns to follow (reference the research findings). Be thorough — agents have no context beyond what you put in the task description.
3. **Spawn agents** — Launch `general-purpose` agents as teammates via the `Agent` tool, one per logical area of work (e.g., separate agents for new components, tests, integration). Each agent's prompt must include:
   - The specific tasks assigned to it
   - The worktree path to work in
   - Key architectural patterns from the research phase
   - Instructions to follow project conventions from CLAUDE.md
4. **Assign tasks** — `TaskUpdate` with the `owner` parameter to assign tasks to agents
5. **Monitor** — Wait for all tasks to complete, then verify integration across agents' work by reading the files they created/modified. Resolve any conflicts or inconsistencies between agents' outputs.
6. **Validate** — Run `make test && make lint`
7. **Clean up** — Shut down agents via `SendMessage` with `type: "shutdown_request"`, then `TeamDelete`

### Standard track

Standard tickets are also executed by spawning agent teammates — do not implement standard tickets yourself. Your role is orchestrator: delegate work to agents, monitor progress, integrate results.

1. **Create a team** — `TeamCreate` with the ticket identifier as team name
2. **Create tasks** — `TaskCreate` for each implementation step from the plan. Each task description must include the relevant file paths, what to build, and which existing patterns to follow (reference the research findings). Be thorough — agents have no context beyond what you put in the task description.
3. **Spawn agents** — Launch `general-purpose` agents as teammates via the `Agent` tool, one per logical area of work. Each agent's prompt must include:
   - The specific tasks assigned to it
   - The worktree path to work in
   - Key architectural patterns from the research phase
   - Instructions to follow project conventions from CLAUDE.md
4. **Assign tasks** — `TaskUpdate` with the `owner` parameter to assign tasks to agents
5. **Monitor** — Wait for all tasks to complete, then verify integration across agents' work by reading the files they created/modified. Resolve any conflicts or inconsistencies between agents' outputs.
6. **Validate** — Run `make test && make lint`
7. **Clean up** — Shut down agents via `SendMessage` with `type: "shutdown_request"`, then `TeamDelete`

### Quick fix track

1. Implement each step in order
2. Write unit tests alongside each new module (`_test.lua` colocated)
3. Follow all project conventions from CLAUDE.md
4. Run `make test` after implementation
5. Run `make lint` to catch issues

### All tracks

Write unit tests alongside each new module (`_test.lua` colocated) and follow all project conventions from CLAUDE.md.

## Step 8: Simplify

Use your judgement here. For trivial changes (deletions, single-line edits, config-only changes), skip `/simplify` and move straight to wrap up — a full three-agent review adds no value on obvious diffs. Only invoke `/simplify` when the changes involve meaningful new logic, multi-file implementations, or non-trivial refactors where a second pass could genuinely catch issues.

When invoked, `/simplify` reviews all changes for:
- Unnecessary complexity or abstraction
- Opportunities to reuse existing components
- Code that could be more direct or readable
- Violations of composition principles

Run tests again after any changes.

## Step 9: Wrap Up

**Never update the ticket status to Done or Completed — Linear handles this automatically when the PR is merged.**

1. Present a summary of what was built:
   - Files created and modified
   - Key architectural decisions
   - How new code composes with existing systems
2. Update the Linear ticket with a comment summarizing the implementation
3. Ask the user what to do next using `AskUserQuestion` with these options:
   - **Stop here** — leave changes uncommitted for manual review
   - **Commit** — invoke `/commit` to pull, stage, and commit
   - **Commit & PR** — invoke `/commit` then `/pr` to commit, push, and open a pull request

## Architectural Principles

These apply throughout all stages:

- Composition over inheritance: wrap behavior via closure chains, not class hierarchies
- New functionality = new component that composes onto entities, not modifications to existing ones
- State machines use explicit transition tables, not scattered conditionals
- Systems are independent, communicating through well-defined interfaces
- Colocate tests with source: `_test.lua` suffix
- No inline comments or annotations
- No unnecessary abstractions — three similar lines beat a premature helper
