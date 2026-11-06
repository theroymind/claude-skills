#!/usr/bin/env bash
set -euo pipefail

plugin_dir="$(cd "$(dirname "$0")/.." && pwd)"
node_link="$(command -v node)"
node_binary="$(realpath "$node_link")"
node_dir="$(dirname "$node_binary")"
export PATH="$node_dir:$PATH"

cd "$plugin_dir"
exec claude plugin eval . --judge-model sonnet --scaffold --allow-tools Bash --no-publish --trust-plugin "$@"
