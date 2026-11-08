---
name: wf-testing-standard
description: Testing standard for project tasks: what to test, at which layer, and what each task level requires. Use when executing or testing Medium/Hard tasks, or when deciding which tests to write.
---

# Testing standard

Use skill `tdd` for the red → green loop and seam selection. This file adds level requirements and coverage rules.

## Principles
- Test behavior through public interfaces (seams). Refactors that keep behavior must not break tests.
- Pure logic: write the test first, one vertical slice at a time.
- Expected values come from the spec or hand-worked examples, never recomputed the way the code computes them.
- Name tests by behavior, with requirement IDs when they exist.

## Layers (pick the cheapest one that catches the bug)
| Layer | When |
|---|---|
| Unit | Pure logic, edge cases |
| Component / integration | UI wiring, modules working together, DB queries |
| E2E | Each acceptance criterion, main user flows |

## Required per level
- **Easy**: relevant gates; one cheap test if it proves the task is done.
- **Medium**: every done criterion has ≥1 test; edge cases named in the scope have tests.
- **Hard**: Medium + E2E per acceptance criterion + **prove the tests have teeth**: break 1–2 key behaviors on purpose,
  confirm a test fails, restore, and record this in the report.

## Edge cases to consider (write "n/a" when irrelevant)
Empty / whitespace-only input · special characters, regex metacharacters, Unicode and diacritics · missing/null
fields · empty list and single item · duplicates (stable sort) · negative/zero/huge numbers · rapid repeated actions
(races) · reset to initial state · keyboard-only use for UI.

## Reporting
Give the commands and their results (pass/fail counts). Never write "tested" without output.
