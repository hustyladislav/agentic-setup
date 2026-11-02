---
name: agentic-setup
description: Sets up or upgrades a repository for AI coding agents (Claude Code, Codex, Cursor) with current best practices — AGENTS.md as an index, topic docs, a decision log, shared skills, PR-template hooks, CI with required checks, branch protection and deploy-from-main. Use when the user asks to "set up the repo for agents", "add AGENTS.md", "make this repo agent-ready", bootstrap a new repo, or audit/upgrade an existing agent setup.
---

# Agentic repo setup

Installs a proven agent setup into the current repository and **adapts** it to the repo's real stack.
Never overwrite the user's existing instructions blindly — merge them. Files to copy live in
[`assets/`](assets/) (stored without leading dots; the target path is given below). Why each piece exists:
[`references/practices.md`](references/practices.md).

Work on a branch named for the task (e.g. `agentic-setup`). Prefer writing files with your file-editing tool over
shell here-docs (some sandboxes refuse here-docs next to `sed`/`gh`).

## 0. New repository? Bootstrap first

If there is no repo yet (empty folder, or the user asks for a new project):
- Ask for the name, visibility and stack only if they can't be inferred; default to private.
- Scaffold the app with its framework's **current** official starter (check its docs/CLI version first, step 2), set
  `packageManager`, `.nvmrc` with the current Node LTS, and scripts `dev`, `build`, `test`, `e2e` (if any) and one
  pre-push bundle (`check`: typecheck + lint + unit).
- `git init -b main`, first commit, then `gh repo create <owner>/<name> --private --source . --push` — creating a
  remote is outward-facing: confirm the owner and visibility with the user first.
- Then run steps 1–5 below on it (commit straight to `main` for this first setup; PRs from then on).

## 1. Inspect before writing

Read, don't guess. Record findings in a short list you will show the user:
- Package manager and runtime (`packageManager`, lockfiles, `.nvmrc`), language(s) and **versions** (TypeScript major!),
  framework, test runners, linter/formatter and what it scans.
- Monorepo? Where apps, shared UI and config live (`apps/*`, `packages/*`, `components.json` location).
- Exact script names for typecheck / lint / unit / e2e / build / dev and the **one "verify" command** that runs the
  pre-push bundle (often `check`, `verify` or `ci`). Use these names everywhere below — never invent `pnpm verify`.
- Existing agent files: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursor/rules`, `.github/copilot-instructions.md`,
  `.claude/`, `.agents/skills`, `skills-lock.json`. Existing docs (`docs/*.md`, ARCHITECTURE, DOMAIN, ADRs).
- CI (`.github/workflows`: job names, which are required, action versions, where security scans live), hosting/deploy
  config (`vercel.json` incl. `ignoreCommand`, `netlify.toml`, Dockerfile…), database/migration tool.
- UI stack (Tailwind? shadcn, Radix or Base UI?), user-facing language, auth/tenancy model, anything touching money or real people.
- **Kind of repo.** No app (a skills/docs/config package, a library)? Then the app-shaped parts below don't apply:
  skip `ui.md`, `environment.md`, `security.md`, `domain.md`, `launch.json`, the LSP plugin and the `e2e`/deploy bits, and write
  the repo's own checks (a validation script) as the `check` job. Say in the PR which pieces you skipped and why.

## 2. Refresh "latest" — never assume

Your training data is outdated by definition. Before writing versions or config:
- Tool versions you reference: `npm view <pkg> version` (read-only lookups via `npm`/`npx` are fine even in pnpm repos).
- GitHub Actions: `gh api repos/<owner>/<action>/releases/latest --jq .tag_name` — **re-pin every `uses:` in the CI
  asset**; keep the repo's own pins when they are newer.
- Current Claude Code settings/hooks/skills/plugin schema and Codex `AGENTS.md`/skills behaviour from the official docs;
  adjust the assets if a field was renamed or a better mechanism exists.
- Skills CLI: `npm view skills version`.

## 3. Install, adapting as you go

| Asset | Target | Adapt |
|---|---|---|
| `AGENTS.md` | `AGENTS.md` | Fill every `<…>` from step 1 with the repo's real commands (replace `pnpm verify` with the actual verify script); delete "Before you touch…" lines whose topic file you don't create; merge existing instructions into a section or topic file (nothing lost). Keep it an index (< ~120 lines). |
| `CLAUDE.md` | `CLAUDE.md` | `@AGENTS.md` only. If a `CLAUDE.md` exists, move its content into `AGENTS.md`/topic files first. |
| `docs/agents/*.md` | `docs/agents/` | Keep `delivery.md` (trim deploy/DB lines the repo doesn't have), `domain.md`; adapt `environment.md`, `security.md`; `ui.md` only with a UI (use the repo's real paths — monorepos keep primitives in e.g. `packages/ui`). Add a topic file for any repo-wide rule that doesn't fit (e.g. `api.md`). Env var **names** only, never values. A glossary may live inline in `domain.md` instead of `GLOSSARY.md`. |
| `docs/decisions/*` | `docs/decisions/` | Set the date in `0001`. Back-fill entries for decisions already visible in the code that pass the README bar. When git history doesn't record the alternatives, keep "Rejected" thin and mark it "to confirm by the owner" — never invent reasons. |
| `claude/settings.json` | `.claude/settings.json` | Merge with an existing file. Fill `autoMode.environment` with the real repo/host/DB. Keep the PR hooks. |
| `claude/hooks/*` | `.claude/hooks/` | `chmod +x`. They need `jq` and `gh`. |
| `claude/marketplace/…` | `.claude/marketplace/` | TypeScript repos only. Rename `claude-plugin/` → `.claude-plugin/` (both levels), `lsp.json` → `.lsp.json`. TypeScript ≤ 6: `typescript-language-server --stdio` (add it as a devDependency). TypeScript ≥ 7 (native, no `tsserver`): command `node_modules/.bin/tsc`, args `["--lsp", "--stdio"]`. |
| `claude/launch.json` | `.claude/launch.json` | Real dev command and port (the app's package in a monorepo). |
| `github/*` | `.github/` | See "Merging CI" below. Drop `actions/pnpm` if not pnpm. |
| `gitignore` | `.gitignore` | Append missing lines only. |

**Existing docs.** Link still-valid docs (architecture, domain rules, design system, security audits) from the matching
topic file so they stay live; leave the rest as archive. Fix lines that contradict decisions you just recorded (e.g. a
doc promising preview deployments when previews are off).

**Merging CI.** Keep existing job names, required checks and newer action pins. Add only what is missing:
- the docs-only fast path to **every required job** (`check`, `e2e`, …), so a docs/agent-config PR still reports
  them as passing; the path set is Markdown, `.claude/**`, `.agents/**`, `skills-lock.json`. Use the portable scope
  test from the asset (`grep -vE … | grep -q .`, works with BSD and GNU grep). Skip it when Markdown *is* the product
  (skills/docs repos): there every PR runs the checks;
- `gitleaks` only if no workflow runs it yet (it often lives in a `security.yml`);
- the composite pnpm action only if pnpm setup is slow or flaky — otherwise keep `pnpm/action-setup`.
Mirror the same skip in the host's deploy-ignore rule (e.g. Vercel `ignoreCommand`) so agent-config commits don't
burn deploy quota.

**Ignore lists.** Add `.agents/` and `.claude/` to the linter/formatter ignore (Biome `files.includes`/`ignore`,
ESLint/oxlint ignores, Prettier) and to typecheck/test globs if they would scan them — installed third-party skills
are not your code.

**Skills** — install from their sources with the skills CLI (it writes them into `.agents/skills` and the agent's own
directory and pins them in `skills-lock.json`, so `skills update` keeps them current). Use the repo's package runner
(`pnpm dlx` / `npx` / `bunx`), one agent per call (`-a claude-code`, then again with `-a codex`) — several `-a` flags
at once fail, and without `-a` it may prompt:
- always: `skills add hustyladislav/agentic-setup -s pr -y` and `skills add mattpocock/skills -s writing-for-agents -y`
- with a UI: `skills add anthropics/skills -s frontend-design -y`; with shadcn: `skills add shadcn/ui -s shadcn -y`
  (without `-s` it also installs migration skills you may not want)
- others only if the repo clearly uses the tool (list a repo's skills with `skills add <repo> -l`).
An install can print "Installation failed" and still have worked, or fail transiently: check `skills-lock.json` and
the `SKILL.md` files, retry once. Commit the lockfile and installed files so clones work offline. The managed `pr`
skill refers to "the verify command" generically — don't edit it (it would drift from its source); the repo-specific
command lives in `AGENTS.md`.

## 4. Repository settings — ask first

These change shared/outward-facing state, so confirm with the user before running — unless the request already asks
for them (e.g. the owner says "apply it"). Skip what is already set:
- Branch protection on `main`: required checks `check`, `gitleaks` (+ `e2e` if it exists), strict up-to-date, no required
  reviews for a solo owner, `enforce_admins` off — `gh api -X PUT repos/<o>/<r>/branches/main/protection --input -` with
  `{"required_status_checks":{"strict":true,"contexts":["check","gitleaks"]},"enforce_admins":false,"required_pull_request_reviews":null,"restrictions":null}`.
- Allow auto-merge and delete merged branches: `gh api -X PATCH repos/<o>/<r> -F allow_auto_merge=true -F delete_branch_on_merge=true`.
- Hosting: production deploys from `main` via Git integration; turn off per-branch previews if the plan has a deploy quota.

## 5. Verify and hand off

- JSON files parse (`jq . .claude/settings.json`); hooks are executable; `.claude/skills/pr/SKILL.md` resolves.
- Simulate the PR hook: `echo '{"tool_input":{"command":"gh pr create --body x"}}' | .claude/hooks/pr-body-check.sh` must deny.
- Run the repo's verify command, and e2e if you touched CI or scripts. Restore files that tests rewrite as a side
  effect (generated examples, snapshots) before committing.
- Open a PR with the `pr` skill (keep any attribution footer the session asks for). In the summary, list what was
  installed, adapted and merged from existing files, which `<…>`/"to confirm" items still need the owner, and what you
  did not verify.
