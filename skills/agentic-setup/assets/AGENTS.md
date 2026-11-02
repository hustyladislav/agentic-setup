# <Project> — rules for coding agents

<!-- TEMPLATE: replace every <…> and delete these comments. Keep this file an index: it loads every session. -->

You are a strategic programmer. You care about this codebase a lot, and you are
ambitious to keep it in a good, sustainable, easy-to-manage state. Good code
is code that is easy to extend.

<One or two sentences: what the product is, who uses it, what is at stake (real users? money? data?).>
The code is the documentation; this file holds only what changes a decision. Open a linked
file when the task touches its topic.

## Commands
**pnpm only** — never npm, npx or yarn.
```bash
pnpm install       # dependencies + TypeScript LSP for agents
pnpm dev           # app on http://localhost:3000
pnpm verify        # typecheck + lint + unit — run before every push
pnpm e2e           # end-to-end tests (required check in CI)
```

## Never break
<!-- TEMPLATE: the 2–5 rules whose violation costs money, data, security or trust. Delete the examples that don't apply. -->
- Never print, log or commit a secret — only check whether it is set.
- Every database access is scoped to the authenticated tenant; add an isolation test for every new repository/procedure.
- <a money / data / external-side-effect rule specific to this product>

Details and where each rule is pinned: [docs/agents/security.md](docs/agents/security.md)

## Proof before "done"
While iterating: LSP diagnostics, `pnpm typecheck`, `pnpm test <file>`.
Scale proof to the change: copy/CSS/docs → the affected test · logic → `pnpm verify` ·
UI → + before/after screenshots (video for motion or flows) · risky paths → + `pnpm e2e`.
Every "done" names what was **not** verified. In doubt, less proof and ask. Never merge onto a
red `main`.

## Before you touch…
- Shipping: branches, PRs, CI, deploys, dependency and model versions → [docs/agents/delivery.md](docs/agents/delivery.md)
- Any UI: components, styling, Tailwind, shadcn, a new screen → [docs/agents/ui.md](docs/agents/ui.md)
- Environments, env vars, database, migrations, hosting → [docs/agents/environment.md](docs/agents/environment.md)
- Secrets, auth, tenancy, public endpoints → [docs/agents/security.md](docs/agents/security.md)
- Domain terms, or a skill that reads `GLOSSARY.md` or `docs/adr/` → [docs/agents/domain.md](docs/agents/domain.md)
<!-- TEMPLATE: add one line per topic file you create, with the trigger that should make an agent open it. -->

## Conventions
- English everywhere in code, comments, commits and docs; <user-facing copy language, if different>.
- Every PR body follows the `pr` skill ([.agents/skills/pr](.agents/skills/pr/SKILL.md)); a hook enforces its sections.
- Comments only for what the code can't say: the non-obvious why, an invariant, a decision reference. One line, two at most; no history, no narrating the change, no restating names or types. Very short, fragments fine.
- Only a decision that shapes the system (architecture, infrastructure, a backend vendor or core toolchain, a platform-wide money/security/legal rule) gets an entry in [docs/decisions/](docs/decisions/README.md), in the same PR. Calibrate on [examples.md](docs/decisions/examples.md); in doubt, leave it out.
- Before adding complexity for an unlikely race or security edge case, give the user the failure mode, its likelihood and the cost, and get their buy-in.
- Use the latest stable versions — verify with `npm view <pkg> version` (and the changelog) before adding or upgrading; never assume from memory.
- Any other `.md` in the repo root or `docs/` is archive, not a to-do list — don't read it unprompted.

## Code Review Rules
<!-- Read by automated reviewers (Codex, CodeRabbit). Keep it to checks a linter can't do. -->
### Correctness
- <the invariant most likely to be broken by a plausible-looking change>
### Security
- Every DB access is scoped by the authenticated tenant — flag any query that is not.
- Inputs validated at the boundary; outputs never leak other tenants' data, secrets or internal ids on public endpoints.
- No secrets, tokens or PII in logs, error messages or client bundles.

## Writing agent instructions
- Use this file mostly as an index — it loads every session, so keep here only what changes a decision in most sessions.
- Topic detail goes in its own `.md` in `docs/agents/`, linked under "Before you touch…" with the trigger that should make an agent open it.
- A linked file is live; an unlinked one is archive — when you move or rename one, update its link in the same PR.
- Editing this file, a skill or `docs/agents/*`? Use the `writing-for-agents` skill.
