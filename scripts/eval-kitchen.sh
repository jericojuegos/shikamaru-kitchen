#!/usr/bin/env bash
# ==============================================================================
# shikamaru-kitchen/scripts/eval-kitchen.sh
# Validates Universal Michelin Kitchen contracts
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
echo " SHIKAMARU-KITCHEN UNIVERSAL MICHELIN BRIGADE EVAL SUITE (v1.0)"
echo "=================================================================="

assert_eval "core/rules/kitchen-protocol.md exists" "[ -f '$REPO_ROOT/core/rules/kitchen-protocol.md' ]"
assert_eval "No hardcoded stacks/ directory exists" "[ ! -d '$REPO_ROOT/stacks' ]"
assert_eval "core/templates/stack-rules.md.template exists" "[ -f '$REPO_ROOT/core/templates/stack-rules.md.template' ]"
assert_eval "taste unified recipe.md.template exists" "[ -f '$REPO_ROOT/core/skills/taste/resources/recipe.md.template' ]"

for skill in menu prep taste cook plate; do
  assert_eval "core/skills/$skill/SKILL.md exists" "[ -f '$REPO_ROOT/core/skills/$skill/SKILL.md' ]"
done

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
