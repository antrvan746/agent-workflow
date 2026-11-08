---
name: wf-lessons
description: Turn what a task taught into proposed hooks (plan, execute or verify) - defects found late, the user correcting the approach, and practices the user confirmed as good - so the next task repeats what worked and avoids what did not. Use at report time of any task with a late defect, a correction or a confirmed practice, or when the user asks to learn from a task.
---

# Lessons

## Sources
- **Defect**: found after execution by the reviewer, the user or a failing gate.
- **Correction**: the user redirected the approach ("don't do X, do Y", "wrong layer", "use our script for that").
- **Confirmed practice**: the user approved a non-obvious choice ("good, keep doing it this way"). Obvious or
  already-written practices are not lessons.

During the task, note each one the moment it happens as `⚑ lesson candidate: <one line>` and keep working; propose
at report time, not mid-task.

## Steps
1. List the candidates, one line each, with their source.
2. Filter:
   - one-off typos, and anything true only for this task: drop;
   - preferences about how to talk or report (tone, language, length): not a hook; suggest a memory entry instead;
   - a repeatable action or check for this kind of work: keep.
3. For each kept candidate, pick the phase that should carry it: plan (an action or risk to plan for), execute (a
   skill, tool, command or step), verify (a check). Propose the smallest hook in the shared format, or a sharper
   wording of an existing hook, and where it belongs:
   - global: `wf-plan`, `wf-execute`, or a `wf-verify` pack (`$W/skills/…`), when it applies to most projects;
   - project: the matching section (`## Plan`, `## Execute`, `## Verify`) of the project profile.
   Number them (L1, L2 …) so the user can answer per line.
4. Show the proposed diffs and wait for the user's answers. Never edit hooks without approval.
5. Apply the approved ones. In the workflow repo, note each in `$W/CHANGELOG.md` (date, source, new hook); commit only
   if the user asks. Log a `lesson` row per applied hook when the profile sets `log:` (`$W/templates/report.md` "Hook log rows").
