## 2024-07-20 - Missing Spinner Animation CSS
**Learning:** Developers frequently add standard utility classes like `className="spinner"` to icons expecting them to animate, forgetting that without a CSS framework, these require explicit `@keyframes` definitions, leading to static, confusing loading states.
**Action:** Always verify that loading/spinner utility classes have corresponding CSS animation definitions when working in plain CSS environments.
