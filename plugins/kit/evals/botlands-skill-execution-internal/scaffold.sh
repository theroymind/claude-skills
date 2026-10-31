set -e
A="${BOTLANDS_ARCHIVE:-/Users/ericroy/Development/claude-skills/plugins/kit/evals/fixtures/botlands}"
git -C "$A" archive 86f679a1^ | tar x
rm -rf web-debug assets/sprites
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "before"
