## 2026-06-12 - Accessible Color Pickers
**Learning:** Icon-only color selection buttons (colored circles) were completely opaque to screen readers because they lacked ARIA labels and names. Also, there was no way for screen readers to identify which color was actively selected.
**Action:** When implementing custom color pickers or icon-only buttons, always use an object mapping the visual representation (e.g., hex code or icon) to a human-readable name. Apply `aria-label`, `title`, and `aria-pressed` to communicate the button's purpose and state.
