# Report templates

## Easy (1–3 sentences + declarations line)
<What was done>. `<relevant gate>` → <result>.
Declarations: <⚠️ … | None> · Hooks: <IDs done / skipped (why) | None> · Not verified: <… | None>
Lessons: <L1 … | None> (hook log: only non-plain rows)
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

**Docs:** <fragment `<path>` · ADR `<path>` | n/a (why) | off> <· suggest wf-docs sync (wf-lint threshold reached)>

**Not done / not verified:** <skipped, deferred, unverified, deviations from the workflow | None>

**Least confident (worth a look):**
1. <spot> — <why>

**Lessons proposed:** <L1 … from defects / corrections / confirmed practices (wf-lessons) | None>
**Hook log:** <n rows appended to `<path>` | off (no `log:` in profile)> <· suggest wf-retro (≥20 Medium/Hard tasks since last retro)>

## Hook log rows
Only when the profile sets `log:`. Append before writing the report. Medium/Hard: one row per matched hook. Easy: only
rows that are not plain `done`/`pass` (wf-retro ignores Easy rows for ratios and task counts).
```
| YYYY-MM-DD | <task, ≤8 words> | <level> | <ID> | <status> | <caught: yes/no> | <note> |
| 2026-11-08 | add export endpoint | Medium | SEC-AUTHZ | fail | yes | IDOR on /export/:id, fixed |
| 2026-11-08 | add export endpoint | Medium | -         | missed | -  | CSV injection found by user |
| 2026-11-08 | add export endpoint | Medium | BE-CSV-ESCAPE | lesson | - | added via wf-lessons L1 |
```
status: `done`, `skipped`, `pass`, `fail`, `n-a`, `mismatch` (matched but did not apply), `missed` (ID `-`: a defect
found late that no hook caught), `lesson` (hook added by wf-lessons). `caught: yes` = the hook found a real defect or
changed the plan or code; `-` for missed/lesson rows.
