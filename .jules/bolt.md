## 2024-06-13 - Optimize Record Counts Query
**Learning:** When querying Supabase for record counts, always use `.select('*', { count: 'exact', head: true })` instead of fetching full rows (`select('*')`) and reading the array length (`length`). This prevents network performance bottlenecks by avoiding large uncompressed payloads and unnecessary memory allocations.
**Action:** Apply this optimization uniformly across the application whenever the length of an array is the primary information needed from a database query.
