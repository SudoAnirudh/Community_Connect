## 2024-05-24 - Supabase Record Counting
**Learning:** Fetching full rows (`.select('*')`) and reading `.data?.length` to count records causes network and memory performance bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property instead when fetching counts.
