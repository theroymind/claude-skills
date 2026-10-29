set -e
mkdir -p src tasks test
cat > package.json <<'J'
{ "name": "slugs", "type": "module", "scripts": { "test": "node --test" } }
J
cat > src/slugify.js <<'J'
export function slugify(text) {
  return text.toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
}
J
cat > test/slugify.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { slugify } from '../src/slugify.js';

test('lowercases and joins words with dashes', () => {
  assert.equal(slugify('Hello World'), 'hello-world');
});
J
cat > CLAUDE.md <<'J'
# slugs

A tiny slug library. The task list is `tasks/todo.md`; the plan is `tasks/plan.md`.

## Commands

Run `node --test` before reporting any task done. Git is unavailable here: leave changes uncommitted.
J
cat > tasks/plan.md <<'J'
# Implementation Plan: slug options

## Code Shape
- `slugify(text, options?)` with `options: { maxLength?: int }`. Truncation never leaves a trailing dash and never cuts mid-word when a dash exists before the limit.
J
cat > tasks/todo.md <<'J'
# Tasks

## Task 1: maxLength option for slugify

**Acceptance criteria:**
- [ ] `slugify(text, { maxLength })` returns at most `maxLength` characters.
- [ ] The result never ends with a dash.
- [ ] It cuts at the last dash before the limit when one exists.

**Verification:**
- [ ] Tests pass: `node --test`

## Task 2: custom separator option
- [ ] `slugify(text, { separator: '_' })` joins words with the separator.
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm init
