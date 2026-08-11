## 2026-08-11 - Legacy Form Component Accessibility
**Learning:** In the React Admin panel, many legacy form components (like the login form) use incorrect class names (e.g., `input-field` instead of `input`) and lack explicit `htmlFor` to `id` mapping, breaking screen reader accessibility.
**Action:** When working on form components, always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes to ensure screen reader accessibility, and verify standard CSS classes (like `.input`) are used instead of assuming correct legacy implementations.
