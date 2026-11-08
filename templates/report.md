# Report templates

## Easy (1–3 sentences + declarations line)
<What was done>. `<relevant gate>` → <result>.
Declarations: <⚠️ … | None> · Hooks: <IDs done / skipped (why) | None> · Not verified: <… | None>
Reviewer (if the project enables it): <VERDICT; fixed …>

## Medium / Hard
**Result:** <1–2 sentences: done / not done, why>
**Understanding:** <one line>

**Declarations** (read the ⚠️ lines)
| # | Kind | Content | Status | Where in code |
|---|---|---|---|---|
| A1 | Default | <…> | ⚠️ unconfirmed | `<file:line>` |
| A2 | Decision | <…> | ✅ user chose this | `<file>` |
| A3 | Assumption | <…> | ⚠️ not objected at plan approval | `<file>` |
(None → write "None")

**Done criteria ↔ evidence**
| Criterion | Status | Evidence |
|---|---|---|
| | ✅/❌ | <test name, command, screenshot> [verified] |

**Hooks matched**
- Plan: <ID done | ID skipped — why | None>
- Execute: <…>

**Verify checks**
| ID | Result | Evidence |
|---|---|---|
| <SEC-AUTHZ> | Pass / Fail `file:line` / n/a (why) | <test, command, screenshot> |

**Gates:** `<command>` → <x passed / y failed>

**Reviewer:** <VERDICT>. Fixed: <…>. Not fixed (why): <…>. (UNDECLARED findings were added to the table above.)

**Not done / not verified:** <skipped, deferred, unverified, deviations from the workflow | None>

**Least confident (worth a look):**
1. <spot> — <why>

**Lessons proposed:** <hook proposals (wf-lessons) | None>
