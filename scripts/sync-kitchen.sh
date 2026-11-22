#!/usr/bin/env bash
# ==============================================================================
# shikamaru-kitchen/scripts/sync-kitchen.sh
# Syncs the Universal Michelin Kitchen Brigade Engine into any target project.
# ==============================================================================
set -euo pipefail

PROJECT_PATH=${1:-}
FLAG=${2:-}

if [ -z "$PROJECT_PATH" ]; then
  echo "Usage: bash scripts/sync-kitchen.sh <project-path> [--local-exclude]"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CORE_DIR="$REPO_ROOT/.agents"

mkdir -p "$PROJECT_PATH"
TARGET_ROOT="$(cd "$PROJECT_PATH" && pwd)"
PROJECT_NAME="$(basename "$TARGET_ROOT")"
TODAY="$(date +%Y-%m-%d)"

mkdir -p "$TARGET_ROOT/.agents/rules" \
         "$TARGET_ROOT/.agents/skills" \
         "$TARGET_ROOT/docs/foundation/design-reference" \
         "$TARGET_ROOT/docs/planning" \
         "$TARGET_ROOT/docs/specs"

cp "$CORE_DIR/rules/"* "$TARGET_ROOT/.agents/rules/"
cp -r "$CORE_DIR/skills/"* "$TARGET_ROOT/.agents/skills/"

[ ! -f "$TARGET_ROOT/.agents/rules/stack-rules.md" ] && cp "$CORE_DIR/templates/stack-rules.md.template" "$TARGET_ROOT/.agents/rules/stack-rules.md"
[ ! -f "$TARGET_ROOT/AGENTS.md" ] && sed -e "s/\[PROJECT NAME\]/$PROJECT_NAME/g" -e "s/\[Project Name\]/$PROJECT_NAME/g" -e "s/YYYY-MM-DD/$TODAY/g" "$CORE_DIR/templates/AGENTS.md.template" > "$TARGET_ROOT/AGENTS.md"
[ ! -f "$TARGET_ROOT/CLAUDE.md" ] && cp "$CORE_DIR/templates/CLAUDE.md.template" "$TARGET_ROOT/CLAUDE.md"
[ ! -f "$TARGET_ROOT/docs/INDEX.md" ] && cp "$CORE_DIR/templates/INDEX.md.template" "$TARGET_ROOT/docs/INDEX.md"
[ ! -f "$TARGET_ROOT/docs/planning/issues.md" ] && cp "$CORE_DIR/templates/issues.md.template" "$TARGET_ROOT/docs/planning/issues.md"

if [ "$FLAG" = "--local-exclude" ]; then
  [ ! -d "$TARGET_ROOT/.git" ] && (cd "$TARGET_ROOT" && git init --quiet)
  mkdir -p "$TARGET_ROOT/.git/info"
  printf "\nAGENTS.md\nCLAUDE.md\n.agents/\ndocs/\n" >> "$TARGET_ROOT/.git/info/exclude"
fi

echo "✅ Universal Kitchen Sync Complete! Run /design -> /scaffold -> /prototype -> /craft -> /polish"
