---
name: wf-project-init
description: Read a project and propose its workflow rules (the `## Workflow` section of its CLAUDE.md) instead of a fixed profile. Use when a project has no `## Workflow` section, when the user asks to set up or re-check project rules, or when the project's nature changed.
---

# Project init

Goal: derive rules that fit **this** project from evidence, let the user confirm them, then write them down.
No hard-coded profiles: every rule must cite the signal it came from.

## 1. Gather signals (read-only)
- `README*`, `CONTRIBUTING*`, `CODEOWNERS`, `PROBLEM.md`, `.kodwai/`, existing `CLAUDE.md` / `AGENTS.md`.
- Manifests and scripts: `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Makefile`, `justfile`.
- Quality tooling: lint/format/typecheck configs, test directories, e2e config.
- CI: `.github/workflows/`, `.gitlab-ci.yml`, others. Branch protection hints in docs.
- Git: `git remote -v` (personal account vs organization), default branch, recent commit message style.
- Size and shape: top-level directories (these become "areas"), languages, frontend/backend split.

## 2. Infer the project's nature (as a declaration, not a profile)
State it with evidence, e.g. "Looks like a company service [inferred]: remote under org `acme`, CODEOWNERS, CI with
required checks." Typical signal → rule mappings to consider (adapt, do not copy blindly):

| Signal | Rules to consider |
|---|---|
| Organization remote, CODEOWNERS, protected-branch CI, CONTRIBUTING | Follow existing conventions; branch + PR, never push to default; no CI/dependency/schema change without asking; security checklist always; no external services; rules in `CLAUDE.local.md`; decision log Off or outside the repo; use the repo's existing ADR location if any |
| Personal remote, no CI, small codebase | Wider Easy band; reviewer optional for Medium; decision log optional |
| `PROBLEM.md`, time limit, interview/challenge wording, `.kodwai/` | Rubric/problem as done criteria; commit per step to show decomposition; README records decisions; visible verification |
| Payment, auth, PII, migrations directories | Changes there are at least Hard |
| No tests or gates | Propose gate commands to add first |

## 3. Propose the section
Fill `templates/workflow-section.md` (next to this file). Every rule gets a short reason with its evidence label.
Present the choices that matter as numbered questions (Q1, Q2 …), each with a recommended answer. Always include:
- **Where to store the rules**: `CLAUDE.md` (shared with the team, committed) or `CLAUDE.local.md` (personal, not
  committed). Recommend `CLAUDE.local.md` for repos you do not own alone.
- **Decision log**: path inside the repo, outside the repo (e.g. `~/notes/<project>-decisions.md`), or Off.
"ok" to that message answers exactly the questions it listed (✅). Rules that were not asked as questions are written
with ⚠️ until the user confirms them individually.

## 4. Write
After the user answers: append (or update) the `## Workflow` section in the chosen file. Never delete other content.
If `CLAUDE.local.md` is chosen, check it is git-ignored (Claude Code ignores it by convention; add it to `.gitignore`
only with the user's consent). Show the final section in the reply.
