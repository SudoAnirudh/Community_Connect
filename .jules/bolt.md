
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2025-02-12 - Optimize Supabase fetching with unbounded arrays
**Learning:** Using `.select('*')` on tables with unbounded array columns (like `member_uids` in `families`) fetches unnecessarily large payloads, causing memory and network bottlenecks.
**Action:** Always explicitly select required scalar columns (e.g., `.select('id, name, status')`) to prevent transferring unbounded data when array columns are not needed.
