## 2024-05-20 - Form Accessibility & Styling

**Learning:** Form components lack explicit label-to-input association (`htmlFor` and `id`) and use incorrect CSS classes (`input-field` instead of `input`, `btn-primary` instead of `btn`). Error messages also lack `role="alert"`.
**Action:** Always link `<label>` and `<input>` using `htmlFor` and `id`. Use standard base CSS classes `input` and `btn`. Add `role="alert"` to dynamic error message containers for screen readers.
