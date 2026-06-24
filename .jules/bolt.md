## 2024-05-28 - Supabase Record Counting
**Learning:** Using `select("*")` without `{ head: true }` when only needing a count causes Supabase to download all full rows over the network, leading to massive memory usage and slow performance on large datasets.
**Action:** When querying Supabase for record counts, always use `.select("*", { count: "exact", head: true })` instead of fetching full rows and reading the array length to prevent network performance bottlenecks.
