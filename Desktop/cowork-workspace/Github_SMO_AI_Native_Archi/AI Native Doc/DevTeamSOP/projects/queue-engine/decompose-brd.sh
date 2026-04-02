#!/usr/bin/env bash
# decompose-brd.sh — Decompose a BRD into queue tasks using Claude
# Deploy to: smo-brain at /root/.smo/queue/decompose-brd.sh
# Usage: ./decompose-brd.sh "BRD text or file path"
#
# Process:
#   1. Takes BRD text (or reads from file)
#   2. Sends to Claude for decomposition into structured tasks
#   3. Inserts each task into SQLite queue via add-task.sh
#   4. Returns summary of created tasks
#
# Can be called by: OpenClaw (via Telegram /brd), n8n workflow, or manually

set -euo pipefail

QUEUE_DIR="/root/.smo/queue"
QUEUE_DB="$QUEUE_DIR/queue.db"
LOG_DIR="/root/.smo/logs"
SCRIPTS_DIR="$QUEUE_DIR"

# Load parameterized SQL wrapper (Sprint 1, Fix #1 — SQL injection prevention)
source "$(dirname "$0")/db.sh"

mkdir -p "$LOG_DIR"

BRD_INPUT="${1:-}"
if [[ -z "$BRD_INPUT" ]]; then
  echo "Usage: ./decompose-brd.sh 'BRD text or /path/to/brd.md'"
  exit 1
fi

# ─── READ BRD ───

if [[ -f "$BRD_INPUT" ]]; then
  BRD_TEXT=$(cat "$BRD_INPUT")
  BRD_SOURCE="file:$BRD_INPUT"
else
  BRD_TEXT="$BRD_INPUT"
  BRD_SOURCE="inline"
fi

log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [decompose] $1"
  echo "$msg"
  echo "$msg" >> "$LOG_DIR/decompose.log"
}

log "Decomposing BRD (source: $BRD_SOURCE, length: ${#BRD_TEXT} chars)"

# ─── CREATE BRD RECORD (Sprint 1, Fix #2 — BRD traceability) ───

BRD_LAST_NUM=$(db_query "SELECT COALESCE(MAX(CAST(SUBSTR(id, 5) AS INTEGER)), 0) FROM brds WHERE id LIKE 'BRD-%'")
BRD_NEXT=$((BRD_LAST_NUM + 1))
BRD_ID=$(printf "BRD-%03d" "$BRD_NEXT")
BRD_TITLE=$(echo "$BRD_TEXT" | head -1 | cut -c1-100)
db_exec "INSERT INTO brds (id, title, source, raw_text, status, submitted_by) VALUES (:1, :2, :3, :4, 'decomposing', 'mamoun')" \
  "$BRD_ID" "$BRD_TITLE" "$BRD_SOURCE" "$BRD_TEXT"
log "Created BRD record: $BRD_ID"

# ─── LOAD AVAILABLE ROLES + SKILLS FROM DB ───

ROLES_JSON=$(db_query_json "SELECT role, GROUP_CONCAT(skill_name, ', ') as skills, quality_gate, pass_threshold FROM role_skills WHERE mandatory = 1 GROUP BY role")

NODES_JSON=$(db_query_json "SELECT na.node, na.account_id, na.max_concurrent, a.name as account_name FROM node_accounts na JOIN accounts a ON na.account_id = a.id")

# ─── LOAD ACTIVE REPOS ───

REPOS=$(cat <<'REPOLIST'
SMOrchestra-ai/SaaSFast - Next.js SaaS boilerplate
SMOrchestra-ai/EO-Scorecard-Platform - EO MENA scorecard and training platform
SMOrchestra-ai/smorch-brain - Skills registry and agent configs
SMOrchestra-ai/eo-mena - EO MENA marketing site
SMOrchestra-ai/smorch-dist - Distribution and deployment configs
SMOrchestra-ai/smorch-context - Context and memory management
SMOrchestra-ai/supervibes - Design system and UI components
REPOLIST
)

# ─── BUILD DECOMPOSITION PROMPT ───

DECOMP_PROMPT=$(cat <<PROMPT
You are the COO of SMOrchestra AI-Native Organization. Your job is to decompose a Business Requirements Document (BRD) into discrete, executable tasks for the AI agent queue.

## Available Roles and Their Mandatory Skills

$ROLES_JSON

## Available Nodes

$NODES_JSON

## Node Affinity Rules
- smo-brain: Planning, orchestration, OpenClaw tasks, DevOps. Best for Claude-heavy work.
- smo-dev: Primary build server. Best for Codex execution, feature development, API work.
- desktop: QA, content production, design review. Lower priority (shared account).

## Available Repos

$REPOS

## Role Assignment Rules
- vp_engineering: Code features, API endpoints, database models, refactoring, TDD
- qa_lead: Testing, security audit, code review, benchmarking
- gtm: Campaign setup, outbound sequences, signal detection, lead research
- content: Landing pages, marketing copy, YouTube scripts, LinkedIn posts, design assets
- devops: Deployment, CI/CD, infrastructure, Docker, monitoring
- data_eng: Data pipelines, scraping, enrichment, database architecture

## Task Decomposition Rules

1. Each task must be completable by ONE agent in ONE session (< 60 min)
2. Large features must be split: backend API → frontend UI → integration tests → deployment
3. Set blocked_by when a task depends on another task completing first
4. declared_files should list the specific files the agent will create or modify
5. Each task needs a clear, actionable goal (not vague like "improve performance")
6. Include tests_required for engineering tasks
7. Mark constraints that prevent scope creep
8. Tasks should be ordered: infrastructure → backend → frontend → tests → deployment → content

## Output Format

Return a JSON array of task objects. Each task:
{
  "title": "Short title (< 60 chars)",
  "goal": "Detailed goal with specific deliverables",
  "repo": "SMOrchestra-ai/RepoName",
  "role": "vp_engineering|qa_lead|gtm|content|devops|data_eng",
  "node": "smo-brain|smo-dev|desktop",
  "declared_files": ["path/to/file1.ts", "path/to/file2.ts"],
  "hard_constraints": ["constraint1", "constraint2"],
  "tests_required": ["npm test", "pytest"],
  "blocked_by": "" or "TASK-NNN" or "TASK-NNN,TASK-MMM"
}

Task IDs will be assigned automatically (TASK-001, TASK-002, ...). Use relative references in blocked_by: "PREV-1" means the immediately previous task, "PREV-2" means two tasks back, etc. These will be resolved to actual TASK-NNN IDs after assignment.

## BRD to Decompose

$BRD_TEXT

---

Decompose this BRD into 4-12 executable tasks. Return ONLY the JSON array, no other text.
PROMPT
)

# ─── CALL CLAUDE FOR DECOMPOSITION ───

log "Calling Claude for BRD decomposition..."

DECOMP_OUTPUT=$(claude -p "$DECOMP_PROMPT" --output-format json 2>/dev/null || \
                claude -p "$DECOMP_PROMPT" 2>/dev/null)

# ─── EXTRACT JSON ARRAY ───
# Claude may return: raw JSON array, code-block-wrapped array,
# or --output-format json envelope with .result containing markdown

extract_json_array() {
  local raw="$1"

  # 1. If --output-format json envelope: extract .result then parse
  if echo "$raw" | jq -e '.result' >/dev/null 2>&1; then
    raw=$(echo "$raw" | jq -r '.result')
  fi

  # 2. Try direct JSON array parse
  if echo "$raw" | jq -e 'type == "array"' >/dev/null 2>&1; then
    echo "$raw"
    return 0
  fi

  # 3. Extract from ```json ... ``` code block
  local from_block
  from_block=$(echo "$raw" | sed -n '/```json/,/```/{/```/d;p}')
  if [[ -n "$from_block" ]] && echo "$from_block" | jq -e 'type == "array"' >/dev/null 2>&1; then
    echo "$from_block"
    return 0
  fi

  # 4. Find first [ ... ] in the text
  local bracket_extract
  bracket_extract=$(echo "$raw" | python3 -c "
import sys, json, re
text = sys.stdin.read()
m = re.search(r'\[.*\]', text, re.DOTALL)
if m:
    try:
        arr = json.loads(m.group())
        if isinstance(arr, list):
            print(json.dumps(arr))
            sys.exit(0)
    except: pass
sys.exit(1)
" 2>/dev/null)
  if [[ $? -eq 0 ]] && [[ -n "$bracket_extract" ]]; then
    echo "$bracket_extract"
    return 0
  fi

  return 1
}

TASKS_JSON=$(extract_json_array "$DECOMP_OUTPUT")
if [[ $? -ne 0 ]] || [[ -z "$TASKS_JSON" ]]; then
  log "ERROR: Could not extract task array from Claude response"
  echo "$DECOMP_OUTPUT" >> "$LOG_DIR/decompose-error.log"
  echo "{\"error\": \"Could not extract task array\", \"raw_length\": ${#DECOMP_OUTPUT}}"
  exit 1
fi

TASK_COUNT=$(echo "$TASKS_JSON" | jq length)
log "Claude generated $TASK_COUNT tasks"

# Cap at 12 tasks per BRD
if [[ $TASK_COUNT -gt 12 ]]; then
  log "WARNING: Capping from $TASK_COUNT to 12 tasks"
  TASKS_JSON=$(echo "$TASKS_JSON" | jq '.[0:12]')
  TASK_COUNT=12
fi

# ─── GET CURRENT TASK ID OFFSET ───

LAST_NUM=$(db_query "SELECT COALESCE(MAX(CAST(SUBSTR(id, 6) AS INTEGER)), 0) FROM tasks WHERE id LIKE 'TASK-%'")
FIRST_NEW=$((LAST_NUM + 1))

# ─── RESOLVE RELATIVE BLOCKED_BY REFERENCES ───

resolve_blocked_by() {
  local blocked_by="$1"
  local current_index="$2"  # 0-based index in the batch

  if [[ -z "$blocked_by" ]] || [[ "$blocked_by" == "null" ]]; then
    echo ""
    return
  fi

  local resolved=""
  IFS=',' read -ra REFS <<< "$blocked_by"
  for ref in "${REFS[@]}"; do
    ref=$(echo "$ref" | tr -d ' ')
    if [[ "$ref" =~ ^PREV-([0-9]+)$ ]]; then
      local offset="${BASH_REMATCH[1]}"
      local dep_index=$((current_index - offset))
      if [[ $dep_index -ge 0 ]]; then
        local dep_id=$(printf "TASK-%03d" $((FIRST_NEW + dep_index)))
        resolved="${resolved:+$resolved,}$dep_id"
      fi
    elif [[ "$ref" =~ ^TASK- ]]; then
      # Already an absolute reference
      resolved="${resolved:+$resolved,}$ref"
    fi
  done
  echo "$resolved"
}

# ─── INSERT TASKS ───

CREATED_TASKS=()

for i in $(seq 0 $((TASK_COUNT - 1))); do
  TASK=$(echo "$TASKS_JSON" | jq -r ".[$i]")

  TITLE=$(echo "$TASK" | jq -r '.title // ""')
  GOAL=$(echo "$TASK" | jq -r '.goal // ""')
  REPO=$(echo "$TASK" | jq -r '.repo // "SMOrchestra-ai/SaaSFast"')
  ROLE=$(echo "$TASK" | jq -r '.role // "vp_engineering"')
  NODE=$(echo "$TASK" | jq -r '.node // "smo-dev"')
  FILES=$(echo "$TASK" | jq -c '.declared_files // []')
  CONSTRAINTS=$(echo "$TASK" | jq -c '.hard_constraints // []')
  TESTS=$(echo "$TASK" | jq -c '.tests_required // []')
  RAW_BLOCKED=$(echo "$TASK" | jq -r '.blocked_by // ""')

  BLOCKED_BY=$(resolve_blocked_by "$RAW_BLOCKED" "$i")

  RESULT=$("$SCRIPTS_DIR/add-task.sh" \
    --repo "$REPO" \
    --goal "$GOAL" \
    --title "$TITLE" \
    --role "$ROLE" \
    --node "$NODE" \
    --files "$FILES" \
    --constraints "$CONSTRAINTS" \
    --tests "$TESTS" \
    --brd-id "$BRD_ID" \
    ${BLOCKED_BY:+--blocked-by "$BLOCKED_BY"})

  TASK_ID=$(echo "$RESULT" | jq -r '.task_id')
  CREATED_TASKS+=("$TASK_ID")
  log "Created $TASK_ID: $TITLE ($ROLE on $NODE)"
done

# ─── SUMMARY ───

# Build safe IN clause using escaped values
SAFE_IN=""
for tid in "${CREATED_TASKS[@]}"; do
  escaped_tid=$(db_escape "$tid")
  SAFE_IN="${SAFE_IN:+$SAFE_IN,}'$escaped_tid'"
done
SUMMARY=$(sqlite3 -json "$QUEUE_DB" "SELECT id, title, role, server_node, status, COALESCE(blocked_by, '') as blocked_by FROM tasks WHERE id IN ($SAFE_IN) ORDER BY id;")

TOTAL=${#CREATED_TASKS[@]}
FIRST_ID="${CREATED_TASKS[0]}"
LAST_ID="${CREATED_TASKS[$((TOTAL - 1))]}"

# Update BRD record with task count and status
db_exec "UPDATE brds SET task_count = :1, status = 'pending_approval' WHERE id = :2" "$TOTAL" "$BRD_ID"

log "BRD $BRD_ID decomposed into $TOTAL tasks ($FIRST_ID — $LAST_ID)"

# Proactive CEO notification (Sprint 1, Fix #3)
"$SCRIPTS_DIR/notify-ceo.sh" "brd_decomposed" "$BRD_ID" 2>/dev/null &

cat <<EOF
{
  "status": "decomposed",
  "brd_id": "$BRD_ID",
  "task_count": $TOTAL,
  "first_task": "$FIRST_ID",
  "last_task": "$LAST_ID",
  "tasks": $SUMMARY,
  "next_step": "Run: /approve-all or /approve $FIRST_ID"
}
EOF
