#!/usr/bin/env bash
# task-complete.sh — Handle agent session completion
# Deploy to: smo-brain at /root/.smo/queue/task-complete.sh
# Usage: ./task-complete.sh TASK-XXX [exit_code]
#
# Called when an agent session finishes (or is detected as finished).
# Records artifacts, triggers quality gate scoring, updates status.

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"
LOG_DIR="/root/.smo/logs"
WORKSPACES="/workspaces/smo"
SCRIPTS_DIR="/root/.smo/queue"

# Load parameterized SQL wrapper (Sprint 1, Fix #1 — SQL injection prevention)
source "$(dirname "$0")/db.sh"

TASK_ID="${1:-}"
EXIT_CODE="${2:-0}"

if [[ -z "$TASK_ID" ]]; then
  echo "Usage: ./task-complete.sh TASK-XXX [exit_code]"
  exit 1
fi

mkdir -p "$LOG_DIR"

log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [complete] $1"
  echo "$msg"
  echo "$msg" >> "$LOG_DIR/task-complete.log"
}

# audit() is now provided by db.sh

# ─── LOAD TASK ───

TASK_JSON=$(db_query_json "SELECT * FROM tasks WHERE id = :1 LIMIT 1" "$TASK_ID")
if [[ -z "$TASK_JSON" ]] || [[ "$TASK_JSON" == "[]" ]]; then
  log "ERROR: Task $TASK_ID not found"
  exit 1
fi

REPO=$(echo "$TASK_JSON" | jq -r '.[0].repo')
BRANCH=$(echo "$TASK_JSON" | jq -r '.[0].branch')
TITLE=$(echo "$TASK_JSON" | jq -r '.[0].title')
SERVER_NODE=$(echo "$TASK_JSON" | jq -r '.[0].server_node')
STATUS=$(echo "$TASK_JSON" | jq -r '.[0].status')

log "Task $TASK_ID completed (exit: $EXIT_CODE, status was: $STATUS)"

# ─── HANDLE FAILURE ───

if [[ "$EXIT_CODE" != "0" ]]; then
  RETRY=$(db_query "SELECT COALESCE(retry_count, 0) FROM tasks WHERE id = :1" "$TASK_ID")
  if [[ $RETRY -lt 2 ]]; then
    NEW_RETRY=$((RETRY + 1))
    log "Agent failed (exit $EXIT_CODE) — requeueing (attempt $NEW_RETRY/2)"
    db_exec "UPDATE tasks SET status = 'queued', retry_count = :1, session_pid = NULL, session_started_at = NULL, updated_at = datetime('now') WHERE id = :2" \
      "$NEW_RETRY" "$TASK_ID"
    db_release_locks "$TASK_ID"
    audit "$TASK_ID" "agent_failed_retry" "{\"exit_code\": $EXIT_CODE, \"attempt\": $NEW_RETRY}"
  else
    log "Agent failed after $RETRY retries — marking failed + dead letter"
    db_exec "UPDATE tasks SET status = 'failed', session_pid = NULL, updated_at = datetime('now') WHERE id = :1" "$TASK_ID"
    db_release_locks "$TASK_ID"
    # Dead letter queue entry (Sprint 1, Fix #6)
    local BRD_ID_DL
    BRD_ID_DL=$(db_query "SELECT COALESCE(brd_id, '') FROM tasks WHERE id = :1" "$TASK_ID")
    db_exec "INSERT INTO dead_letters (task_id, brd_id, original_status, failure_reason, retry_count, last_error) VALUES (:1, :2, 'active', :3, :4, :5)" \
      "$TASK_ID" "$BRD_ID_DL" "Agent failed after max retries" "$RETRY" "exit_code=$EXIT_CODE"
    audit "$TASK_ID" "dead_lettered" "{\"exit_code\": $EXIT_CODE, \"retries\": $RETRY}"
    # Proactive CEO notification (Sprint 1, Fix #3)
    "$SCRIPTS_DIR/notify-ceo.sh" "task_failed" "$TASK_ID" "Exit code $EXIT_CODE after $RETRY retries" 2>/dev/null &
  fi
  exit 0
fi

# ─── RECORD ARTIFACTS ───

REPO_DIR="$WORKSPACES/$(basename "$REPO")"
if [[ -d "$REPO_DIR" ]]; then
  cd "$REPO_DIR"
  git fetch origin 2>/dev/null || true

  # Get files changed on this branch vs main
  CHANGED_FILES=$(git diff --name-only origin/main..."origin/$BRANCH" 2>/dev/null || echo "")
  if [[ -n "$CHANGED_FILES" ]]; then
    while IFS= read -r file; do
      db_add_artifact "$TASK_ID" "modified_file" "$file"
    done <<< "$CHANGED_FILES"
    log "Recorded ${#CHANGED_FILES} artifacts"
  fi

  # Check if branch has commits
  COMMIT_COUNT=$(git rev-list --count origin/main..."origin/$BRANCH" 2>/dev/null || echo "0")
  log "Branch $BRANCH has $COMMIT_COUNT new commits"

  if [[ "$COMMIT_COUNT" -eq 0 ]]; then
    log "WARNING: No commits on branch — marking as failed (no work done)"
    db_update_task "$TASK_ID" "status" "failed"
    db_release_locks "$TASK_ID"
    # Dead letter (Sprint 1, Fix #6)
    local BRD_ID_NC
    BRD_ID_NC=$(db_query "SELECT COALESCE(brd_id, '') FROM tasks WHERE id = :1" "$TASK_ID")
    db_exec "INSERT INTO dead_letters (task_id, brd_id, original_status, failure_reason, last_error) VALUES (:1, :2, 'active', 'No commits on branch', :3)" \
      "$TASK_ID" "$BRD_ID_NC" "branch=$BRANCH"
    audit "$TASK_ID" "no_commits" "{\"branch\": \"$BRANCH\"}"
    "$SCRIPTS_DIR/notify-ceo.sh" "task_failed" "$TASK_ID" "No commits produced on branch $BRANCH" 2>/dev/null &
    exit 0
  fi
fi

# ─── TRIGGER QUALITY GATE ───

log "Triggering quality gate scoring..."
db_exec "UPDATE tasks SET status = 'scoring', session_pid = NULL, updated_at = datetime('now') WHERE id = :1" "$TASK_ID"

audit "$TASK_ID" "session_complete" "{\"exit_code\": $EXIT_CODE}"

# Run scorer (async - it will update status and create PR)
nohup /root/.smo/queue/score-task.sh "$TASK_ID" >> "$LOG_DIR/scorer.log" 2>&1 &
log "Scorer started (PID $!)"
