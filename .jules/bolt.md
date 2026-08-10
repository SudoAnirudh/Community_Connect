
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.
## 2025-02-13 - Avoid fetching unbounded arrays in Supabase
**Learning:** Fetching full rows (`.select('*')`) on tables with unbounded array columns (like `member_uids` in the `families` table) causes unnecessary data transfer overhead and memory bottlenecks, even if the application only maps specific scalar fields.
**Action:** Always explicitly select the required scalar columns (e.g., `.select('id, name, house_name...')`) when querying tables that contain unbounded array columns.
