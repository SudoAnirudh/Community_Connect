## 2026-07-03 - Supabase Count Query Optimization
**Learning:** In OverviewDashboard, there was a query pulling full rows just to get the length (`supabase.from('reports').select('*').eq('status', 'pending')`).
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read `.count` instead of fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) to prevent network and memory performance bottlenecks.
