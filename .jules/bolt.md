## 2024-05-19 - Supabase Count Queries Optimization
**Learning:** Found an N+1/data transfer bottleneck where full rows were fetched just to count records (e.g., `supabase.from('reports').select('*').eq('status', 'pending')` to get `length`).
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read `res.count` instead of fetching full rows when only the count is needed, to save memory and network payload.
