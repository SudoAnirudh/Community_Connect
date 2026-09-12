## 2026-09-12 - Login Form Accessibility and Styles
**Learning:** Legacy login forms in the React Admin panel lacked explicit label-to-input association (htmlFor/id), used incorrect base classes (`input-field` and `btn-primary` instead of `input` and `btn`), and omitted the `role="alert"` attribute for error announcements.
**Action:** When working on React Admin forms, always explicitly link labels and inputs, use the defined base classes (`input`, `btn`), and add `role="alert"` to dynamic error messages to ensure screen reader accessibility.
