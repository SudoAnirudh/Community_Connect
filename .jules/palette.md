## 2024-05-14 - Admin Panel Forms Accessibility
**Learning:** Legacy form components in the React Admin panel lack proper label-to-input association (`htmlFor` and `id`), and error messages lack `role="alert"`. Additionally, the standard input class is `input`, and standard button class is `btn`.
**Action:** When working on forms, always link `<label>` and `<input>` with matching `htmlFor`/`id`, add `role="alert"` to dynamic error containers, and use correct base CSS classes.
