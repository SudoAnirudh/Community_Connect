## 2024-05-24 - [Avoid exact count queries on large tables]
**Learning:** In Supabase, using `select(*, { count: "exact", head: true })` causes PostgreSQL to scan the entire table to compute the exact count. On large tables, this is a major performance bottleneck, leading to slow queries or timeouts.
**Action:** When an exact count is needed for analytics dashboards, use aggregated data from a separate tracking table or use an estimated count instead.
## 2024-05-24 - [Avoid fetching entire tables for local filtering]
**Learning:** `FamiliesDashboard.tsx` fetches all `families` and filters them locally into `pending` and `others`. As the database grows, this fetches megabytes of unnecessary data.
**Action:** When working with data that is logically separated by status, perform filtering at the database level by requesting only the needed rows, or at minimum, be aware that filtering all rows locally is an N+1 scaling issue for memory/network.
