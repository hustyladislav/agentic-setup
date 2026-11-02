# agentic-setup

Skills that make a repository **agent-ready** with current best practices for Claude Code, Codex and friends.

```bash
npx skills add hustyladislav/agentic-setup          # or: pnpm dlx skills add …
```

Then ask your agent: **"set up this repo for coding agents"** (or invoke `/agentic-setup`).

## Skills

| Skill | What it does |
|---|---|
| [`agentic-setup`](skills/agentic-setup/SKILL.md) | Inspects the repo, refreshes "latest" (tool versions, Claude Code / Codex docs), then installs and **adapts**: `AGENTS.md` as an index, `docs/agents/*` topic files, a decision log, shared skills, PR-template hooks, a TypeScript LSP plugin, CI with required checks, Dependabot, and (with your OK) branch protection + auto-merge. Merges existing instructions instead of overwriting them. |
| [`pr`](skills/pr/SKILL.md) | PR bodies a reviewer reads in a minute: claim, smallest picture, before/after evidence, **Not verified**, one-way/two-way door and blast radius. Rewritten after every push. |

Why each piece exists: [references/practices.md](skills/agentic-setup/references/practices.md).

## What you get

```text
AGENTS.md                 # index: commands, never-break rules, proof bar, "Before you touch…" links
CLAUDE.md                 # @AGENTS.md
docs/agents/              # delivery, domain, environment, security, ui
docs/decisions/           # decision log with a high bar (+ examples)
.agents/skills/           # pr, writing-for-agents, frontend-design (+ shadcn, …) via the skills CLI
skills-lock.json
.claude/settings.json     # auto mode, PR hooks, repo-local LSP plugin
.claude/hooks/            # PR body check + refresh after push
.github/                  # CI (check · e2e · gitleaks, docs-only fast path), PR template, Dependabot
```

Bundled third-party skills are installed from their upstreams:
[anthropics/skills](https://github.com/anthropics/skills) (`frontend-design`, Apache-2.0) and
[mattpocock/skills](https://github.com/mattpocock/skills) (`writing-for-agents`, MIT).

## License

MIT
