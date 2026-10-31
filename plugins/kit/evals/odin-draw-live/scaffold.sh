set -e
git -C /Users/ericroy/Development/odin-proto archive HEAD | tar x
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "snapshot"
