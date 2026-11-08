# Pack: frontend
Components, styles, user interaction, accessibility. Framework-agnostic; React/Playwright names are examples.
Verify by running the app, not only by reading code.

### FE-CONTROLS [must]
When: interactive controls (search, filters, sort, forms)
Claim: all controls work and compose; reset returns to the exact initial state.
Verify: combine controls in the running app or a component test; reset → initial state.
Evidence: test names or screenshots

### FE-STATES [must]
When: views that load, can be empty or can fail
Claim: loading, empty and error states are clear and offer a way out (reset / retry).
Verify: force each state (mock slow/empty/failing data).
Evidence: screenshots or test names

### FE-DATA-EDGES [should]
When: rendering external or user data
Claim: missing fields, long strings, special characters and Unicode render without breaking layout.
Verify: render with such fixtures.
Evidence: screenshot or test name

### FE-STRUCTURE [should]
When: new or substantially changed components
Claim: one responsibility per component; state at the right level, no prop drilling beyond one layer; derived state
computed, not duplicated; no mutation of state or props; similar things share a reusable piece, so adding a
filter/field needs no rewrite.
Verify: read the diff.
Evidence: `file:line` of concerns, or "Pass"

### FE-PERF [should]
When: lists, filtering, typing-driven updates
Claim: derived lists memoized; typing stays responsive (debounce / deferred rendering); unchanged items do not
re-render.
Verify: profiler or render count with a large fixture.
Evidence: measurement

### FE-STALE [should]
When: async results triggered by repeated user actions
Claim: an older result never overwrites a newer one.
Verify: test with out-of-order responses.
Evidence: test name

### FE-LAYOUT-STABLE [must]
When: content that changes size (results, counters, empty states)
Claim: no layout jumps; space is reserved.
Verify: screenshots before/after change; Playwright bounding-box assert for key elements.
Evidence: screenshots or test name

### FE-RESPONSIVE [should]
When: layout or styling changes
Claim: usable at 375px with no horizontal scroll.
Verify: screenshot at 375px and desktop width.
Evidence: screenshots

### FE-FOCUS [must]
When: UI that resets, clears, closes or removes the focused element
Claim: focus never drops to `<body>`; it moves somewhere sensible (disabled/unmounted buttons are a common cause).
Verify: keyboard walk; Playwright `toBeFocused` after reset/close.
Evidence: test name

### FE-FEEDBACK [should]
When: user actions
Claim: every action gives feedback (result count, button state, message).
Verify: walk the main flows.
Evidence: screenshots

### FE-A11Y-NAMES [must]
When: inputs, buttons, icons, groups of controls
Claim: every input has a label; checkbox/radio groups use `fieldset/legend`; buttons have accessible names.
Verify: accessibility tree or axe scan.
Evidence: scan output

### FE-A11Y-KEYBOARD [should]
When: interactive UI
Claim: fully usable by keyboard with a visible focus ring.
Verify: keyboard-only walk of the main flows.
Evidence: notes or test

### FE-A11Y-LIVE [should]
When: dynamic content changes (result counts, empty states, async messages)
Claim: changes are announced (`aria-live`).
Verify: inspect markup; screen reader or test.
Evidence: `file:line`

### FE-A11Y-CONTRAST [must]
When: colors, themes or text styles change
Claim: WCAG AA (text ≥4.5:1, large text/UI components ≥3:1); color is never the only signal.
Verify: contrast check of the changed colors.
Evidence: ratios
