# Security, auth and tenancy

<!-- TEMPLATE: pin each "Never break" rule from AGENTS.md here with where it is enforced. -->
- **Secrets:** only in the hosting provider's env store; never in code, logs, error messages or client bundles. `gitleaks` runs in CI.
- **Tenancy:** every query is scoped by the authenticated tenant from the request context. A test suite replays one tenant's ids as another for every procedure and expects not-found/forbidden — a new procedure without a case fails it.
- **Public endpoints:** unguessable, revocable tokens; no private notes or internal ids; `noindex`; rate-limited.
- **Auth:** <library/provider>; session cookies secure + same-site; rate limits on sign-in, sign-up and magic links.
- **Headers:** CSP (nonce), HSTS, frame-ancestors none, referrer and permissions policies.
- **CI:** CodeQL, gitleaks, OSV-Scanner, dependency review, Dependabot.
