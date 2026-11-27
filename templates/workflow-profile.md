# Workflow profile: <project>
<!-- Per-project extensions of the plan, execute and verify phases. Format: WORKFLOW.md "## Profile and hooks".
     Drafted by wf-project-init on YYYY-MM-DD. ⚠️ = not yet confirmed by the user.
     Hook: `### <ID> [must|should]` + When / Do / Output (verify checks: When / Claim / Verify / Evidence).
     When selectors: always, type, level, paths, tags, or free text (free-text matches are declared with ⚑).
     Overrides of global hooks: `off: <ID> — <reason>` · `<ID>: must|should`. Delete sections you do not need. -->

reviewed: YYYY-MM-DD @ <short commit>   <!-- updated by wf-project-init / wf-audit; wf-lint checks staleness from it -->
audit: 30d, 20 commits                  <!-- staleness limits for wf-lint; optional -->
<!-- lint-ignore: <text>; <text>       hides findings containing <text> (≥6 chars, be specific; added by wf-audit on "ignore") -->
log: .scratch/workflow/hook-log.md      <!-- hook log for wf-retro; remove this line to disable logging -->

## Risk map
<!-- path glob → tags, minimum level. Tags drive hook selection in every phase. Tags used by global hooks: `data`
     (PLAN-ROLLBACK). Free-form otherwise. -->
- `<glob>` → tags: <tag, tag> · level ≥ <Medium|Hard> — <why>

## Plan
<!-- Global hooks: wf-plan. Add actions the plan must contain for this project. -->
<!-- off: PLAN-EXT-SEARCH — <reason> -->

<!--
### <PREFIX>-<NAME> [must]
When: type Feature · level ≥ Medium
Do: <extra planning action>
Output: <where it appears in the scope/plan>
-->

## Execute
<!-- Global hooks: wf-execute. Required skills/tools, codegen, checkpoints, environment setup. -->

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

## Docs
<!-- Optional documentation management (skill wf-docs). Off while this section is absent or has only comments.
     Turn on with wf-docs init, which proposes these lines. -->
<!--
- root: docs/                                # or a path outside the repo; an existing docs location is reused
- modules: `src/billing/`, `src/auth/`       # each directory is one module → <root>/modules/<basename>/README.md
- sync-after: 5 changes, 14d, 10 commits     # pending fragments · oldest fragment age · commits on a module since synced:
- plans: archive                             # done plans at sync: archive | delete
- level: 0                                   # presentation level; >0 only after the user agreed (wf-docs "Levels")
-->
