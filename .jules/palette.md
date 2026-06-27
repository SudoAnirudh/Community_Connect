
## 2026-06-27 - Accessible Custom Color Pickers
**Learning:** Custom visual elements like color pickers require human-readable names mapping to hex codes to be usable by screen readers. Visual indicators for selected states are not sufficient.
**Action:** Always map hex codes to human-readable names and apply `aria-label`, `title`, and `aria-pressed` properties to visual selection buttons.
