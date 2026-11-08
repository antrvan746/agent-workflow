---
name: wf-retro
description: Retrospective over the hook log - find hooks that never catch anything, hooks that match wrongly, should-hooks that keep catching defects, and project hooks worth promoting to global - then propose pruning, rewording or promotion. Use when the user asks for a retro, or when the report suggests one (≥20 Medium/Hard tasks since the last retro).
---

# Retro

Goal: keep the hooks lean and useful. Lessons add hooks; the retro removes, sharpens and promotes them.
Never edit a hook, profile or global skill without the user's approval.

## Inputs
- The hook log of each project in scope (path: the profile's `log:`; no `log:` = nothing to read).
  Scope: the current project, or the project paths the user names.
- Their profiles, and the global hooks in `wf-plan`, `wf-execute`, `wf-verify` (and its packs).
- Only entries after the last `<!-- retro YYYY-MM-DD -->` marker, unless the user asks for all.
- Row format and status values: `$W/templates/report.md` → "Hook log rows".

## Steps
1. **Tally per ID**: tasks matched, done, skipped, pass, fail, caught, mismatch. Also count `missed` and `lesson`
   rows. Ratios and task counts use Medium/Hard rows only (Easy logs only notable rows); Easy rows still count as
   evidence for `caught`, `mismatch` and `missed`. Easy-only hooks (e.g. TEST-EASY) cannot be judged by ratios or the
   never-matched signal; judge them only by `mismatch` and `missed` rows.
2. **Propose**, one numbered line each (R1, R2 …), with the numbers behind it:

   | Signal | Proposal |
   |---|---|
   | matched ≥10, caught 0, fail 0 | remove it (project hook), or `off:` / downgrade to `should` (global hook, from the project profile) |
   | mismatch ≥2, or ≥30% of matches | narrow `When` (prefer `paths`/`tags` over free text) |
   | skipped ≥50% of matches | `should` is ignored in practice: drop it, or make it `must` if the skips caused misses |
   | `should` with caught ≥2 | upgrade to `must` |
   | the same `missed` class ≥2 times | new hook via `wf-lessons` |
   | similar project hooks in ≥2 profiles, or one `off:` of the same global hook in ≥2 profiles | promote to global, or fix/narrow the global hook |
   | hook that never matched since it was added (≥20 tasks) | check its `When`; remove if obsolete |

   Thresholds are defaults; small logs give weak signals, so say how many tasks each number rests on.
3. **Show the diffs** of the proposed changes and wait for answers per line ("R1 yes, R3 no").
4. **Apply** approved changes. Global changes go into `$W/skills/…` and `$W/CHANGELOG.md` (date, signal, change);
   commit only if the user asks.
5. **Mark**: append `<!-- retro YYYY-MM-DD: R1, R3 applied -->` to each log reviewed.
