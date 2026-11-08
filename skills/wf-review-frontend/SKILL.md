---
name: wf-review-frontend
description: Frontend, UI and accessibility review checklist (framework-agnostic). Use when a task touches components, styles, or user interaction, or when reviewing frontend code.
---

# Frontend checklist

Framework-agnostic; React examples are illustrations only. Mark each item Pass / Fail (with file:line) / n/a.
**[B]** = blocker when failed.

## Behavior
- [B] All controls work and **compose** (search + filter + sort …); reset returns to the exact initial state.
- [B] Empty, loading, and error states are clear and offer a way out (reset / retry).
- Data edge cases: missing fields, long strings, special characters, Unicode/diacritics.

## Components and state
- One responsibility per component; no mega-component holding all state and markup.
- State lives at the right level; no prop drilling beyond one layer; derived state is computed (memo/computed), not duplicated.
- A reusable pattern appears when two things are alike (e.g. a generic `<FilterGroup>`); adding a filter/field does not require a rewrite.
- No mutation of state or props.

## Performance
- Derived lists are memoized; typing stays responsive (debounce or the framework's deferred rendering, e.g. `useDeferredValue`).
- Unchanged items do not re-render (stable keys; React: `React.memo`, no new functions/objects per render where it breaks memo).
- Rapid repeated actions: stale results never overwrite newer ones.

## UX
- [B] No layout jumps when results change (stable sizes, reserved space for counters/empty states).
- Responsive: usable at 375px with no horizontal scroll.
- [B] **Focus is never lost**: after reset/clear/close, focus moves somewhere sensible (a disabled or unmounted button is a common cause).
- Feedback for every action (result count, button states).

## Accessibility
- [B] Every input has a label; checkbox groups use `fieldset/legend`; buttons have names.
- Fully usable by keyboard; visible focus ring.
- Dynamic changes are announced (`aria-live` for result counts / empty state).
- [B] Color contrast meets WCAG AA (text ≥4.5:1, large text/UI components ≥3:1); color is never the only signal.

## Verify by running, not only reading
Run the app, walk the main flows by keyboard, screenshot desktop and mobile widths. With Playwright, assert focus
(`toBeFocused`) and layout stability for important flows.
