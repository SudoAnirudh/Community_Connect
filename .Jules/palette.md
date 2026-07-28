## 2024-07-28 - Destructive Action Confirmations
**Learning:** Immediate execution of moderation actions (like approving/rejecting user data) without confirmation leads to accidental clicks and data integrity issues.
**Action:** Always wrap destructive or significant state-changing actions in moderation dashboards with a confirmation dialog (e.g., `window.confirm`) to prevent accidental clicks.
