#!/bin/sh
set -eu

if [ $# -lt 1 ]; then
	echo "usage: await.sh <report file>..." >&2
	echo "  returns once every report file exists and is not empty" >&2
	exit 2
fi

POLL_SECONDS=10

for report in "$@"; do
	until [ -s "$report" ]; do
		sleep "$POLL_SECONDS"
	done
done
