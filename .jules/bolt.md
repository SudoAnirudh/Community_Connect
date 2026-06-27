## 2025-02-15 - Optimize count query with exact head
**Learning:** Supabase/PostgreSQL count queries should use `{ count: "exact", head: true }` instead of fetching all rows and counting the array length. This drastically reduces the network payload, preventing the frontend from downloading unnecessary full row payloads when only an aggregate count is needed.
**Action:** Always prefer `head: true` when doing count queries where row data is unneeded.
