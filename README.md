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
| `WORKFLOW.md` | Core rules, always loaded: scope, transparency, type × level routing, flows, gates, reviewer, ship, external systems |
| `skills/wf-project-init` | Reads a project and proposes its `## Workflow` rules (no fixed profiles) |
| `skills/wf-review-*` | Frontend / backend / security checklists, loaded only when relevant |
| `skills/wf-testing-standard` | What each level must test |
| `skills/wf-lessons` | Turns late-found defects into proposed checklist items (user approves) |
| `agents/wf-reviewer.md` | Independent read-only reviewer for Medium/Hard tasks |
| `templates/` | Plan, report, decision log, ADR |

## Using it in a project
1. Open Claude Code in the project and ask: "run wf-project-init". Confirm or correct the proposed rules.
2. Work normally. Questions and discussion are answered directly; project tasks get an Analyze line
   (`Type · Level · Understanding`) and the matching flow.
3. Steer with prefixes: `quick:` / `medium:` / `deep:` (or `nhanh:` / `vừa:` / `kỹ:`).

## Keeping control without reading all the code
- Read the ⚠️ lines in each report and answer them specifically (only then they become ✅).
- Check "Not done / not verified" and "Least confident" in each report.
- Browse the project's decision log (if enabled in `### Decision log`) and its ADRs.
