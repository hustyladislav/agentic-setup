# Environment: hosting, env vars, database, migrations

<!-- TEMPLATE: fill in for this project. -->
- **Hosting:** <provider / project / region>. Production deploys only from `main` via Git (see [delivery.md](delivery.md)).
- **Database:** <provider / region>. Local dev and tests use <a local or per-developer database> — never production.
- **Migrations:** generated with <tool>, committed, applied only by production builds (or a preview's own branch DB).
- **Env vars:** managed in <provider>; pull locally with `<command>`. `.env*` is git-ignored. Never print values — check whether a variable is set.
- **Cron / background jobs:** <where they run, how they are authenticated>.
