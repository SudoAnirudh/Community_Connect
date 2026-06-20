## 2024-06-17 - Supabase Count Query Optimization
**Learning:** Fetching full rows using `select('*')` just to check the array length causes unnecessary network and memory overhead, especially for metrics/dashboard components.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and access the `count` property on the response when only the number of records is needed.
