## 2026-07-07 - Supabase Count Query Pattern
**Learning:** Fetching full rows via `.select('*')` just to read `.data?.length` is a performance anti-pattern in Supabase, leading to memory and network bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when calculating totals.
