## 2024-05-24 - Supabase Query Bottlenecks

**Learning:** When querying Supabase just to get record counts, doing `.select('*')` and reading the `.length` fetches the entire payload, which causes severe network and memory bottlenecks for large datasets.

**Action:** Always use `.select('*', { count: 'exact', head: true })` to perform a fast, head-only request that returns only the count.
