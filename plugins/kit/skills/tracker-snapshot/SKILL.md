---
name: tracker-snapshot
description: Write a read-only snapshot of an outside issue tracker project to .tix/tracker.json, so the Herdr work-map panel can show it next to the local tix tickets. Use when the user asks to sync, snapshot or refresh the tracker, the project map or the work map, or runs /kit:tracker-snapshot with a project name, URL or issue id. With no arguments, it takes the project from the ticket key in the current branch name.
---

# Tracker snapshot

Write one JSON file that describes a tracker project: its issues, their parents, their dependencies and their merge requests. The Herdr `work-map` mod reads it and joins it to tix tickets by `external_id`. Read the tracker only. Never change anything in it.

## Run the sync script

The Herdr `work-map` mod ships a script that does this for Linear, at `~/.config/herdr-app/mods/work-map/bin/tracker-sync`. When that file exists, use it first. When it doesn't, skip to the steps by hand.

1. Find the tix root. It is the nearest folder above the current one that has `.tix/config.yml`.
2. Run the script from there:

   ```sh
   python3 -I ~/.config/herdr-app/mods/work-map/bin/tracker-sync --root <tix root>
   ```

   - If the user named a project id or project URL, add `--project <id or URL>`.
   - If the user named an issue, add `--issue <KEY>`.
   - If the user asked for a full or fresh sync, add `--full`.
   - With none of these, the script reuses the project in the existing `tracker.json`. If there is none, it takes the issue key from the branch name.
3. Read the exit code.
   - **0**: it worked. It prints a line like `synced 48 items (3 changed)`. Tell the user that line and which project it used. Then stop.
   - **2**: no Linear API key is stored. Tell the user they can store one with `security add-generic-password -s linear-api-key -a "$USER" -w`. Then make the snapshot by hand with the steps below.
   - **1**: the sync failed. Show the user the error line and stop. Don't fall back to the steps below, because the cause is something other than the missing key.

The script makes a full sync when you pass `--full`, when the file is older than 24 hours, or when it points at a different project. Otherwise it only asks for issues changed since the last sync.

## By hand, when there is no script or it exits 2

### Find the project

1. If the user named a project, a project URL, or an issue id, use that project.
2. Otherwise read the current branch with `git branch --show-current`. Branches are named after their ticket, like `ino-343-fix-login`. Take the first issue key in the name, uppercase it (`INO-343`) and look it up. If it exists, use the project it belongs to. The branch wins over tix tickets that point elsewhere, because it is what the user is working on now.
3. If the branch has no key, or the issue doesn't exist, run `tix ls --all --json` there and collect every `external_id`. Look those issues up and use the project they belong to. If they belong to several projects, ask which one.
4. If the issue found in step 2 or 3 has no project, snapshot that issue's tree instead. Walk up to its top parent, then take that parent and all its sub-issues. Use the top parent's id, title and URL as `project`.
5. If nothing above finds an issue, ask the user for a project, URL or issue id.

### Read the tracker

Use the issue tracker tools available in this session, such as the tracker's MCP server. Read:

- the project's name, id and URL
- every issue in the project, including sub-issues
- for each issue: id (the human key, like `ABC-123`), title, state, parent, assignee name and id, URL
- "blocks" or "blocked by" relations between issues
- linked merge or pull requests: their id, URL and state
- who the current user is: their id and name

If the tools can't return some field, leave it out. Don't guess it.

### Write the file

Write `<tix root>/.tix/tracker.json`, replacing any old one:

```json
{
  "schema_version": 1,
  "source": "linear",
  "synced_at": "2026-11-05T14:00:00Z",
  "project": { "id": "...", "name": "...", "url": "..." },
  "viewer": { "id": "...", "name": "..." },
  "items": [
    {
      "id": "ABC-123",
      "title": "...",
      "status": "in_progress",
      "parent": null,
      "assignee": "...",
      "assignee_id": "...",
      "url": "...",
      "depends_on": ["ABC-120"],
      "mrs": [{ "id": "!4512", "url": "...", "state": "open" }]
    }
  ]
}
```

- `source` is the tracker's name in lowercase.
- `synced_at` is the current UTC time.
- `viewer` is the current user. Leave it out if you can't find who that is. The script then makes a full sync next time.
- `status` is one of `open`, `in_progress`, `in_review`, `done`, `canceled`. Map the tracker's own state names onto these.
- `depends_on` lists the issues this one is blocked by.
- `parent` is the parent issue's id, or null.
- An MR's `state` is `open`, `merged` or `closed`.

Check the file parses with `python3 -m json.tool` before you finish. Then tell the user which project you used and how you found it (named, branch, or tix tickets). Say how many items you wrote and how many match a tix ticket's `external_id`.
