## 2024-07-11 - Supabase Record Counting
**Learning:** Fetching full rows to count records using `.select('*')` and reading `.data?.length` causes unnecessary network and memory performance bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when querying Supabase for record counts.
