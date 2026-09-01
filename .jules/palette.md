## 2024-05-01 - Legacy Form Components Missing Label Associations
**Learning:** In the React Admin panel, many legacy form components lack proper label-to-input association and use incorrect CSS classes (e.g., `input-field` instead of `input`). Error containers also often miss `role="alert"`.
**Action:** Always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes. Apply `role="alert"` to dynamic error message containers to ensure screen readers automatically announce errors. Use the standard base CSS class `input` for form input elements.
