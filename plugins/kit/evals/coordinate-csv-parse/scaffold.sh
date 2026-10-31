set -e
mkdir -p src tasks test
cat > package.json <<'J'
{ "name": "tinycsv", "type": "module", "scripts": { "test": "node --test" } }
J
cat > src/parse.js <<'J'
export function parse(text) {
  if (text === '') return [];
  return text.split('\n').map((line) => line.split(','));
}
J
cat > test/parse.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { parse } from '../src/parse.js';

test('splits unquoted rows and fields', () => {
  assert.deepEqual(parse('a,b\nc,d'), [['a', 'b'], ['c', 'd']]);
});
J
cat > CLAUDE.md <<'J'
# tinycsv

A tiny CSV library. The task list is `tasks/todo.md`; the plan is `tasks/plan.md`.

## Commands

Run `node --test` before reporting any task done. Git is unavailable here: leave changes uncommitted.
J
cat > tasks/plan.md <<'J'
# Implementation Plan: RFC 4180 parsing

## Code Shape
- `parse(text: string): string[][]` in `src/parse.js`, a single pass over the input with explicit states (field start, unquoted field, quoted field, quote seen inside quoted field). No regex-based splitting: quoted fields can contain the delimiters.
- Errors are thrown as `Error` with a message; no custom error class.
- Task 2 adds `stringify(rows)` next to it, as the inverse. Nothing of it belongs in Task 1.
J
cat > tasks/todo.md <<'J'
# Tasks

## Task 1: RFC 4180 `parse`

Replace the naive splitter in `src/parse.js` with a real RFC 4180 parser.

**Acceptance criteria:**
- [ ] A quoted field may contain commas and newlines; both are kept verbatim in the field's value.
- [ ] Inside a quoted field, `""` is one literal `"`; the surrounding quotes are not part of the value.
- [ ] A `"` inside an unquoted field is a literal character.
- [ ] Records are separated by `\n` or `\r\n`; neither appears in a field value unless quoted.
- [ ] A trailing newline at the end of the input does not produce an extra record. An empty input gives `[]`.
- [ ] A blank line between records is one record with one empty field.
- [ ] Empty fields are kept: `a,,b` is three fields and `a,` is two.
- [ ] A quoted field that is never closed throws an `Error` whose message contains `unterminated`.
- [ ] Text after a closing quote in the same field (like `"a"b`) throws an `Error` whose message contains `unexpected`.

**Verification:**
- [ ] Tests pass: `node --test`

## Task 2: `stringify(rows)`
- [ ] `stringify([['a', 'b']])` returns `a,b\n`, quoting fields that need it.
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm init
