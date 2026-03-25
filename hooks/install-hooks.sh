#!/bin/bash
# install-hooks.sh — installs SMOrchestra git hooks into the current repo
# Usage: bash ~/smorch-brain/hooks/install-hooks.sh
# Or: bash /root/.openclaw/workspace/smorch-brain/hooks/install-hooks.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)

if [ -z "$GIT_DIR" ]; then
  echo "ERROR: Not inside a git repository. Run this from your project root."
  exit 1
fi

HOOKS_DIR="$GIT_DIR/hooks"

echo "Installing SMOrchestra git hooks into $HOOKS_DIR..."

# Install commit-msg hook
cp "$SCRIPT_DIR/commit-msg" "$HOOKS_DIR/commit-msg"
chmod +x "$HOOKS_DIR/commit-msg"
echo "  commit-msg hook installed"

echo ""
echo "Done. Conventional commit validation is now active in this repo."
echo "Format: type(scope): description"
echo "Types: feat | fix | refactor | test | docs | chore | agent | hotfix"
