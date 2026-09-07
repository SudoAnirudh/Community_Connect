## 2024-05-18 - Form Labels and Error Associations
**Learning:** In the React Admin panel, many legacy form components lack proper label-to-input association and use custom undocumented CSS class variations. Also, error messages are missing `role="alert"` preventing screen readers from picking them up automatically.
**Action:** Always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes. Add `role="alert"` to error message containers. Standardize on `.input` and `.btn` classes based on `index.css`.
