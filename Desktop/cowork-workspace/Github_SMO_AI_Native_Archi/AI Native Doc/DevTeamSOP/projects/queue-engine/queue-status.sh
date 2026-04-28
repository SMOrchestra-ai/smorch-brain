#!/usr/bin/env bash
# queue-status.sh — Query queue status for Telegram /status command
# Deploy to: smo-brain at /root/.smo/queue/queue-status.sh
# Usage: ./queue-status.sh [--active|--queue|--all|--task TASK-XXX]

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"

# Load parameterized SQL wrapper (Sprint 1, Fix #1 — SQL injection prevention)
source "$(dirname "$0")/db.sh"

MODE="${1:---all}"
TASK_ID="${2:-}"
# Output format: --json flag on any mode switches to JSON output
OUTPUT_FORMAT="text"
for arg in "$@"; do
  [[ "$arg" == "--json" ]] && OUTPUT_FORMAT="json"
done

case "$MODE" in
  --active)
    db_query "
      SELECT '🔄 ' || id || ': ' || title || ' (' || role || ' on ' || server_node || ')' ||
             CASE WHEN session_started_at IS NOT NULL
               THEN ' — ' || CAST(ROUND((julianday('now') - julianday(session_started_at)) * 24 * 60, 0) AS INTEGER) || 'min'
               ELSE '' END
      FROM tasks WHERE status = 'active' ORDER BY session_started_at;
    "
    COUNT=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'active';")
    echo "---"
    echo "Active: $COUNT tasks"
    ;;

  --queue)
    db_query "
      SELECT '⏳ ' || id || ': ' || title || ' (' || role || ')' ||
             CASE WHEN blocked_by IS NOT NULL AND blocked_by != ''
               THEN ' ← blocked by ' || blocked_by
               ELSE '' END
      FROM tasks WHERE status IN ('queued', 'pending_approval') ORDER BY created_at;
    "
    QUEUED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'queued';")
    PENDING=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'pending_approval';")
    echo "---"
    echo "Queued: $QUEUED | Pending approval: $PENDING"
    ;;

  --task)
    if [[ -z "$TASK_ID" ]]; then
      echo "Usage: ./queue-status.sh --task TASK-XXX"
      exit 1
    fi
    db_query_json "SELECT * FROM tasks WHERE id = :1" "$TASK_ID"
    ;;

  --dead-letters)
    # Dead letter queue (Sprint 1, Fix #6)
    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
      db_query_json "SELECT dl.task_id, t.title, dl.failure_reason, dl.last_error, dl.retry_count, dl.resolved, dl.created_at FROM dead_letters dl JOIN tasks t ON dl.task_id = t.id WHERE dl.resolved = 0 ORDER BY dl.created_at DESC"
    else
      COUNT=$(db_query "SELECT COUNT(*) FROM dead_letters WHERE resolved = 0")
      if [[ $COUNT -eq 0 ]]; then
        echo "No unresolved dead letters."
      else
        echo "💀 Dead Letters ($COUNT unresolved):"
        db_query "SELECT '  ' || dl.task_id || ' | ' || t.title || ' | ' || dl.failure_reason || ' | ' || dl.created_at FROM dead_letters dl JOIN tasks t ON dl.task_id = t.id WHERE dl.resolved = 0 ORDER BY dl.created_at DESC"
      fi
    fi
    ;;

  --summary)
    db_query "SELECT status, COUNT(*) as count FROM tasks GROUP BY status ORDER BY
      CASE status WHEN 'active' THEN 1 WHEN 'queued' THEN 2 WHEN 'ci_pending' THEN 3
      WHEN 'scoring' THEN 4 WHEN 'pr_open' THEN 5 WHEN 'pending_approval' THEN 6
      WHEN 'merged' THEN 7 WHEN 'killed' THEN 8 WHEN 'failed' THEN 9 END;"
    ;;

  --all|*)
    # Header
    TOTAL=$(db_query "SELECT COUNT(*) FROM tasks;")
    ACTIVE=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'active';")
    QUEUED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'queued';")
    PENDING=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'pending_approval';")
    MERGED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'merged';")
    FAILED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status IN ('failed', 'killed');")

    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
      # JSON output for n8n / Paperclip (Sprint 1, Fix #5)
      ACTIVE_JSON=$(db_query_json "SELECT id, title, role, server_node, CAST(ROUND((julianday('now') - julianday(session_started_at)) * 24 * 60, 0) AS INTEGER) as minutes_elapsed FROM tasks WHERE status = 'active' ORDER BY session_started_at" 2>/dev/null || echo "[]")
      QUEUED_JSON=$(db_query_json "SELECT id, title, role, blocked_by FROM tasks WHERE status = 'queued' ORDER BY created_at" 2>/dev/null || echo "[]")
      PENDING_JSON=$(db_query_json "SELECT id, title, role, server_node FROM tasks WHERE status = 'pending_approval' ORDER BY created_at" 2>/dev/null || echo "[]")
      ACCOUNTS_JSON=$(db_query_json "SELECT na.node, a.name as account_name, na.max_concurrent, COUNT(CASE WHEN t.status = 'active' THEN 1 END) as active_count FROM node_accounts na JOIN accounts a ON na.account_id = a.id LEFT JOIN tasks t ON t.server_node = na.node AND t.status = 'active' GROUP BY na.node" 2>/dev/null || echo "[]")
      cat <<JSONEOF
{
  "summary": {"total": $TOTAL, "active": $ACTIVE, "queued": $QUEUED, "pending": $PENDING, "merged": $MERGED, "failed": $FAILED},
  "active_tasks": $ACTIVE_JSON,
  "queued_tasks": $QUEUED_JSON,
  "pending_tasks": $PENDING_JSON,
  "accounts": $ACCOUNTS_JSON,
  "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
}
JSONEOF
    else
      # Text output for Telegram
      echo "📊 Queue Status"
      echo "═══════════════════════════"
      echo "Active:   $ACTIVE"
      echo "Queued:   $QUEUED"
      echo "Pending:  $PENDING"
      echo "Merged:   $MERGED"
      echo "Failed:   $FAILED"
      echo "Total:    $TOTAL"
      echo "═══════════════════════════"

      # Active tasks with elapsed time
      if [[ $ACTIVE -gt 0 ]]; then
        echo ""
        echo "🔄 Active Tasks:"
        db_query "
          SELECT '  ' || id || ' | ' || title || ' | ' || role || '@' || server_node ||
                 ' | ' || CAST(ROUND((julianday('now') - julianday(session_started_at)) * 24 * 60, 0) AS INTEGER) || 'min'
          FROM tasks WHERE status = 'active' ORDER BY session_started_at;
        "
      fi

      # Queued tasks
      if [[ $QUEUED -gt 0 ]]; then
        echo ""
        echo "⏳ Queued:"
        db_query "
          SELECT '  ' || id || ' | ' || title || ' | ' || role ||
                 CASE WHEN blocked_by IS NOT NULL AND blocked_by != ''
                   THEN ' ← blocked: ' || blocked_by ELSE '' END
          FROM tasks WHERE status = 'queued' ORDER BY created_at;
        "
      fi

      # Pending approval
      if [[ $PENDING -gt 0 ]]; then
        echo ""
        echo "🔒 Pending Approval:"
        db_query "
          SELECT '  ' || id || ' | ' || title || ' | ' || role || '@' || server_node
          FROM tasks WHERE status = 'pending_approval' ORDER BY created_at;
        "
      fi

      # Account usage
      echo ""
      echo "💰 Account Usage:"
      db_query "
        SELECT '  ' || na.node || ' (' || a.name || '): ' ||
               COUNT(CASE WHEN t.status = 'active' THEN 1 END) || '/' || na.max_concurrent || ' slots'
        FROM node_accounts na
        JOIN accounts a ON na.account_id = a.id
        LEFT JOIN tasks t ON t.server_node = na.node AND t.status = 'active'
        GROUP BY na.node;
      "
    fi
    ;;
esac
