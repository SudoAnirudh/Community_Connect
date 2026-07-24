
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.
## 2025-02-12 - Optimize Supabase data fetching
**Learning:** Fetching full rows (`.select('*')`) on tables with unbounded arrays or many columns causes unnecessary network overhead.
**Action:** Always explicitly select only the required scalar columns (e.g., `.select('id, name, ...')`) based on the component's data mapping logic.
