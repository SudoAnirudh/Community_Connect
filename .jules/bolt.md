
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2026-08-12 - Optimize Supabase querying with explicit columns
**Learning:** Using `.select('*')` on tables with unbounded array columns (like `member_uids` in the `families` table) causes significant data transfer overhead and memory bottlenecks.
**Action:** Always explicitly select only the required scalar columns instead of `*` on such tables to minimize data transfer size.
