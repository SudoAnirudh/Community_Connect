## 2024-05-24 - [PostgreSQL RLS Privilege Escalation]
**Vulnerability:** The Row Level Security (RLS) policies for the `users` table allowed any user to insert or update their own profile without restrictions on the `role` or `suspended` columns.
**Learning:** This allowed users to grant themselves `admin` role or un-suspend themselves by simply providing those values when inserting or updating their own profile via Supabase API. RLS only controls *which* rows a user can access or modify, but the `WITH CHECK` clause is required to restrict *what* data they can write into those rows.
**Prevention:** Always restrict security-sensitive columns (like role, permissions, status) when writing RLS `INSERT` and `UPDATE` policies by adding appropriate assertions in the `WITH CHECK` clause to ensure they match default safe values or that only privileged users can modify them.

## 2024-06-14 - [PostgreSQL RLS IDOR Vulnerability in INSERT Policies]
**Vulnerability:** IDOR (Insecure Direct Object Reference) / Impersonation. The RLS `INSERT` policies for `events` and `families` tables only checked if the user was authenticated. They failed to verify that the user was setting themselves as the creator/admin, allowing any authenticated user to create an event or family appearing to be owned by another user.
**Learning:** Checking for mere authentication (`public.auth_uid_text() is not null`) is insufficient for `INSERT` policies if the table records ownership or authorship. Attackers can provide arbitrary values for `created_by` or `admin_uid` fields.
**Prevention:** Always strictly enforce ID matching on `INSERT` policies using `WITH CHECK` clauses (e.g., `created_by = public.auth_uid_text()`) to ensure users can only create records that belong to them.

## 2024-06-19 - [Preventing Status Field IDOR via Triggers]
**Vulnerability:** [Insecure Direct Object Reference / Privilege Escalation allowing any user to verify families or approve join requests by updating the `verification_status` and `status` columns.]
**Learning:** [RLS policies often only restrict WHICH rows can be updated but do not inherently restrict WHICH columns can be modified. This allowed unauthorized modifications of sensitive workflow state columns.]
**Prevention:** [Implement `BEFORE UPDATE` triggers to explicitly check and authorize modifications to specific sensitive columns, using `security definer set search_path = public` and safely bypassing backend service roles.]

## 2024-06-21 - [PostgreSQL RLS Privilege Escalation in INSERT Policies]
**Vulnerability:** The RLS `INSERT` policies for `events` and `reports` tables did not restrict default status fields (`status` and `action_taken`), allowing any authenticated user to create events with arbitrary statuses (e.g., 'completed' or 'cancelled') or reports that were already marked as resolved or acted upon.
**Learning:** Even if a PostgreSQL table defines default values for columns (e.g., `status text not null default 'upcoming'`), the Supabase PostgREST API allows clients to explicitly supply custom values during an `INSERT`. If the RLS policy does not explicitly forbid it using a `WITH CHECK` clause, users can set any value they want for those columns upon creation.
**Prevention:** Always explicitly enforce safe default values for workflow/state columns (like `status`, `action_taken`, `role`) in RLS `INSERT` policies using `WITH CHECK` clauses (e.g., `status = 'upcoming'`) to ensure newly created records begin in a secure, expected state.
