# Review profile

A project's review profile tells `review` what the project adds to the four lenses: its own rules, where a pull request's context and ticket come from, and how findings get posted. It names the project's files, skills and commands and copies none of them, so each rule still has one home.

## Applying it

- **Lenses.** For each row whose pattern matches a changed file, read what it names and walk the change once more with those rules as an extra lens. A row naming a skill or agent runs it on the change and treats its findings as candidates. Every candidate goes through Verify like any other.
- **Exceptions win.** Where the profile says the project differs from a kit default, the project's rule holds.
- **Tests.** The profile's test conventions and coverage bar set what Tests sized to the risk asks for.
- **Context, Ticket, Posting.** Read by [pull requests](pull-request.md).
- **Missing targets.** A file, skill or command the profile names that does not exist gets one line in the report, and the review carries on without it.

Every section is optional. A profile with only Lenses is a complete profile.

## Template

```markdown
# Review profile

## Context

The command or skill that loads a pull request's context, and what it returns.

## Ticket

Where tickets live, and how to fetch one by its id.

## Lenses

| Applies to | Read | Notes |
|---|---|---|
| `**/*.rb` | `.agents/rules/backend/global.md` | |
| `app/javascript/**` | the `standards-reviewer` agent | Pass it the base sha. |

## Tests

How specs are run, and the coverage bar a change is held to.

## Exceptions

Where this project departs from a kit default.

## Posting

The skill or command that posts chosen findings to the forge, and its limits.
```
