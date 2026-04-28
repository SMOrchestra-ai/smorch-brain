#!/bin/bash
# Install SMOrchestra git hooks into the current repo
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOKS_DIR="$(git rev-parse --show-toplevel 2>/dev/null)/.git/hooks"

if [ -z "$HOOKS_DIR" ]; then
    echo "❌ Not in a git repository"
    exit 1
fi

cp "$SCRIPT_DIR/commit-msg" "$HOOKS_DIR/commit-msg"
chmod +x "$HOOKS_DIR/commit-msg"
echo "✅ Installed commit-msg hook to $HOOKS_DIR"
