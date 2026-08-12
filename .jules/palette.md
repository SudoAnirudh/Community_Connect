## 2026-08-12 - Legacy Form Component Accessibility
**Learning:** Legacy form components in the React Admin panel often lack proper label-to-input associations and use incorrect input CSS classes.
**Action:** When updating form elements, always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes for screen readers, and ensure standard classes like `input` are applied.
