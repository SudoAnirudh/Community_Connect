## 2024-05-24 - [PostgreSQL RLS Privilege Escalation]
**Vulnerability:** The Row Level Security (RLS) policies for the `users` table allowed any user to insert or update their own profile without restrictions on the `role` or `suspended` columns.
**Learning:** This allowed users to grant themselves `admin` role or un-suspend themselves by simply providing those values when inserting or updating their own profile via Supabase API. RLS only controls *which* rows a user can access or modify, but the `WITH CHECK` clause is required to restrict *what* data they can write into those rows.
**Prevention:** Always restrict security-sensitive columns (like role, permissions, status) when writing RLS `INSERT` and `UPDATE` policies by adding appropriate assertions in the `WITH CHECK` clause to ensure they match default safe values or that only privileged users can modify them.

## 2026-06-14 - [Insecure Direct Object Reference (IDOR) in INSERT Policies]
**Vulnerability:** The `INSERT` policies for `families` and `events` tables only checked if the user was authenticated, allowing users to spoof the `admin_uid` or `created_by` fields to impersonate other users.
**Learning:** Relying solely on authentication checks in RLS policies is insufficient for columns that track ownership or creation identity. Users could pass any valid user ID in the payload.
**Prevention:** Always explicitly enforce that ownership/identity fields (like `created_by`, `admin_uid`) match the authenticated user's ID (`public.auth_uid_text()`) in the `WITH CHECK` clause of `INSERT` policies.
