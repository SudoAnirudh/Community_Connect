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
## 2024-06-22 - Mass-Assignment Vulnerability in RLS INSERT Policies
**Vulnerability:** Supabase allows overriding default column values during record insertion unless explicit `WITH CHECK` conditions are declared.
**Learning:** Even if a schema column has a `default` value (like `status default 'pending'`), a user interacting directly with the Supabase PostgREST API can insert a custom state (e.g. `status: 'resolved'`) successfully unless restricted.
**Prevention:** Always strictly enforce exact workflow defaults (e.g., `status = 'pending'`, `action_taken = 'none'`, `used = false`) inside the `WITH CHECK` expression for RLS `for insert` policies on user-facing tables.

## 2024-06-25 - Prevent Mass-Assignment in RLS Policies
**Vulnerability:** Privilege escalation in the `families` table where regular members could update the `admin_uid` to themselves. The RLS `UPDATE` policy allows members to modify the row, but didn't restrict which columns they could modify.
**Learning:** Using `WITH CHECK` clauses in RLS `UPDATE` policies to prevent mass-assignment on specific columns (like `admin_uid` or `status`) is problematic because it can inadvertently restrict all other valid row updates or cause infinite recursion if self-referencing.
**Prevention:** To prevent mass-assignment/privilege escalation on specific columns during PostgreSQL updates, use `BEFORE UPDATE` triggers (with `security definer` and `set search_path = public`) that raise an exception if unauthorized modification of restricted columns is attempted, explicitly allowing backend services via `service_role`.

## 2024-07-06 - Mass-Assignment Vulnerability in Events RLS INSERT Policy
**Vulnerability:** The RLS INSERT policy for the `events` table lacked a restriction on the `status` column, allowing users to provide a custom value (e.g., 'canceled' or 'completed') during creation and bypass the default 'upcoming' status.
**Learning:** Supabase allows overriding default column values during record insertion unless explicit WITH CHECK conditions are declared. Relying solely on schema defaults is insufficient against direct API interaction.
**Prevention:** Always strictly enforce workflow defaults (e.g., `status = 'upcoming'`) inside the WITH CHECK expression for RLS insert policies on tables where users can create records.
