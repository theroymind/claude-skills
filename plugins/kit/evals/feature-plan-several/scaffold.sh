#!/bin/sh
set -e
mkdir -p src docs/phases
cat > SPEC.md <<'MD'
# Spec: Motel tycoon prototype

## Objective
Players run a roadside motel: guests arrive, rent rooms and leave reviews.

## Success Criteria
- [x] Guests check in to a free room and pay the nightly price.
- [x] Rooms are stamped from a fixed motel prefab.

## Out of Scope
- Player-built rooms.
MD
cat > docs/phases/tier-1-motel.md <<'MD'
---
status: done
---
# Tier 1 motel
All tasks done.
MD
echo 'export const rooms = ["motel"];' > src/rooms.js
