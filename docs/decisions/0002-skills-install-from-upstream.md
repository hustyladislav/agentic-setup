# 0002 — Skills install from upstream sources, not vendored

- Date: 2026-11-02
- Status: accepted
- Decided by: founder

## Context
`agentic-setup` wants every repo to have `pr`, `writing-for-agents` and, with a UI, `frontend-design` and `shadcn`.
Third-party skills are maintained elsewhere and change; copying them into this package would freeze and relicense them.

## Decision
The skill tells the agent to install each skill from its source with the skills CLI (`skills add <repo> -s <skill>`).
The CLI pins source and hash in `skills-lock.json`, and `skills update` keeps them current. This package vendors no
third-party skill; it only ships its own (`agentic-setup`, `pr`), and `pr` is installed from this repo like any other.

## Rejected (to confirm by the owner)
- **Vendoring copies of third-party skills:** they drift from upstream and mix licences (Apache-2.0, MIT) into this package.
- **Linking a skill by instruction only, without installing:** works in one agent session, not for clones, other agents or CI.

## Consequences
Setup needs network access and the skills CLI. Upstream renames or removals break the install step; the CI discovery
check and dogfooding catch this for our own skills only, so third-party sources are re-checked when the skill is touched.
