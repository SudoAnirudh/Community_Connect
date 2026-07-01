## 2026-07-01 - Add accessible names to color picker buttons
**Learning:** For custom visual elements like color pickers, you must map the visual representation to a human-readable name and apply `aria-label`, `title`, and `aria-pressed` to ensure keyboard and screen reader accessibility.
**Action:** When creating or modifying color pickers or similar icon-only functional lists, map their hex codes/icons to string names and include accessibility props on the interactive elements.
