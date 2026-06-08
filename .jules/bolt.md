## 2024-05-24 - Supabase Counting Optimization
**Learning:** Fetching full rows using `select('*')` just to read `data.length` transfers unnecessary data over the network, causing a performance bottleneck, especially on large tables. Supabase provides a way to get counts efficiently without data payloads.
**Action:** Always use `.select('*', { count: 'exact', head: true })` when only the count is needed, avoiding full data transfer.
