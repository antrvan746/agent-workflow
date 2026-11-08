---
name: wf-lessons
description: Turn defects caught by the reviewer or the user into proposed hooks (plan, execute or verify), so the same class of mistake is prevented or caught next time. Use after Medium/Hard tasks when a defect was found late, or when the user asks to learn from a mistake.
---

# Lessons

1. List defects found after execution (by the reviewer, the user, or a failing gate), each in one line.
2. For each, ask which phase could have stopped it: plan (a missing action or risk), execute (a missing skill, tool
   or step) or verify (a missing check). Skip one-off typos.
3. Propose the smallest new hook in the shared format (or a sharper wording of an existing one), and where it belongs:
   - global: `wf-plan`, `wf-execute`, or a `wf-verify` pack in the workflow repo (`$W/skills/…`), when it applies to
     most projects;
   - project: the matching section (`## Plan`, `## Execute`, `## Verify`) of the project profile.
4. Show the proposed diff and wait for the user's approval. Never edit hooks without it.
5. After approval: apply it; if the change is in the workflow repo, note it in `$W/CHANGELOG.md`
   (date, defect, new item) and commit only if the user asks.
