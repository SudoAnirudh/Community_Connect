## 2024-05-24 - Supabase Count Query Optimization
**Learning:** Fetching full rows (`.select('*')`) and reading the array length just to get a record count causes severe network and memory bottlenecks in Supabase.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only a count is needed.
