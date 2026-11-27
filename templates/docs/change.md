---
date: YYYY-MM-DD
modules: [<module>]
plan: <plans/active/YYYY-MM-DD-slug.md | none>
adr: [<NNNN>]            # or []
commits: [<short sha>]   # or [] when not committed yet (sync then relies on the files named below)
affects: [<doc#section>, …]   # e.g. modules/billing#5, overview#3, onboarding#2
---
<!-- Change fragment: file name `<root>/_changes/YYYY-MM-DD-<slug>.md`. Written at the end of a Medium/Hard task
     that changes a public interface, behavior, data or module structure. A hint for wf-docs sync, which merges it
     into the living docs (checking the code) and then deletes it. Facts only, 2–6 bullets. -->
- <what changed, from a reader's point of view>
- <why, if not in the plan/ADR>
