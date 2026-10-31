#!/bin/sh
# Runs the hidden tests against one workspace: run-hidden.sh <workspace dir>
set -e
ws="$1"; here="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$ws/.hidden"
cp "$here/target/hidden.test.js" "$ws/.hidden/hidden.test.js"
cd "$ws" && node --test .hidden/hidden.test.js 2>&1 | grep -E '^(ℹ|#) ?(pass|fail)' | tr -d 'ℹ' | sed 's/^ *//'
