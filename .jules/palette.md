## 2024-11-20 - Ensure Login Error Accessibility
**Learning:** Error messages in legacy React components like Login.tsx lack role="alert" which means screen readers do not automatically announce them to users when they appear.
**Action:** When working on form or authentication components, always ensure dynamic error containers include `role="alert"`. Additionally, explicitly associate labels and inputs using htmlFor and id respectively.
