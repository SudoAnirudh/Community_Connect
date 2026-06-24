## 2025-02-14 - Optimized Supabase Count Queries
**Learning:** In Supabase, fetching `.select('*')` just to count the `.length` of the returned array causes unnecessary payload overhead.
**Action:** Use `.select('*', { count: 'exact', head: true })` to only fetch the integer count directly from the database and avoid large payloads.