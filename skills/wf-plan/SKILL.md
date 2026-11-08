---
name: wf-plan
description: Plan phase for Medium/Hard project tasks - scope, brainstorm, approaches, plan.md - plus global and project plan hooks. Use when starting a Medium or Hard task, when escalating mid-task, or when the project profile defines plan hooks.
---

# Plan phase

Goal: agree on what "done" means, how it will be proven and which risks matter, before writing code.

## Procedure
1. **Select hooks**: the global hooks below + `## Plan` of the project profile (WORKFLOW.md "Profile and hooks").
   Apply `off` / strength overrides, match `When` against type, level and the Risk map tags of the paths you expect to
   touch. List the selected IDs.
2. **Medium (scope, ≤10 lines)**: goal, in/out, declarations, done criteria, selected hooks. Ask ≤3 questions only
   if the answer changes the approach; otherwise proceed with ⚠️ assumptions.
3. **Hard (plan)**: fill `$W/templates/plan.md`, run every selected hook, then **stop for approval**.
4. Each selected hook's `Output` must appear in the scope or plan. A `should` hook may be skipped with a declared
   reason; a `must` hook may be skipped only if the user says so.

## Global hooks
### PLAN-DONE-CRITERIA [must]
When: level ≥ Medium
Do: write each done criterion so a test, command or screenshot can prove it; source = request, rubric or spec.
Output: "Done criteria"

### PLAN-EXT-SEARCH [must]
When: level Hard
Do: search external references (similar solutions, standards, docs, rubric); record what you took from them, or
that nothing relevant turned up.
Output: "External references found"

### PLAN-APPROACHES [must]
When: level Hard
Do: 2–3 approaches with trade-offs; pick one and say why.
Output: "Approaches"

### PLAN-GRILL [should]
When: level Hard and requirements are open or ambiguous
Do: resolve them with `mattpocock-skills:grilling` before planning steps.
Output: answers recorded as ✅ declarations

### PLAN-CONTRACT [must]
When: the task changes a contract (API, public props, data format, schema, CLI flags)
Do: list affected consumers and the compatibility strategy (version, migrate, or break with notice).
Output: "Risks" → contract impact

### PLAN-ROLLBACK [must]
When: migration, data rewrite, or tags `data`
Do: rollback steps and data safety (backup, reversible migration, dry run).
Output: "Risks" → rollback

### PLAN-STEPS [must]
When: level Hard
Do: split into steps that are each verifiable on their own; mark dependencies and which can run in parallel.
Output: "Steps"

### PLAN-VERIFY-SELECTION [should]
When: level ≥ Medium
Do: choose verify packs and check IDs for the areas the plan touches.
Output: "Verify selection"
