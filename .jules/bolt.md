## 2024-05-15 - Optimizing Supabase Pending Report Counts
**Learning:** Fetching full rows just to get a count (e.g., `reportsRes.data?.length`) creates unnecessary network and memory overhead. Supabase provides `{ count: exact, head: true }` which performs a `HEAD` request to return only the integer count.
**Action:** When only the count of records is needed (e.g., for dashboard statistics), always use `count: "exact", head: true` and read the `.count` property instead of fetching data arrays.
