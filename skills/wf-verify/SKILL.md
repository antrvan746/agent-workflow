---
name: wf-verify
description: Verify phase for project tasks - select checks from global packs (security, backend, frontend) and the project profile, prove each with evidence, apply the testing standard per level. Use after executing any project task, when deciding which tests to write, or when reviewing a change.
---

# Verify phase

Goal: every "done" claim has evidence. Reading the code counts as evidence only when a check says so.

## Procedure
1. **Select**
   - Packs: those listed in the profile's `## Verify` → `packs:`. No profile: pick by touched area and declare ⚠️.
     Pack files: `packs/<name>.md` next to this file (`security`, `backend`, `frontend`).
   - Checks: within each pack, those whose `When` matches the diff or the Risk map tags; plus the profile's own checks;
     plus the testing standard below. Apply `off` / strength overrides.
   - Easy: gates + TEST-EASY + TEST-REUSE (when adding a test) + matching checks of the `security` pack, `FE-A11Y-NAMES`, `FE-A11Y-CONTRAST`, and
     matching `must` checks of the profile. Other pack checks are for Medium/Hard.
2. **Prove**: run each check's `Verify`; record Pass / Fail (`file:line`) / n/a (why) with its evidence.
   Also check the diff against the profile's `## Invariants`.
3. **Gates**: run them (WORKFLOW.md "Gates") and keep the real output.
4. **Report**: one row per check: `ID | result | evidence`. A failed `must` is a blocker: fix it, or write down the
   accepted risk with a reason and get the user's ✅.
5. **Reviewer**: pass the pack paths, the selected IDs and the profile path.

## Check format
```
### <ID> [must|should]
When: <selector: always, type, level, paths, tags, or free text>
Claim: <what must be true>
Verify: <command, test or action that proves it>
Evidence: <what goes in the report>
```

## Testing standard
Principles: test behavior through public interfaces; refactors that keep behavior must not break tests. Pure logic
test-first, one vertical slice at a time. Expected values come from the spec or hand-worked examples, never recomputed
the way the code computes them. Name tests by behavior, with requirement IDs when they exist. Keep the suite lean:
extend an existing test before adding one, and add only tests the project's structure supports (TEST-REUSE).

Layers (pick the cheapest that catches the bug): unit for pure logic and edge cases; component/integration for
wiring, modules together and DB queries; E2E for acceptance criteria and main user flows.

### TEST-EASY [should]
When: level Easy
Claim: the change is proven by the relevant gates and, if cheap, one test.
Verify: run gates of the touched area; add one test if it proves the task; visual change: one screenshot or a
contrast check.
Evidence: gate output

### TEST-REUSE [must]
When: about to add a new test (test case, file, fixture or helper), any level
Claim: every new test is needed, could not be an extension of an existing test, and fits a test structure the
project already supports.
Verify: before writing it:
1. **Needed?** Search the existing tests for this behavior/module. Already covered (at this or another layer that
   catches the same bug) → do not add.
2. **Reuse?** Prefer extending an existing test: add a case to a table/parametrized test, an assertion to the test of
   the same behavior, or reuse an existing fixture/helper/factory instead of writing a new one.
3. **Supported structure?** A new test goes where the project's own tests live: existing directory, naming, runner,
   layer, and it runs in the gates/CI. No new framework, runner, folder convention or one-off script for it.
4. **Temporary?** A test written only to check something while working (debug probe, scratch repro) is not kept:
   delete it, or turn it into a proper test that passes 1–3.
Unsure whether a test is worth keeping, or where it belongs → ask the user before adding it.
Evidence: per new test: `extended <existing test>` or `new: <why reuse did not fit> · <path> follows <existing
pattern> · runs in <gate>`; temporary tests removed

### TEST-CRITERIA [must]
When: level ≥ Medium
Claim: every done criterion and every edge case named in the scope has ≥1 test.
Verify: map criterion → test name.
Evidence: criteria ↔ evidence table

### TEST-E2E [must]
When: level Hard
Claim: each acceptance criterion has an E2E (or the closest top-level) test.
Verify: run the E2E suite.
Evidence: command + pass/fail counts

### TEST-TEETH [must]
When: level Hard
Claim: the tests catch real regressions.
Verify: break 1–2 key behaviors on purpose, confirm a test fails, restore.
Evidence: what was broken and which test failed

### TEST-EDGES [should]
When: level ≥ Medium
Claim: relevant edge cases are covered (write n/a for irrelevant ones).
Verify: consider empty / null / missing · boundaries (0, negative, max, off-by-one) · duplicates and ordering ·
invalid format and encoding (Unicode) · repeated or concurrent actions · a dependency failing or slow · reset and
idempotence · the profile's domain edge cases.
Evidence: tests per case, or n/a with reason

### DOC-FRAGMENT [should]
When: the profile's `## Docs` is on · level ≥ Medium · the diff changes a public interface, behavior, data or module
structure
Claim: a change fragment in `<root>/_changes/` covers the change (modules, what changed, plan/ADR links), and an ADR
exists for each architecture decision.
Verify: list the fragments and ADRs in the diff; compare their `modules:` with the modules the diff touches.
Evidence: fragment/ADR paths, or n/a with reason

### TEST-EVIDENCE [must]
When: always
Claim: test results in the report are real.
Verify: give the commands and their pass/fail counts; never write "tested" without output.
Evidence: command output
