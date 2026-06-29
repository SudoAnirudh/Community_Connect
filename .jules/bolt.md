## 2024-06-29 - [Supabase Count Query Optimization]
**Learning:** Fetching full rows for counts using `.select('*')` followed by `.length` in Supabase queries incurs severe N+1 memory and payload bottlenecks compared to database-level counting.
**Action:** Always use `.select('*', { count: 'exact', head: true })` for record counts to skip payload and rely on PostgreSQL count aggregation.
