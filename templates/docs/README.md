# <Project> documentation
<!-- Index and reading order. Living docs describe the system as it is now; the code is the source of truth.
     Managed by wf-docs (profile `## Docs`). Keep this page short: it links, it does not explain. -->

## Start here (new members)
1. [Overview](overview.md): what the system does, its parts and how they fit (C4 levels 1–2).
2. [Onboarding](onboarding.md): set up, run, make a first change.
3. [Glossary](glossary.md): domain terms.
4. The module you will work on (below).

## Modules
| Module | Purpose | Code | Doc |
|---|---|---|---|
| <name> | <one line> | `<path/>` | [modules/<name>](modules/<name>/README.md) |

## Decisions and history
- [Architecture decisions (ADR)](adr/README.md): why things are the way they are, newest first.
- Plans: [active](plans/active/) · [archive](plans/archive/).
- Pending changes not yet merged into these docs: [_changes](_changes/) (merged by `wf-docs sync`).

## Generated references
<!-- Link generated artifacts instead of copying them: OpenAPI/AsyncAPI specs, Javadoc, generated diagrams,
     architecture tests (e.g. ArchUnit). Remove this section if there are none. -->
- <API spec / Javadoc / diagram>: `<path or command that generates it>`

## Other documentation
<!-- Existing docs kept where they are (wiki, README of examples, agent rules). Agent rules stay in CLAUDE.md /
     .claude/rules; they are linked here only when a human benefits from reading them. -->
- <path> — <what it covers>
