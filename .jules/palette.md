## 2026-07-15 - Missing animation for loading spinner icons
**Learning:** The React admin panel components use `<CircleNotch className="spinner" />` for loading states, but lacked the corresponding CSS `.spinner` animation, resulting in static loading icons that fail to provide clear visual feedback.
**Action:** Always ensure that utility classes used for animations, especially for async operations and loading states, are defined in the global stylesheet to provide proper interaction feedback.
