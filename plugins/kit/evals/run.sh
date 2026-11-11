#!/usr/bin/env bash
set -euo pipefail

# A full run is every case, three runs each, with and without the plugin. While iterating, narrow it:
#   evals/run.sh --ablation none --case 'review-*' --runs 1 --max-cost-usd 5

plugin_dir="$(cd "$(dirname "$0")/.." && pwd)"
node_link="$(command -v node)"
node_binary="$(realpath "$node_link")"
node_dir="$(dirname "$node_binary")"
git_binary="$(xcrun -f git 2>/dev/null || command -v git)"
git_dir="$(dirname "$git_binary")"
export PATH="$node_dir:$git_dir:$PATH"

cd "$plugin_dir"
exec claude plugin eval . --judge-model sonnet --scaffold --allow-tools Bash Write Edit --no-publish --trust-plugin "$@"
