# Decision log

The few decisions that shape the system and that the code can't explain by
itself. It is not a changelog: keep it short enough to read in one sitting.

**Log it** only when it is one of:
- Architecture: how the system is split, where work runs, the data model, tenancy.
- Infrastructure and environments: hosting, database, CI, deploys, migrations, local dev.
- A backend vendor or a core toolchain piece (runtime, package manager, compiler, linter).
- A platform-wide rule on money, security or legal exposure.
- Frontend only when it is cross-cutting (security headers, i18n, auth), never one screen.

**Don't log** a feature default, a tuning number, UI layout or copy, prompt or
creative craft, one agent's configuration, or agent/editor tooling (skills,
plugins, settings). Put the why in a one-line comment at the code or in the
commit message. In doubt, leave it out. How to calibrate: [examples.md](examples.md).

- Name: `NNNN-short-slug.md`, numbered in order (`0001-…`). Numbers are never
  reused, so gaps are expected.
- Never rewrite an accepted entry. When a decision changes, add a new one and
  set the old one's status to `superseded by NNNN`.
- Code that embodies a decision points here (`// see docs/decisions/0007`)
  instead of explaining the history inline.

## Template

```markdown
# NNNN — Title in a few words

- Date: YYYY-MM-DD
- Status: accepted | superseded by NNNN
- Decided by: founder | team

## Context
What forced a choice. Two or three sentences.

## Decision
What we do.

## Rejected
The alternatives we considered, and why each one lost.

## Consequences
What this costs us or locks in; when to revisit.
```

## Index

- [0001 — Agent-first repository](0001-agent-first-repo.md)
- [0002 — Skills install from upstream sources, not vendored](0002-skills-install-from-upstream.md)
- [0003 — One package, two skills; template repo retired](0003-one-package-two-skills.md)
