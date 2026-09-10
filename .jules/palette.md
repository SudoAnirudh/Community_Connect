## 2026-09-10 - Screen Reader Support for Dynamic Errors
**Learning:** In the React Admin panel, dynamic error message containers must explicitly include `role="alert"` so screen readers automatically announce errors to users upon appearance.
**Action:** Always add `role="alert"` to dynamic error rendering blocks (e.g., login errors, validation failures) to ensure assistive technologies can surface them without requiring manual focus changes.
