## 2026-08-29 - Form Accessibility and Styling Defaults
**Learning:** Legacy form components in the React Admin panel lack proper label-to-input association and screen reader alerts for dynamic error messages, while sometimes using incorrect legacy CSS classes (e.g. input-field instead of input).
**Action:** Explicitly link labels and inputs using htmlFor and id attributes, add role="alert" to error containers, and ensure standard input classes are used.
