## 2024-05-30 - Lockfile modifications during package manager usage
**Learning:** Using `pnpm install` without `--no-lockfile` (or modifying files that trigger `flutter test` dependencies) will cause unwanted lockfile diffs (like `pnpm-lock.yaml` and `pubspec.lock`) to be included in code review patches, clouding the scope of a targeted optimization PR.
**Action:** Always clean up unintended lockfile changes (`git restore`, `rm`, etc.) before finishing a PR, or run installation commands with flags that prevent lockfile creation/mutation.
