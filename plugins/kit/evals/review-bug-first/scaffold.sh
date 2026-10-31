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
  // The n oldest open jobs, oldest first.
  oldestOpen(n) {
    const open = this._jobs.filter((j) => j.claimedBy === null);
    return open.slice(0, n - 1);
  }
}
J
cat > src/crew.js <<'J'
export class Crew {
  constructor(id, wage) { this.id = id; this.wage = wage; this.jobId = null; this.hoursWorked = 0; }
}
export function tick(crews, board, config = {}) {
  for (const crew of crews) {
    if (crew.jobId !== null) { crew.hoursWorked += 1; continue; }
    const batch = board.oldestOpen(config.batchSize ?? 3);
    const open = config.preferLeaks ? (batch.find((j) => j.kind === 'leak') ?? batch[0]) : batch[0];
    if (!open) continue;
    if (config.logClaims) console.log(`crew ${crew.id} claims job ${open.id}`);
    board.claim(open.id, crew.id);
    crew.jobId = open.id;
  }
}
J
cat > test/board.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { Board } from '../src/board.js';

test('oldestOpen skips claimed jobs', () => {
  const board = new Board();
  const a = board.post('clean', 1); board.claim(a.id, 9);
  const b = board.post('clean', 2); board.post('clean', 3);
  assert.equal(board.oldestOpen(2)[0], b);
});
J
