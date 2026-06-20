## 2024-03-24 - Accessible Custom Color Pickers
**Learning:** Custom interactive elements that rely solely on visual properties, like hex-colored swatch buttons, are inaccessible to screen reader users because hex values aren't meaningful.
**Action:** Always map visual properties (like hex colors) to human-readable names and apply them using `aria-label`, `title`, and `aria-pressed` for screen reader accessibility and clear interaction feedback.
