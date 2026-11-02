# 0003 — One package, two skills; template repo retired in favour of the bootstrap step

- Date: 2026-11-02
- Status: accepted
- Decided by: founder

## Context
Starting a new agent-ready repo used to mean cloning a separate template repository, which duplicated the assets
this package ships and drifted from them. `pr` is useful without `agentic-setup`.

## Decision
One repository publishes two skills, `agentic-setup` and `pr`, discovered by the skills CLI from `skills/*/SKILL.md`.
New repositories are created by `agentic-setup`'s step 0 (bootstrap) followed by the normal setup steps; the template
repo is retired. The assets live only in `skills/agentic-setup/assets/`, so there is one source of truth.

## Rejected (to confirm by the owner)
- **Keep a template repo next to the skill:** two copies of every asset, updated by hand.
- **Split `pr` into its own repo:** two releases to keep in step for a skill the setup depends on; `skills add -s pr` already installs it alone.

## Consequences
Everything ships from `main` of this repo, so a broken `SKILL.md` breaks every new install at once. CI guards frontmatter and
discovery; revisit if the package grows beyond a handful of skills.
