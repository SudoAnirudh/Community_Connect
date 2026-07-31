## 2024-10-24 - Missing Loading Spinner Animation
**Learning:** React Phosphor icons like `CircleNotch` often have a `className="spinner"` applied to them for loading states, but they require a CSS keyframe animation to actually spin. A static loading icon fails to provide active system feedback.
**Action:** Always ensure `.spinner` CSS classes include `@keyframes spin` when implementing loading states with static icon libraries.
