---
name: wf-lessons
description: Turn defects caught by the reviewer or the user into proposed checklist items, so the same class of mistake is caught next time. Use after Medium/Hard tasks when a defect was found late, or when the user asks to learn from a mistake.
---

# Lessons

1. List defects found after execution (by the reviewer, the user, or a failing gate), each in one line.
2. For each, ask: would a checklist or testing-standard item have caught it before review? Skip one-off typos.
3. Propose the smallest new item (or a sharper wording of an existing one), and where it belongs:
   - global: a `wf-*` skill in the workflow repo (`$W/skills/…`), when it applies to most projects;
   - project: the project's `.claude/skills/review-<area>/` or its `## Workflow` section.
4. Show the proposed diff and wait for the user's approval. Never edit checklists without it.
5. After approval: apply it; if the change is in the workflow repo, note it in `$W/CHANGELOG.md`
   (date, defect, new item) and commit only if the user asks.
