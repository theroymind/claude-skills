set -e
A="${BOTLANDS_ARCHIVE:?run through evals/run.sh or set BOTLANDS_ARCHIVE}"
git -C "$A" archive 86f679a1^ | tar x
rm -rf web-debug assets/sprites
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "before"
