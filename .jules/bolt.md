## 2025-02-12 - Supabase Count Queries
**Learning:** Fetching full row data just to calculate `data.length` for a count metric is a major performance anti-pattern in Supabase, leading to large network payloads and memory consumption.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read `res.count` when only the count of records is needed, omitting the actual row data from the response.
