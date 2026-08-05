## 2025-01-20 - Undefined Design Variables in Boilerplate
**Learning:** Found boilerplate login components relying on generic undefined classes (`card`, `input-field`, `btn-primary`) and incorrect design variables (`--bg-main`, `--text-secondary`) instead of the app's established design system (`glass-card`, `input`, `btn`, `--bg-dark`, `--text-muted`).
**Action:** Always verify if a standalone page (like Login) correctly implements the established design tokens from `index.css` before attempting to add new styling or custom components.
