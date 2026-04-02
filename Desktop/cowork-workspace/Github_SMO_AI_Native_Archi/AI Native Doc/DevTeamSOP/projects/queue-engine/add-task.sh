#!/usr/bin/env bash
# add-task.sh — Add a task to the SQLite queue
# Deploy to: smo-brain at /root/.smo/queue/add-task.sh
# Usage: ./add-task.sh --repo "SMOrchestra-ai/SaaSFast" --goal "Build health check endpoint" \
#          --role vp_engineering --node smo-dev --files '["src/health.ts"]' \
#          [--blocked-by TASK-001] [--constraints '["no external deps"]'] [--tests '["npm test"]']

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"

# Load parameterized SQL wrapper (Sprint 1, Fix #1 — SQL injection prevention)
source "$(dirname "$0")/db.sh"

# ─── PARSE ARGUMENTS ───

REPO="" GOAL="" ROLE="" NODE="smo-dev" FILES="" BLOCKED_BY="" CONSTRAINTS="" TESTS="" TITLE="" BRD_ID=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)       REPO="$2";        shift 2 ;;
    --goal)       GOAL="$2";        shift 2 ;;
    --title)      TITLE="$2";       shift 2 ;;
    --role)       ROLE="$2";        shift 2 ;;
    --node)       NODE="$2";        shift 2 ;;
    --files)      FILES="$2";       shift 2 ;;
    --blocked-by) BLOCKED_BY="$2";  shift 2 ;;
    --constraints) CONSTRAINTS="$2"; shift 2 ;;
    --tests)      TESTS="$2";       shift 2 ;;
    --brd-id)     BRD_ID="$2";      shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$REPO" ]] || [[ -z "$GOAL" ]] || [[ -z "$ROLE" ]]; then
  echo "Required: --repo, --goal, --role"
  echo "Usage: ./add-task.sh --repo 'SMOrchestra-ai/Repo' --goal 'description' --role vp_engineering"
  exit 1
fi

# ─── GENERATE TASK ID ───

LAST_NUM=$(db_query "SELECT COALESCE(MAX(CAST(SUBSTR(id, 6) AS INTEGER)), 0) FROM tasks WHERE id LIKE 'TASK-%'")
NEXT_NUM=$((LAST_NUM + 1))
TASK_ID=$(printf "TASK-%03d" "$NEXT_NUM")

# Default title from goal if not provided
[[ -z "$TITLE" ]] && TITLE="$GOAL"

# ─── INSERT TASK ───

db_exec "INSERT INTO tasks (id, brd_id, title, description, repo, goal, declared_files, hard_constraints, tests_required, blocked_by, server_node, role, status)
VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, 'pending_approval')" \
  "$TASK_ID" "$BRD_ID" "$TITLE" "$GOAL" "$REPO" "$GOAL" "$FILES" "$CONSTRAINTS" "$TESTS" "$BLOCKED_BY" "$NODE" "$ROLE"

# ─── LOG TO AUDIT ───

audit "$TASK_ID" "created" "{\"role\": \"$ROLE\", \"repo\": \"$REPO\", \"node\": \"$NODE\"}"

echo "{\"task_id\": \"$TASK_ID\", \"status\": \"pending_approval\", \"role\": \"$ROLE\", \"node\": \"$NODE\", \"repo\": \"$REPO\"}"
