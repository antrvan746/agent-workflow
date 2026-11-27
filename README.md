# agent-workflow

A Claude Code workflow for any code project (company, personal, interview, kodwai): route each project task by
**type × level**, keep everything the AI assumed **visible**, and verify with gates and an independent reviewer.

## Install
```sh
git clone <this repo> ~/Workspace/personal-projects/agent-workflow
~/Workspace/personal-projects/agent-workflow/install.sh      # targets $CLAUDE_CONFIG_DIR or ~/.claude; run once per config dir
```
Uninstall: `./uninstall.sh [dir]`. Existing non-symlink skills with the same name are never overwritten.
Requires the mattpocock skills plugin (`mattpocock-skills:tdd`, `diagnosing-bugs`, `grilling`, …).

## What's inside
| Path | Purpose |
|---|---|
| `WORKFLOW.md` | Core rules, always loaded: scope, transparency, profile and hooks, type × level routing, flows, gates, reviewer, ship, external systems |
| `skills/wf-project-init` | Reads a project and proposes its `## Workflow` rules and workflow profile (no fixed presets) |
| `skills/wf-plan` | Plan phase procedure + global plan hooks |
| `skills/wf-execute` | Execute phase procedure + global execute hooks (type sequence, skills, parallel steps) |
| `skills/wf-verify` | Verify phase procedure, testing standard, check packs (`packs/security`, `backend`, `frontend`) |
| `skills/wf-lessons` | Turns late defects, user corrections and confirmed practices into proposed hooks (user approves) |
| `skills/wf-retro` | Reads the hook log; proposes pruning, narrowing, upgrading or promoting hooks (user approves) |
| `skills/wf-audit` | Checks rules and profile against the current code (or `$W` with `--global`); raises D-lines, applies approved ones |
| `skills/wf-docs` | Optional docs management (off by default): `init` scaffolds living docs per module from the code, `sync` merges change fragments into them and cleans agent memory, `memory` cleans memory on its own |
| `bin/wf-lint` | Deterministic drift/staleness checks, plus docs/memory upkeep when enabled; installed as a SessionStart hook (silent when clean) |
| `agents/wf-reviewer.md` | Independent read-only reviewer for Medium/Hard tasks |
| `templates/` | Plan, report, decision log, ADR, workflow profile; `templates/docs/` for wf-docs (index, overview, onboarding, glossary, module, change fragment) |

## Using it in a project
1. Open Claude Code in the project and ask: "run wf-project-init". Confirm or correct the proposed rules.
2. Work normally. Questions and discussion are answered directly; project tasks get an Analyze line
   (`Type · Level · Understanding`) and the matching flow.
3. Steer with prefixes: `quick:` / `medium:` / `deep:` (or `nhanh:` / `vừa:` / `kỹ:`).

## Customizing a project
`.claude/workflow-profile.md` extends the three phases with hooks in one format
(`### <ID> [must|should]` + When / Do / Output; verify checks: When / Claim / Verify / Evidence):
- **Risk map**: path globs → tags and minimum level, shared by every phase.
- **Plan**: extra actions the plan must contain (e.g. map rubric criteria to steps).
- **Execute**: required skills, tools and commands (e.g. run codegen after editing the schema).
- **Verify**: which packs apply, how to run the app, domain edge cases, project checks.
- Turn a global hook off with `off: <ID> — <reason>` or change its strength with `<ID>: must|should`.

## Learning loop
When the profile sets `log:` (e.g. `.scratch/workflow/hook-log.md`), each task appends its matched hooks to that log;
every task ends with lesson proposals (`wf-lessons`). Every ~20 Medium/Hard tasks the report suggests `wf-retro`, which removes hooks that never catch
anything, narrows ones that match wrongly, upgrades `should` hooks that keep catching defects, and promotes hooks
shared by several projects to global.

## Staying up to date
`install.sh` adds a SessionStart hook that runs `bin/wf-lint`. In a project with a profile it reports dead paths,
missing gate commands or skills, unknown override IDs, changed top-level dirs, and staleness (>30 days or ≥20 commits
touching manifests/CI/docs since `reviewed:`). It prints nothing when clean. When it reports, the AI suggests
`wf-audit`, which raises numbered issues (D1, D2 …) and applies only what you approve. Run `bin/wf-lint --global` or
`wf-audit --global` for the workflow repo itself.

## Documentation (optional)
Off by default; turn it on with "run wf-docs init" (or answer yes in `wf-project-init`). Docs come in two kinds:
**living** docs (`overview.md`, `onboarding.md`, `glossary.md`, one `modules/<name>/README.md` per module with the
same 9 sections) always describe the current code; **timeline** docs (immutable ADRs, plans, and change fragments in
`_changes/`) record what happened when. Each Medium/Hard task that changes an interface or behavior adds a fragment;
when fragments pile up or a module's code moves on, wf-lint suggests `wf-docs sync`, which checks the code, rewrites
the affected docs, deletes merged fragments, archives done plans and proposes memory clean-ups (M-lines you approve).
The code is the source of truth; docs explain it. Diagrams are Mermaid. Level 0 is plain Markdown that is already
Docusaurus-compatible; a Docusaurus site (level 1) or interactive architecture (level 2) is proposed only when the
project's size calls for it, and only with your OK. Docs are written as short statements with flows and diagrams;
decisions go into ADRs with guardrails. Optional translations (`locales: en, vi`) are derived from the source
language, tracked with `translated_from:` and refreshed by `sync` when the source changes.

## Keeping control without reading all the code
- Read the ⚠️ lines in each report and answer them specifically (only then they become ✅).
- Check "Not done / not verified" and "Least confident" in each report.
- Browse the project's decision log (if enabled in `### Decision log`) and its ADRs.
