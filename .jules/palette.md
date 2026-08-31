## 2026-08-31 - Fix form focus styles and input linking in React Admin
**Learning:** The React Admin panel standardizes form inputs on the `input` CSS class (defined in `index.css`), not `input-field`. Additionally, form inputs lacked proper `htmlFor` and `id` linking for screen readers, and dynamic error messages lacked `role="alert"`.
**Action:** When adding or updating forms, always use the `input` class for styling, explicitly link labels and inputs with matching `id`/`htmlFor`, and add `role="alert"` to error message containers.
