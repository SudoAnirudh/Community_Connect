## 2025-02-13 - Improve Login Form Accessibility
**Learning:** In the React Admin panel, legacy form components often lack proper label-to-input association (htmlFor/id), dynamic error messages miss `role="alert"` for screen readers, and some inputs use an incorrect `input-field` CSS class instead of the standard `input` class.
**Action:** Always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes, add `role="alert"` to dynamic error message containers, and ensure standard base CSS classes are used.
