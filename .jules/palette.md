
## 2024-07-23 - Missing Animation for Loading Icons
**Learning:** Icon libraries (like @phosphor-icons/react) used as loading indicators (e.g., CircleNotch) do not include built-in CSS animations. This results in static loading icons, which is confusing UX because users can't tell if the application is frozen or loading.
**Action:** When using an icon as a loading spinner, ensure a custom CSS animation (like `@keyframes spin` and `.spinner`) is defined in the global stylesheet and explicitly applied to the icon class.
