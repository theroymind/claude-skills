set -e
mkdir -p src test docs .claude/kit
cat > package.json <<'J'
{ "name": "crewsim", "type": "module", "scripts": { "test": "node --test" } }
J
cat > CLAUDE.md <<'J'
# crewsim

A hotel crew simulation. Modules: `board` owns jobs, `crew` owns crew members and their AI, `payroll` owns wages. Dependencies point `payroll → crew → board`. Run `node --test` before reporting.
J
cat > .claude/kit/review.md <<'J'
# Review profile

## Lenses

| Applies to | Read | Notes |
|---|---|---|
| `src/**` | `docs/money.md` | |
J
cat > docs/money.md <<'J'
# Money

Every amount of money is a whole number of cents, held in a JavaScript integer. A wage, bonus or total that can hold a fraction of a cent is a bug: round to whole cents with `Math.round` at the point the fraction appears, never later.
J
cat > src/payroll.js <<'J'
export function wages(crews) {
  let total = 0;
  for (const crew of crews) total += crew.wage * crew.hoursWorked;
  return total;
}
export function perMinute(wageCents) {
  return wageCents / 60;
}
J
cat > test/payroll.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { wages } from '../src/payroll.js';

test('wages sums wage times hours in cents', () => {
  assert.equal(wages([{ wage: 1500, hoursWorked: 2 }, { wage: 1000, hoursWorked: 1 }]), 4000);
});
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "base"
cat > src/bonus.js <<'J'
export const BONUS_RATE = 0.15;
export function bonus(crew) {
  return crew.wage * crew.hoursWorked * BONUS_RATE;
}
J
cat > src/payroll.js <<'J'
import { bonus } from './bonus.js';

export function wages(crews) {
  let total = 0;
  for (const crew of crews) total += crew.wage * crew.hoursWorked + bonus(crew);
  return total;
}
export function perMinute(wageCents) {
  return wageCents / 60;
}
J
cat > test/payroll.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { wages } from '../src/payroll.js';

test('wages adds a 15% bonus in cents', () => {
  assert.equal(wages([{ wage: 1000, hoursWorked: 2 }]), 2300);
});
J
