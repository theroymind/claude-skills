# coordinate-csv-parse

A harder `coordinate` case for comparing review policies. The task is an RFC 4180 CSV
parser: objectively specified, a state machine, and full of well-known slips (trailing
newline, CRLF, `""` escapes, text after a closing quote).

## Target

`target/parse.js` is the reference solution and `target/hidden.test.js` the acceptance
tests it is validated against (22 pass; the naive scaffold passes 8). The hidden tests are
never scaffolded into the workspace, so the agent cannot tune to them.

The harness has no command grader, so hidden tests run after the fact:

    claude plugin eval plugins/kit --case coordinate-csv-parse --keep-temp --json out.json ...
    ./run-hidden.sh <kept workspace dir>     # prints "pass N" / "fail N"

## Arms

Compare review policies by editing step 4 of `skills/coordinate/SKILL.md` in a worktree
per arm and running the same case against each:

- **none**: the diff read is the whole review; no `code-review` call.
- **conditional** (current): `code-review` at medium only for risky slices or diffs over ~300 lines.
- **always**: `code-review` at medium on every slice.

Compare hidden-test pass rate, cost and duration per arm. Five runs per arm only shows a
large gap; treat a one-run difference as noise.
