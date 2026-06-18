## 2024-05-24 - [PostgreSQL RLS Privilege Escalation]
**Vulnerability:** The Row Level Security (RLS) policies for the `users` table allowed any user to insert or update their own profile without restrictions on the `role` or `suspended` columns.
**Learning:** This allowed users to grant themselves `admin` role or un-suspend themselves by simply providing those values when inserting or updating their own profile via Supabase API. RLS only controls *which* rows a user can access or modify, but the `WITH CHECK` clause is required to restrict *what* data they can write into those rows.
**Prevention:** Always restrict security-sensitive columns (like role, permissions, status) when writing RLS `INSERT` and `UPDATE` policies by adding appropriate assertions in the `WITH CHECK` clause to ensure they match default safe values or that only privileged users can modify them.

## 2024-06-14 - [PostgreSQL RLS IDOR Vulnerability in INSERT Policies]
**Vulnerability:** IDOR (Insecure Direct Object Reference) / Impersonation. The RLS `INSERT` policies for `events` and `families` tables only checked if the user was authenticated. They failed to verify that the user was setting themselves as the creator/admin, allowing any authenticated user to create an event or family appearing to be owned by another user.
**Learning:** Checking for mere authentication (`public.auth_uid_text() is not null`) is insufficient for `INSERT` policies if the table records ownership or authorship. Attackers can provide arbitrary values for `created_by` or `admin_uid` fields.
**Prevention:** Always strictly enforce ID matching on `INSERT` policies using `WITH CHECK` clauses (e.g., `created_by = public.auth_uid_text()`) to ensure users can only create records that belong to them.
## 2026-06-14 - RLS WITH CHECK Policies on INSERT vs UPDATE

**Vulnerability:** Mass assignment / IDOR on workflow status columns (e.g. `status`, `verification_status`) during `INSERT` in Supabase.
**Learning:** `WITH CHECK` clauses in PostgreSQL RLS policies are ideal for enforcing constraints on newly created records (e.g., ensuring `INSERT` statements set `status = 'pending'`). However, applying the same logic to `UPDATE` policies (e.g., `WITH CHECK (status = 'pending')`) is fundamentally incorrect, as it forces the row's state to remain 'pending' after *any* update, preventing users from updating other fields once the status has been changed by an admin.
**Prevention:** To secure specific columns during `UPDATE` operations, use column-level privileges (e.g., `REVOKE UPDATE (status) ON table FROM PUBLIC`) or `BEFORE UPDATE` triggers rather than restrictive `WITH CHECK` clauses on the entire table. Keep RLS fixes for status initialization scoped strictly to `INSERT` policies.
