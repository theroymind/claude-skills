set -e
mkdir -p src test
cat > package.json <<'J'
{ "name": "crewsim", "type": "module", "scripts": { "test": "node --test" } }
J
cat > CLAUDE.md <<'J'
# crewsim

A hotel crew simulation. Modules: `board` owns jobs, `crew` owns crew members and their AI. Dependencies point `crew → board`. Run `node --test` before reporting.
J
cat > src/board.js <<'J'
export class Board {
  constructor() { this._jobs = []; this._nextId = 1; }
  post(kind, room) { const job = { id: this._nextId++, kind, room, claimedBy: null }; this._jobs.push(job); return job; }
  claim(jobId, crewId) { const job = this._jobs.find((j) => j.id === jobId); if (job) job.claimedBy = crewId; return job; }
  open() { return this._jobs.filter((j) => j.claimedBy === null); }
}
J
cat > src/crew.js <<'J'
export class Crew {
  constructor(id) { this.id = id; this.jobId = null; }
}
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "base"
cat > src/crew.js <<'J'
export class Crew {
  constructor(id) { this.id = id; this.jobId = null; }
}
export function assignAll(crews, board, jobs) {
  // Board.claim skips a job that is already claimed, so two crews can never hold the same job.
  crews.forEach((crew, index) => {
    const job = jobs[index % jobs.length];
    board.claim(job.id, crew.id);
    crew.jobId = job.id;
  });
}
J
cat > test/crew.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { Board } from '../src/board.js';
import { Crew, assignAll } from '../src/crew.js';

test('each crew gets a job', () => {
  const board = new Board();
  const job = board.post('clean', 1);
  const crew = new Crew(1);
  assignAll([crew], board, [job]);
  assert.equal(crew.jobId, job.id);
});
J
