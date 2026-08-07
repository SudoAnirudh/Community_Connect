
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2026-08-07 - Optimize Supabase querying on unbounded array columns
**Learning:** Using `.select('*')` on tables like `families` that contain unbounded array columns (e.g., `member_uids`) causes significant data transfer overhead and memory bottlenecks when those columns are not needed by the client.
**Action:** Always explicitly select only the required scalar columns (e.g., `.select('id, name, house_name, ward_number, verification_status')`) instead of fetching full rows.
