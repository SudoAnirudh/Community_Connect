## 2024-05-18 - Avoid fetching full rows for counts in Supabase
**Learning:** In the React admin panel, doing `.select('*')` and then checking `.length` on the frontend for simple aggregations transfers unnecessary full row data across the network, leading to poor network performance as data grows.
**Action:** Use `.select('*', { count: 'exact', head: true })` and read the `.count` property to perform database-level counting without returning the row payloads.
