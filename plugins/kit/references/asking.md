# Asking the user

Every question to the user is either a **choice** or a **review**. Ask it the way its kind says.

The question dialog collapses any text written before it in the same turn into a one-line summary, so the user never sees that text while the dialog is open. Anything the user must read before answering goes in a review, which ends your turn.

## Choice

A question the user can answer from the card alone: an assumption to confirm, a decision between options, where to go next.

- Ask with `AskUserQuestion`, the recommended option first and its reasoning in the description.
- Make the card stand on its own: the question names the items it asks about, never "the above" or "option 2".
- Keep it short, so it works on a phone: a one-line question and one-line option descriptions. Add a `preview` only to compare short code shapes.
- A skill that tracks confidence opens the question text with it ("~40% · Who opens this dashboard first?").
- Write no lettered option lists in the text.

## Review

A question whose answer depends on content the user must read: a document, report, overview, layout tree, or list of candidates.

1. **Show** the content in the chat as plain text, in full. The user may not open the file.
2. **End your turn** with one line saying how to answer, and open no `AskUserQuestion` in that turn:
   - Approval: "Reply approve, or tell me what to change."
   - Selection, with the items numbered: "Reply with the numbers to apply."
   - Read before choices: "Reply when you've read it, or comment on it." The choices follow as cards in the next turn.
3. **Act on the reply.** For changes, revise and run the review again.
