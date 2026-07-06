## 2024-05-24 - Supabase Count Query Optimization
**Learning:** When querying Supabase just to get record counts (e.g., pending reports), fetching full rows with `.select('*')` and reading the array length (`.data?.length`) causes network and memory performance bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property instead of fetching full rows when only the count is needed.
