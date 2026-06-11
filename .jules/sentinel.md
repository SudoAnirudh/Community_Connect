## 2024-06-11 - [Privilege Escalation Risk in Users Table]
**Vulnerability:** [Users can update their own profile without restrictions, allowing them to change their `role` to 'admin' and `suspended` status.]
**Learning:** [RLS policies on update operations must explicitly block modification of sensitive fields by regular users, or the fields should be restricted using triggers/separate tables.]
**Prevention:** [Implement a trigger function to block regular users from modifying sensitive fields like `role` and `suspended` in the `users` table.]
