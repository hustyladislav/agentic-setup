# Delivery: branches, PRs, CI, versions

How work gets from a branch to `main`. Open this before you push, open a PR or pin a version.

## Ship small
- One focused change per PR. Branch from the latest `main`; never commit to `main` directly except trivial docs fixes.
- Write the PR body with the `pr` skill and pass it via `--body-file`; after every push to a branch with an open PR, rewrite the body so it describes the PR as it stands.
- Arm auto-merge (`gh pr merge <n> --auto --squash`) once the PR is ready; it merges when the required checks pass and the branch is up to date.
- Behind `main`: `gh pr update-branch <n>`. With several PRs queued, land them one at a time — parallel updates restart each other's CI.
- Resolve conflicts by rebasing onto `main`, then rerun `scripts/check.sh` before pushing again.

## CI and branch protection
- CI runs on PRs and `main` only. Required checks on `main`: `check` (`scripts/check.sh` + `skills add . -l` lists both skills) and `gitleaks`. Branches must be up to date.
- A red `main` blocks everyone: whoever merged last fixes it first. Never merge with `--admin` to skip checks.
- Every `uses:` in `.github/workflows` is pinned to the latest release (`gh api repos/<owner>/<action>/releases/latest --jq .tag_name`); Dependabot keeps them current.

## Versions
- Before pinning or recommending a version in a skill or asset: `npm view <pkg> version` / the releases API, and read the changelog for breaking changes. Training data is outdated by definition.
- The CI discovery step runs `npx skills@<version> add . -l` with the exact latest version from `npm view skills version`; bump it when it changes.
