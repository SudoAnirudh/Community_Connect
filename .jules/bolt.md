## 2025-06-07 - O(N) String Conversion in Filter Callbacks
**Learning:** Calling `searchTerm.toLowerCase()` inside a `.filter` callback on a React component causes an unnecessary string conversion on every iteration (O(N)), compounded by unnecessary re-computations on every unrelated render if not memoized.
**Action:** Always hoist invariant transformations like `.toLowerCase()` outside the loop and wrap expensive list filtering in `useMemo` so it only recalculates when dependencies change.
