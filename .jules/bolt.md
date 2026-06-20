## 2024-06-06 - [Supabase Count Optimization]
**Learning:** [When fetching a count using Supabase JS client, fetching all row data `select(*)` and checking length (`data.length`) causes unnecessary payload size and network latency. Using `{ count: "exact", head: true }` makes it a HEAD request returning only the count metadata without the payload data.]
**Action:** [Always use `{ count: "exact", head: true }` when only the count of records is needed instead of pulling the entire array of data.]
