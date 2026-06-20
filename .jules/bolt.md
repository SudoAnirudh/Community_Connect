## 2024-05-24 - Supabase Query Count Optimization
**Learning:** When needing only a record count from Supabase (e.g. pending reports), doing `select('*')` followed by `.length` on the client pulls all row data over the network, causing a bottleneck for large datasets.
**Action:** Use `.select('*', { count: 'exact', head: true })` and read `res.count` instead.
