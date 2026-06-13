## 2024-05-24 - [PostgreSQL RLS Privilege Escalation]
**Vulnerability:** The Row Level Security (RLS) policies for the `users` table allowed any user to insert or update their own profile without restrictions on the `role` or `suspended` columns.
**Learning:** This allowed users to grant themselves `admin` role or un-suspend themselves by simply providing those values when inserting or updating their own profile via Supabase API. RLS only controls *which* rows a user can access or modify, but the `WITH CHECK` clause is required to restrict *what* data they can write into those rows.
**Prevention:** Always restrict security-sensitive columns (like role, permissions, status) when writing RLS `INSERT` and `UPDATE` policies by adding appropriate assertions in the `WITH CHECK` clause to ensure they match default safe values or that only privileged users can modify them.
## 2024-05-24 - Postgres RLS IDOR / Impersonation Vulnerability
**Vulnerability:** IDOR in `INSERT` operations on `families` and `events` tables allowing attackers to specify `admin_uid` and `created_by` to any arbitrary ID.
**Learning:** Initial `WITH CHECK` restrictions only validated that the user was authenticated, not that they were setting the resource ID to their own user ID. Adding a `WITH CHECK` to a `FOR SELECT` policy breaks Postgres deployments entirely. Adding them to `UPDATE` redundantly isn't useful.
**Prevention:** Strictly enforce `user_id = public.auth_uid_text()` within `INSERT` statements' `WITH CHECK`. Only apply `WITH CHECK` clauses for table mutation operations, not selections.
