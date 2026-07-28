
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2025-02-12 - Avoid select('*') on tables with unbounded arrays
**Learning:** Using `.select('*')` on tables like `families` that contain unbounded array columns (`member_uids`) causes unnecessary network overhead and memory bottlenecks.
**Action:** Always explicitly specify required scalar columns (e.g., `.select('id, name')`) instead of `*` when unbounded array data is not needed.
