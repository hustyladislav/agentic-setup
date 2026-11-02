# 0001 — Agent-first repository

- Date: 2026-11-02
- Status: accepted
- Decided by: founder

## Context
Most code in this repo is written and reviewed by AI agents (Claude Code, Codex) working in parallel.
Without shared rules they drift: inconsistent PRs, unverified "done", stale pinned versions, merges onto red `main`.

## Decision
`AGENTS.md` is a short index loaded every session; topic rules live in `docs/agents/*.md`; system-shaping
decisions live here. The repo practises what `skills/agentic-setup` preaches: shared skills are installed with the
skills CLI into `.agents/skills` and pinned in `skills-lock.json`, hooks enforce the PR template, branch protection
requires CI and up-to-date branches.

## Rejected
- **One long AGENTS.md:** loads every session and buries the rules that matter.
- **Per-tool instruction files with duplicated content:** they drift; `CLAUDE.md` just imports `AGENTS.md`.

## Consequences
New rules need a home (index line + topic file). If the skill's own advice changes, this repo adopts it in the same PR.
