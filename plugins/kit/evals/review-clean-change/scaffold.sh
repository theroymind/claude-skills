set -e
mkdir -p src test
cat > package.json <<'J'
{ "name": "crewsim", "type": "module", "scripts": { "test": "node --test" } }
J
cat > CLAUDE.md <<'J'
# crewsim

A hotel crew simulation. Modules: `board` owns jobs, `crew` owns crew members and their AI, `payroll` owns wages. Dependencies point `payroll → crew → board`. Run `node --test` before reporting.
J
cat > src/board.js <<'J'
export class Board {
  constructor() { this._jobs = []; this._nextId = 1; }
  post(kind, room) { const job = { id: this._nextId++, kind, room, claimedBy: null }; this._jobs.push(job); return job; }
  claim(jobId, crewId) { const job = this._jobs.find((j) => j.id === jobId); if (job) job.claimedBy = crewId; return job; }
  complete(jobId) { this._jobs = this._jobs.filter((j) => j.id !== jobId); }
  count() { return this._jobs.length; }
}
J
cat > src/crew.js <<'J'
export class Crew {
  constructor(id, wage) { this.id = id; this.wage = wage; this.jobId = null; this.hoursWorked = 0; }
}
export function tick(crews, board) {
  for (const crew of crews) {
    if (crew.jobId !== null) { crew.hoursWorked += 1; continue; }
  }
}
J
cat > src/payroll.js <<'J'
export function wages(crews) {
  let total = 0;
  for (const crew of crews) total += crew.wage * crew.hoursWorked;
  return total;
}
J
cat > test/crew.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { Board } from '../src/board.js';
import { Crew, tick } from '../src/crew.js';

test('a busy crew member accrues hours', () => {
  const board = new Board();
  const c = new Crew(1, 10); c.jobId = 7;
  tick([c], board);
  assert.equal(c.hoursWorked, 1);
});
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "base"
cat > src/board.js <<'J'
export class Board {
  constructor() { this._jobs = []; this._nextId = 1; }
  post(kind, room) { const job = { id: this._nextId++, kind, room, claimedBy: null }; this._jobs.push(job); return job; }
  claim(jobId, crewId) { const job = this._jobs.find((j) => j.id === jobId); if (job) job.claimedBy = crewId; return job; }
  complete(jobId) { this._jobs = this._jobs.filter((j) => j.id !== jobId); }
  count() { return this._jobs.length; }
  nextOpen() { return this._jobs.find((j) => j.claimedBy === null) ?? null; }
}
J
cat > src/crew.js <<'J'
export class Crew {
  constructor(id, wage) { this.id = id; this.wage = wage; this.jobId = null; this.hoursWorked = 0; }
}
export function tick(crews, board) {
  for (const crew of crews) {
    if (crew.jobId !== null) { crew.hoursWorked += 1; continue; }
    const open = board.nextOpen();
    if (open) { board.claim(open.id, crew.id); crew.jobId = open.id; }
  }
}
J
cat > test/board.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { Board } from '../src/board.js';
import { Crew, tick } from '../src/crew.js';

test('nextOpen returns the first unclaimed job', () => {
  const board = new Board();
  const a = board.post('clean', 1); board.claim(a.id, 9);
  const b = board.post('clean', 2);
  assert.equal(board.nextOpen(), b);
});
test('an idle crew member claims the next open job', () => {
  const board = new Board(); const job = board.post('clean', 1);
  const c = new Crew(1, 10);
  tick([c], board);
  assert.equal(c.jobId, job.id); assert.equal(job.claimedBy, 1);
});
J
