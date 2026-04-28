#!/usr/bin/env bash
# notify-ceo.sh — Proactive CEO notifications via @SMO-AI-CEO
# Deploy to: smo-brain at /root/.smo/queue/notify-ceo.sh
# Usage: ./notify-ceo.sh EVENT [TASK_ID] [DETAILS]
#
# Events:
#   brd_decomposed  — BRD was decomposed into tasks, awaiting approval
#   task_failed     — Task failed after all retries
#   task_stuck      — Task active for >45 min (TTL warning)
#   pr_ready        — PR created and ready for review (HIGH/MEDIUM risk only)
#   brd_complete    — All tasks in a BRD are merged
#   system_error    — System-level error (node down, queue stuck)
#   daily_digest    — Daily summary of progress
#
# Sprint 1, Fix #3 — Proactive CEO notifications

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"
source "$(dirname "$0")/db.sh"

# Telegram Bot Token and Chat ID for @SMO-AI-CEO
# These should be set as environment variables on smo-brain
BOT_TOKEN="${SMO_QUEUE_BOT_TOKEN:-}"
CHAT_ID="${SMO_QUEUE_CHAT_ID:-}"

EVENT="${1:-}"
TASK_ID="${2:-}"
DETAILS="${3:-}"

if [[ -z "$EVENT" ]]; then
  echo "Usage: ./notify-ceo.sh EVENT [TASK_ID] [DETAILS]"
  exit 1
fi

if [[ -z "$BOT_TOKEN" ]] || [[ -z "$CHAT_ID" ]]; then
  echo "WARNING: SMO_QUEUE_BOT_TOKEN or SMO_QUEUE_CHAT_ID not set — skipping notification"
  exit 0
fi

# ─── BUILD MESSAGE ───

build_message() {
  case "$EVENT" in
    brd_decomposed)
      local BRD_INFO
      BRD_INFO=$(db_query "SELECT title || ' (' || task_count || ' tasks)' FROM brds WHERE id = :1" "$TASK_ID")
      echo "📋 *BRD Decomposed*

*$TASK_ID:* $BRD_INFO

Awaiting your approval.
\`/approve-all\` to start or \`/status\` to review tasks."
      ;;

    task_failed)
      local TASK_INFO
      TASK_INFO=$(db_query "SELECT title || ' (' || role || '@' || server_node || ')' FROM tasks WHERE id = :1" "$TASK_ID")
      echo "❌ *Task Failed*

*$TASK_ID:* $TASK_INFO
${DETAILS:+*Reason:* $DETAILS}

Action needed: review logs or reassign."
      ;;

    task_stuck)
      local STUCK_INFO
      STUCK_INFO=$(db_query "SELECT title || ' — ' || CAST(ROUND((julianday('now') - julianday(session_started_at)) * 24 * 60, 0) AS INTEGER) || 'min elapsed' FROM tasks WHERE id = :1" "$TASK_ID")
      echo "⚠️ *Task Stuck (TTL Warning)*

*$TASK_ID:* $STUCK_INFO

Will auto-kill at 60min. \`/extend $TASK_ID\` to add 30min or \`/kill $TASK_ID\` to stop."
      ;;

    pr_ready)
      local PR_INFO
      PR_INFO=$(db_query "SELECT title || ' | Risk: ' || risk_tier || ' | Score: ' || COALESCE(CAST(quality_score AS TEXT), 'N/A') FROM tasks WHERE id = :1" "$TASK_ID")
      local PR_URL
      PR_URL=$(db_query "SELECT pr_url FROM tasks WHERE id = :1" "$TASK_ID")
      echo "🔍 *PR Ready for Review*

*$TASK_ID:* $PR_INFO
*Link:* $PR_URL"
      ;;

    brd_complete)
      local BRD_SUMMARY
      BRD_SUMMARY=$(db_query "SELECT title || ': ' || task_count || '/' || task_count || ' tasks merged' FROM brds WHERE id = :1" "$TASK_ID")
      echo "✅ *BRD Complete!*

*$TASK_ID:* $BRD_SUMMARY

All tasks merged successfully."
      ;;

    system_error)
      echo "🚨 *System Error*

${DETAILS:-Unknown system error}

Check smo-brain logs: \`/root/.smo/logs/\`"
      ;;

    daily_digest)
      local ACTIVE QUEUED MERGED FAILED TOTAL
      ACTIVE=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'active'")
      QUEUED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'queued'")
      MERGED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'merged'")
      FAILED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status IN ('failed', 'killed')")
      TOTAL=$(db_query "SELECT COUNT(*) FROM tasks")
      local PENDING_BRD
      PENDING_BRD=$(db_query "SELECT COUNT(*) FROM brds WHERE status NOT IN ('completed', 'failed')")
      echo "📊 *Daily Digest*

Active: $ACTIVE | Queued: $QUEUED
Merged: $MERGED | Failed: $FAILED
Total: $TOTAL | Open BRDs: $PENDING_BRD

\`/status\` for details."
      ;;

    *)
      echo "📌 *Notification*

Event: $EVENT
${TASK_ID:+Task: $TASK_ID}
${DETAILS:+Details: $DETAILS}"
      ;;
  esac
}

MESSAGE=$(build_message)

# ─── SEND VIA TELEGRAM ───

RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -H "Content-Type: application/json" \
  -d "$(jq -n --arg chat "$CHAT_ID" --arg text "$MESSAGE" \
    '{chat_id: $chat, text: $text, parse_mode: "Markdown"}')" 2>/dev/null)

if echo "$RESPONSE" | jq -e '.ok == true' >/dev/null 2>&1; then
  echo "Notification sent: $EVENT"
else
  echo "WARNING: Failed to send notification: $(echo "$RESPONSE" | jq -r '.description // "unknown error"')" >&2
fi
