## 2024-06-09 - Supabase Network Bottleneck Fix
**Learning:** Found a major Supabase performance anti-pattern. Fetching full rows using `select('*')` just to check `data.length` causes massive network payloads, particularly with unbounded list queries.
**Action:** When only the count of records is needed, ALWAYS use `select('*', { count: 'exact', head: true })` to perform a lightweight HEAD request and read the resulting `.count` property.
