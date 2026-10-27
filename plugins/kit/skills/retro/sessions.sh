#!/bin/sh
set -eu

count="${1:-3}"
project_directory="${2:-$(pwd)}"
message_width="${MESSAGE_WIDTH:-400}"
log_directory="$HOME/.claude/projects/$(printf '%s' "$project_directory" | sed 's|[/.]|-|g')"

if [ ! -d "$log_directory" ]; then
	echo "No session logs at $log_directory" >&2
	exit 1
fi

ls -t "$log_directory"/*.jsonl | head -n "$count" | while read -r log; do
	echo "=== $(basename "$log" .jsonl)  $(date -r "$log" '+%Y-%m-%d %H:%M')"

	echo "--- user messages"
	jq -r --argjson width "$message_width" '
		select(.type == "user" and (.isMeta | not))
		| .message.content
		| if type == "string" then . else (map(select(.type == "text") | .text) | join(" ")) end
		| select(length > 0 and (startswith("<system-reminder") | not) and (startswith("<local-command") | not))
		| gsub("\\s+"; " ")
		| "- " + .[0:$width]
	' "$log"

	echo "--- dispatches"
	jq -r '
		select(.type == "assistant") | .message.content[]?
		| select(.type == "tool_use" and (.name == "Agent" or .name == "Workflow" or .name == "SendMessage"))
		| "- \(.name): \(.input.description // .input.to // "") [\(.input.subagent_type // "")] prompt \(.input.prompt // .input.message // "" | length) chars"
	' "$log"

	echo "--- tool calls"
	jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "tool_use") | .name' "$log" \
		| sort | uniq -c | sort -rn
	echo
done
