# Workflow profile: <project>
<!-- Per-project extensions of the plan, execute and verify phases. Format: WORKFLOW.md "## Profile and hooks".
     Drafted by wf-project-init on YYYY-MM-DD. ⚠️ = not yet confirmed by the user.
     Hook: `### <ID> [must|should]` + When / Do / Output (verify checks: When / Claim / Verify / Evidence).
     When selectors: type, level, paths, tags, or free text (free-text matches are declared with ⚑).
     Overrides of global hooks: `off: <ID> — <reason>` · `<ID>: must|should`. Delete sections you do not need. -->

## Risk map
<!-- path glob → tags, minimum level. Tags drive hook selection in every phase. -->
- `<glob>` → tags: <tag, tag> · level ≥ <Medium|Hard> — <why>

## Plan
<!-- Global hooks: wf-plan. Add actions the plan must contain for this project. -->
- defaults: on
<!-- off: PLAN-EXT-SEARCH — <reason> -->

<!--
### <PREFIX>-<NAME> [must]
When: type Feature · level ≥ Medium
Do: <extra planning action>
Output: <where it appears in the scope/plan>
-->

## Execute
<!-- Global hooks: wf-execute. Required skills/tools, codegen, checkpoints, environment setup. -->
- defaults: on

<!--
### <PREFIX>-<NAME> [must]
When: paths `prisma/schema.prisma`
Do: run `pnpm prisma generate` after editing the schema
Output: command output in the report
-->

## Verify
<!-- Global checks: wf-verify and its packs. -->
- packs: <security, backend, frontend>
- environments: <how to run the app, seed data, test accounts — never real secrets>
- edge cases (domain): <project-specific inputs worth testing>
<!-- off: FE-RESPONSIVE — <reason>   ·   BE-PAGINATION: must -->

<!--
### <PREFIX>-<NAME> [must]
When: paths `src/billing/webhooks/**`
Claim: <what must be true>
Verify: <command / test / action that proves it>
Evidence: <what goes in the report>
-->

## Invariants
<!-- Domain rules every phase must respect, e.g. "money is integer cents". -->
