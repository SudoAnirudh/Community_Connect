## 2026-07-07 - Adding Accessible Color Pickers
**Learning:** When implementing custom interactive color pickers using mapped arrays, they must explicitly be grouped with `role="group"`, describe their active state with `aria-pressed`, and use `aria-label` for screen readers to understand the otherwise invisible color values.
**Action:** Next time I implement custom visual selection groups, I will ensure they use proper semantic grouping `aria-labelledby` and convey their state accurately to assistive technologies.
