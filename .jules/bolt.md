
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.
## 2026-09-15 - Optimize Supabase payload size for bounded/unbounded columns
**Learning:** In Supabase, using `.select('*')` on tables with unbounded array columns (e.g., `member_uids` in the `families` table) causes unnecessary data transfer overhead and memory bottlenecks, even if the application only needs scalar data for the view.
**Action:** Always explicitly select only the required scalar columns to prevent data transfer overhead and memory bottlenecks.
