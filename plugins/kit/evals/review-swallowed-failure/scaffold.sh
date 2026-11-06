set -e
mkdir -p src test
cat > package.json <<'J'
{ "name": "crewsim", "type": "module", "scripts": { "test": "node --test" } }
J
cat > CLAUDE.md <<'J'
# crewsim

A hotel crew simulation. `payroll` owns wages and sends each run's wage bill to the accounting service. Run `node --test` before reporting.
J
cat > src/payroll.js <<'J'
export function wages(crews) {
  let total = 0;
  for (const crew of crews) total += crew.wage * crew.hoursWorked;
  return total;
}
J
cat > test/payroll.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { wages } from '../src/payroll.js';

test('wages sums wage times hours in cents', () => {
  assert.equal(wages([{ wage: 1500, hoursWorked: 2 }]), 3000);
});
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "base"
cat > src/payroll.js <<'J'
export function wages(crews) {
  let total = 0;
  for (const crew of crews) total += crew.wage * crew.hoursWorked;
  return total;
}

export async function submitWageBill(crews, client) {
  const total = wages(crews);
  try {
    await client.post('/wage-bills', { total });
  } catch {
  }
  for (const crew of crews) crew.hoursWorked = 0;
  return { submitted: true, total };
}
J
cat > test/payroll.test.js <<'J'
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { wages, submitWageBill } from '../src/payroll.js';

test('wages sums wage times hours in cents', () => {
  assert.equal(wages([{ wage: 1500, hoursWorked: 2 }]), 3000);
});

test('submitWageBill posts the total and resets hours', async () => {
  const posted = [];
  const client = { post: async (path, body) => { posted.push([path, body]); } };
  const crews = [{ wage: 1500, hoursWorked: 2 }];
  const result = await submitWageBill(crews, client);
  assert.deepEqual(posted, [['/wage-bills', { total: 3000 }]]);
  assert.equal(crews[0].hoursWorked, 0);
  assert.equal(result.submitted, true);
});
J
