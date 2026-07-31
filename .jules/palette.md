## 2024-05-14 - Loading Spinner Animation
**Learning:** React Phosphor icons (`CircleNotch` etc.) might have a `spinner` className applied by developers assuming standard spinning CSS is globally available, resulting in broken, static icons if the CSS isn't present in the design system.
**Action:** Always verify if utility animation classes like `.spinner` are actually defined in `index.css` or the main stylesheet before using them, especially when importing third-party icon sets.
