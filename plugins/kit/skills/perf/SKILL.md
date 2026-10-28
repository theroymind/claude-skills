---
name: perf
description: Profile and optimize performance
disable-model-invocation: true
---

# Performance Optimization

Measure, find the actual bottleneck, fix that one thing, measure again, then guard the result. Optimize only what a measurement shows matters.

## 1. Measure

Take a baseline with a fixed command, fixed conditions and a fixed budget (wall-clock time, sample count or request count). Before proposing an experiment, read the attempt log from step 4 so you don't re-run an idea that already failed.

- **Frontend**: synthetic measurements (Lighthouse, a DevTools performance trace) to reproduce problems and gate CI, and field data (`web-vitals` `onLCP`/`onINP`/`onCLS`, CrUX) to confirm that real users felt the change. The "good" thresholds are LCP ≤ 2.5s, INP ≤ 200ms and CLS ≤ 0.1.
- **Backend**: request timing, APM, query logs with timings, and CPU and heap profiles.

## 2. Identify

Let the symptom decide what to measure first:

| Symptom | Look at |
|---|---|
| Slow first load | Bundle size and code splitting. TTFB in the network waterfall: long DNS → preconnect, long TCP/TLS → HTTP/2 and keep-alive, long server wait → profile the backend. Render-blocking CSS and JS. |
| Slow LCP, high CLS | Image sizes and priority. Images without dimensions, late-loading content, font shifts. |
| Sluggish interaction (INP) | Long main-thread tasks (over 50ms), re-renders, layout thrashing and forced reflows. |
| Slow after navigation | API waterfalls, N+1 fetches, component render time. |
| One endpoint slow | Its queries and their plans. |
| Every endpoint slow at once | Connection pool, memory, CPU. |
| Intermittent slowness | Lock contention, GC pauses, external dependencies. |
| Memory growth, CPU spikes | Heap snapshots (leaked references, unbounded caches). CPU profile (heavy synchronous work, regex backtracking). |

## 3. Fix

Fix only the bottleneck that step 2 found. These are the usual suspects. Each links to a worked fix in [references/optimization-patterns.md](references/optimization-patterns.md); open only the one you need.

**Backend**

- **N+1 queries.** One query per row is the most common backend bottleneck. Fetch the relation in the same query (join or include), not inside the loop. [Pattern](references/optimization-patterns.md#n1-queries-backend).
- **Unbounded data fetching.** Every list endpoint paginates, with a limit and a stable order. [Pattern](references/optimization-patterns.md#unbounded-data-fetching).
- **Queries that ignore their index.** "Add an index" is a guess; `EXPLAIN ANALYZE` is the measurement. Each of these calls for a different fix: a `Seq Scan` where you expected an index, a `rows=` estimate that is off by an order of magnitude, or a `Sort` node above the scan. A bad `rows=` estimate means stale statistics, so run `ANALYZE` instead of adding an index. Index for the shape of the query: equality columns first, then the range or sort column. A plain index won't help a query on a dominant, low-selectivity value (use a partial index for the rare value), a leading wildcard (needs trigram or full-text search), or a function applied to the column (index the expression, as in `WHERE lower(email) = ?`). Every index slows every write. Re-run the plan afterwards and revert an index that didn't change it. [Pattern](references/optimization-patterns.md#queries-that-ignore-their-index).
- **Connection pool exhaustion.** Signature: *every* endpoint slows down at once, the time goes to waiting for a connection rather than executing, and the database shows mostly idle sessions. Use one pool per process, sized so that `instances × max` stays under the database's connection limit. A bigger pool isn't faster; it moves the queue into the database, where it is harder to see. With unbounded instance counts (serverless, autoscaling), multiplex through a proxy (pgbouncer, RDS Proxy) instead of raising `max`. [Pattern](references/optimization-patterns.md#connection-pool-exhaustion).
- **Missing caching.** Cache what is expensive to produce and read far more often than it changes. Caching an already-fast query only adds a network hop and a staleness bug. Choose the layer on purpose: in-process, shared or CDN. Every input that changes the response belongs in the key (tenant, locale, permissions, feature flags); a key that leaves out the viewer is how one user's data gets served to another. Pick one invalidation strategy (TTL, event or tag based, versioned keys) and state the acceptable staleness window. Protect hot keys from stampedes by serving stale data while one request recomputes, or by coalescing concurrent misses behind one in-flight request. Never cache what must be fresh: balances, permissions, inventory at checkout. [Pattern](references/optimization-patterns.md#missing-caching-backend).

**Frontend**

- **Missing image optimization.** Every image declares `width` and `height` (for CLS). The LCP image gets `fetchpriority="high"`, modern formats (AVIF, WebP) through `<picture>`, and `srcset`/`sizes` for resolution switching. Images below the fold get `loading="lazy"` and `decoding="async"`. [Pattern](references/optimization-patterns.md#missing-image-optimization-frontend).
- **Unnecessary re-renders.** An object or function created during render is a new reference every time, so every child that receives it re-renders. Hoist constants. Use `React.memo` and `useMemo` only for work the profile shows is expensive, since overusing them has its own cost. [Pattern](references/optimization-patterns.md#unnecessary-re-renders-react).
- **Large bundle size.** Modern bundlers already tree-shake ESM named imports. The real gains come from route-level code splitting and lazy-loading heavy, rarely used features behind `Suspense`. Profile before changing import styles. [Pattern](references/optimization-patterns.md#large-bundle-size).

## 4. Verify: keep or revert

A fix is a hypothesis until you measure again. Measure exactly the way you took the baseline: same command, same conditions, same budget. A cold-cache baseline against a warm-cache result measures the cache, not your change. Change one thing per measurement, because three changes together give one number you can't attribute. Repeat the runs and compare the difference with the run-to-run variance; a 3% gain inside ±5% noise is not a gain.

| Result compared with the baseline | Action |
|---|---|
| Better beyond the noise, tests green | Keep. Put the before and after numbers in the commit message. |
| Within the noise | Revert. |
| Worse | Revert. |
| Better, but a test went red | Revert. |

A neutral result is a revert, not a keep: any code you keep, you maintain forever. Correctness comes before the metric. An "optimization" that wins by dropping work the product needs (a validation, a load-bearing `await`, caching something that must be fresh) is a regression.

Log every attempt, kept or reverted, in the PR description or a `PERF.md`, so a dead idea stays dead:

| Idea | Baseline → Result | Verdict | Why |
|---|---|---|---|
| Memoize the row component | INP 240ms → 235ms | reverted | Inside the ±15ms noise; rows weren't the bottleneck. |
| Virtualize the list | INP 240ms → 90ms | kept | Long tasks gone from the trace. |

## 5. Guard

Guard the metric that justified the fix (LCP, INP, p95 latency), not every number available. For user-facing surfaces, use two layers:

- **A synthetic budget in CI** (`npx lhci autorun`, `bundlesize`) that compares a median or trend, so normal noise doesn't make the gate flaky.
- **A field alert** on meaningful p75 movement. Use attributed `web-vitals` data to find the cause, and treat CrUX's rolling window as confirmation rather than an immediate alert.

When either guard fires, go back to step 1 and take a fresh baseline before proposing another fix.

If the project has no budgets yet, start from: initial JavaScript under 200KB gzipped, CSS under 50KB, each above-the-fold image under 200KB, fonts under 100KB in total, API p95 under 200ms.
