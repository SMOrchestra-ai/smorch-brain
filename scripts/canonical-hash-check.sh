#!/bin/bash
# Canonical hash check — called from SessionStart hook.
# Compares local settings.json and CLAUDE.md to canonical in smorch-brain.
# Outputs a single warning line if drift detected (so SessionStart additionalContext picks it up).

BRAIN="${BRAIN:-/Users/mamounalamouri/Desktop/cowork-workspace/CodingProjects/smorch-brain}"

LOCAL_SETTINGS_HASH=$(sha256sum ~/.claude/settings.json 2>/dev/null | awk '{print $1}')
CANON_SETTINGS_HASH=$(sha256sum "$BRAIN/canonical/settings/local-settings.json" 2>/dev/null | awk '{print $1}')

LOCAL_CLAUDE_HASH=$(sha256sum ~/.claude/CLAUDE.md 2>/dev/null | awk '{print $1}')
CANON_CLAUDE_HASH=$(sha256sum "$BRAIN/canonical/claude-md/local-CLAUDE.md" 2>/dev/null | awk '{print $1}')

WARN=""
if [ -n "$CANON_SETTINGS_HASH" ] && [ "$LOCAL_SETTINGS_HASH" != "$CANON_SETTINGS_HASH" ]; then
  WARN="$WARN | Local settings.json differs from canonical — run 'bash $BRAIN/scripts/check-config-drift.sh' to investigate."
fi
if [ -n "$CANON_CLAUDE_HASH" ] && [ "$LOCAL_CLAUDE_HASH" != "$CANON_CLAUDE_HASH" ]; then
  WARN="$WARN | Local CLAUDE.md differs from canonical."
fi

echo "$WARN"
