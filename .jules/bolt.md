
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.
## 2026-09-01 - Optimize Supabase querying with explicit columns
**Learning:** Using `.select('*')` on Supabase tables with unbounded array columns (like `member_uids` in `families`) causes unnecessary data transfer overhead and memory bottlenecks, even if the array is not used in the application layer.
**Action:** Always explicitly select only the required scalar columns (e.g., `.select('id, name...')`) to prevent fetching large unused arrays and optimize network payload.
