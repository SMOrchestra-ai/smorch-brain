#!/bin/bash
# Config drift detector — compares live machines to canonical snapshots.
# Run: bash scripts/check-config-drift.sh
# Cron: every 1h via n8n, or crontab on a central machine
#
# Exits 0 if no drift, 1 if drift detected.
# Sends Telegram alert on drift via BOT_TOKEN + CHAT_ID env vars.

set -eo pipefail

BRAIN="${BRAIN:-/Users/mamounalamouri/Desktop/cowork-workspace/CodingProjects/smorch-brain}"
CANON="$BRAIN/canonical"
BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
CHAT_ID="${TELEGRAM_CHAT_ID:-311453473}"

MACHINES="smo-dev:100.117.35.19 smo-prod:100.84.76.35 eo-prod:100.89.148.62 smo-test:100.105.86.13"

DRIFT_FOUND=0
REPORT=""

check_file() {
  local machine=$1
  local ip=$2
  local remote_path=$3
  local canonical_path=$4
  local label=$5

  local remote_hash
  remote_hash=$(ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "root@$ip" "sha256sum $remote_path 2>/dev/null | awk '{print \$1}'" 2>/dev/null || echo "UNREACHABLE")

  if [ "$remote_hash" = "UNREACHABLE" ]; then
    REPORT+=$'\n'"⚠️ $machine $label — UNREACHABLE"
    return 0
  fi

  local canonical_hash
  canonical_hash=$(sha256sum "$canonical_path" 2>/dev/null | awk '{print $1}')

  if [ "$remote_hash" != "$canonical_hash" ]; then
    REPORT+=$'\n'"🚨 $machine $label — DRIFT (remote=$remote_hash, canonical=$canonical_hash)"
    DRIFT_FOUND=1
  else
    REPORT+=$'\n'"✅ $machine $label — match"
  fi
}

echo "=== Config Drift Check — $(date) ==="

for entry in $MACHINES; do
  name="${entry%%:*}"
  ip="${entry##*:}"
  check_file "$name" "$ip" "/root/.claude/settings.json" "$CANON/settings/${name}-settings.json" "settings.json"
  check_file "$name" "$ip" "/root/.claude/CLAUDE.md" "$CANON/claude-md/${name}-CLAUDE.md" "CLAUDE.md"
  check_file "$name" "$ip" "/root/.claude/.mcp.json" "$CANON/mcp-json/${name}-mcp.json" ".mcp.json"
done

echo "$REPORT"

if [ $DRIFT_FOUND -eq 1 ] && [ -n "$BOT_TOKEN" ]; then
  MSG="🔔 Config Drift Alert — $(date '+%Y-%m-%d %H:%M')$REPORT"
  curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
    -d "chat_id=$CHAT_ID" \
    --data-urlencode "text=$MSG" > /dev/null
fi

exit $DRIFT_FOUND
