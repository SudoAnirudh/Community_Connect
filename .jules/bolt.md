## 2024-07-10 - Supabase Record Counts Performance
**Learning:** Fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) to get record counts causes significant network and memory performance bottlenecks, especially for tables that can grow large.
**Action:** When querying Supabase for record counts, always use `.select('*', { count: 'exact', head: true })` and read the `.count` property to offload counting to the database.
