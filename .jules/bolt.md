
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.
## 2025-02-12 - Optimize Array Filtering During Renders
**Learning:** Performing O(n) array `.filter()` operations combined with redundant `.toLowerCase()` allocations directly in React render functions creates hidden CPU overhead, especially as lists grow (users, invitations, reports).
**Action:** Use `useMemo` to cache filtered arrays and hoist static operations like `searchTerm.toLowerCase()` outside of the `.filter()` loop to reduce string allocations from O(n) per render to O(1) when search terms change.
