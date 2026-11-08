---
name: wf-audit
description: Audit whether a project's workflow rules and profile (or the workflow repo itself with --global) still match the codebase - dead paths, missing commands or skills, new areas or frameworks not covered, hooks describing processes the code no longer has - then raise numbered issues and apply only the ones the user approves. Use when wf-lint (SessionStart) reports drift or staleness, when the user asks to re-check or audit the workflow, or after big structural changes.
---

# Audit

Goal: keep the project's `## Workflow` and profile true to the codebase as it changes. `wf-retro` asks "are the hooks
useful?" (from the hook log); the audit asks "are they still correct?" (from the code). Never edit without approval.

## Project mode (default)
1. **Deterministic checks**: run `$W/bin/wf-lint <project>` and keep its output. Every line is a candidate issue.
2. **What changed**: read `reviewed: <date> @ <commit>` from the profile. With a commit, run
   `git diff --stat <commit>..HEAD` and read the diffs of manifests, CI, lint/test configs, CONTRIBUTING, README and
   top-level directories. Without one, compare against the whole repo.
3. **Re-gather signals** as in `wf-project-init` step 1, then compare with the current rules and profile:
   - areas (top-level dirs, new packages/apps) not covered by the Risk map, or entries for areas that are gone;
   - frameworks/stacks added or removed vs `packs:` (e.g. a UI appeared, no `frontend` pack);
   - gate commands vs current scripts and CI (renamed, replaced tool, new required check);
   - hooks whose `Do`/`Verify` describe a tool or process the repo no longer uses, or miss a new one (codegen,
     migrations, i18n);
   - `environments`, invariants and Context facts contradicted by the code or docs;
   - nature changes (personal → organization remote, CODEOWNERS added) that change Ship / External systems policy.
4. **Usefulness**: if the hook log has ≥20 Medium/Hard tasks since its last retro, run `wf-retro` too and merge its
   R-lines into the list.
5. **Raise issues**: one numbered line each (D1, D2 …): `kind (drift | stale | gap | contradiction) · evidence
   [verified] · proposed change`, with the diff to the profile or `## Workflow`. Most important first. For a wf-lint
   line that may be intentional, offer both options: fix it, or keep it and add `lint-ignore: <text>` to the profile so
   the SessionStart hook stops repeating it.
6. **Wait** for answers per line ("D1 yes", "D2 ignore", "D3 no"). An unanswered line stays unapplied. A plain "no"
   on a wf-lint line will come back next session; say so and offer `ignore`.
7. **Apply** the approved changes, run `$W/bin/wf-lint <project>` again and show its output.
8. **Close the audit** (also when nothing was found or every line was rejected): set the profile's `reviewed:` line to
   today and `git rev-parse --short HEAD`. This bookkeeping edit needs no approval (WORKFLOW.md "Staleness"); list it
   and every unapplied line in the reply. Commit only if the project's Ship rules or the user allow it.

## Global mode (`--global`, the workflow repo `$W`)
1. Run `$W/bin/wf-lint --global`: hook format, duplicate IDs, referenced skills that are not installed (e.g. a renamed
   mattpocock skill), `wf-*` names that do not exist.
2. For each missing skill, look for its replacement in the installed plugins (same plugin, similar name or
   description) and propose the rename.
3. Raise D-lines and apply only approved ones as in project mode; note each in `$W/CHANGELOG.md` (date, issue,
   change). Commit only if the user asks.

## Notes
- `wf-lint` is a heuristic: a reported path or command can be intentional (e.g. a glob for files not created yet).
  Say so in the D-line rather than proposing a blind deletion.
- Keep the proposal minimal: fix what drifted; do not redesign the profile (that is `wf-project-init`).
