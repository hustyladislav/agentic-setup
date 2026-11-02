#!/usr/bin/env bash
# The repo's whole check bundle; CI runs exactly this. Needs ruby, jq, shellcheck.
set -euo pipefail
cd "$(dirname "$0")/.."

ruby scripts/validate.rb

shellcheck .claude/hooks/*.sh scripts/*.sh skills/agentic-setup/assets/claude/hooks/*.sh

# Hook simulation: an incomplete PR body must be denied, a complete one allowed.
for hook in .claude/hooks/pr-body-check.sh skills/agentic-setup/assets/claude/hooks/pr-body-check.sh; do
  out=$(echo '{"tool_input":{"command":"gh pr create --body x"}}' | "$hook")
  jq -e '.hookSpecificOutput.permissionDecision == "deny"' <<<"$out" >/dev/null || { echo "$hook did not deny an incomplete body"; exit 1; }
  full=$(mktemp)
  printf '%s\n' '**x**' '## Summary' '## Evidence' '- **Not verified:** x' '## Merge Danger' '**Door:** two-way' '**Blast radius:** none' >"$full"
  out=$(jq -n --arg c "gh pr create --body-file $full" '{tool_input:{command:$c}}' | "$hook")
  rm -f "$full"
  [[ -z $out ]] || { echo "$hook denied a complete body"; exit 1; }
done
cmp .claude/hooks/pr-body-check.sh skills/agentic-setup/assets/claude/hooks/pr-body-check.sh
cmp .claude/hooks/pr-body-refresh.sh skills/agentic-setup/assets/claude/hooks/pr-body-refresh.sh
echo "check: ok"
