# Why each piece exists

Distilled from running multi-agent builds (an orchestrator plus parallel Claude/Codex sub-agents shipping 100+ PRs a day).

## Instructions
- **AGENTS.md is an index.** It loads every session, so it holds only what changes a decision in most sessions:
  commands, the few never-break rules, the proof bar, and "Before you touch X → open Y". Long files bury the rules that matter.
- **Topic files in `docs/agents/`** carry the detail. A linked file is live; an unlinked one is archive — so agents
  don't act on stale docs. Every link has a trigger ("Any UI…", "Migrations…").
- **`CLAUDE.md` imports `AGENTS.md`.** One source for every tool; duplicated instruction files drift.
- **A decision log with a high bar.** Only architecture, infrastructure, core vendors/toolchain and platform-wide
  money/security/legal rules. Never rewritten — superseded. Stops agents re-litigating settled choices.
- **"Proof before done" + "Not verified".** Agents over-claim. Scaling proof to the change (test → verify → screenshots
  → e2e) and forcing a "not verified" line keeps reports honest.
- **"Verify latest, never assume".** Models default to versions from their training data. Requiring `npm view` and live
  model lists before choosing keeps the stack current.
- **Code Review Rules section.** Automated reviewers (Codex, CodeRabbit) read `AGENTS.md`; give them the checks a linter can't do.

## Skills
- **`pr`** — a PR body a reviewer reads in a minute: one-sentence claim, smallest picture, before/after evidence,
  "Not verified", door (one-way/two-way) and blast radius. Hooks enforce the sections and nudge a rewrite after each push.
- **`writing-for-agents`** (MIT, Matt Pocock) — how to write instructions agents follow predictably.
- **`frontend-design`** (Apache-2.0, Anthropic) — avoids templated-looking UI.
- **Installed with the skills CLI** — one copy in `.agents/skills`, linked into each agent's directory, pinned in
  `skills-lock.json`, refreshed with `skills update`.

## Delivery
- **Small PRs, auto-merge, required checks (`check`, `e2e`, `gitleaks`), up-to-date branches.** Parallel agents
  otherwise merge onto each other's breakage; a red `main` blocks everyone.
- **One updater at a time.** Several agents running `update-branch` restart each other's CI forever; serialize.
- **Production deploys only from `main` via Git.** Agents running a CLI production deploy from a worktree ship unmerged branches.
- **Preview deploys cost quota.** On free tiers, skip previews for agent branches and docs-only commits.
- **Previews never migrate the production database.**
- **Explicit file ownership per sub-agent; cheaper models for implementation and chores; the orchestrator reviews
  screenshots and CI, not reports.**

## Security baseline
- Tenant-isolation test that replays one tenant's ids as another for every procedure (fails when a new procedure has no case).
- Secrets only in the host's env store; gitleaks in CI; never print values — check presence.
- CodeQL, OSV-Scanner, dependency review, Dependabot.
