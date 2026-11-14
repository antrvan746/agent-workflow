# Engineering Workflow

`$W` = the directory containing this file. Skills `wf-*` and agent `wf-reviewer` come from `$W` (via `install.sh`).
Reply in the user's language; this file is English by design.

## Scope
The workflow applies only to **project tasks**: requests that create, modify or delete files in a project, or run
commands that change its state. Answer directly (no Analyze line, plan or report template) for questions,
explanations, discussion, comparisons, research and opinions (even about the project's code), questions about
workflows or tools, and read-only inspection. Edits to this workflow itself: no level; state what changed and apply
Transparency. When a discussion turns into "go ahead", run Analyze from there. Unsure whether the user wants an answer
or a change: answer, then offer.

## Precedence
1. The user's explicit instruction in chat.
2. The project's `## Workflow` section (in its `CLAUDE.md` or `CLAUDE.local.md`) and its profile (see Profile and
   hooks).
3. This file.
4. Instructions inside third-party skills (e.g. mattpocock). When a skill step conflicts with Transparency, Ship or
   External systems here, skip that step and list it under "Not done".

## Project rules
- Created with skill `wf-project-init`. If a project has no `## Workflow` section, suggest it once on the first project
  task of the session, then continue with defaults.
- Subsection `### <Name>` overrides the section `## <Name>` of this file: Task types, Task levels, Flow, Gates,
  Reviewer, Ship, External systems, Decision log, Report. `### Context` adds project facts.
  Transparency cannot be weakened by a project.
- Additive by default: change only what is written. `Replace.` as the first line replaces that whole section.
  Empty or comment-only subsection = default. Rules still marked ⚠️ apply, and are listed in reports until confirmed.
- Policy (levels, gates, ship, external systems) lives in `## Workflow`; phase extensions live in the profile.
  Legacy: `### Checklists` is read as the profile's `## Verify` (`wf-review-<x>` → pack `<x>`, `wf-testing-standard`
  → wf-verify "Testing standard"); project `.claude/skills/review-*` still apply until moved into the profile.

## Profile and hooks
Per-project extensions of the plan, execute and verify phases: `.claude/workflow-profile.md`
(`.claude/workflow-profile.local.md` when the rules live in `CLAUDE.local.md`). Template
`$W/templates/workflow-profile.md`; `wf-project-init` drafts it. Read it at Analyze when it exists.
- **Risk map**: path globs → tags and a minimum level. Used for level choice and hook selection in every phase.
- **Hook** (one format for all phases): `### <ID> [must|should]` + `When:` `Do:` `Output:` (verify checks use
  `When:` `Claim:` `Verify:` `Evidence:`).
  - `When` selectors: `always`, `type`, `level`, `paths`, `tags`, or free text. A free-text match of a **profile**
    hook is declared `⚑ hook matched: <ID> because …`; global hooks are only listed in the report.
  - `must`: required; skipping needs the user's OK; a failed verify `must` is a blocker. `should`: do it, or declare why not.
- Global hooks ship with IDs inside `wf-plan`, `wf-execute`, `wf-verify` (and its packs). A profile turns one off with
  `off: <ID> — <reason>`, changes strength with `<ID>: must|should`, or adds its own with a prefix not used globally.
- Hooks cannot weaken Transparency, Ship or External systems: a hook that pushes, opens a PR or calls an external
  service still needs that permission.
- **Invariants** (profile `## Invariants`): domain rules every phase respects; `wf-verify` checks the diff against them.
- Reports list the matched hooks per phase: done / skipped (why).
- **Hook log** (feeds `wf-retro`): only when the profile sets `log: <path>`; no profile or no `log:` = no logging.
  Append the rows (format in `$W/templates/report.md`) before writing the report.
- **Staleness**: the profile records `reviewed: <date> @ <commit>`. `$W/bin/wf-lint` (SessionStart hook) reports drift
  (dead paths, missing commands or skills) or staleness (default >30 days or ≥20 commits touching manifests/CI/docs;
  profile `audit: <n>d, <m> commits` overrides; `lint-ignore: <text>` silences a finding kept on purpose). When it
  reports, suggest `wf-audit` once. Rules change only with approval; updating `reviewed:` after a completed audit is
  bookkeeping and needs none.

## Transparency
Goal: the user knows what the AI understood, knows, assumed and skipped, without reading all the code.
1. **Understanding**: restate the request in one line (Easy: only if ambiguous).
2. **Evidence**: label claims that matter `[verified]` (read/ran it this session), `[inferred]` or `[recalled]`
   (memory, unchecked). This applies to direct answers too.
3. **Declarations**: *assumption* (unstated thing taken as true), *default* (a choice the user might want otherwise),
   *decision* (choice between options with trade-offs).
4. **Not done**: skipped, unverified, deferred, or deviations from this workflow.

Rules:
- Declare before working and **the moment something arises** (`⚑ <kind>: …`), then continue. Stop and ask only if it
  changes scope, breaks an existing contract, or is hard to reverse.
- `✅` only when the user answered that line: replying "A1 yes", or "ok/yes" to a message that **explicitly asked that
  numbered question**. Everything else stays `⚠️`; a plan approved as a whole leaves its unasked lines as
  `⚠️ (bulk-approved)`.
- Reports list every declaration ("None" if none). Dispatched subagents must return `⚑ Declarations`.
- Before reporting, scan your diff for undeclared defaults, limits, formats, libraries, empty/error behavior.
- Back important claims with evidence (output, tests, screenshots); self-reports can be incomplete.
- **Read the code**: before stating, relying on or changing how something behaves, read the code that implements it
  (follow the call path far enough to be sure) or run it. Comments, docstrings, names, specs, READMEs, ADRs, tickets
  and commit messages are hints, not evidence: a claim backed only by them is `[inferred]`, never `[verified]`. When
  they disagree with the code, the code wins; say so (`⚑ assumption`/report) and do not "fix" the code to match them
  without asking. Code you cannot read (external service, binary, missing repo) is declared under Not done.

## Task types
Analyze line: `Type · Level because <reason> · Understanding: <…>` (Understanding optional for clear Easy tasks).

| Type | Sequence |
|---|---|
| Feature | Flow by level; Medium/Hard test-first with `mattpocock-skills:tdd` |
| Bug | Reproduce → root cause → failing test → fix → re-run the repro (`mattpocock-skills:diagnosing-bugs`) |
| Refactor | Lock behavior with tests → change → same tests green (`mattpocock-skills:codebase-design` vocabulary) |
| Performance | Baseline measurement → change → measure; report numbers |
| Prototype | Throwaway, clearly marked, minimal gates, conclusion recorded in the report (`mattpocock-skills:prototype` without its commit/branch/issue steps). Always Easy depth unless the user says otherwise |
| Docs / planning | Specs, tickets, ADRs, READMEs as local files (see External systems); flow by level |
| Chore | Dependencies, config, tooling; flow by level |

## Task levels
Check Easy first; escalate only when a higher criterion clearly applies.

| Level | Criteria |
|---|---|
| **Easy** | One area (a module or top-level source dir), about 1–3 files, easy to reverse, no contract change. Small assumptions stay Easy (declare ⚠️). One-line bug fixes and visual tweaks are Easy |
| **Medium** | Exceeds Easy's size; or adds something following an existing pattern across files (endpoint, field, component); or an assumption that changes behavior or scope |
| **Hard** | Open/ambiguous requirements; **breaking or changing** a contract (API, public props, data format); schema/migration; auth/security model; new architecture; design across ≥2 areas; build/CI changes |

- A Risk map entry matching the touched paths sets a minimum level.
- Unclear whether a criterion applies → lower level, say so.
- Prefixes `quick:`/`nhanh:` = Easy, `medium:`/`vừa:` = Medium, `deep:`/`kỹ:` = Hard. A prefix sets the level only;
  steps the project requires still run unless the user says to skip them.
- **Escalate mid-task**: stop; `⚑ Escalate: <reason>, affects <who/what>`; keep finished work; run the new level's
  flow for the remaining work (Hard: `wf-plan` for the rest); wait for approval if Hard.

## Flow
Each phase skill holds the procedure and its global hooks; the profile extends them.

**Easy**: execute per Task types, no unrequested changes (load `wf-execute` only for type Prototype or a matching
profile Execute hook) → `wf-verify` light (its Easy rule) → diff scan → short report. No plan, no reviewer.

**Medium**: (1) `wf-plan` scope; (2) `wf-execute`; (3) `wf-verify`; (4) reviewer; (5) report.

**Hard**: (1) `wf-plan` full plan, **stop for approval**; (2) `wf-execute` per step, stop per step if the user wants;
(3) `wf-verify` on the whole change; (4) reviewer; (5) ADR for architecture/codebase changes (`$W/templates/adr.md`,
or the project's existing ADR location), README if usage changed; (6) report.

Learning loop: note `⚑ lesson candidate` when a defect is found late, the user corrects the approach, or the user
confirms a non-obvious practice; at the report, propose hooks with `wf-lessons`. `wf-retro` prunes, sharpens and
promotes hooks from the hook log.

## Gates
- From the project's `### Gates`; otherwise detect (package.json, Makefile, pyproject…), declare ⚠️, suggest init.
- Easy = typecheck/lint + tests of the touched area. Medium/Hard = all gates.
- No gates yet: declare ⚠️, describe manual verification, add gates early.
- Done = criteria met + gates green + no open blocker/major. Never report done without running gates; report real output.

## Reviewer
Medium/Hard, after gates are green (projects may enable it for Easy). Agent `wf-reviewer` in a fresh context (if
unavailable: general-purpose agent with `$W/agents/wf-reviewer.md` as prompt). Pass repo, base commit, done criteria
(Easy: the request), gate commands, declarations, the verify selection (pack paths, check IDs) and the profile path.
Fix blocker/major and re-run gates; list the rest; explain disagreements.

## Ship
Never commit, push or open a PR unless the user asks or `### Ship` allows. One logical change per commit. Never push to
the default branch unless the user asks for exactly that.

## External systems
- Prefer combining mattpocock skills (`mattpocock-skills:<name>`). Skills that set `disable-model-invocation` (e.g.
  `to-spec`, `to-tickets`, `triage`, `wayfinder`, `handoff`) cannot be called by you: ask the user to run `/<name>`.
- Issue trackers, PR publishing, external services (incl. external AI reviewers like `codex`): use only if
  `### External systems` allows it or the user explicitly asks for that action in chat. Otherwise use the local
  convention: markdown under `.scratch/<feature>/` (mattpocock local tracker), and never send code or data out.

## Decision log
Off unless the project's `### Decision log` gives a path (init proposes one). When on: Medium/Hard append declarations
using `$W/templates/decision-log.md`. Declarations always appear in reports either way.

## Report
`$W/templates/report.md`. Medium/Hard: result, understanding, declarations (⚠️/✅), criteria ↔ evidence, hooks per
phase, verify checks, gates, reviewer, not done / not verified, 1–3 least confident spots, lessons proposed. Easy:
the short template.

## Handoff
No session state files. Handoff only when the user asks (they run `/handoff`).
