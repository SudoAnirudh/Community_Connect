## 2024-05-24 - Supabase Query Count Optimization
**Learning:** Fetching full rows via `select("*")` just to calculate the length of the array in Supabase causes a significant network bottleneck, particularly as data scales (e.g., pending reports).
**Action:** Use `.select("*", { count: "exact", head: true })` and read the `.count` property on the response to optimize payload size and execution time when only the number of records is needed.
