## 2024-08-30 - Fix Login Form Accessibility
**Learning:** Legacy form components in the React Admin panel often lack proper label-to-input associations and use incorrect CSS classes (e.g. `input-field` instead of `input`), and dynamic error messages lack `role="alert"`.
**Action:** When working on form inputs, always explicitly link `<label>` and `<input>` using `htmlFor` and `id`, ensure the correct base CSS class `input` is used, and add `role="alert"` to error message containers.
