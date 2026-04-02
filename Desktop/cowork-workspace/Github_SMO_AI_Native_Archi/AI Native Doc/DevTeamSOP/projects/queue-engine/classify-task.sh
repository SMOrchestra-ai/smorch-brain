#!/usr/bin/env bash
# classify-task.sh — Score task complexity and return routing tier
# Deploy to: smo-brain at /root/.smo/queue/classify-task.sh
# Usage: ./classify-task.sh "task description" "file1.ts,file2.ts" [repo]
#
# Output: JSON with tier, score, planner, executor
# Example: {"tier":"staged_hybrid","score":12,"planner":"claude","executor":"codex"}

set -euo pipefail

DESCRIPTION="${1:-}"
DECLARED_FILES="${2:-}"
REPO="${3:-unknown}"

if [[ -z "$DESCRIPTION" ]]; then
  echo '{"error":"Missing task description","usage":"./classify-task.sh \"description\" \"files\" [repo]"}'
  exit 1
fi

# ─── FORBIDDEN ZONE CHECK ───
FORBIDDEN=0
FORBIDDEN_REASON=""

# Check file paths against forbidden zones
IFS=',' read -ra FILES <<< "$DECLARED_FILES"
for f in "${FILES[@]}"; do
  case "$f" in
    *auth*|*Auth*)
      FORBIDDEN=1; FORBIDDEN_REASON="touches auth path: $f" ;;
    *payment*|*Payment*|*billing*|*Billing*)
      FORBIDDEN=1; FORBIDDEN_REASON="touches payment path: $f" ;;
    *infra*|*Infra*|*terraform*|*docker-compose*)
      FORBIDDEN=1; FORBIDDEN_REASON="touches infrastructure: $f" ;;
    *migration*|*Migration*)
      FORBIDDEN=1; FORBIDDEN_REASON="touches migration: $f" ;;
    *.env|*.env.*|*secrets*|*credentials*)
      FORBIDDEN=1; FORBIDDEN_REASON="touches secrets: $f" ;;
  esac
done

# Check description for forbidden keywords
DESC_LOWER=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]')
for keyword in "database migration" "auth flow" "payment integration" "infrastructure change" "secret rotation" "production database" "drop table" "alter table"; do
  if echo "$DESC_LOWER" | grep -q "$keyword"; then
    FORBIDDEN=1
    FORBIDDEN_REASON="description contains forbidden keyword: $keyword"
  fi
done

if [[ $FORBIDDEN -eq 1 ]]; then
  echo "{\"tier\":\"forbidden\",\"score\":99,\"planner\":\"human\",\"executor\":\"human\",\"reason\":\"$FORBIDDEN_REASON\"}"
  exit 0
fi

# ─── COMPLEXITY SCORING ───
# Simplified heuristic scoring (full 13-dimension model would use LLM classification)
SCORE=0

# File count (blast radius proxy)
FILE_COUNT=${#FILES[@]}
if [[ $FILE_COUNT -le 1 ]]; then
  SCORE=$((SCORE + 1))
elif [[ $FILE_COUNT -le 3 ]]; then
  SCORE=$((SCORE + 3))
elif [[ $FILE_COUNT -le 6 ]]; then
  SCORE=$((SCORE + 5))
else
  SCORE=$((SCORE + 8))
fi

# Description complexity (word count + keyword analysis)
WORD_COUNT=$(echo "$DESCRIPTION" | wc -w | tr -d ' ')
if [[ $WORD_COUNT -le 10 ]]; then
  SCORE=$((SCORE + 1))   # Simple task
elif [[ $WORD_COUNT -le 30 ]]; then
  SCORE=$((SCORE + 3))   # Medium task
else
  SCORE=$((SCORE + 5))   # Complex task
fi

# Complexity keywords
for keyword in "refactor" "redesign" "multi" "across" "integrate" "complex" "architecture" "system"; do
  if echo "$DESC_LOWER" | grep -q "$keyword"; then
    SCORE=$((SCORE + 2))
  fi
done

# Simplicity keywords (reduce score)
for keyword in "fix typo" "update readme" "add comment" "lint" "format" "rename" "docs" "documentation"; do
  if echo "$DESC_LOWER" | grep -q "$keyword"; then
    SCORE=$((SCORE - 2))
  fi
done

# Test/TDD keywords (moderate complexity)
for keyword in "test" "tdd" "spec" "coverage"; do
  if echo "$DESC_LOWER" | grep -q "$keyword"; then
    SCORE=$((SCORE + 1))
  fi
done

# Multi-service indicators
for keyword in "frontend" "backend" "database" "api" "ui" "deploy"; do
  if echo "$DESC_LOWER" | grep -q "$keyword"; then
    SCORE=$((SCORE + 1))
  fi
done

# Ensure score is at least 1
[[ $SCORE -lt 1 ]] && SCORE=1

# ─── TIER ASSIGNMENT ───
if [[ $SCORE -lt 8 ]]; then
  TIER="fast_track"
  PLANNER="codex"
  EXECUTOR="codex"
elif [[ $SCORE -lt 15 ]]; then
  TIER="staged_hybrid"
  PLANNER="claude"
  EXECUTOR="codex"
else
  TIER="agent_team"
  PLANNER="claude"
  EXECUTOR="claude"
fi

echo "{\"tier\":\"$TIER\",\"score\":$SCORE,\"planner\":\"$PLANNER\",\"executor\":\"$EXECUTOR\",\"file_count\":$FILE_COUNT}"
