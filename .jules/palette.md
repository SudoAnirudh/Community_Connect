## 2024-07-27 - Custom CSS animations for Loading States
**Learning:** In the React admin application, `@phosphor-icons/react` components (like `CircleNotch`) do not include built-in CSS animations. When using them as loading indicators, relying on utility classes or built-in props is insufficient.
**Action:** When utilizing icon components for loading states, ensure a custom CSS animation (e.g., `@keyframes spin` and `.spinner`) is explicitly defined in the global stylesheet (`admin/src/index.css`) and applied to the component's `className`.
