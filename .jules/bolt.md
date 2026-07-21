
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.
## 2025-02-12 - Optimize Supabase payload size
**Learning:** Using `.select('*')` on Supabase queries fetches all columns, which can lead to large network payloads and higher memory usage on the frontend, even if only a few columns are used for UI rendering.
**Action:** Always explicitly specify required columns in `.select('col1, col2')` for list-fetching queries to minimize payload sizes and improve dashboard load times.
