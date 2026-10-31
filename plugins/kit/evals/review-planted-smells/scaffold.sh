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
cat > src/crew.js <<'J'
import { wages } from './payroll.js';

export class Crew {
  constructor(id, wage) { this.id = id; this.wage = wage; this.jobId = null; this.hoursWorked = 0; }
}
export function tick(crews, board) {
  for (const crew of crews) {
    if (crew.jobId !== null) { crew.hoursWorked += 1; continue; }
    const open = board._jobs.find((j) => j.claimedBy === null);
    if (open) assign(crew, open, board, false);
  }
}
export function assign(crew, job, board, urgent) {
  if (urgent) {
    board._jobs.sort((a, b) => (a.kind === 'leak' ? -1 : 1) - (b.kind === 'leak' ? -1 : 1));
    crew.jobId = board._jobs[0].id;
    board._jobs[0].claimedBy = crew.id;
  } else {
    board.claim(job.id, crew.id);
    crew.jobId = job.id;
  }
}
J
cat > src/payroll.js <<'J'
// Called once per tick for the whole hotel; a large hotel runs 5,000 crew.
export function wages(crews) {
  let total = 0;
  for (const crew of crews) total += crew.wage * crew.hoursWorked;
  return total;
}
export function wagesByJob(crews, jobs) {
  const out = {};
  for (const crew of crews) {
    const job = jobs.find((j) => j.id === crew.jobId);
    const kind = job ? job.kind : 'idle';
    out[kind] = (out[kind] ?? 0) + crew.wage * crew.hoursWorked;
  }
  return out;
}
J
