## 2024-07-14 - Missing Interaction Feedback on Destructive/Important Actions
**Learning:** The admin panel lacked loading indicators on important approval/rejection actions and global focus-visible outlines. This degrades keyboard accessibility and leaves users without visual confirmation during async operations, which can lead to double-clicks on potentially destructive actions.
**Action:** Implemented `:focus-visible` globally for better keyboard navigation and added explicit disabling and loading spinners (`processingState`) to action buttons.
