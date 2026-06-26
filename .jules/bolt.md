
## 2024-05-18 - Ensure Exact Counts with `head: true` to prevent Network Overload
**Learning:** Using `select('*')` to count large tables by checking array length forces the database to send full record data over the network, which is extremely slow. Using `{ count: 'exact', head: true }` makes the database handle the calculation and avoids large network payloads entirely.
**Action:** When querying for data counts where row-level data is unnecessary, explicitly append `{ count: 'exact', head: true }` to Supabase select clauses.
