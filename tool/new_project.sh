#!/bin/bash
# new_project.sh — Create a new Flutter project with MasterTool base
#
# Usage:
#   ./tool/new_project.sh com.example my_app
#   ./tool/new_project.sh com.example my_app --org com.mycompany
#
# The script:
#   1. Runs `flutter create` (gets latest native configs)
#   2. Copies MasterTool's lib/, tool/, assets/, configs into the new project
#   3. Preserves the new project's native files (android/, ios/, web/, etc.)
#
# Requirements:
#   - Flutter SDK installed
#   - Run from the mastertool repo root directory

set -euo pipefail

ORG="${1:-com.example}"
PROJECT="${2:-}"
MASTERTOOL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "$PROJECT" ]; then
  echo "Usage: $0 <org> <project_name>"
  echo "Example: $0 com.mycompany my_app"
  exit 1
fi

TARGET="../$PROJECT"

echo "═══════════════════════════════════════════"
echo " Creating new Flutter project: $PROJECT"
echo " Organization: $ORG"
echo " Template: $MASTERTOOL_DIR"
echo "═══════════════════════════════════════════"

# Step 1: Create fresh Flutter project with latest native configs
flutter create --org "$ORG" --project-name "$PROJECT" "$TARGET"

# Step 2: Copy MasterTool template files (preserving native configs)
echo "   📦  Copying MasterTool base..."

# Copy core lib (but not main.dart — keep fresh project's entry point for manual merge)
cp -r "$MASTERTOOL_DIR/lib/core" "$TARGET/lib/"
cp -r "$MASTERTOOL_DIR/lib/features" "$TARGET/lib/features" 2>/dev/null || true

# Copy tools
cp -r "$MASTERTOOL_DIR/tool" "$TARGET/"

# Copy assets
cp -r "$MASTERTOOL_DIR/assets" "$TARGET/"

# Copy CI/CD
cp -r "$MASTERTOOL_DIR/.github" "$TARGET/" 2>/dev/null || true

# Copy docs
cp "$MASTERTOOL_DIR/AGENTS.md" "$TARGET/" 2>/dev/null || true
cp "$MASTERTOOL_DIR/STANDARDS.md" "$TARGET/" 2>/dev/null || true
cp "$MASTERTOOL_DIR/TODO_BASE_CODE.md" "$TARGET/" 2>/dev/null || true

# Copy lint config
cp "$MASTERTOOL_DIR/analysis_options.yaml" "$TARGET/"

# Copy opencode config
cp "$MASTERTOOL_DIR/opencode.json" "$TARGET/" 2>/dev/null || true

# Step 3: Preserve the freshly created main.dart (replace our template main)
cp "$MASTERTOOL_DIR/lib/main.dart" "$TARGET/lib/main.dart"

echo ""
echo "✅  Project created at: $(cd "$TARGET" && pwd)"
echo ""
echo "Next steps:"
echo "  cd $PROJECT"
echo "  # Update pubspec.yaml — add MasterTool dependencies from mastertool/pubspec.yaml"
echo "  flutter pub get"
echo "  flutter analyze"
echo "  dart run tool/build.dart --flavor dev --mode run"
