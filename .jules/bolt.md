## 2024-05-14 - Use COUNT with HEAD requests for Supabase Data
**Learning:** We can calculate database aggregations (like COUNT) directly within Supabase by passing `{ count: 'exact', head: true }` to `.select()` instead of doing client-side calculations (`.data?.length`).
**Action:** When querying for just a count, always use `.select('*', { count: 'exact', head: true })` and read the `.count` property instead of fetching full rows (`.select('*')`) and reading the array length to prevent network and memory performance bottlenecks.
