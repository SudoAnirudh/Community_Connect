
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2025-02-13 - Optimize Supabase querying with explicit columns
**Learning:** Using `.select('*')` on Supabase tables that contain unbounded array columns (like `member_uids` in the `families` table) causes unnecessary data transfer overhead and memory usage.
**Action:** Always explicitly select only the required scalar columns (e.g., `.select('id, name, house_name, ward_number, verification_status')`) when fetching records with potentially large or unbounded arrays.
