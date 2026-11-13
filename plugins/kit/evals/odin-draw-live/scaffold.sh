set -e
A="${ODIN_ARCHIVE:?run through evals/run.sh or set ODIN_ARCHIVE}"
git -C "$A" archive 4a27f9d23bf9c9f5a372ee99a9b643b156fc2d47 | tar x
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "snapshot"
