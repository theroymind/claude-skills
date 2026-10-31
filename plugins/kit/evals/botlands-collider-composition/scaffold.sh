set -e
A="${BOTLANDS_ARCHIVE:-/Users/ericroy/Development/claude-skills/plugins/kit/evals/fixtures/botlands}"
git -C "$A" archive 595fd777^ | tar x
rm -rf web-debug assets/sprites
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "before"
