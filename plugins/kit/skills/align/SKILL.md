---
name: align
description: Interviews the user one question at a time, each with a best guess attached, until you can predict their answers. Use when you don't yet know what the user wants (an ask with no who, why or definition of done), when they say "interview me", "grill me" or "are we sure?", or when you catch yourself filling in ambiguous requirements.
---

# Align

Close the gap between what the user asks for and what they want before any spec, plan or code exists: they ask for "a dashboard" when what they need is a list of running experiments. Skip it for unambiguous, self-contained asks, mechanical changes, information requests, and when the user wants speed. It needs a live user: in a non-interactive run (CI, a scheduled job, `/loop`), report the underspecified ask as a blocker.

## Steps

1. **Hypothesize.** State your best read of what they want in one sentence, with a confidence and, below about 70%, what is still missing:
   ```markdown
   **Hypothesis:** You want a way to answer "how are we doing?" in standup.
   **Confidence:** ~30%, missing: who it's for, what "metrics" means, what success looks like
   ```
2. **Ask one question at a time** with `AskUserQuestion`: your guess first as the recommended option, its reasoning in the description, the plausible alternatives after it. Later questions depend on earlier answers, so wait for each reply and update the hypothesis. Sometimes guess in a direction you expect to be rejected, so that agreeing is never the easy answer.
3. **Probe "should want".** When an answer sounds like best-practice talk ("scalable", "the standard approach", "I should probably…"), ask what they would want if they didn't have to justify it to anyone.
4. **Stop asking** when you can predict their answers to your next three questions. If several rounds pass without your confidence rising, say so and offer to step back.
5. **Restate** the intent in lines they can confirm one by one. Always fill Out of scope: most misalignment is silent disagreement about what isn't being built.
   ```markdown
   | | |
   |---|---|
   | **Outcome** | <one line> |
   | **User** | <who benefits> |
   | **Why now** | <what changed> |
   | **Success** | <how we know it worked> |
   | **Constraint** | <the binding limit> |
   | **Out of scope** | <what we're not doing> |
   ```
6. **Confirm** with `AskUserQuestion`: confirmed, or the line to refine. Fold in each correction and restate until confirmed. "Whatever you think" hands the decision back to you, so re-ask it as a choice between two concrete options.
7. **Hand off** with `AskUserQuestion`: `spec` to write it up, `refine` to explore approaches first, or stop here. Offer to save the statement to `docs/intent/<topic>.md`. Start nothing downstream until they choose.

## Done when

The user has confirmed every line of the intent statement, Out of scope included.
