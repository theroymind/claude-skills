---
name: align
description: Interviews the user one question at a time, each with a best guess attached, until you can predict their answers. Use when you don't yet know what the user wants (an ask with no who, why or definition of done), when they say "interview me", "grill me" or "are we sure?", or when you catch yourself filling in ambiguous requirements.
---

# Interview Me

What people ask for and what they want are often different. They ask for "a dashboard" because that's the usual thing to ask for, or say "make it faster" with no number to hit. Close that gap before any spec, plan or code exists: ask one question at a time, each with your best guess attached, until you can predict the user's answers.

Skip this for asks that are unambiguous and self-contained, for information requests, for mechanical changes, and when the user has asked for speed. The interview needs a live user. In a non-interactive run (CI, a scheduled job, `/loop`), report the underspecified ask as a blocker instead of guessing.

## Steps

1. **Hypothesize.** Write your best read of what they want in one sentence, with a confidence you can defend:
   ```markdown
   **Hypothesis:** You want a way to answer "how are we doing?" in standup, and "dashboard" is the conventional ask.
   **Confidence:** ~30%, missing: who it's for, what "metrics" means, what success looks like
   ```
   Below about 70%, name on the same line what is still missing.

2. **Ask one question per message, with a guess.**
   ```markdown
   **Q:** <one focused question>
   **Guess:** <your predicted answer and the reasoning behind it>
   ```
   When the question is a choice between known options, letter them and mark your guess, so the user can answer with a letter:
   ```markdown
   **Q:** Who's asking "how are we doing?"
   - **a.** You
   - **b.** The team in standup *(guess: "our" usually scopes that way)*
   - **c.** Someone above you
   ```
   Wait for the reply before asking the next question: later questions depend on earlier answers, and a wrong guess is quicker to correct than an answer is to write from scratch. Watch for users agreeing just to be agreeable. Stay visibly willing to be wrong, and sometimes guess in a direction you expect them to reject. Update the hypothesis and confidence as the answers come in.

3. **Probe "should want".** When an answer sounds like best-practice talk ("scalable", "clean", "the standard approach", "I should probably…"), ask: *"If you didn't have to justify this to anyone, what would you actually want?"*

4. **Stop asking** when you can predict how they'd answer the next three questions you'd ask. If several rounds pass and your confidence isn't rising, say so instead of grinding on: "I've asked N questions and still can't predict your answers. Something foundational is missing. Want to step back?"

5. **Restate** what they want in their own words, in lines they can confirm one by one:
   ```markdown
   | | |
   |---|---|
   | **Outcome** | <one line> |
   | **User** | <who benefits> |
   | **Why now** | <what changed> |
   | **Success** | <how we know it worked> |
   | **Constraint** | <the binding limit> |
   | **Out of scope** | <what we're not doing> |

   Yes / no / refine?
   ```
   Always include Out of scope. Half of all misalignment is silent disagreement about what isn't being built.

6. **Get an explicit yes.** "Whatever you think" hands the decision back to you, so re-ask as a choice between two concrete options, lettered as in step 2. "Sounds good" and "sure, let's go" are ambiguous, so ask what they would refine. Fold in any correction and restate until they say yes.

7. **Hand off and stop.** Deliver the confirmed statement of intent and offer the next steps: save it to `docs/intent/<topic>.md`, run `refine` to explore options against it, or run `spec` to write it up. Then end your turn. Save nothing and start no downstream work until they choose.

## Example

```
User:  build me a dashboard for our metrics

Agent: **Hypothesis:** You want a way to answer "how are we doing?" in standup.
       **Confidence:** ~30%, missing: who it's for, what "metrics" are, what success looks like
       **Q:** Who's asking "how are we doing?"
       - **a.** You
       - **b.** The team in standup *(guess: "our" usually scopes that way)*
       - **c.** Someone above you

User:  Me. I keep losing track of which experiments are running and what their early signal is.

Agent: **Updated read:** a personal experiment tracker, not a team dashboard.
       **Confidence:** ~60%, missing: what "early signal" means
       **Q:** Is the gap knowing which experiments exist, or seeing their results in one place?
       **Guess:** Results in one place. You have a list, but the results live in five tools.

User:  The first one. I don't have a list; they're spread across docs.
```

Two questions in, the real ask turns out to be a list, not a dashboard: a different artifact with different scope.
