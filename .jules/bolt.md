
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.
## 2025-02-13 - Avoid fetching unbounded array columns
**Learning:** Using `.select('*')` on tables that contain unbounded array columns (like `member_uids` in `families`) causes significant data transfer overhead and memory bottlenecks when only scalar values are needed.
**Action:** Always explicitly select only the required scalar columns (e.g., `.select('id, name')`) instead of `*` to prevent unnecessary network and memory bottlenecks.
