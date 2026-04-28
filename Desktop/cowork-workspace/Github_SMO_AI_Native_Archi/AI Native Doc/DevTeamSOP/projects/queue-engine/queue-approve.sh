#!/usr/bin/env bash
# queue-approve.sh — Approve/reject/kill tasks in the queue
# Deploy to: smo-brain at /root/.smo/queue/queue-approve.sh
# Usage:
#   ./queue-approve.sh approve TASK-XXX          # approve single task
#   ./queue-approve.sh approve-all               # approve all pending
#   ./queue-approve.sh reject TASK-XXX [reason]  # reject with reason
#   ./queue-approve.sh kill TASK-XXX             # kill active task
#   ./queue-approve.sh pause                     # pause all dispatch
#   ./queue-approve.sh resume                    # resume dispatch

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"

# Load parameterized SQL wrapper (Sprint 1, Fix #1 — SQL injection prevention)
source "$(dirname "$0")/db.sh"

ACTION="${1:-}"
TASK_ID="${2:-}"
REASON="${3:-}"

# audit() is now provided by db.sh

case "$ACTION" in
  approve)
    if [[ -z "$TASK_ID" ]]; then
      echo "Usage: ./queue-approve.sh approve TASK-XXX"
      exit 1
    fi
    STATUS=$(db_query "SELECT status FROM tasks WHERE id = :1" "$TASK_ID")
    if [[ "$STATUS" != "pending_approval" ]]; then
      echo "Task $TASK_ID is '$STATUS', not pending_approval"
      exit 1
    fi
    db_update_task "$TASK_ID" "status" "queued"
    audit "$TASK_ID" "approved" "{\"from\": \"pending_approval\", \"to\": \"queued\"}"
    echo "✅ $TASK_ID approved → queued"
    ;;

  approve-all)
    COUNT=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'pending_approval'")
    if [[ $COUNT -eq 0 ]]; then
      echo "No tasks pending approval"
      exit 0
    fi
    TASK_IDS=$(db_query "SELECT id FROM tasks WHERE status = 'pending_approval'")
    db_exec "UPDATE tasks SET status = 'queued', updated_at = datetime('now') WHERE status = 'pending_approval'"
    for tid in $TASK_IDS; do
      audit "$tid" "approved" "{\"from\": \"pending_approval\", \"to\": \"queued\", \"batch\": true}"
    done
    echo "✅ $COUNT tasks approved → queued"
    echo "$TASK_IDS"
    ;;

  reject)
    if [[ -z "$TASK_ID" ]]; then
      echo "Usage: ./queue-approve.sh reject TASK-XXX [reason]"
      exit 1
    fi
    db_update_task "$TASK_ID" "status" "killed"
    audit "$TASK_ID" "rejected" "{\"reason\": \"$REASON\"}"
    echo "❌ $TASK_ID rejected"
    ;;

  kill)
    if [[ -z "$TASK_ID" ]]; then
      echo "Usage: ./queue-approve.sh kill TASK-XXX"
      exit 1
    fi
    PID=$(db_query "SELECT session_pid FROM tasks WHERE id = :1" "$TASK_ID")
    if [[ -n "$PID" ]] && [[ "$PID" != "" ]]; then
      kill "$PID" 2>/dev/null || true
      echo "Killed PID $PID"
    fi
    db_update_task "$TASK_ID" "status" "killed"
    db_release_locks "$TASK_ID"
    audit "$TASK_ID" "killed" "{\"pid\": \"$PID\"}"
    echo "💀 $TASK_ID killed"
    ;;

  pause)
    # Create a pause flag file
    touch /root/.smo/queue/.paused
    audit "SYSTEM" "paused" "{\"action\": \"dispatch_paused\"}"
    echo "⏸️  Dispatch paused. Run ./queue-approve.sh resume to restart."
    ;;

  resume)
    rm -f /root/.smo/queue/.paused
    audit "SYSTEM" "resumed" "{\"action\": \"dispatch_resumed\"}"
    echo "▶️  Dispatch resumed."
    ;;

  *)
    echo "Usage: ./queue-approve.sh {approve|approve-all|reject|kill|pause|resume} [TASK-ID] [reason]"
    exit 1
    ;;
esac
