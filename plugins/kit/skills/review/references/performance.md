# Performance

Static reasoning about what the code does at scale. Every finding names the scale that makes it matter. A finding whose fix is a trade-off recommends measuring rather than asserting.

- **Work in the hot path.** Allocation, string building, regex compilation, logging, synchronous I/O inside a per-frame, per-request or per-row loop.
- **Shape mismatch.** A lookup in a list where a map is due, nested loops over the same collection, a sort or a full scan inside a loop, a recomputation of a value the loop doesn't change.
- **Chatty boundary.** One call per item across a process, network or database boundary (N+1). Batch, join or prefetch. The loop may be in another file, where a callee makes the call for each item its caller hands it.
- **Unbounded growth.** A cache with no eviction, a listener never removed, a collection that only ever grows, a retry with no cap.
- **Needless copies.** Cloning a structure to read it, serialising to compare, converting between representations at every step instead of once at the edge.
- **Serial waits.** Independent async work awaited one after the other; blocking work on the main or event thread.
