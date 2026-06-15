## 2024-05-24 - [PostgreSQL RLS Privilege Escalation]
**Vulnerability:** The Row Level Security (RLS) policies for the `users` table allowed any user to insert or update their own profile without restrictions on the `role` or `suspended` columns.
**Learning:** This allowed users to grant themselves `admin` role or un-suspend themselves by simply providing those values when inserting or updating their own profile via Supabase API. RLS only controls *which* rows a user can access or modify, but the `WITH CHECK` clause is required to restrict *what* data they can write into those rows.
**Prevention:** Always restrict security-sensitive columns (like role, permissions, status) when writing RLS `INSERT` and `UPDATE` policies by adding appropriate assertions in the `WITH CHECK` clause to ensure they match default safe values or that only privileged users can modify them.

## 2024-06-14 - [PostgreSQL RLS IDOR Vulnerability in INSERT Policies]
**Vulnerability:** IDOR (Insecure Direct Object Reference) / Impersonation. The RLS `INSERT` policies for `events` and `families` tables only checked if the user was authenticated. They failed to verify that the user was setting themselves as the creator/admin, allowing any authenticated user to create an event or family appearing to be owned by another user.
**Learning:** Checking for mere authentication (`public.auth_uid_text() is not null`) is insufficient for `INSERT` policies if the table records ownership or authorship. Attackers can provide arbitrary values for `created_by` or `admin_uid` fields.
**Prevention:** Always strictly enforce ID matching on `INSERT` policies using `WITH CHECK` clauses (e.g., `created_by = public.auth_uid_text()`) to ensure users can only create records that belong to them.

## 2024-06-15 - [PostgreSQL RLS Privilege Escalation via Unrestricted INSERT Status]
**Vulnerability:** The RLS `INSERT` policies for the `families`, `join_requests`, `events`, and `reports` tables did not restrict the values of workflow-related columns like `verification_status`, `status`, and `action_taken`.
**Learning:** Even if a table has default values for workflow columns (e.g., `default 'pending'`), the Supabase Data API allows users to supply their own values during an `INSERT` operation. If the RLS `INSERT` policy does not explicitly restrict these fields, an attacker can bypass the approval workflow entirely (e.g., by creating a family with `verification_status = 'approved'` or a report with `action_taken = 'resolved'`).
**Prevention:** Always ensure that security-sensitive workflow columns are constrained to their default, initial values in the `WITH CHECK` clause of an RLS `INSERT` policy (e.g., `verification_status = 'pending'`), or use triggers to forcibly override user input.
