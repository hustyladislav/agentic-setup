# Domain Docs

How the engineering skills consume this repo's domain documentation. Single-context: one glossary, one decision log.

## Before exploring, read these

- **`GLOSSARY.md`** at the repo root: the domain vocabulary. Live, despite the "root `.md` is archive" rule in `AGENTS.md`.
- **[`docs/decisions/`](../decisions/README.md)**: this repo's ADRs. Read the entries that touch the area you're about to work in (the README index has one line each).

If `GLOSSARY.md` doesn't exist, **proceed silently**. The `/domain-modeling` skill creates it lazily when a term actually gets resolved.

## ADRs are `docs/decisions/` entries

Wherever a skill says `docs/adr/` or "ADR", use `docs/decisions/` and its [README](../decisions/README.md): its bar for what gets logged (stricter than the skill's ADR format: agent tooling, feature defaults and tuning stay out), its template, `NNNN-slug.md` numbering after the highest existing number, the index line, and superseding instead of rewriting. Calibrate on [examples.md](../decisions/examples.md); in doubt, leave it out.

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `GLOSSARY.md`. Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal: either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `/domain-modeling`).

## Flag decision conflicts

If your output contradicts an accepted decision, surface it explicitly rather than silently overriding:

> _Contradicts 0019 (ads are paused-first), but worth reopening because…_
