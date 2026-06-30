## 2024-05-24 - Supabase Count Query Optimization
**Learning:** Fetching full rows with `select('*')` just to determine the count using `data.length` creates a network bottleneck and wastes memory, especially when filtering tables like `reports`.
**Action:** Always use `.select('*', { count: 'exact', head: true })` when querying Supabase for record counts instead of fetching full rows, and use the `count` property from the response.
