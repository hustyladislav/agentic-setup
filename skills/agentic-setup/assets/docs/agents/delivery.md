# Delivery: branches, PRs, CI, deploys, versions

How work gets from a branch to production. Open this before you push, open a PR, add a dependency or pick a model.

## Ship small, continuously
- One focused change per PR; ship a rough working slice and iterate rather than a big-bang branch.
- Branch from the latest `main`. Never commit to `main` directly except trivial docs fixes.
- Write the PR body with the `pr` skill and pass it via `--body-file`; after every push to a branch with an open PR, rewrite the body so it describes the PR as it stands.
- Arm auto-merge (`gh pr merge <n> --auto --squash`) once the PR is ready; it merges when the required checks pass and the branch is up to date.
- If the branch is behind, `gh pr update-branch <n>`. With several PRs queued, land them **one at a time** — parallel updates restart each other's CI and nothing merges.
- Resolve conflicts by rebasing onto `main`, then rerun the verify command and e2e before pushing again.

## CI and branch protection
- CI runs on PRs and `main` only. Required checks on `main`: `check` (typecheck · lint · unit · build), `e2e`, `gitleaks`. Branches must be up to date.
- Docs-only changes (Markdown, `.claude/**`, `.agents/**`) report the required check as a pass with nothing run.
- A red `main` blocks everyone: whoever merged last fixes it first. Never merge with `--admin` to skip checks.
- Automated review (Codex/CodeRabbit) comments on every PR; fix valid P0/P1 findings before merging, reply with evidence when a finding doesn't hold.

## Deploys
- Production deploys **only** from `main` via the hosting provider's Git integration. Never run a production deploy from a local checkout or worktree — it ships an unmerged branch.
- Preview deployments are optional; on free tiers they burn the daily deploy quota. Verify PRs with CI + local `pnpm e2e` instead when quota is tight; skip builds for docs-only commits.
- Database migrations run only for production builds (or against a preview's own branch database) — a preview must never migrate the production database.

## Versions and models
- Before adding or upgrading a dependency: `npm view <pkg> version`, read the changelog for breaking changes, pin exact versions (pnpm catalog for shared ones).
- Before choosing an AI model: query the provider's live model list (e.g. `https://ai-gateway.vercel.sh/v1/models`). Training data is outdated by definition — a newer model than the one requested usually exists; say so.

## Working with sub-agents
- The orchestrating session plans, reviews and merges; implementation goes to cheaper models (e.g. Sonnet at medium effort), mechanical chores (branch updates, screenshots, renames) to the cheapest (e.g. Haiku).
- Give each sub-agent explicit file ownership so parallel agents never edit the same files; one agent owns the app shell/layout.
- Every sub-agent's report is a claim, not proof: check the PR, the CI run and a screenshot before telling the user it's done.
