#!/usr/bin/env bash
# db.sh — Parameterized SQL wrapper for queue engine
# Deploy to: smo-brain at /root/.smo/queue/db.sh
# Source this file in all queue scripts: source "$(dirname "$0")/db.sh"
#
# PURPOSE: Eliminate SQL injection by escaping all values before interpolation.
# Every script that touches queue.db MUST use these functions instead of raw sqlite3.
#
# Sprint 1, Fix #1 — Security hard stop (5 → 9)

QUEUE_DB="${QUEUE_DB:-/root/.smo/queue/queue.db}"

# ─── CORE: ESCAPE ───
# Escapes single quotes for safe SQL string interpolation: ' → ''
# Also strips null bytes which can break sqlite3 CLI
db_escape() {
  local val="$1"
  # Replace single quotes with doubled single quotes (SQL standard escaping)
  val="${val//\'/\'\'}"
  # Strip null bytes
  val=$(printf '%s' "$val" | tr -d '\0')
  printf '%s' "$val"
}

# ─── CORE: EXECUTE (write queries) ───
# Usage: db_exec "INSERT INTO t (a, b) VALUES (:1, :2)" "val1" "val2"
# Placeholders: :1, :2, :3, ... (positional, 1-based)
db_exec() {
  local sql="$1"
  shift
  local i=1
  for arg in "$@"; do
    local escaped
    escaped=$(db_escape "$arg")
    sql="${sql//:$i/'$escaped'}"
    i=$((i + 1))
  done
  sqlite3 "$QUEUE_DB" "$sql"
}

# ─── CORE: QUERY (read queries, text output) ───
# Usage: db_query "SELECT * FROM t WHERE id = :1" "TASK-001"
db_query() {
  local sql="$1"
  shift
  local i=1
  for arg in "$@"; do
    local escaped
    escaped=$(db_escape "$arg")
    sql="${sql//:$i/'$escaped'}"
    i=$((i + 1))
  done
  sqlite3 "$QUEUE_DB" "$sql"
}

# ─── CORE: QUERY JSON ───
# Usage: db_query_json "SELECT * FROM t WHERE id = :1" "TASK-001"
db_query_json() {
  local sql="$1"
  shift
  local i=1
  for arg in "$@"; do
    local escaped
    escaped=$(db_escape "$arg")
    sql="${sql//:$i/'$escaped'}"
    i=$((i + 1))
  done
  sqlite3 -json "$QUEUE_DB" "$sql"
}

# ─── HELPER: AUDIT LOG ───
# Common across all scripts. Safe by default.
# Usage: audit "TASK-001" "dispatched" '{"server":"smo-brain"}'
audit() {
  local task_id="$1"
  local event="$2"
  local details="${3:-{}}"
  local node
  node=$(hostname)
  db_exec "INSERT INTO audit_log (task_id, event, details, node) VALUES (:1, :2, :3, :4)" \
    "$task_id" "$event" "$details" "$node"
}

# ─── HELPER: UPDATE TASK FIELD ───
# Whitelisted field names only — prevents column injection.
# Usage: db_update_task "TASK-001" "status" "active"
db_update_task() {
  local task_id="$1"
  local field="$2"
  local value="$3"

  # Whitelist valid field names (column names are NOT parameterizable in SQL)
  case "$field" in
    status|server_node|session_pid|branch|quality_score|retry_count|\
    updated_at|pr_url|tier|complexity_score|session_started_at|brd_id)
      db_exec "UPDATE tasks SET $field = :1, updated_at = datetime('now') WHERE id = :2" \
        "$value" "$task_id"
      ;;
    *)
      echo "ERROR: db_update_task — invalid field '$field' (not in whitelist)" >&2
      return 1
      ;;
  esac
}

# ─── HELPER: DELETE FILE LOCKS ───
# Usage: db_release_locks "TASK-001"
db_release_locks() {
  local task_id="$1"
  db_exec "DELETE FROM file_locks WHERE task_id = :1" "$task_id"
}

# ─── HELPER: INSERT FILE LOCK ───
# Usage: db_lock_file "src/api.ts" "TASK-001" "SMOrchestra-ai/Repo"
db_lock_file() {
  local file_path="$1"
  local task_id="$2"
  local repo="$3"
  db_exec "INSERT OR IGNORE INTO file_locks (file_path, task_id, repo) VALUES (:1, :2, :3)" \
    "$file_path" "$task_id" "$repo"
}

# ─── HELPER: INSERT ARTIFACT ───
# Usage: db_add_artifact "TASK-001" "modified_file" "src/api.ts" "Added health endpoint"
db_add_artifact() {
  local task_id="$1"
  local artifact_type="$2"
  local file_path="$3"
  local summary="${4:-}"
  db_exec "INSERT OR IGNORE INTO task_artifacts (task_id, artifact_type, file_path, summary) VALUES (:1, :2, :3, :4)" \
    "$task_id" "$artifact_type" "$file_path" "$summary"
}
