## 2024-08-14 - Fix legacy form inputs
**Learning:** In the React Admin panel, many legacy form components lack proper label-to-input association and use an incorrect CSS class (`input-field` instead of `input`).
**Action:** When adding or updating form elements, always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes, and use the standard `input` class for styling.
