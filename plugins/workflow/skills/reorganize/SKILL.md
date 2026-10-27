---
name: reorganize
description: Reorganize project files and directories into logical groupings. Use this skill whenever the user wants to restructure, reorganize, rearrange, or refactor the file/directory layout of a project or part of a project. Trigger on phrases like "reorganize files", "restructure the project", "clean up the directory structure", "group files by module", "move files into folders", "refactor project layout", or any request about changing how files and folders are organized. Also trigger when the user says things like "this folder is a mess", "these files should be grouped differently", or "split this directory up".
---

# Reorganize

A skill for restructuring project files and directories into clean, logical groupings while preserving git history and updating all references.

## Overview

Reorganizing a codebase is deceptively tricky. Moving files is easy — the hard part is doing it without breaking anything. This skill handles the full pipeline: understanding the current layout, proposing a better one, getting approval, executing moves with git history preserved, and updating every import/require across the codebase.

## Step 1: Gather Context

Before proposing anything, understand what you're working with.

### Detect the environment

- **Language/framework**: Scan for package.json, Cargo.toml, go.mod, setup.py, .luarc.json, etc. This determines import syntax, conventions, and what "idiomatic structure" means.
- **Current structure**: Map the existing directory tree. Note patterns — are things already partially organized? Is there a convention that's been followed inconsistently?
- **Import style**: Sample a few files to understand how imports work (relative vs absolute, path aliases, require paths, etc.).

### Ask the user (if not already specified)

Ask these questions conversationally, not as a checklist. Skip any that the user already answered.

1. **Scope**: "Should I reorganize the entire project, or focus on a specific directory?"
2. **Organization strategy**: Present options based on what makes sense for the project:
   - **Module-based**: Group by feature/domain (e.g., `auth/`, `payments/`, `inventory/`). Each module contains its own components, utils, tests, etc. Best for larger projects with distinct domains.
   - **Type-based**: Group by file role (e.g., `components/`, `services/`, `utils/`, `models/`). Best for smaller projects or when features share lots of code.
   - **Hybrid**: Top-level split by type, with module subdirectories inside (e.g., `components/auth/`, `components/payments/`). Good middle ground.
   - **Custom**: The user describes what they want.
3. **Test files**: "Do you want test files alongside the source files they test (e.g., `foo.lua` and `foo_test.lua` in the same directory), or collected in a separate test directory (e.g., `tests/`)?"
4. **Barrel/index files**: Based on the language, recommend whether to create barrel files (index.ts, init.lua, __init__.py, mod.rs) for cleaner imports from reorganized directories. Ask if the user wants them.

## Step 2: Propose the New Structure

Present a clear tree diagram showing the proposed directory layout. Use the format:

```
src/
├── auth/
│   ├── login.ts
│   ├── login.test.ts
│   ├── register.ts
│   ├── register.test.ts
│   └── index.ts
├── payments/
│   ├── checkout.ts
│   ├── checkout.test.ts
│   ├── refund.ts
│   └── index.ts
└── shared/
    ├── utils/
    └── types/
```

Include annotations for non-obvious decisions — why a file ended up where it did, especially if it could reasonably live in multiple places.

If any files don't fit cleanly into the new structure, call them out explicitly and ask the user where they should go.

**Wait for explicit confirmation before proceeding.** The user must approve the plan. If they suggest changes, update the tree and re-present.

## Step 3: Execute the Moves

Use `git mv` for all file moves. This preserves git history, which matters — losing blame history on important files is a real cost.

Execute moves in a logical order:
1. Create new directories first
2. Move files using `git mv`
3. Remove empty directories left behind

If the project is not a git repository, use regular filesystem moves instead and note that history won't be preserved.

### Batch moves efficiently

Group moves by source directory and execute them in batches rather than one at a time. For large reorganizations, this can be dozens or hundreds of moves — don't make the user watch each one individually.

## Step 4: Update All References

This is the critical step. After moving files, every import/require that referenced the old path must be updated.

### Spawn Haiku agents for import updates

For each moved file, spawn a Haiku agent (use `model: "haiku"`) to:
1. Search the codebase for all references to the old path
2. Update each reference to the new path
3. Report what it changed

Spawn agents in parallel — one per moved file or one per small batch of related files. Each agent should:
- Use Grep to find all occurrences of the old module/file path
- Use Edit to update each occurrence to the new path
- Account for different import styles (with/without extension, relative vs absolute, path aliases)

**Language-specific import patterns to handle:**

| Language | Pattern | Example |
|----------|---------|---------|
| JavaScript/TypeScript | `import ... from "path"`, `require("path")` | `import { foo } from "../old/path"` → `"../new/path"` |
| Lua | `require("dot.separated.path")` | `require("src.old.module")` → `require("src.new.module")` |
| Python | `from package.module import ...`, `import package.module` | `from old.package import foo` → `from new.package import foo` |
| Go | `import "module/old/path"` | Update go module paths |
| Rust | `mod`, `use crate::` | `use crate::old::module` → `use crate::new::module` |

### Update non-code references too

Don't forget:
- Config files (tsconfig paths, webpack aliases, Makefile paths, .luarc.json)
- CI/CD pipelines (.github/workflows, Jenkinsfile)
- Documentation that references file paths
- Build scripts, Dockerfiles
- Package.json "main", "exports", "files" fields

## Step 5: Verify

After all moves and updates are complete:

1. **Run the project's test suite** if one exists (check for `make test`, `npm test`, `cargo test`, `busted`, etc.)
2. **Run the linter** if configured
3. **Check for broken references**: Do a final grep for any remaining references to old paths
4. Report results to the user

If tests or linting fail, diagnose and fix the issues before declaring success.

## Edge Cases

- **Circular dependencies**: If reorganizing reveals circular imports, flag them to the user rather than silently working around them.
- **Generated files**: Don't move files that are auto-generated (check for "DO NOT EDIT", "generated by", etc.). Flag them and ask.
- **Symlinks**: Preserve symlinks and update their targets if needed.
- **Large monorepos**: For very large projects, suggest reorganizing one module/package at a time rather than everything at once.
- **Files referenced by name in strings**: Some frameworks reference files by convention (e.g., Rails looks for `app/models/user.rb`). Flag framework-specific constraints before proposing moves that would break them.
