## 2024-08-13 - Standardizing Form Inputs and Labels
**Learning:** Legacy form components in the React Admin panel lack proper label-to-input association and use non-existent classes like `input-field` instead of `input`.
**Action:** Always explicitly link `<label>` and `<input>` elements using matching `htmlFor` and `id` attributes for screen reader accessibility, and use the standard `input` CSS class.
