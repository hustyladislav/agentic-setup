# UI: shadcn/ui on Tailwind v4

<!-- TEMPLATE: adapt paths and tokens; delete what doesn't apply. -->
Every new or touched screen is built from shadcn components (Base UI flavour). Use the `shadcn`
and `frontend-design` skills.

## Where things live
- `<src/ui/primitives>/*` — shadcn components, restyled once to the project tokens. Add with
  `pnpm dlx shadcn@latest add <name>`; never `--overwrite` without reading the diff.
- `<globals.css>` — the only theme file: tokens feed the shadcn roles (`--background`, `--primary`, …)
  and Tailwind's `@theme`, light and dark.
- `<docs/DESIGN.md>` — the design system: tokens, type, spacing, page patterns.

## Rules
- Compose primitives before writing custom markup; variants before ad-hoc classes.
- Base UI, not Radix: custom triggers use `render={<Button />}` (not `asChild`). A link that looks like a
  button is a real `<Link>` with `className={buttonVariants(…)}` (`Button render={<Link />}` gets `role="button"`).
- Semantic colors only (`bg-primary`, `text-muted-foreground`, `bg-destructive/10`…). No raw hex in
  `className`; a missing role goes in the theme file.
- Every user-facing string lives in the copy/i18n module, never inline.
- Status is icon + text + color, never color alone. Inputs have labels (tests use `getByLabel`).

## Proof
Before/after screenshots at 1440 and 390 px, light and dark, in the PR. Run the a11y e2e (axe) for
touched pages. Wait for hydration and finished transitions before clicking or measuring in tests.
