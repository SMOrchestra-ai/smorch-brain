#!/usr/bin/env bash
# health-check.sh — Queue engine health check endpoint
# Deploy to: smo-brain at /root/.smo/queue/health-check.sh
# Usage: ./health-check.sh [--json|--brief]
#
# Returns structured health status for monitoring, n8n, and Paperclip.
# Exit codes: 0 = healthy, 1 = degraded, 2 = critical
#
# Sprint 1, Fix #4 — Health check endpoint (API & Integration 7 → 9)

set -euo pipefail

QUEUE_DB="/root/.smo/queue/queue.db"
source "$(dirname "$0")/db.sh"

MODE="${1:---json}"

# ─── CHECKS ───

HEALTHY=true
WARNINGS=()
ERRORS=()

# 1. Database accessible
DB_OK=false
if [[ -f "$QUEUE_DB" ]]; then
  if db_query "SELECT 1" >/dev/null 2>&1; then
    DB_OK=true
  else
    ERRORS+=("database_locked_or_corrupt")
    HEALTHY=false
  fi
else
  ERRORS+=("database_file_missing")
  HEALTHY=false
fi

# 2. Queue stats
TOTAL=0 ACTIVE=0 QUEUED=0 STUCK=0 FAILED=0 MERGED=0
if $DB_OK; then
  TOTAL=$(db_query "SELECT COUNT(*) FROM tasks")
  ACTIVE=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'active'")
  QUEUED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'queued'")
  FAILED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status IN ('failed', 'killed')")
  MERGED=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'merged'")
  # Stuck = active for > 45 minutes
  STUCK=$(db_query "SELECT COUNT(*) FROM tasks WHERE status = 'active' AND session_started_at IS NOT NULL AND (julianday('now') - julianday(session_started_at)) * 24 * 60 > 45")
  if [[ $STUCK -gt 0 ]]; then
    WARNINGS+=("stuck_tasks:$STUCK")
  fi
fi

# 3. Disk space (queue.db directory)
DISK_FREE_MB=0
if command -v df >/dev/null 2>&1; then
  DISK_FREE_MB=$(df -m "$(dirname "$QUEUE_DB")" 2>/dev/null | tail -1 | awk '{print $4}')
  if [[ ${DISK_FREE_MB:-0} -lt 100 ]]; then
    WARNINGS+=("low_disk:${DISK_FREE_MB}MB")
  fi
fi

# 4. DB file size
DB_SIZE_KB=0
if [[ -f "$QUEUE_DB" ]]; then
  DB_SIZE_KB=$(du -k "$QUEUE_DB" | cut -f1)
fi

# 5. Paused check
PAUSED=false
if [[ -f "/root/.smo/queue/.paused" ]]; then
  PAUSED=true
  WARNINGS+=("dispatch_paused")
fi

# 6. Scripts exist
SCRIPTS_OK=true
for script in dispatch.sh score-task.sh task-complete.sh queue-status.sh db.sh notify-ceo.sh; do
  if [[ ! -x "/root/.smo/queue/$script" ]] && [[ ! -f "/root/.smo/queue/$script" ]]; then
    WARNINGS+=("missing_script:$script")
    SCRIPTS_OK=false
  fi
done

# 7. n8n reachable (localhost:5678)
N8N_OK=false
if curl -s --max-time 3 "http://localhost:5678/healthz" >/dev/null 2>&1; then
  N8N_OK=true
elif curl -s --max-time 3 "http://localhost:5678/" >/dev/null 2>&1; then
  N8N_OK=true
else
  WARNINGS+=("n8n_unreachable")
fi

# 8. BRD stats
BRD_TOTAL=0 BRD_ACTIVE=0
if $DB_OK; then
  BRD_TOTAL=$(db_query "SELECT COUNT(*) FROM brds" 2>/dev/null || echo "0")
  BRD_ACTIVE=$(db_query "SELECT COUNT(*) FROM brds WHERE status NOT IN ('completed', 'failed')" 2>/dev/null || echo "0")
fi

# ─── DETERMINE STATUS ───

STATUS="healthy"
EXIT_CODE=0
if [[ ${#ERRORS[@]} -gt 0 ]]; then
  STATUS="critical"
  EXIT_CODE=2
  HEALTHY=false
elif [[ ${#WARNINGS[@]} -gt 0 ]]; then
  STATUS="degraded"
  EXIT_CODE=1
fi

# ─── OUTPUT ───

WARNINGS_JSON=$(printf '%s\n' "${WARNINGS[@]}" 2>/dev/null | jq -R . | jq -s . 2>/dev/null || echo "[]")
ERRORS_JSON=$(printf '%s\n' "${ERRORS[@]}" 2>/dev/null | jq -R . | jq -s . 2>/dev/null || echo "[]")

case "$MODE" in
  --brief)
    echo "$STATUS (active:$ACTIVE queued:$QUEUED stuck:$STUCK failed:$FAILED merged:$MERGED)"
    ;;
  --json|*)
    cat <<EOF
{
  "status": "$STATUS",
  "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "queue": {
    "total": $TOTAL,
    "active": $ACTIVE,
    "queued": $QUEUED,
    "stuck": $STUCK,
    "failed": $FAILED,
    "merged": $MERGED
  },
  "brds": {
    "total": $BRD_TOTAL,
    "active": $BRD_ACTIVE
  },
  "system": {
    "database": $DB_OK,
    "n8n": $N8N_OK,
    "scripts": $SCRIPTS_OK,
    "paused": $PAUSED,
    "disk_free_mb": ${DISK_FREE_MB:-0},
    "db_size_kb": $DB_SIZE_KB
  },
  "warnings": $WARNINGS_JSON,
  "errors": $ERRORS_JSON
}
EOF
    ;;
esac

exit $EXIT_CODE
