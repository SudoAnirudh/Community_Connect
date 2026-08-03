## 2024-06-25 - React Component Accessibility Patterns
**Learning:** Even simple custom form implementations in this admin dashboard often lack basic `htmlFor` and `id` linking for labels and inputs, relying instead on wrapping elements or proximity styling. This is a recurring anti-pattern that significantly harms screen reader accessibility.
**Action:** When reviewing React components with custom forms (especially in `admin/src/pages` or `admin/src/components`), always explicitly check for and add standard `htmlFor`/`id` pairs to `<label>` and their corresponding inputs/selects/textareas.
