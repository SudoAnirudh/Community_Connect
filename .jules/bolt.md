
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2024-05-24 - Supabase Select on Tables with Unbounded Arrays
**Learning:** In PostgreSQL/Supabase, using `.select('*')` on tables with array-based columns (like `member_uids` in `families`) for list views creates an O(N * M) data transfer bottleneck, as the unbounded array is unnecessarily fetched for every row.
**Action:** Always explicitly select only the required scalar columns (e.g., `.select('id, name, house_name, ward_number, verification_status')`) when querying tables that contain array columns, to avoid exponential payload growth.
