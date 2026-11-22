#!/usr/bin/env bash
# ==============================================================================
# shikamaru-kitchen/scripts/eval-kitchen.sh
# Validates Michelin Kitchen contracts across 5 evaluation suites
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
echo " SHIKAMARU-KITCHEN MICHELIN BRIGADE EVAL SUITE (v1.0)"
echo "=================================================================="

echo ""
echo "[Suite 1] Core Kitchen Protocol & 5 Culinary Lifecycle Skills"
assert_eval "core/rules/kitchen-protocol.md exists" "[ -f '$REPO_ROOT/core/rules/kitchen-protocol.md' ]"
assert_eval "kitchen-protocol.md defines 3-Course Cooking Loop" "grep -q '3-Course Cooking Loop' '$REPO_ROOT/core/rules/kitchen-protocol.md'"
assert_eval "kitchen-protocol.md defines 4-Star Culinary Craft Standard" "grep -q '4-Star Culinary Craft' '$REPO_ROOT/core/rules/kitchen-protocol.md'"

for skill in menu prep taste cook plate; do
  assert_eval "core/skills/$skill/SKILL.md exists" "[ -f '$REPO_ROOT/core/skills/$skill/SKILL.md' ]"
  assert_eval "core/skills/$skill/SKILL.md has name frontmatter" "grep -q '^name: $skill' '$REPO_ROOT/core/skills/$skill/SKILL.md'"
done

echo ""
echo "[Suite 2] Stack Packs & 0-Token Mechanical Architecture Linters"
assert_eval "nextjs-supabase has architecture.test.ts.template" "[ -f '$REPO_ROOT/stacks/nextjs-supabase/skills/cook/examples/architecture.test.ts.template' ]"
assert_eval "python-fastapi has test_architecture.py.template" "[ -f '$REPO_ROOT/stacks/python-fastapi/skills/cook/examples/test_architecture.py.template' ]"
assert_eval "wp-hexagonal has HexagonalArchitectureTest.php.template" "[ -f '$REPO_ROOT/stacks/wp-hexagonal/skills/cook/examples/HexagonalArchitectureTest.php.template' ]"

echo ""
echo "[Suite 3] Tasting Spoon 4-State Prototype & Recipe Templates"
for tpl in recipe.md.template design.md.template courses.md.template plating.md.template preview.html.template; do
  assert_eval "taste resource $tpl exists" "[ -f '$REPO_ROOT/core/skills/taste/resources/$tpl' ]"
done

echo ""
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
