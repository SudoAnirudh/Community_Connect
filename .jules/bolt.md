
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2025-03-02 - Explicitly select required columns
**Learning:** Using `select('*')` on tables fetches all columns indiscriminately, causing unnecessary network payload size, memory usage, and database I/O, particularly detrimental for frontend dashboard performance.
**Action:** Always fetch only the required columns by specifying them explicitly (e.g., `select('id, name, created_at')`) instead of using the wildcard `*`.
