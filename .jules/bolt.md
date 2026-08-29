
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2026-08-29 - Avoid SELECT * with unbounded arrays
**Learning:** In Supabase, using `.select('*')` on tables with unbounded array columns (like `member_uids` in `families`) causes significant data transfer overhead and memory bottlenecks.
**Action:** Always explicitly select only the required scalar columns (e.g., `.select('id, name')`) instead of `*` to optimize network payload and memory.
