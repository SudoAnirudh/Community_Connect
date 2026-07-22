## 2024-07-22 - Missing Loading State Animation
**Learning:** Component libraries providing loading icons (like Phosphor's CircleNotch) often lack built-in animation classes. Simply adding the icon results in a static, frozen-looking state that fails to communicate async activity to the user.
**Action:** Always ensure a global `.spinner` utility class with a rotation keyframe is defined in the base CSS and applied to loading icons, rather than assuming the icon library handles animation.
