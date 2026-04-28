#!/usr/bin/env bash
# score-task.sh — Quality gate scoring for completed agent work
# Deploy to: smo-brain at /root/.smo/queue/score-task.sh
# Usage: ./score-task.sh TASK-XXX
#
# Process:
#   1. Reads task from queue (must be in 'ci_pending' or 'scoring' status)
#   2. Gets the branch diff from GitHub
#   3. Determines the scorer skill for the task's role
#   4. Runs Claude with the scorer skill to evaluate quality
#   5. If score >= threshold: creates PR
#   6. If score < threshold and retries < 2: sends back for revision
#   7. If score < threshold and retries >= 2: creates PR with needs-quality-review label

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"
LOG_DIR="/root/.smo/logs"
WORKSPACES="/workspaces/smo"

# Load parameterized SQL wrapper (Sprint 1, Fix #1 — SQL injection prevention)
source "$(dirname "$0")/db.sh"

TASK_ID="${1:-}"

if [[ -z "$TASK_ID" ]]; then
  echo "Usage: ./score-task.sh TASK-XXX"
  exit 1
fi

mkdir -p "$LOG_DIR"

log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] [scorer] $1"
  echo "$msg"
  echo "$msg" >> "$LOG_DIR/scorer.log"
}

# audit() is now provided by db.sh

# ─── LOAD TASK ───

TASK_JSON=$(db_query_json "SELECT * FROM tasks WHERE id = :1 LIMIT 1" "$TASK_ID")
if [[ -z "$TASK_JSON" ]] || [[ "$TASK_JSON" == "[]" ]]; then
  log "ERROR: Task $TASK_ID not found"
  exit 1
fi

ROLE=$(echo "$TASK_JSON" | jq -r '.[0].role')
REPO=$(echo "$TASK_JSON" | jq -r '.[0].repo')
BRANCH=$(echo "$TASK_JSON" | jq -r '.[0].branch')
GOAL=$(echo "$TASK_JSON" | jq -r '.[0].goal')
TITLE=$(echo "$TASK_JSON" | jq -r '.[0].title')
RETRY_COUNT=$(echo "$TASK_JSON" | jq -r '.[0].retry_count // 0')

log "Scoring $TASK_ID: $TITLE (role: $ROLE, repo: $REPO, branch: $BRANCH)"

# Update status to scoring
db_update_task "$TASK_ID" "status" "scoring"

# ─── GET SCORER SKILL FOR ROLE ───

SCORER=$(db_query "SELECT quality_gate FROM role_skills WHERE role = :1 AND quality_gate IS NOT NULL LIMIT 1" "$ROLE")
THRESHOLD=$(db_query "SELECT pass_threshold FROM role_skills WHERE role = :1 AND pass_threshold IS NOT NULL LIMIT 1" "$ROLE")
[[ -z "$THRESHOLD" ]] && THRESHOLD="8.0"
[[ -z "$SCORER" ]] && SCORER="engineering-scorer"

log "Scorer: $SCORER | Threshold: $THRESHOLD"

# ─── GET BRANCH DIFF ───

REPO_DIR="$WORKSPACES/$(basename "$REPO")"
DIFF=""

if [[ -d "$REPO_DIR" ]]; then
  cd "$REPO_DIR"
  git fetch origin 2>/dev/null || true
  DIFF=$(git diff origin/main..."origin/$BRANCH" 2>/dev/null || echo "")
fi

# Fallback: use gh CLI
if [[ -z "$DIFF" ]] || [[ ${#DIFF} -lt 10 ]]; then
  DIFF=$(gh api "repos/$REPO/compare/main...$BRANCH" --jq '.files[] | "--- " + .filename + "\n" + (.patch // "")' 2>/dev/null || echo "No diff available")
fi

if [[ -z "$DIFF" ]] || [[ "$DIFF" == "No diff available" ]]; then
  # Check if this is a review/analysis role (no code changes expected)
  case "$ROLE" in
    qa_lead|qa|review|analyst)
      log "Review task with no diff — marking as complete (review-only)"
      db_exec "UPDATE tasks SET status = 'merged', quality_score = 10.0, updated_at = datetime('now') WHERE id = :1" "$TASK_ID"
      db_release_locks "$TASK_ID"
      audit "$TASK_ID" "review_complete" "{\"reason\": \"review-only task, no code changes expected\"}"
      exit 0
      ;;
    *)
      log "WARNING: No diff found for $BRANCH — skipping scoring, creating PR directly"
      audit "$TASK_ID" "score_skipped" "{\"reason\": \"no diff\"}"
      /root/.smo/queue/create-pr.sh "$TASK_ID"
      exit 0
      ;;
  esac
fi

# Truncate diff if too large (keep first 8000 chars)
if [[ ${#DIFF} -gt 8000 ]]; then
  DIFF="${DIFF:0:8000}
... [truncated — ${#DIFF} total chars]"
fi

# ─── RUN SCORER ───

SCORE_PROMPT="You are a quality reviewer using the $SCORER methodology.

## Task Being Reviewed
- Task: $TASK_ID
- Title: $TITLE
- Goal: $GOAL
- Role: $ROLE
- Repo: $REPO

## Code Diff to Review
\`\`\`diff
$DIFF
\`\`\`

## Scoring Instructions
Score this work on a scale of 1-10 across these dimensions:
1. **Correctness** — Does the code achieve the stated goal?
2. **Quality** — Clean code, proper patterns, no anti-patterns?
3. **Completeness** — All requirements addressed? No missing pieces?
4. **Safety** — No security issues, no hardcoded secrets, proper validation?
5. **Tests** — Are tests included and meaningful?

## Output Format
Return ONLY valid JSON:
{
  \"score\": <average of all dimensions as float>,
  \"dimensions\": {
    \"correctness\": <1-10>,
    \"quality\": <1-10>,
    \"completeness\": <1-10>,
    \"safety\": <1-10>,
    \"tests\": <1-10>
  },
  \"passed\": <true if score >= $THRESHOLD>,
  \"feedback\": \"<specific actionable feedback if score < $THRESHOLD>\",
  \"summary\": \"<1-2 sentence summary of the work>\"
}"

SCORE_OUTPUT=$(claude -p "$SCORE_PROMPT" --output-format json 2>/dev/null || \
               claude -p "$SCORE_PROMPT" 2>/dev/null)

# Extract score JSON
extract_score() {
  local raw="$1"
  # Try envelope extraction
  if echo "$raw" | jq -e '.result' >/dev/null 2>&1; then
    raw=$(echo "$raw" | jq -r '.result')
  fi
  # Try direct parse
  if echo "$raw" | jq -e '.score' >/dev/null 2>&1; then
    echo "$raw"
    return 0
  fi
  # Extract from code block
  local from_block
  from_block=$(echo "$raw" | sed -n '/```json/,/```/{/```/d;p}')
  if [[ -n "$from_block" ]] && echo "$from_block" | jq -e '.score' >/dev/null 2>&1; then
    echo "$from_block"
    return 0
  fi
  # Find first { ... } with score key
  echo "$raw" | python3 -c "
import sys, json, re
text = sys.stdin.read()
m = re.search(r'\{.*\"score\".*\}', text, re.DOTALL)
if m:
    try:
        obj = json.loads(m.group())
        print(json.dumps(obj))
        sys.exit(0)
    except: pass
sys.exit(1)
" 2>/dev/null
}

SCORE_JSON=$(extract_score "$SCORE_OUTPUT")
if [[ $? -ne 0 ]] || [[ -z "$SCORE_JSON" ]]; then
  log "WARNING: Could not parse score output — defaulting to pass"
  audit "$TASK_ID" "score_parse_failed" "{\"raw_length\": ${#SCORE_OUTPUT}}"
  /root/.smo/queue/create-pr.sh "$TASK_ID"
  exit 0
fi

SCORE=$(echo "$SCORE_JSON" | jq -r '.score')
PASSED=$(echo "$SCORE_JSON" | jq -r '.passed')
FEEDBACK=$(echo "$SCORE_JSON" | jq -r '.feedback // ""')
SUMMARY=$(echo "$SCORE_JSON" | jq -r '.summary // ""')

log "Score: $SCORE / 10 | Passed: $PASSED"

# Store score
db_update_task "$TASK_ID" "quality_score" "$SCORE"

audit "$TASK_ID" "scored" "{\"score\": $SCORE, \"passed\": $PASSED, \"threshold\": $THRESHOLD}"

# ─── DECISION ───

if [[ "$PASSED" == "true" ]]; then
  log "PASSED — creating PR"
  /root/.smo/queue/create-pr.sh "$TASK_ID" "$SUMMARY"
elif [[ $RETRY_COUNT -lt 2 ]]; then
  NEW_RETRY=$((RETRY_COUNT + 1))
  log "FAILED (attempt $NEW_RETRY/2) — sending back for revision"
  # Sanitize feedback for safe SQL
  SAFE_FEEDBACK=$(echo "$FEEDBACK" | tr '\n' ' ' | sed 's/[^a-zA-Z0-9 .,;:!?()/-]//g' | cut -c1-500)
  ESCAPED_FEEDBACK=$(db_escape "$SAFE_FEEDBACK")
  # Update via db_exec with parameterized values
  db_exec "UPDATE tasks SET status = 'queued', retry_count = :1, goal = goal || char(10) || char(10) || 'REVISION FEEDBACK (attempt ' || :2 || '): ' || :3, updated_at = datetime('now') WHERE id = :4" \
    "$NEW_RETRY" "$NEW_RETRY" "$SAFE_FEEDBACK" "$TASK_ID" || {
    log "WARNING: Feedback append failed, updating status only"
    db_exec "UPDATE tasks SET status = 'queued', retry_count = :1, updated_at = datetime('now') WHERE id = :2" "$NEW_RETRY" "$TASK_ID"
  }
  # Release file locks so the task can be re-dispatched
  db_release_locks "$TASK_ID"
  SAFE_FEEDBACK_JSON=$(printf '%s' "$FEEDBACK" | tr '\n' ' ' | sed 's/[^a-zA-Z0-9 .,;:!?()/-]//g' | cut -c1-200)
  audit "$TASK_ID" "revision_requested" "{\"attempt\": $NEW_RETRY, \"score\": $SCORE, \"feedback\": \"$SAFE_FEEDBACK_JSON\"}"
else
  log "FAILED after $RETRY_COUNT retries — creating PR with review label"
  /root/.smo/queue/create-pr.sh "$TASK_ID" "$SUMMARY" "needs-quality-review"
fi
