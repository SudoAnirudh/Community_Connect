## 2026-06-11 - Prevent Network Bottlenecks by using count: exact in Supabase
**Learning:** Fetching full rows (`select('*')`) just to count them (`data.length`) creates significant network performance bottlenecks in Supabase/PostgreSQL.
**Action:** Always use `.select('*', { count: 'exact', head: true })` instead of fetching full rows (`select('*')`) when only the record count is needed.
