set -e
mkdir -p src scripts .claude/skills .github/workflows
cat > package.json <<'J'
{
  "name": "tidepool",
  "version": "1.4.2",
  "type": "module",
  "scripts": {
    "test": "node --test",
    "lint": "eslint src",
    "build": "node scripts/build.js",
    "release": "sh scripts/release.sh"
  }
}
J
cat > CLAUDE.md <<'J'
# tidepool

A small CLI that syncs tide tables to a local cache. Source in `src/`, scripts in `scripts/`. Run `npm test` before reporting.
J
cat > scripts/release.sh <<'J'
#!/bin/sh
# Usage: npm run release -- <patch|minor|major>
set -e
npm run lint
npm test
npm run build
npm version "$1" -m "Release %s"
git push origin main --follow-tags
J
cat > scripts/build.js <<'J'
import { cpSync } from "node:fs";
cpSync("src", "dist", { recursive: true });
J
cat > src/index.js <<'J'
export function nextTide(table, now) { return table.find((t) => t.at > now) ?? null; }
J
cat > CHANGELOG.md <<'J'
# Changelog

## Unreleased

- Cache tide tables for seven days instead of one.

## 1.4.2

- Fix the timezone of the first entry in a table.
J
cat > .github/workflows/publish.yml <<'J'
name: publish
on:
  push:
    tags: ["v*"]
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci && npm run build && npm publish
J
git init -q
git add -A
git -c user.name=eval -c user.email=eval@example.com commit -qm "Initial"
