## 2024-05-18 - Missing Accessibility Attributes and Broken Styles in Login Form
**Learning:** The React Admin panel's legacy forms often lack proper `htmlFor`/`id` associations for inputs, and incorrectly use non-existent base classes like `input-field` instead of `input`. Also, error messages lack `role="alert"`.
**Action:** Always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes, use the correct base CSS classes (e.g. `input`), and add `role="alert"` to dynamic error message containers to ensure screen reader accessibility.
