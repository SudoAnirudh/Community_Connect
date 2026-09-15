## 2024-05-30 - Form Accessibility and Class Names
**Learning:** Legacy forms in this application consistently miss accessibility basics: `<label>` and `<input>` elements lack explicit association via `htmlFor`/`id`, dynamic error messages lack `role="alert"`, and inputs/buttons sometimes use incorrect CSS class variations (like `input-field` or `btn-primary`) instead of the standard `input` or `btn` classes.
**Action:** Always verify `htmlFor` and `id` mapping for inputs, ensure dynamic errors have `role="alert"`, and use the correct base CSS classes.
