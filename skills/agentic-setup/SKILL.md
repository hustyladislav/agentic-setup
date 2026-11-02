---
name: agentic-setup
description: Sets up or upgrades a repository for AI coding agents (Claude Code, Codex, Cursor) with current best practices — AGENTS.md as an index, topic docs, a decision log, shared skills, PR-template hooks, CI with required checks, branch protection and deploy-from-main. Use when the user asks to "set up the repo for agents", "add AGENTS.md", "make this repo agent-ready", bootstrap a new repo, or audit/upgrade an existing agent setup.
---

# Agentic repo setup

Installs a proven agent setup into the current repository and **adapts** it to the repo's real stack.
Never overwrite the user's existing instructions blindly — merge them. Files to copy live in
[`assets/`](assets/) (stored without leading dots; the target path is given below). Why each piece exists:
[`references/practices.md`](references/practices.md).

## 1. Inspect before writing

Read, don't guess. Record findings in a short list you will show the user:
- Package manager and runtime (`packageManager`, lockfiles, `.nvmrc`), language(s), framework, test runners, linter.
- Scripts that typecheck / lint / test / e2e / build / dev (exact names).
- Existing agent files: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursor/rules`, `.github/copilot-instructions.md`, `.claude/`, `.agents/skills`, `skills-lock.json`.
- CI (`.github/workflows`), hosting/deploy config (`vercel.json`, `netlify.toml`, Dockerfile…), database/migration tool.
- UI stack (Tailwind? shadcn `components.json`?), user-facing language, auth/tenancy model, anything touching money or real people.

## 2. Refresh "latest" — never assume

Your training data is outdated by definition. Before writing versions or config:
- Latest versions of every tool you reference: `npm view <pkg> version` (or the ecosystem equivalent); GitHub Actions via `gh api repos/<owner>/<action>/releases/latest --jq .tag_name`.
- Current Claude Code settings/hooks/skills/plugin schema and Codex `AGENTS.md`/skills behaviour from the official docs (fetch them); adjust the assets if a field was renamed or a better mechanism exists.
- Current skills CLI: `npm view skills version`.

## 3. Install, adapting as you go

| Asset | Target | Adapt |
|---|---|---|
| `AGENTS.md` | `AGENTS.md` | Fill every `<…>` from step 1; real commands only; delete "Before you touch…" lines whose topic file you don't create; merge any existing instructions into the right section or a topic file (nothing lost). Keep it an index (< ~120 lines). |
| `CLAUDE.md` | `CLAUDE.md` | `@AGENTS.md` only. If a `CLAUDE.md` exists, move its content into `AGENTS.md`/topic files first. |
| `docs/agents/*.md` | `docs/agents/` | Keep `delivery.md`, `domain.md`; adapt `environment.md`, `security.md`; `ui.md` only if there is a UI. Fill with facts from the repo, remove template comments. |
| `docs/decisions/*` | `docs/decisions/` | Set the date in `0001`. Offer to back-fill 3–6 entries for decisions already visible in the code (database, hosting, framework, auth) — only ones that pass the bar in `README.md`. |
| `claude/settings.json` | `.claude/settings.json` | Merge with an existing file. Fill `autoMode.environment` with the real repo/host/DB. Keep the PR hooks. Enable the LSP plugin only for TypeScript repos. |
| `claude/hooks/*` | `.claude/hooks/` | `chmod +x`. They need `jq` and `gh`. |
| `claude/marketplace/…` | `.claude/marketplace/` | Rename `claude-plugin/` → `.claude-plugin/` (both levels) and `lsp.json` → `.lsp.json`. TypeScript repos only; ensure `typescript-language-server` is a devDependency. |
| `claude/launch.json` | `.claude/launch.json` | Real dev command and port. |
| `github/*` | `.github/` | CI: use the repo's real scripts; keep the docs-only fast path and job names `check`/`e2e`/`gitleaks`. Drop `actions/pnpm` if not pnpm. Merge with existing workflows instead of replacing. |
| `gitignore` | `.gitignore` | Append missing lines only. |

**Skills** — install from their sources with the skills CLI (it puts them in `.agents/skills`, links them into each
agent's directory and pins them in `skills-lock.json`, so `skills update` keeps them current). Use the repo's package
runner (`pnpm dlx` / `npx` / `bunx`):
- always: `skills add hustyladislav/agentic-setup -s pr -y` and `skills add mattpocock/skills -s writing-for-agents -y`
- with a UI: `skills add anthropics/skills -s frontend-design -y`; with shadcn: `skills add shadcn/ui -y`
- others only if the repo clearly uses the tool (list a repo's skills with `skills add <repo> -l`).
Commit `skills-lock.json` and the installed files so every clone has them without a network call.

## 4. Repository settings — ask first

These change shared/outward-facing state, so confirm with the user before running:
- Branch protection on `main`: required checks `check`, `gitleaks` (+ `e2e` if it exists), strict up-to-date —
  `gh api -X PUT repos/<o>/<r>/branches/main/protection --input <json>`.
- Allow auto-merge and delete merged branches: `gh api -X PATCH repos/<o>/<r> -F allow_auto_merge=true -F delete_branch_on_merge=true`.
- Hosting: production deploys from `main` via Git integration; turn off per-branch previews if the plan has a deploy quota.

## 5. Verify and hand off

- JSON files parse (`jq . .claude/settings.json`); hooks are executable; `.claude/skills/pr/SKILL.md` resolves.
- Simulate the PR hook: `echo '{"tool_input":{"command":"gh pr create --body x"}}' | .claude/hooks/pr-body-check.sh` must deny.
- Run the repo's verify/test command if you touched CI or scripts.
- Open a PR with the `pr` skill. In the summary, list: what was installed, what was adapted, what you merged from existing files, which `<…>` still need the owner (e.g. "Never break" rules), and what you did not verify.
