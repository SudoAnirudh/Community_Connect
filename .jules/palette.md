
## 2024-08-01 - Form Label Association and Dynamic Error Announcements
**Learning:** React inputs missing explicit `htmlFor`/`id` bindings are a common accessibility anti-pattern that prevents screen readers from correctly announcing fields and stops users from clicking labels to focus inputs. Additionally, conditionally rendered error messages require `role="alert"` and `aria-live="polite"` to ensure assistive technologies proactively read them when they appear.
**Action:** When inspecting forms, verify that all `<label>` elements explicitly bind to their `<input>` via matching `htmlFor` and `id` properties. Always add ARIA live regions to dynamic error or success states.
