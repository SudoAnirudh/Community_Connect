
## 2025-02-12 - Optimize Supabase row counting
**Learning:** Querying Supabase for record counts by fetching full rows (`.select('*')`) and reading the array length (`.data?.length`) causes unnecessary network and memory bottlenecks.
**Action:** Always use `.select('*', { count: 'exact', head: true })` and read the `.count` property when only the record count is required.

## 2024-07-16 - RLS Subquery Bottlenecks
**Learning:** Supabase Row Level Security (RLS) policies and triggers frequently use `EXISTS` subqueries filtering on specific column combinations. Adding indexes to foreign keys (family_id) and frequently filtered columns (status) prevents sequential scans. However, composite indexes starting with unique keys (e.g., `(uid, role)`) are redundant as PostgreSQL will rapidly find the row using the unique index.
**Action:** Always add indexes to foreign keys and filtered columns, but avoid composite indexes that start with primary/unique keys to prevent unnecessary write overhead.
