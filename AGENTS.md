# agentic-setup — rules for skill authors

You are a strategic programmer. You care about this codebase a lot, and you are
ambitious to keep it in a good, sustainable, easy-to-manage state. Good code
is code that is easy to extend.

A public skills package (MIT): `skills/agentic-setup` sets up or upgrades a repo for coding agents,
`skills/pr` writes PR bodies. Users install it with the skills CLI straight from the default branch,
so whatever is on `main` is what everyone gets. No app, no package.json — Markdown, JSON, shell hooks, YAML.
The code is the documentation; this file holds only what changes a decision. Open a linked
file when the task touches its topic.

## Commands
No build. Run the same checks as CI before every push:
```bash
scripts/check.sh                                   # frontmatter, JSON, YAML, shellcheck, hook simulation, relative links
npx skills@latest add . -l                         # must list both skills (GitHub form: add hustyladislav/agentic-setup -l)
```
Install tools with `npx`/`brew` as needed (`jq`, `shellcheck`, `python3` with PyYAML).

## Never break
- Every `skills/*/SKILL.md` keeps valid frontmatter (`name` equal to its folder, `description`) and the skills CLI must still discover each skill. A skill that silently stops being listed is a broken release.
- `skills/agentic-setup/assets/` are stored without leading dots; the table in `SKILL.md` step 3 maps each asset to its target. Add, rename or delete an asset and update that table in the same PR.
- Versions pinned in assets (actions, tools) are verified latest at the time of the change (`gh api repos/<o>/<a>/releases/latest`, `npm view`) — never from memory.
- Never edit the installed copies in `.agents/skills` or `.claude/skills`; change the source and reinstall.

## Proof before "done"
Scale proof to the change: wording → the affected check · assets/hooks → `scripts/check.sh` · behaviour of a skill →
dogfood it on a real repo ([docs/agents/release.md](docs/agents/release.md)). Every "done" names what was **not** verified.
Never merge onto a red `main`.

## Before you touch…
- Branches, PRs, CI, dependency pins → [docs/agents/delivery.md](docs/agents/delivery.md)
- Releasing a skill change, README changelog, dogfooding → [docs/agents/release.md](docs/agents/release.md)

## Conventions
- English everywhere. Commits are conventional (`feat(agentic-setup): …`, `fix(pr): …`).
- Every PR body follows the `pr` skill ([.agents/skills/pr](.agents/skills/pr/SKILL.md)); a hook enforces its sections.
- Keep `SKILL.md` concise — it loads whenever the skill triggers. Route detail to `references/`, files to copy to `assets/`.
- Comments only for what the code can't say: the non-obvious why, an invariant, a decision reference. One line, two at most.
- Only a decision that shapes the system gets an entry in [docs/decisions/](docs/decisions/README.md), in the same PR. Calibrate on [examples.md](docs/decisions/examples.md); in doubt, leave it out.
- Use the latest stable versions — verify with `npm view <pkg> version` before pinning; never assume from memory.
- Any other `.md` in the repo root or `docs/` is archive, not a to-do list — don't read it unprompted.

## Code Review Rules
### Correctness
- A renamed or added asset without the matching `SKILL.md` table row (or the reverse) is a bug.
- A skill instruction that names a command, flag or field must match what the tool does today.
### Security
- Assets must not contain real secrets, tokens or personal data; placeholders are `<…>`.
- Hooks and scripts must not run network or destructive commands beyond what their comment says.

## Writing agent instructions
- Use this file mostly as an index — keep here only what changes a decision in most sessions.
- Topic detail goes in its own `.md` in `docs/agents/`, linked under "Before you touch…" with the trigger that should make an agent open it.
- A linked file is live; an unlinked one is archive — when you move or rename one, update its link in the same PR.
- Editing this file, a skill or `docs/agents/*`? Use the `writing-for-agents` skill.
