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
## 2024-07-26 - [Hardcoded API Key]
**Vulnerability:** Google Maps API key was hardcoded in AndroidManifest.xml.
**Learning:** Hardcoding API keys exposes them to reverse engineering and potential misuse.
**Prevention:** Externalize API keys using secure configuration mechanisms like local.properties for Android.
## 2024-07-26 - [Infinite Recursion in RLS Policy]
**Vulnerability:** A self-referencing subquery inside the `WITH CHECK` clause of an RLS `UPDATE` policy caused infinite recursion.
**Learning:** In Supabase/PostgreSQL, you cannot use `select column from table where uid = public.auth_uid_text()` inside the `WITH CHECK` clause for the same table to enforce column immutability because it triggers the same RLS policy recursively when evaluating the check.
**Prevention:** Remove self-referencing `WITH CHECK` clauses in RLS `UPDATE` policies and rely entirely on `BEFORE UPDATE` triggers to protect specific columns from unauthorized modification (mass-assignment).
