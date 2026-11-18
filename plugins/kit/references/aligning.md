# Aligning

Pin down what the user wants before how to build it: they ask for "a dashboard" when what they need is a list of running experiments. Run it when an ask leaves out who it's for, why it matters now, or what done looks like.

## Steps

1. **Hypothesize.** Open with your best read in one sentence and a confidence, naming what's missing below about 70%:
   ```markdown
   **Hypothesis:** You want a way to answer "how are we doing?" in standup.
   **Confidence:** ~30%, missing: who reads it, what "metrics" means, what success looks like
   ```
2. **Ask one question at a time** as a choice ([asking](asking.md)), opened with your current confidence, and update the hypothesis after each answer. Now and then lead with a guess you expect to be rejected, so agreeing is never the easy answer.
3. **Probe "should want".** When an answer sounds like best-practice talk ("scalable", "the standard way", "I should probably…"), ask what they'd want if they didn't have to justify it to anyone.
4. **Notice a stall.** If several answers pass without your confidence rising, say so and offer to step back.
5. **Restate** the intent as a review ([asking](asking.md)) once you can predict the next three answers. Always fill Out of scope, since most misalignment is silent disagreement about what isn't being built.
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
6. **Confirm.** Fold in each correction and restate until confirmed. "Whatever you think" hands the call back to you, so re-ask it as a choice between two concrete options.

Without a live user (CI, a scheduled job, `/loop`), report the unclear ask as a blocker and stop.

## Done when

The user has confirmed every line of the intent, Out of scope included.
