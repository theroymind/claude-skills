set -e
mkdir -p src/reports tasks
cat > package.json <<'J'
{ "name": "reports-app", "type": "module", "scripts": { "test": "node --test", "build": "node --check src/reports/query.js" } }
J
cat > src/reports/query.js <<'J'
export function queryReport(rows, filters) {
  return rows.filter((row) => Object.entries(filters).every(([key, value]) => row[key] === value));
}
J
cat > src/reports/page.js <<'J'
import { queryReport } from './query.js';
export function renderReportTable(rows, filters) {
  return queryReport(rows, filters).map((row) => `<tr><td>${row.region}</td><td>${row.revenue}</td></tr>`).join('');
}
J
cat > SPEC.md <<'J'
# Spec: CSV export for reports

## Objective
Account admins export the report they are looking at to CSV, to hand data to finance each month.

## Success Criteria
- [ ] The CSV holds exactly the rows the on-screen filters show, across all pages, in the same order.
- [ ] Columns and headers match the on-screen table.
- [ ] Cells starting with `=`, `+`, `-` or `@` are escaped so spreadsheets don't run them.
- [ ] Only account admins can export, enforced on the server.

## Out of Scope
- Scheduled or emailed exports.
- Formats other than CSV.

## Constraints
- The export and the table use the same query code, so they cannot drift.

## Open Questions
- None blocking.
J
cat > tasks/plan.md <<'J'
# Implementation Plan: CSV export

## Code Shape

### Modules
| Module | Depends on | Owns |
|---|---|---|
| `reports/query` | — | `queryReport(rows, filters)`, shared by table and export |
| `reports/export` | reports/query | `toCsv(rows, columns)`, cell escaping |
| `reports/routes` | reports/export, auth | `GET /reports/export.csv`, admin check |
| `reports/page` | reports/query | table rendering, Export button |

### Decisions
- Export reuses `queryReport` · rejected: a separate export query · decided by user
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm init
