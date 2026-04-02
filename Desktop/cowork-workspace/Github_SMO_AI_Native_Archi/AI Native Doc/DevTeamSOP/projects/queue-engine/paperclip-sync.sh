#!/usr/bin/env bash
# paperclip-sync.sh — Bidirectional sync between queue.db and Paperclip
# Deploy to: smo-brain at /root/.smo/queue/paperclip-sync.sh
# Usage: ./paperclip-sync.sh [sync-status|push-task|push-brd|pull-brd]
#
# Paperclip API: http://127.0.0.1:3100/api (local_trusted, no auth)
# Company ID: 1fd08eca-f681-468c-a468-9db41fa1425f
#
# Sprint 1, Fix #8 — Paperclip queue sync

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"
source "$(dirname "$0")/db.sh"

PAPERCLIP_URL="${PAPERCLIP_URL:-http://127.0.0.1:3100}"
COMPANY_ID="${PAPERCLIP_COMPANY_ID:-1fd08eca-f681-468c-a468-9db41fa1425f}"
API="$PAPERCLIP_URL/api"

ACTION="${1:-sync-status}"

log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [paperclip] $1"
  echo "$msg"
}

# Map queue status → Paperclip status
queue_to_paperclip_status() {
  case "$1" in
    pending_approval) echo "backlog" ;;
    queued)           echo "todo" ;;
    active|scoring)   echo "in_progress" ;;
    pr_open)          echo "in_review" ;;
    merged)           echo "done" ;;
    failed|killed)    echo "cancelled" ;;
    *)                echo "backlog" ;;
  esac
}

# Map queue role → Paperclip agent name
queue_role_to_agent() {
  case "$1" in
    vp_engineering) echo "vp-engineering" ;;
    qa_lead)        echo "qa-lead" ;;
    gtm)            echo "gtm-specialist" ;;
    content)        echo "content-lead" ;;
    devops)         echo "devops" ;;
    data_eng)       echo "data-engineer" ;;
    *)              echo "" ;;
  esac
}

# Map queue tier → Paperclip priority
queue_tier_to_priority() {
  case "$1" in
    fast_track)     echo "low" ;;
    staged_hybrid)  echo "medium" ;;
    agent_team)     echo "high" ;;
    forbidden)      echo "critical" ;;
    *)              echo "medium" ;;
  esac
}

# Get Paperclip agent ID by URL key
get_agent_id() {
  local agent_key="$1"
  curl -s "$API/companies/$COMPANY_ID/agents" | \
    jq -r --arg key "$agent_key" '.[] | select(.urlKey == $key) | .id' 2>/dev/null
}

case "$ACTION" in

  # ─── SYNC STATUS: Push all queue task statuses to Paperclip ───
  sync-status)
    log "Syncing queue status → Paperclip..."

    # Get all tasks from queue
    TASKS=$(db_query_json "SELECT id, title, goal, role, status, tier, server_node, branch, pr_url, quality_score, brd_id, retry_count FROM tasks ORDER BY id")

    TASK_COUNT=$(echo "$TASKS" | jq length)
    SYNCED=0
    CREATED=0
    UPDATED=0

    for i in $(seq 0 $((TASK_COUNT - 1))); do
      TASK=$(echo "$TASKS" | jq ".[$i]")
      TASK_ID=$(echo "$TASK" | jq -r '.id')
      TITLE=$(echo "$TASK" | jq -r '.title')
      GOAL=$(echo "$TASK" | jq -r '.goal')
      STATUS=$(echo "$TASK" | jq -r '.status')
      ROLE=$(echo "$TASK" | jq -r '.role // ""')
      TIER=$(echo "$TASK" | jq -r '.tier // "staged_hybrid"')
      NODE=$(echo "$TASK" | jq -r '.server_node // ""')
      BRANCH=$(echo "$TASK" | jq -r '.branch // ""')
      PR_URL=$(echo "$TASK" | jq -r '.pr_url // ""')
      SCORE=$(echo "$TASK" | jq -r '.quality_score // ""')

      PP_STATUS=$(queue_to_paperclip_status "$STATUS")
      PP_PRIORITY=$(queue_tier_to_priority "$TIER")

      # Build description with queue metadata
      DESC="**Queue Task:** $TASK_ID
**Role:** $ROLE | **Node:** $NODE | **Tier:** $TIER
**Status:** $STATUS
${BRANCH:+**Branch:** \`$BRANCH\`}
${PR_URL:+**PR:** $PR_URL}
${SCORE:+**Quality Score:** $SCORE/10}

---
$GOAL"

      # Check if issue already exists in Paperclip (search by title prefix)
      EXISTING=$(curl -s "$API/companies/$COMPANY_ID/issues" | \
        jq -r --arg tid "[$TASK_ID]" '.[] | select(.title | startswith($tid)) | .id' 2>/dev/null | head -1)

      if [[ -n "$EXISTING" ]]; then
        # Update existing issue
        curl -s -X PATCH "$API/issues/$EXISTING" \
          -H "Content-Type: application/json" \
          -d "$(jq -n --arg title "[$TASK_ID] $TITLE" --arg desc "$DESC" --arg status "$PP_STATUS" --arg priority "$PP_PRIORITY" \
            '{title: $title, description: $desc, status: $status, priority: $priority}')" >/dev/null 2>&1
        UPDATED=$((UPDATED + 1))
      else
        # Create new issue
        AGENT_KEY=$(queue_role_to_agent "$ROLE")
        AGENT_ID=""
        [[ -n "$AGENT_KEY" ]] && AGENT_ID=$(get_agent_id "$AGENT_KEY")

        PAYLOAD=$(jq -n \
          --arg title "[$TASK_ID] $TITLE" \
          --arg desc "$DESC" \
          --arg status "$PP_STATUS" \
          --arg priority "$PP_PRIORITY" \
          --arg agentId "$AGENT_ID" \
          '{title: $title, description: $desc, status: $status, priority: $priority} + (if $agentId != "" then {assigneeAgentId: $agentId} else {} end)')

        curl -s -X POST "$API/companies/$COMPANY_ID/issues" \
          -H "Content-Type: application/json" \
          -d "$PAYLOAD" >/dev/null 2>&1
        CREATED=$((CREATED + 1))
      fi

      SYNCED=$((SYNCED + 1))
    done

    log "Sync complete: $SYNCED tasks processed ($CREATED created, $UPDATED updated)"
    echo "{\"synced\": $SYNCED, \"created\": $CREATED, \"updated\": $UPDATED}"
    ;;

  # ─── PUSH SINGLE TASK: Push one task to Paperclip ───
  push-task)
    TASK_ID="${2:-}"
    if [[ -z "$TASK_ID" ]]; then
      echo "Usage: ./paperclip-sync.sh push-task TASK-XXX"
      exit 1
    fi

    TASK=$(db_query_json "SELECT * FROM tasks WHERE id = :1 LIMIT 1" "$TASK_ID")
    if [[ -z "$TASK" ]] || [[ "$TASK" == "[]" ]]; then
      echo "Task $TASK_ID not found"
      exit 1
    fi

    TITLE=$(echo "$TASK" | jq -r '.[0].title')
    GOAL=$(echo "$TASK" | jq -r '.[0].goal')
    STATUS=$(echo "$TASK" | jq -r '.[0].status')
    ROLE=$(echo "$TASK" | jq -r '.[0].role // ""')
    TIER=$(echo "$TASK" | jq -r '.[0].tier // "staged_hybrid"')
    PP_STATUS=$(queue_to_paperclip_status "$STATUS")
    PP_PRIORITY=$(queue_tier_to_priority "$TIER")

    RESULT=$(curl -s -X POST "$API/companies/$COMPANY_ID/issues" \
      -H "Content-Type: application/json" \
      -d "$(jq -n --arg title "[$TASK_ID] $TITLE" --arg desc "$GOAL" --arg status "$PP_STATUS" --arg priority "$PP_PRIORITY" \
        '{title: $title, description: $desc, status: $status, priority: $priority}')")

    ISSUE_ID=$(echo "$RESULT" | jq -r '.id // "error"')
    log "Pushed $TASK_ID → Paperclip issue $ISSUE_ID"
    echo "$RESULT"
    ;;

  # ─── PUSH BRD: Create a Paperclip project for a BRD ───
  push-brd)
    BRD_ID="${2:-}"
    if [[ -z "$BRD_ID" ]]; then
      echo "Usage: ./paperclip-sync.sh push-brd BRD-XXX"
      exit 1
    fi

    BRD=$(db_query_json "SELECT * FROM brds WHERE id = :1 LIMIT 1" "$BRD_ID")
    if [[ -z "$BRD" ]] || [[ "$BRD" == "[]" ]]; then
      echo "BRD $BRD_ID not found"
      exit 1
    fi

    TITLE=$(echo "$BRD" | jq -r '.[0].title')
    TASK_COUNT=$(echo "$BRD" | jq -r '.[0].task_count')
    RAW_TEXT=$(echo "$BRD" | jq -r '.[0].raw_text // ""')

    # Create project in Paperclip
    PROJECT=$(curl -s -X POST "$API/companies/$COMPANY_ID/projects" \
      -H "Content-Type: application/json" \
      -d "$(jq -n --arg name "[$BRD_ID] $TITLE" --arg desc "BRD with $TASK_COUNT tasks. Source: queue engine.\n\n$RAW_TEXT" \
        '{name: $name, description: $desc}')" 2>/dev/null)

    PROJECT_ID=$(echo "$PROJECT" | jq -r '.id // "error"')
    log "Created Paperclip project $PROJECT_ID for $BRD_ID"
    echo "$PROJECT"
    ;;

  # ─── PULL BRD: Accept BRD from Paperclip issue → decompose ───
  pull-brd)
    ISSUE_ID="${2:-}"
    if [[ -z "$ISSUE_ID" ]]; then
      echo "Usage: ./paperclip-sync.sh pull-brd ISSUE_ID"
      exit 1
    fi

    # Fetch issue from Paperclip
    ISSUE=$(curl -s "$API/issues/$ISSUE_ID")
    TITLE=$(echo "$ISSUE" | jq -r '.title // ""')
    DESC=$(echo "$ISSUE" | jq -r '.description // ""')

    if [[ -z "$TITLE" ]] || [[ "$TITLE" == "null" ]]; then
      echo "Issue $ISSUE_ID not found or empty"
      exit 1
    fi

    BRD_TEXT="$TITLE

$DESC"

    log "Pulling BRD from Paperclip issue $ISSUE_ID: $TITLE"

    # Decompose via queue engine
    RESULT=$(/root/.smo/queue/decompose-brd.sh "$BRD_TEXT")
    echo "$RESULT"

    # Update Paperclip issue with decomposition result
    TASK_COUNT=$(echo "$RESULT" | jq -r '.task_count // 0')
    BRD_ID=$(echo "$RESULT" | jq -r '.brd_id // ""')

    curl -s -X PATCH "$API/issues/$ISSUE_ID" \
      -H "Content-Type: application/json" \
      -d "$(jq -n --arg comment "Decomposed into $TASK_COUNT tasks ($BRD_ID). Awaiting approval." \
        '{comment: $comment, status: "in_progress"}')" >/dev/null 2>&1

    log "Updated Paperclip issue with decomposition result"
    ;;

  # ─── DASHBOARD: Get combined dashboard data ───
  dashboard)
    # Combine queue health + Paperclip dashboard
    QUEUE_HEALTH=$(/root/.smo/queue/health-check.sh --json 2>/dev/null || echo '{"status":"unknown"}')
    QUEUE_STATUS=$(/root/.smo/queue/queue-status.sh --all --json 2>/dev/null || echo '{}')
    PP_DASHBOARD=$(curl -s "$API/companies/$COMPANY_ID/dashboard" 2>/dev/null || echo '{}')
    PP_AGENTS=$(curl -s "$API/instance/scheduler-heartbeats" 2>/dev/null || echo '[]')

    jq -n \
      --argjson queue_health "$QUEUE_HEALTH" \
      --argjson queue_status "$QUEUE_STATUS" \
      --argjson paperclip "$PP_DASHBOARD" \
      --argjson agents "$PP_AGENTS" \
      '{queue_engine: {health: $queue_health, status: $queue_status}, paperclip: {dashboard: $paperclip, agents: $agents}}'
    ;;

  *)
    echo "Usage: ./paperclip-sync.sh {sync-status|push-task|push-brd|pull-brd|dashboard} [args]"
    exit 1
    ;;
esac
