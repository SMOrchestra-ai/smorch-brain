#!/bin/bash
# Run this manually: bash cleanup-smorch-dev.sh
# Removes smo-skill-creator and smorch-tool-super-admin-creator from smorch-dev plugin
# Both are already copied to their new homes (smorch-gtm-engine and smorch-gtm-tools)

BRAIN="$(cd "$(dirname "$0")" && pwd)"

echo "=== Removing 2 skills + 2 commands from smorch-dev ==="
mkdir -p "$BRAIN/plugins/smorch-dev/_removed-2026-03-25"
mv "$BRAIN/plugins/smorch-dev/skills/smo-skill-creator" "$BRAIN/plugins/smorch-dev/_removed-2026-03-25/"
mv "$BRAIN/plugins/smorch-dev/skills/smorch-tool-super-admin-creator" "$BRAIN/plugins/smorch-dev/_removed-2026-03-25/"
mv "$BRAIN/plugins/smorch-dev/commands/create-skill.md" "$BRAIN/plugins/smorch-dev/_removed-2026-03-25/"
mv "$BRAIN/plugins/smorch-dev/commands/build-operator.md" "$BRAIN/plugins/smorch-dev/_removed-2026-03-25/"
echo "  Done. Backed up to _removed-2026-03-25/"

echo ""
echo "=== Rebuilding all 3 affected plugins ==="

echo "Building smorch-dev.plugin..."
cd "$BRAIN/plugins/smorch-dev" && zip -r "$BRAIN/dist/smorch-dev.plugin" . -x ".*" -x "_removed*" > /dev/null 2>&1
echo "  $(du -h "$BRAIN/dist/smorch-dev.plugin" | cut -f1) | $(ls skills/ | grep -v _removed | wc -l | tr -d ' ') skills"

echo "Building smorch-gtm-engine.plugin..."
cd "$BRAIN/plugins/smorch-gtm-engine" && zip -r "$BRAIN/dist/smorch-gtm-engine.plugin" . -x ".*" > /dev/null 2>&1
echo "  $(du -h "$BRAIN/dist/smorch-gtm-engine.plugin" | cut -f1) | $(ls skills/ | wc -l | tr -d ' ') skills"

echo "Building smorch-gtm-tools.plugin..."
cd "$BRAIN/plugins/smorch-gtm-tools" && zip -r "$BRAIN/dist/smorch-gtm-tools.plugin" . -x ".*" > /dev/null 2>&1
echo "  $(du -h "$BRAIN/dist/smorch-gtm-tools.plugin" | cut -f1) | $(ls skills/ | wc -l | tr -d ' ') skills"

echo ""
echo "=== Final state ==="
echo "smorch-dev:        $(ls "$BRAIN/plugins/smorch-dev/skills/" | grep -v _removed) ($(ls "$BRAIN/plugins/smorch-dev/skills/" | grep -v _removed | wc -l | tr -d ' ') skills)"
echo "smorch-gtm-engine: has smo-skill-creator = $([ -d "$BRAIN/plugins/smorch-gtm-engine/skills/smo-skill-creator" ] && echo YES || echo NO)"
echo "smorch-gtm-tools:  has super-admin-creator = $([ -d "$BRAIN/plugins/smorch-gtm-tools/skills/smorch-tool-super-admin-creator" ] && echo YES || echo NO)"
echo ""
echo "Done! Now run: cd $BRAIN && git add -A && git commit -m 'feat: move skills between plugins' && git push origin dev"
