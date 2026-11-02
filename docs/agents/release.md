# Release: how a skill change ships

Users install with `npx skills add hustyladislav/agentic-setup`, which reads the **default branch**. So:

**PR → CI green → squash-merge to `main` = published.** There is no version to bump, no tag and no registry publish.

## Before merging
1. `scripts/check.sh` passes locally, and `npx skills@latest add . -l` lists both skills.
2. **Dogfood on a real repo.** A change to a skill's behaviour (SKILL.md steps, assets, hooks) is run end to end on a real repository — the agent reads the new `SKILL.md` and applies it — before release. Note in the PR body which repo and what the run exposed (`Evidence`). Pure wording or typo fixes may skip this; say so under **Not verified**.
3. Assets changed → the table in `skills/agentic-setup/SKILL.md` step 3 changed in the same PR. Pinned versions in assets re-verified as latest.

## After merging
- User-facing change (new step, new asset, changed behaviour): add a line under "Changelog" in `README.md` in the same PR (date, one sentence).
- Existing users get the change with `npx skills update`.

## Rolling back
Revert the squash commit on `main` through a PR; the revert is the release.
