## 2024-05-30 - Add Focus-Visible Styles for Better Keyboard Accessibility
**Learning:** Found multiple buttons and inputs across the app lacking clear focus styles, relying only on default browser outlines or generic `:focus` which can be intrusive for mouse users.
**Action:** Always add explicit `:focus-visible` styles to interactive elements like `.btn` and `.nav-link` to improve keyboard navigation accessibility while preserving a clean look for mouse users.
