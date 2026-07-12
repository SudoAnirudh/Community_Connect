## 2024-07-12 - Supabase Count Optimization
**Learning:** Fetching full rows just to count them in Supabase causes network and memory bottlenecks.
**Action:** Always use .select('*', { count: 'exact', head: true }) and read the .count property instead of fetching full rows and reading data?.length.
