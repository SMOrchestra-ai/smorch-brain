#!/usr/bin/env bash
# dispatch.sh — Enhanced dispatcher with skills injection + tier routing
# Deploy to: smo-brain at /root/.smo/queue/dispatch.sh
# Usage: ./dispatch.sh TASK_ID
#
# Reads task from SQLite queue, classifies tier, verifies skills,
# dispatches to correct node with role-specific skills loaded.
# Uses Claude Code for ALL execution (Codex hangs in non-interactive SSH).

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"
SCRIPTS_DIR="/root/.smo/queue"
LOG_DIR="/root/.smo/logs"
WORKSPACES="/workspaces/smo"

# Load parameterized SQL wrapper (Sprint 1, Fix #1 — SQL injection prevention)
source "$(dirname "$0")/db.sh"

TASK_ID="${1:-}"
if [[ -z "$TASK_ID" ]]; then
  echo "Usage: ./dispatch.sh TASK-XXX"
  exit 1
fi

mkdir -p "$LOG_DIR"

# ─── HELPER FUNCTIONS ───

log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [dispatch] $1"
  echo "$msg"
  echo "$msg" >> "$LOG_DIR/dispatch.log"
}

# audit() and db_update_task() are now provided by db.sh

# ─── LOAD TASK FROM QUEUE ───

log "Loading task $TASK_ID..."
TASK_JSON=$(db_query_json "SELECT * FROM tasks WHERE id = :1 AND status = 'queued' LIMIT 1" "$TASK_ID")

if [[ -z "$TASK_JSON" ]] || [[ "$TASK_JSON" == "[]" ]]; then
  log "ERROR: Task $TASK_ID not found or not in 'queued' status"
  exit 1
fi

# IMMEDIATELY mark as active to prevent re-dispatch race condition
db_update_task "$TASK_ID" "status" "active"

# Parse task fields
REPO=$(echo "$TASK_JSON" | jq -r '.[0].repo')
GOAL=$(echo "$TASK_JSON" | jq -r '.[0].goal')
DECLARED_FILES=$(echo "$TASK_JSON" | jq -r '.[0].declared_files // ""')
HARD_CONSTRAINTS=$(echo "$TASK_JSON" | jq -r '.[0].hard_constraints // ""')
TESTS_REQUIRED=$(echo "$TASK_JSON" | jq -r '.[0].tests_required // ""')
SERVER_NODE=$(echo "$TASK_JSON" | jq -r '.[0].server_node')
ROLE=$(echo "$TASK_JSON" | jq -r '.[0].role')
BLOCKED_BY=$(echo "$TASK_JSON" | jq -r '.[0].blocked_by // ""')

log "Task: $GOAL"
log "Repo: $REPO | Node: $SERVER_NODE | Role: $ROLE"

# ─── DEPENDENCY CHECK ───

if [[ -n "$BLOCKED_BY" ]]; then
  IFS=',' read -ra DEPS <<< "$BLOCKED_BY"
  for dep in "${DEPS[@]}"; do
    dep=$(echo "$dep" | tr -d ' ')
    DEP_STATUS=$(db_query "SELECT status FROM tasks WHERE id = :1" "$dep")
    if [[ "$DEP_STATUS" != "merged" ]]; then
      log "BLOCKED: Task $TASK_ID waiting on $dep (status: $DEP_STATUS)"
      db_update_task "$TASK_ID" "status" "queued"
      audit "$TASK_ID" "blocked" "{\"waiting_on\": \"$dep\", \"dep_status\": \"$DEP_STATUS\"}"
      exit 0
    fi
  done
  log "All dependencies merged. Proceeding."
fi

# ─── CONCURRENCY CHECK (per account) ───

ACCOUNT_ID=$(db_query "SELECT account_id FROM node_accounts WHERE node = :1" "$SERVER_NODE")
MAX_CONCURRENT=$(db_query "SELECT SUM(na.max_concurrent) FROM node_accounts na WHERE na.account_id = :1" "$ACCOUNT_ID")
ACTIVE_COUNT=$(db_query "SELECT COUNT(*) FROM tasks t JOIN node_accounts na ON t.server_node = na.node WHERE t.status = 'active' AND na.account_id = :1 AND t.id != :2" "$ACCOUNT_ID" "$TASK_ID")

if [[ $ACTIVE_COUNT -ge $MAX_CONCURRENT ]]; then
  log "CONCURRENCY: Account $ACCOUNT_ID saturated ($ACTIVE_COUNT/$MAX_CONCURRENT active)"
  db_update_task "$TASK_ID" "status" "queued"
  audit "$TASK_ID" "concurrency_wait" "{\"account\": \"$ACCOUNT_ID\", \"active\": $ACTIVE_COUNT, \"max\": $MAX_CONCURRENT}"
  exit 0
fi

# ─── FILE CONFLICT CHECK ───

if [[ -n "$DECLARED_FILES" ]] && [[ "$DECLARED_FILES" != "null" ]]; then
  FILE_LIST=$(echo "$DECLARED_FILES" | jq -r '.[]' 2>/dev/null || echo "$DECLARED_FILES")
  for f in $FILE_LIST; do
    LOCK_TASK=$(db_query "SELECT task_id FROM file_locks WHERE file_path = :1 AND repo = :2" "$f" "$REPO")
    if [[ -n "$LOCK_TASK" ]]; then
      log "FILE CONFLICT: $f locked by $LOCK_TASK"
      db_update_task "$TASK_ID" "status" "queued"
      audit "$TASK_ID" "file_conflict" "{\"file\": \"$f\", \"locked_by\": \"$LOCK_TASK\"}"
      exit 0
    fi
  done
  for f in $FILE_LIST; do
    db_lock_file "$f" "$TASK_ID" "$REPO"
  done
fi

# ─── CLASSIFY TASK TIER ───

TIER_JSON=$("$SCRIPTS_DIR/classify-task.sh" "$GOAL" "$(echo "$DECLARED_FILES" | jq -r 'join(",")' 2>/dev/null || echo "")" "$REPO")
TIER=$(echo "$TIER_JSON" | jq -r '.tier')
COMPLEXITY_SCORE=$(echo "$TIER_JSON" | jq -r '.score')

if [[ "$TIER" == "forbidden" ]]; then
  REASON=$(echo "$TIER_JSON" | jq -r '.reason')
  log "FORBIDDEN: $REASON"
  db_update_task "$TASK_ID" "status" "killed"
  db_update_task "$TASK_ID" "tier" "forbidden"
  audit "$TASK_ID" "forbidden" "{\"reason\": \"$REASON\"}"
  exit 0
fi

db_update_task "$TASK_ID" "tier" "$TIER"
db_update_task "$TASK_ID" "complexity_score" "$COMPLEXITY_SCORE"
log "Tier: $TIER (score: $COMPLEXITY_SCORE)"

# ─── SKILLS VERIFICATION ───

SKILLS=$(db_query "SELECT GROUP_CONCAT(skill_name, ',') FROM role_skills WHERE role = :1 AND mandatory = 1" "$ROLE")

NODE_IP_FOR() {
  case "$1" in
    smo-brain) echo "100.89.148.62" ;;
    smo-dev)   echo "100.117.35.19" ;;
    desktop)   echo "100.117.35.19" ;;  # Redirect desktop → smo-dev (no SSH on desktop)
  esac
}

if [[ -n "$SKILLS" ]]; then
  log "Required skills for $ROLE: $SKILLS"
  IFS=',' read -ra SKILL_LIST <<< "$SKILLS"

  if [[ "$SERVER_NODE" != "$(hostname)" ]]; then
    REMOTE_IP=$(NODE_IP_FOR "$SERVER_NODE")
    for skill in "${SKILL_LIST[@]}"; do
      if ! ssh -o ConnectTimeout=5 "root@$REMOTE_IP" "test -d /root/.claude/skills/$skill/" 2>/dev/null; then
        log "SYNC: Missing skill '$skill' on $SERVER_NODE — syncing..."
        rsync -avzL "/root/.claude/skills/$skill/" "root@$REMOTE_IP:/root/.claude/skills/$skill/" 2>/dev/null || \
          log "WARNING: Failed to sync $skill to $SERVER_NODE"
      fi
    done
  fi
fi

# ─── CREATE BRANCH ───

SLUG=$(echo "$GOAL" | head -1 | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | cut -c1-40)
BRANCH="agent/${TASK_ID}-${SLUG}"
db_update_task "$TASK_ID" "branch" "$BRANCH"
log "Branch: $BRANCH"

# ─── GATHER PREDECESSOR CONTEXT (for tasks with dependencies) ───

PREDECESSOR_CONTEXT=""
if [[ -n "$BLOCKED_BY" ]]; then
  IFS=',' read -ra DEPS <<< "$BLOCKED_BY"
  for dep in "${DEPS[@]}"; do
    dep=$(echo "$dep" | tr -d ' ')
    ARTIFACTS=$(db_query "SELECT artifact_type || ': ' || COALESCE(summary, file_path) FROM task_artifacts WHERE task_id = :1" "$dep")
    if [[ -n "$ARTIFACTS" ]]; then
      PREDECESSOR_CONTEXT="$PREDECESSOR_CONTEXT\n--- Artifacts from $dep ---\n$ARTIFACTS"
    fi
  done
fi

# ─── BUILD AGENT PROMPT ───

ROLE_NAME=$(case "$ROLE" in
  vp_engineering) echo "VP Engineering" ;;
  qa_lead)        echo "QA Lead" ;;
  gtm)            echo "GTM Specialist" ;;
  content)        echo "Content Lead" ;;
  devops)         echo "DevOps Engineer" ;;
  data_eng)       echo "Data Engineer" ;;
  *)              echo "$ROLE" ;;
esac)

PROMPT="$GOAL"

[[ -n "$HARD_CONSTRAINTS" && "$HARD_CONSTRAINTS" != "null" && "$HARD_CONSTRAINTS" != "[]" ]] && \
  PROMPT="$PROMPT Constraints: $(echo "$HARD_CONSTRAINTS" | jq -r 'if type=="array" then join(". ") else . end' 2>/dev/null || echo "$HARD_CONSTRAINTS")"

[[ -n "$TESTS_REQUIRED" && "$TESTS_REQUIRED" != "null" && "$TESTS_REQUIRED" != "[]" ]] && \
  PROMPT="$PROMPT Tests: $(echo "$TESTS_REQUIRED" | jq -r 'if type=="array" then join(", ") else . end' 2>/dev/null || echo "$TESTS_REQUIRED")"

[[ -n "$PREDECESSOR_CONTEXT" ]] && PROMPT="$PROMPT Previous work: $(echo -e "$PREDECESSOR_CONTEXT" | head -5)"

# ─── DISPATCH ───

db_update_task "$TASK_ID" "session_started_at" "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
audit "$TASK_ID" "dispatched" "{\"tier\": \"$TIER\", \"node\": \"$SERVER_NODE\", \"skills\": \"$SKILLS\"}"

DISPATCH_TO_REMOTE() {
  local IP="$1"
  local SCRIPT_FILE="/tmp/smo-exec-$TASK_ID.sh"
  local GOAL_FILE="/tmp/smo-goal-$TASK_ID.txt"
  local PROMPT_FILE="/tmp/smo-prompt-$TASK_ID.txt"

  # Write goal and prompt to files to avoid shell quoting issues
  printf "%s" "$GOAL" > "$GOAL_FILE"
  printf "%s" "$PROMPT" > "$PROMPT_FILE"

  # Build execution script — uses Claude Code for ALL execution (Codex hangs in SSH)
  cat > "$SCRIPT_FILE" <<EXECSCRIPT
#!/bin/bash
set -euo pipefail
BASE_REPO=$WORKSPACES/$(basename "$REPO")
REPO_DIR=$WORKSPACES/$(basename "$REPO")-$TASK_ID
# Use task-specific worktree to avoid conflicts with concurrent tasks
if [ ! -d "\$BASE_REPO" ]; then
  git clone https://github.com/$REPO.git \$BASE_REPO
fi
# Wait for DNS
for i in 1 2 3; do nslookup github.com >/dev/null 2>&1 && break; sleep 3; done
# Create worktree for this task
cd \$BASE_REPO && git fetch origin || true
git worktree add \$REPO_DIR -b $BRANCH origin/main 2>/dev/null || \
  git worktree add \$REPO_DIR $BRANCH 2>/dev/null || \
  { mkdir -p \$REPO_DIR && cp -a \$BASE_REPO/. \$REPO_DIR/ && cd \$REPO_DIR && git checkout -b $BRANCH 2>/dev/null || true; }
cd \$REPO_DIR
EXECSCRIPT

  case "$TIER" in
    fast_track)
      cat >> "$SCRIPT_FILE" <<EXECSCRIPT
GOAL=\$(cat /tmp/smo-goal-$TASK_ID.txt)
timeout 600 claude -p "\$GOAL" --max-turns 10 || echo "Claude session ended (timeout or max turns)"
EXECSCRIPT
      ;;
    staged_hybrid|agent_team)
      # Write the lean task prompt to a file — avoids quoting issues
      local FULL_PROMPT_FILE="/tmp/smo-full-prompt-$TASK_ID.txt"
      printf "%s" "$PROMPT" > "$FULL_PROMPT_FILE"

      cat >> "$SCRIPT_FILE" <<'EXECSCRIPT'
# Read full prompt from file and execute with Claude
FULL_PROMPT=$(cat /tmp/smo-full-prompt-TASK_ID_PLACEHOLDER.txt)
timeout 900 claude -p "$FULL_PROMPT" --max-turns 15 || echo "Claude session ended (timeout or max turns)"
EXECSCRIPT
      # Replace placeholder with actual TASK_ID
      sed -i "s/TASK_ID_PLACEHOLDER/$TASK_ID/g" "$SCRIPT_FILE"
      ;;
  esac

  cat >> "$SCRIPT_FILE" <<EXECSCRIPT
git add -A
git commit -m "agent($TASK_ID): auto-generated" --allow-empty || true
git push origin $BRANCH 2>/dev/null || git push --set-upstream origin $BRANCH
# Cleanup worktree
cd $WORKSPACES/$(basename "$REPO") 2>/dev/null && git worktree remove $WORKSPACES/$(basename "$REPO")-$TASK_ID --force 2>/dev/null || true
EXECSCRIPT

  chmod +x "$SCRIPT_FILE"

  # SCP files to remote, then execute via SSH
  (
    scp -o ConnectTimeout=10 "$GOAL_FILE" "root@$IP:/tmp/smo-goal-$TASK_ID.txt" >> "$LOG_DIR/$TASK_ID.log" 2>&1
    scp -o ConnectTimeout=10 "$PROMPT_FILE" "root@$IP:/tmp/smo-prompt-$TASK_ID.txt" >> "$LOG_DIR/$TASK_ID.log" 2>&1
    # SCP full prompt if it exists (staged_hybrid/agent_team tier)
    [[ -f "/tmp/smo-full-prompt-$TASK_ID.txt" ]] && \
      scp -o ConnectTimeout=10 "/tmp/smo-full-prompt-$TASK_ID.txt" "root@$IP:/tmp/smo-full-prompt-$TASK_ID.txt" >> "$LOG_DIR/$TASK_ID.log" 2>&1
    scp -o ConnectTimeout=10 "$SCRIPT_FILE" "root@$IP:/tmp/smo-exec-$TASK_ID.sh" >> "$LOG_DIR/$TASK_ID.log" 2>&1
    ssh -o ConnectTimeout=10 -o ServerAliveInterval=30 "root@$IP" "bash /tmp/smo-exec-$TASK_ID.sh" >> "$LOG_DIR/$TASK_ID.log" 2>&1
    EXIT_CODE=$?
    /root/.smo/queue/task-complete.sh "$TASK_ID" "$EXIT_CODE" >> "$LOG_DIR/task-complete.log" 2>&1
  ) &
  SESSION_PID=$!
  db_update_task "$TASK_ID" "session_pid" "$SESSION_PID"
  log "Dispatched to $SERVER_NODE ($IP) PID=$SESSION_PID"
}

DISPATCH_LOCAL() {
  local EXEC_DIR="$WORKSPACES/$(basename "$REPO")"

  if [[ ! -d "$EXEC_DIR" ]]; then
    git clone "https://github.com/$REPO.git" "$EXEC_DIR"
  fi
  cd "$EXEC_DIR"
  git fetch origin || true
  git checkout -b "$BRANCH" origin/main 2>/dev/null || git checkout "$BRANCH" 2>/dev/null || true

  case "$TIER" in
    fast_track)
      (
        claude -p "$GOAL" --max-turns 10 >> "$LOG_DIR/$TASK_ID.log" 2>&1
        EXIT_CODE=$?
        cd "$EXEC_DIR"
        git add -A && git commit -m "agent($TASK_ID): auto-generated" --allow-empty || true
        git push origin "$BRANCH" 2>/dev/null || git push --set-upstream origin "$BRANCH"
        /root/.smo/queue/task-complete.sh "$TASK_ID" "$EXIT_CODE" >> "$LOG_DIR/task-complete.log" 2>&1
      ) &
      ;;
    staged_hybrid)
      (
        claude -p "$PROMPT

IMPORTANT: Actually create and write the files. Do not just describe what to do." --max-turns 30 >> "$LOG_DIR/$TASK_ID.log" 2>&1
        cd "$EXEC_DIR"
        git add -A
        git commit -m "agent($TASK_ID): auto-generated" --allow-empty || true
        git push origin "$BRANCH" 2>/dev/null || git push --set-upstream origin "$BRANCH"
        /root/.smo/queue/task-complete.sh "$TASK_ID" "0" >> "$LOG_DIR/task-complete.log" 2>&1
      ) &
      ;;
    agent_team)
      (
        claude -p "$PROMPT" --max-turns 50 >> "$LOG_DIR/$TASK_ID.log" 2>&1
        EXIT_CODE=$?
        cd "$EXEC_DIR"
        git add -A && git commit -m "agent($TASK_ID): auto-generated" --allow-empty || true
        git push origin "$BRANCH" 2>/dev/null || git push --set-upstream origin "$BRANCH"
        /root/.smo/queue/task-complete.sh "$TASK_ID" "$EXIT_CODE" >> "$LOG_DIR/task-complete.log" 2>&1
      ) &
      ;;
  esac
  SESSION_PID=$!
  db_update_task "$TASK_ID" "session_pid" "$SESSION_PID"
  log "Dispatched locally PID=$SESSION_PID"
}

# Determine if local or remote dispatch
CURRENT_HOST=$(hostname)
case "$SERVER_NODE" in
  smo-brain)
    if [[ "$CURRENT_HOST" == *"vmi3051702"* ]]; then
      DISPATCH_LOCAL
    else
      DISPATCH_TO_REMOTE "100.89.148.62"
    fi
    ;;
  smo-dev)
    DISPATCH_TO_REMOTE "$(NODE_IP_FOR smo-dev)"
    ;;
  desktop)
    DISPATCH_TO_REMOTE "$(NODE_IP_FOR desktop)"
    ;;
  *)
    log "ERROR: Unknown server node: $SERVER_NODE"
    db_update_task "$TASK_ID" "status" "failed"
    audit "$TASK_ID" "dispatch_failed" "{\"reason\": \"unknown node: $SERVER_NODE\"}"
    exit 1
    ;;
esac

log "Task $TASK_ID dispatched successfully. Tier: $TIER, Node: $SERVER_NODE"
audit "$TASK_ID" "dispatch_complete" "{\"pid\": $SESSION_PID}"
