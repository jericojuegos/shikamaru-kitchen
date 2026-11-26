#!/usr/bin/env bash
# ==============================================================================
# shikamaru-kitchen/scripts/eval-kitchen.sh
# Validates Universal Michelin-Grade Software Craft contracts
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TOTAL=0
PASSED=0
FAILED=0

assert_eval() {
  local name="$1"
  local condition="$2"
  TOTAL=$((TOTAL + 1))
  if eval "$condition"; then
    PASSED=$((PASSED + 1))
    echo "  [PASS] $name"
  else
    FAILED=$((FAILED + 1))
    echo "  [FAIL] $name"
  fi
}

echo ""
echo "=================================================================="
echo " SHIKAMARU-KITCHEN UNIVERSAL SOFTWARE CRAFT EVAL SUITE (v1.0)"
echo "=================================================================="

assert_eval ".agents/rules/kitchen-protocol.md exists" "[ -f '$REPO_ROOT/.agents/rules/kitchen-protocol.md' ]"
assert_eval "No hardcoded stacks/ directory exists" "[ ! -d '$REPO_ROOT/stacks' ]"
assert_eval ".agents/templates/stack-rules.md.template exists" "[ -f '$REPO_ROOT/.agents/templates/stack-rules.md.template' ]"
assert_eval "prototype unified spec.md.template exists" "[ -f '$REPO_ROOT/.agents/skills/prototype/resources/spec.md.template' ]"
assert_eval "prototype preview-wp-admin.html.template exists" "[ -f '$REPO_ROOT/.agents/skills/prototype/resources/preview-wp-admin.html.template' ]"

for skill in design scaffold prototype craft polish; do
  assert_eval ".agents/skills/$skill/SKILL.md exists" "[ -f '$REPO_ROOT/.agents/skills/$skill/SKILL.md' ]"
done
assert_eval "scaffold enforces Test Integrity & Anti-Slopsquatting" "grep -q 'Test Integrity' '$REPO_ROOT/.agents/skills/scaffold/SKILL.md' && grep -q 'Anti-Slopsquatting' '$REPO_ROOT/.agents/skills/scaffold/SKILL.md'"
assert_eval "craft enforces Red-First Pass 1" "grep -q 'Red-First' '$REPO_ROOT/.agents/skills/craft/SKILL.md'"
assert_eval "polish enforces Gate Immutability & 3-viewport overlap QA" "grep -q 'Gate & Test-Tamper Immutability' '$REPO_ROOT/.agents/skills/polish/SKILL.md' && grep -q 'getBoundingClientRect' '$REPO_ROOT/.agents/skills/polish/SKILL.md'"

echo "=================================================================="
if [ "$FAILED" -eq 0 ]; then
  echo " KITCHEN EVAL RESULT: PASS ($PASSED / $TOTAL checks passed)"
  echo "=================================================================="
  exit 0
else
  echo " KITCHEN EVAL RESULT: FAIL ($PASSED / $TOTAL passed, $FAILED failed)"
  echo "=================================================================="
  exit 1
fi
