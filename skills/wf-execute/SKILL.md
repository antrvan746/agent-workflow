---
name: wf-execute
description: Execute phase for project tasks - follow the task type's sequence, apply global and project execute hooks (required skills, tools, codegen, checkpoints), run independent steps in parallel safely, escalate when scope grows. Use when executing a Medium/Hard task, or an Easy task of type Prototype or with a matching execute hook in the project profile.
---

# Execute phase

Goal: build exactly what was agreed, with the project's own tools, keeping every choice visible.

## Procedure
1. **Select hooks**: the global hooks below + `## Execute` of the project profile. Apply overrides, match `When`,
   list the selected IDs. Easy (loaded only for Prototype or a matching profile hook): those hooks + `always` ones.
2. **Follow the task type's sequence** (WORKFLOW.md "Task types"). What to test and at which layer: `wf-verify`
   → "Testing standard".
3. **Per step** (plan steps, or the scope for Medium): change → run that step's "Verified by" → checkpoint. A
   checkpoint is a commit only if Ship allows it.
4. **Skills named by hooks**: a `must` hook's skill is mandatory; prefer a project skill over a general one. When a
   skill step conflicts with Transparency, Ship or External systems, skip that step and list it under "Not done".
5. **Declare** `⚑` the moment an assumption, default or decision arises; keep going unless it changes scope, breaks a
   contract or is hard to reverse.
6. **Escalate** when the work outgrows its level (WORKFLOW.md "Task levels").
7. **Parallel**: independent steps may go to subagents or worktrees. Each must return `⚑ Declarations` and the
   commands it ran with their output; merge, then re-run the gates yourself.

## Global hooks
### EXEC-TYPE-SEQUENCE [must]
When: level ≥ Medium
Do: follow the type's sequence in WORKFLOW.md "Task types" (skills named there included).
Output: tests written before code, or the repro before the fix, visible in the transcript

### EXEC-CONVENTIONS [must]
When: adding a file, module, pattern or dependency
Do: find an existing equivalent in the repo and follow it; a new library or a new pattern is a `⚑ decision`.
Output: declaration when no equivalent exists

### EXEC-SMALL-STEPS [should]
When: level ≥ Medium
Do: vertical slices; keep build and touched-area tests green between steps.
Output: test run after each step

### EXEC-NO-SCOPE-CREEP [must]
When: always
Do: no unrequested refactors or features; note them as follow-ups in the report.
Output: "Not done" / follow-ups

### EXEC-PROTOTYPE [must]
When: type Prototype
Do: throwaway and clearly marked; `mattpocock-skills:prototype` without its commit/branch/issue steps.
Output: conclusion in the report
