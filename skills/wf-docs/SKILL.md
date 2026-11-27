---
name: wf-docs
description: Optional documentation management for a project - `init` (map existing docs, scaffold living docs per module from the code), `sync` (merge pending change fragments into the living docs after checking the code, archive done plans, then clean agent memory), `memory` (clean agent memory; works even when docs are off). Use when the user asks to set up, sync or clean docs or memory, when wf-lint reports `[docs]` or `[memory]` issues, or when the profile's `## Docs` is on and pending fragments pile up.
---

# Docs

Goal: humans can understand the system quickly (onboarding, high-level design) and still trace every detail down to
the code, without docs scattered across sessions.

## Principles
- **The code is the source of truth.** Docs explain intent, structure and why. Behavior claims come from code read in
  this session (WORKFLOW.md "Read the code"); unknown intent becomes `TODO(<owner>): …`, never invented. Link
  generated artifacts (OpenAPI/AsyncAPI, Javadoc, generated diagrams, architecture tests) instead of copying them.
- **Two kinds of docs.** *Living* docs (overview, onboarding, glossary, module docs) always show the current state
  and are rewritten; their history is git plus a short History section. *Timeline* docs (ADRs, plans, change
  fragments) are append-only: ADRs are immutable (superseded, never edited), fragments wait in `_changes/` until a
  sync merges and deletes them (the towncrier/changesets pattern).
- **Off by default.** Nothing here runs unless the profile has a non-empty `## Docs` section, except `memory`.
- **Approval before writing.** `init`: the approved I-lines are the approval point (then write and list what was
  created). `sync`: show the diff, apply after the user's OK. `memory`: approved per line. Never move, trim or delete
  an existing doc without approval.
- **Same structure everywhere.** Every module doc uses the 9-section template; deviations are additions, not
  removals.

## Profile (`## Docs`)
```
- root: docs/                                # or a path outside the repo; an existing docs location is reused
- modules: `src/billing/`, `src/auth/`       # each directory is one module → <root>/modules/<basename>/README.md
- sync-after: 5 changes, 14d, 10 commits     # pending fragments · oldest fragment age · commits on a module since synced:
- plans: archive                             # done plans at sync: archive | delete
- level: 0                                   # presentation level (see Levels)
- locales: en, vi                            # optional i18n: first = source language, others = translations
```
Defaults when a line is missing: `root: docs/`, `sync-after: 5 changes, 14d, 10 commits`, `plans: archive`,
`level: 0`.

## Layout
```
<root>/
├── README.md            index and reading order          (templates/docs/README.md)
├── overview.md          trimmed arc42, C4 levels 1–2      (templates/docs/overview.md)
├── onboarding.md        tutorial: set up, run, first change (templates/docs/onboarding.md)
├── glossary.md          domain terms                      (templates/docs/glossary.md)
├── modules/<name>/README.md   one per module, 9 sections  (templates/docs/module.md)
├── adr/README.md + NNNN-<slug>.md   index (templates/docs/adr-index.md) + immutable decisions ($W/templates/adr.md)
├── plans/active/YYYY-MM-DD-<slug>.md · plans/archive/   Hard plans ($W/templates/plan.md)
├── _changes/YYYY-MM-DD-<slug>.md    pending fragments     (templates/docs/change.md)
└── _i18n/<locale>/docusaurus-plugin-content-docs/current/<same paths>   translations (only with `locales:`)
```
Templates live in `$W/templates/docs/`. Traceability runs downward: overview → module doc → its Code map → code.
Diagrams are Mermaid fenced blocks (rendered by GitHub/GitLab) unless the level says otherwise.

## Modes

### `init`
1. **Gather (read-only)**: existing docs (`README*`, `docs/`, `doc/`, `wiki/`, `adr/`, `.claude/docs`, `AGENTS.md`,
   per-directory READMEs), agent rules (`CLAUDE.md`, `.claude/rules`), module structure (build files:
   `settings.gradle*`, Maven `<modules>`, package workspaces, `go.work`, top-level source dirs), generated references
   (OpenAPI generators, Javadoc tasks, architecture tests).
2. **Propose** numbered lines (I1, I2 …), each with evidence. One line may cover a group of docs with the same
   disposition.
   - `root`, in this order: an existing human-facing docs dir with Markdown (`docs/`, `doc/`); else a new `docs/`.
     Agent-oriented dirs (`.claude/docs`, `.agents/`) are linked from the index, not used as root, unless the project
     states they are its canonical docs. Dirs without Markdown (assets only) do not count.
   - modules: from the build's module list (Gradle `include`, Maven `<modules>`, workspaces) or top-level source dirs;
     separate builds (examples, samples) are linked, not modules. Module basenames must be unique.
   - `plans`, `sync-after` (defaults unless there is a reason).
   - per existing doc or group: *keep in place* (already under root), *link from the index* (default), *move into
     the layout*, or *leave out*.
   - agent rules (`CLAUDE.md`, `AGENTS.md`, `.claude/rules`) stay where they are and are not rewritten as human docs;
     propose adding one line linking `<root>/README.md` to them, and list sections they duplicate as optional trims
     (never trimmed without approval).
   - the presentation level (see Levels; level 0 needs no question).
3. **After approval**, write:
   - the profile's `## Docs`;
   - every file of the layout from the templates, dropping the template comments; `.gitkeep` in empty folders
     (`plans/active`, `plans/archive`, `_changes`); `adr/README.md` from `templates/docs/adr-index.md`;
   - every section, filled from code read this session or left as `TODO(<owner>): <what is unknown>`; agent rules and
     existing docs are hints for facts (verify them) and are linked rather than copied;
   - module front matter: `code:` = the module's main sources and its build file (e.g. `<module>/src/main/**`,
     generator source sets, `<module>/build.gradle.kts`), tests excluded; `owner:` from CODEOWNERS, else
     `TODO(owner)`; `synced: <git rev-parse --short HEAD>`. Overview `code:` = the root build files and module dirs;
   - section 8 with no ADRs: `n/a`, or links to existing rationale docs; History: one line `created by wf-docs init`;
   - onboarding commands taken from build files and CI; run the cheap ones (under a minute), mark the rest
     `(not run by init)`.
4. Run `$W/bin/wf-lint <project>` and show its output: no `[docs]` line means the docs checks passed; report other
   categories without acting on them.

### `sync`
1. **Collect**: fragments in `<root>/_changes/` grouped by module; module docs `wf-lint` reports as stale; plans in
   `plans/active/` whose `**Status:**` line says `done`.
2. **Read the code** for each affected module: `git diff <synced>..HEAD -- <code globs>`, plus each fragment's
   `commits:` and the files it names, even when they predate `synced:`. Fragments and old docs are hints; the code
   wins. Changes in that diff that no fragment covers are documented too and listed as `unfragmented` in the diff.
3. **Rewrite** only the affected sections of living docs (module docs, overview, glossary, onboarding, index, ADR
   index). Set `synced:` to HEAD on every module doc whose code was checked in this sync; add one History line only to
   docs whose text changed (`date · summary · ADR/plan/fragments`). Re-check onboarding commands against the build
   files when the build changed; mark commands you did not run `(not run)`.
4. **Mismatches**: when a doc or fragment says X and the code does Y, write Y and list `⚑ mismatch: <doc> said X,
   code does Y (<file:line>)` in the reply. A mismatched fragment is deleted with the others, unless the user keeps
   it (e.g. it describes planned work); then it stays, marked `status: planned`. Never change code during a sync.
5. **Level check**: re-evaluate the signals in Levels; ask only if a signal fires that is not already recorded as
   declined in `level:`.
6. **Show the diff** as a summary: per doc, the sections changed with one line each; fragments to delete; plans to
   archive or delete (`plans:`); `unfragmented` changes; the full diff on request. Apply after approval.
7. **Translations** (only with `locales:`): for each translated file whose source changed since its
   `translated_from:` (wf-lint lists them), re-translate the changed sections (rules in "Translations"), set
   `translated_from:` to HEAD, and include them in the diff of step 6.
8. **Memory**: run `memory` below as the last step.
9. Run `$W/bin/wf-lint <project>` and report what it still shows.

### `memory`
Works whether docs are on or off.
1. **Locate**: the memory directory named in this session's instructions; otherwise
   `<claude config dir>/projects/<slug>/memory/` (slug = the absolute project path with every non-alphanumeric
   character replaced by `-`). Read `MEMORY.md` and every memory file. Also read the project's own `CLAUDE.md` /
   `CLAUDE.local.md` for stale facts (report only, as `C1, C2 …` lines under the M-lines, no action; claims you
   cannot check are `[unverified]`). Never touch the user-level `~/.claude/CLAUDE.md` or other projects' memory.
2. **Classify** each entry (one or more kinds; the first kind decides the action), with evidence `[verified]`:
   - `stale`: names a file, symbol, flag or command that no longer exists (grep/glob it);
   - `duplicate`: says the same as another entry; keep the more complete (else the older) one and merge only text
     the survivor lacks, so a merge with nothing to add is a delete;
   - `contradicts`: the code or the living docs say otherwise (the code wins);
   - `now-in-docs`: a project fact the living docs or the repo now record (only memory types `project` and
     `reference`);
   - `broken-index`: a `MEMORY.md` line without its file, or a file without a `MEMORY.md` line;
   - `relative-date`: "yesterday", "next week" without an absolute date.
3. **Propose** numbered lines: `M1 · delete | merge into <file> | edit | move to docs <path> · <file> · <kind>[,
   <kind>] · <evidence>`, with the text before and after. Memory of type `user` or `feedback` is proposed only for
   `stale`, `duplicate` or `contradicts`, never for `now-in-docs`. A file without front matter has an unknown type:
   propose only `broken-index` or `stale`. `move to docs` edits the living doc by sync step 3's rules.
4. **Wait** for answers per line ("M1 yes", "M2 no"). Unanswered lines stay unapplied.
5. **Apply**: first copy every file you will change or delete to `memory/.backup-<YYYY-MM-DD-HHMM>/`; apply; keep
   `MEMORY.md` at one line per memory file with no dangling lines. Report applied and unapplied lines.

## Levels
The presentation level is your call, but anything above 0 needs the user's OK. Record the answer in `level:` either
way, so the question is not repeated: `level: 1`, or `level: 0 (declined 1 on YYYY-MM-DD: <signal>)`; ask again only
when a signal that is not recorded there fires. Never install tooling as part of `init`/`sync`: implementing a level is a
separate task.

| Level | What | Propose when |
|---|---|---|
| 0 | Markdown + Mermaid in the repo, no build; layout already Docusaurus-compatible (below) | Always the default; no question |
| 1 | **Docusaurus** site over `<root>` (default engine: search, sidebar from folders, `@docusaurus/theme-mermaid`, versioning) + interactive API reference from the generated spec (an OpenAPI plugin, or Redoc/Scalar embedded) | ≥5 modules; or >15 Markdown files under `<root>` created from wf-docs templates (existing docs kept in place do not count); or a machine-readable API spec (OpenAPI, AsyncAPI, GraphQL schema, protobuf), not Javadoc; or ≥3 distinct commit authors in the last 90 days |
| 2 | Level 1 + interactive content: MDX components (tabs, live examples, embedded demos) and interactive architecture (LikeC4 or Structurizr DSL: C4 zoom from system to module) | Several containers or deployables where zooming between C4 levels matters, or docs that need live examples |

When a signal fires, either propose the level or state the signal and why not (e.g. the project already publishes a
site elsewhere). Engine: Docusaurus unless the project already runs another docs engine (e.g. an existing `mkdocs.yml`): then propose
keeping it and say why. When asking, give the signal that triggered it, what it adds, and its cost (Node dependency,
build step, CI job).

Level 1 setup notes: put the site in `website/` with `docs.path` pointing at `<root>` (docs are not moved); install
`@mermaid-js/layout-elk` next to `@docusaurus/theme-mermaid` (declared optional, but the build fails without it);
with `locales:`, set `i18n.path` to `<root>/_i18n` and add a `localeDropdown` navbar item.

### Docusaurus compatibility (applies from level 0)
Write level-0 docs so a Docusaurus site can be added without rewriting them:
- Plain `.md` files with YAML front matter; `README.md` is a folder's index page. Custom keys (`code`, `synced`,
  `module`) are fine.
- `_changes/` starts with `_`, so Docusaurus excludes it from the site; keep any other agent-only folder `_`-prefixed.
- Templates use HTML comments and `<placeholders>`, which MDX rejects: the site config sets
  `markdown: { format: 'detect' }` so `.md` stays CommonMark; only files that need components become `.mdx`.
- Relative links between `.md` files inside `<root>` (they work on GitHub and in Docusaurus). Links to files outside
  `<root>` (repo README, CONTRIBUTING, source files) use the repository URL (`<remote>/blob/<default branch>/<path>`)
  when the repo has a remote: a site only serves `<root>`, so relative links leaving it break there.
- Mermaid in ```` ```mermaid ```` blocks.

## Translations (optional, `locales:`)
Off when `locales:` is absent or lists one locale. The first locale is the **source**: the only language `sync`
checks against the code and rewrites. Other locales are translations derived from it.
- **Where**: `<root>/_i18n/<locale>/docusaurus-plugin-content-docs/current/<same relative path>` (the layout Docusaurus
  reads through `i18n.path`; the `_` keeps it out of the source pages). UI strings at level 1 also live under
  `<root>/_i18n/<locale>/` (`code.json`, theme JSON from `docusaurus write-translations`).
- **What**: the files created from wf-docs templates (index, overview, onboarding, glossary, module docs, ADR index).
  ADRs, plans and existing docs kept in place stay in the source language unless the user asks. A missing
  translation falls back to the source page (Docusaurus does this; on GitHub readers open the source).
- **Front matter**: copy the source's front matter unchanged and add `translated_from: <short commit>` (the commit
  whose source text was translated).
- **Keep untranslated**: front matter, code spans and blocks, identifiers, paths, commands, URLs and link targets,
  Mermaid blocks (byte-identical), `TODO(...)` markers, section numbers. A translated heading that other pages link to
  with an anchor keeps the source anchor as an explicit ID (`## 5. Luồng chính {#5-key-flows}`); only translations
  carry `{#…}`, never the source (GitHub would show it as text). A source file without front matter gets one holding
  only `translated_from:`. Mermaid labels stay in the source language (blocks are copied byte for byte).
- **Links to untranslated pages**: Docusaurus resolves relative `.md` links only inside the locale tree, so a
  translation links a page that has no translation by its absolute site route (`/research-foundations`,
  `/modules/caffeine` for a folder's `README.md`, anchors kept); Docusaurus adds the locale prefix and serves the
  source page. Relative links between translated pages stay relative. Docusaurus drops numeric file prefixes from
  routes (`adr/0001-x.md` → `/adr/x`), so take a route from the build output rather than from the file name. Translate headings and prose; keep the
  English technical terms engineers in that language normally use.
- **Terms**: the source glossary may carry one column per extra locale with the preferred term; translations use it
  so the same term is translated the same way everywhere.
- **When**: `init` asks whether to translate now or leave translations to fall back until the first `sync`; `sync`
  step 7 refreshes stale ones. Never edit a translation to change facts: fix the source, then re-translate.

## Writing rules
- **Short statements, not paragraphs.** One idea per bullet, conclusion first, at most two sentences per bullet; no
  paragraph longer than 3 lines. Put the code reference at the end of the bullet: `Class.method` on first mention
  in a section, bare `method` after that, `file:line` when a line matters.
- **No invented rationale.** When the why of a rule is not evident from code, tests or existing docs, write
  `— TODO(<owner>): why` instead of restating the rule as its reason.
- **Show, don't narrate.** A flow is numbered steps (one action each) plus a sequence or flowchart diagram; a
  lifecycle is a `stateDiagram`; a structure is a flowchart or class diagram; a trade-off is a table; a rule that
  must not regress is a "Don't …" guardrail with the code that depends on it.
- Decisions go into ADRs (`$W/templates/adr.md`: Decision, Context, Options table, How it works diagram,
  Consequences, Guardrails); module docs link them instead of explaining the rationale inline.
- Diátaxis: onboarding is a tutorial; how-to guides go in module docs (or `how-to/` when there are many); reference
  is generated; overview and module docs are explanation.
- Short pages that link rather than copy. One fact lives in one place; other places link to it.
- `CLAUDE.md` / `AGENTS.md` hold rules for agents and link to `<root>/README.md`; they do not duplicate the docs.
