## 2024-07-13 - Optimize Supabase count queries
**Learning:** Using `.select('*')` and `.data?.length` to count records causes network and memory performance bottlenecks by fetching all rows.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read `.count` when only the record count is needed.
