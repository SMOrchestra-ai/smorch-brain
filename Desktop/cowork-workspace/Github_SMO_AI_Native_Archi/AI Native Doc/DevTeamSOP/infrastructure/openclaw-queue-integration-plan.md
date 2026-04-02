# OpenClaw Queue Integration — Layer 2 Implementation Plan
## AI Native Git Architecture v2 — Orchestration Layer

**Version:** 1.0
**Owner:** Mamoun Alamouri
**Date:** 2026-03-20
**Status:** Approved — Ready for Build

---

## Architecture

```
Linear Webhook ──▶ n8n (smo-brain) ──▶ SQLite Queue State
                        │
                        ├── Spec Generation ──▶ GitHub API (commit spec to repo)
                        ├── Telegram Alert ───▶ Mamoun approves (/approve TASK-XXX)
                        ├── Concurrency Gate ─▶ Max 4 active agent branches
                        ├── File Conflict ────▶ Check active branches for overlap
                        ├── Dependency Check ──▶ Linear API for blocked-by status
                        │
                        ▼
                   OpenClaw Gateway (smo-brain:18789)
                        ├── smo-brain agents (eo-assessment, EO-Build, eo-mena, smorch-brain)
                        ├── smo-dev agents (SaaSFast, SaaSFast-v2, ScrapMfast, ship-fast)
                        │
                        ▼
                   Claude Code (isolated workspace, 60-min TTL)
                        │
                        ▼
                   GitHub Push ──▶ CI webhook ──▶ n8n
                        ├── Pass: PR + risk labels + reviewer assignment
                        └── Fail: Self-fix (1 retry) or needs-human-debug
```

**Hybrid split:**
- **n8n**: Queue state, Linear intake, spec generation, concurrency/conflict/dependency logic, CI monitoring, PR creation/routing, Telegram commands, TTL monitoring
- **OpenClaw**: Agent dispatch, session execution, multi-node routing, workspace isolation

---

## Data Store: SQLite

**Location:** `/root/.smo/queue/queue.db` on smo-brain
**Access:** n8n Code nodes using `better-sqlite3` npm package

### Schema

```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,                    -- TASK-XXX from Linear
  linear_id TEXT NOT NULL,                -- Linear issue UUID
  linear_url TEXT,
  repo TEXT NOT NULL,                     -- e.g. "eo-assessment-system"
  title TEXT NOT NULL,
  goal TEXT,
  affected_modules TEXT,                  -- comma-separated
  hard_constraints TEXT,
  tests_required BOOLEAN DEFAULT TRUE,
  declared_files TEXT,                    -- JSON array of file paths
  spec_path TEXT,                         -- specs/tasks/TASK-XXX.md
  status TEXT NOT NULL DEFAULT 'pending_spec',
  -- Statuses: pending_spec, pending_approval, queued, blocked,
  --   conflict_wait, active, ci_running, ci_failed, self_fix,
  --   pr_open, merged, killed, expired
  blocked_by TEXT,                        -- TASK-XXX dependency
  branch_name TEXT,                       -- agent/TASK-XXX-slug
  server_node TEXT,                       -- smo-brain or smo-dev
  openclaw_session_id TEXT,
  session_started_at TEXT,
  session_ttl_alerted BOOLEAN DEFAULT FALSE,
  pr_number INTEGER,
  pr_risk_tier TEXT,                      -- high, medium, low
  ci_attempts INTEGER DEFAULT 0,
  ci_last_log TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  branch_created_at TEXT,
  branch_ttl_alerted BOOLEAN DEFAULT FALSE
);

CREATE TABLE file_locks (
  task_id TEXT NOT NULL,
  repo TEXT NOT NULL,
  file_path TEXT NOT NULL,
  locked_at TEXT DEFAULT (datetime('now')),
  PRIMARY KEY (task_id, file_path),
  FOREIGN KEY (task_id) REFERENCES tasks(id)
);

CREATE TABLE audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id TEXT,
  event TEXT NOT NULL,
  detail TEXT,
  created_at TEXT DEFAULT (datetime('now'))
);
```

---

## n8n Workflows (7 total)

### Workflow 1: Linear Intake + Spec Generator

**Trigger:** Webhook POST `/webhook/linear-task-intake`
**Filters:** `action === "create"` AND label contains `agent-task`

**Flow:**
1. Extract Linear fields: identifier, title, description, custom fields (target_repo, agent_goal, declared_files, hard_constraints, tests_required, blocked_by)
2. Generate spec markdown from template (Architecture v2 format)
3. GitHub API: Commit spec to `specs/tasks/TASK-XXX.md` on `dev` branch of target repo
4. SQLite: Insert task with status `pending_approval`
5. Telegram: Send spec summary + approval prompt to Mamoun

**Spec template:**
```markdown
# TASK-XXX: [title]

## Goal
[agent_goal from Linear]

## Context
[description from Linear]

## Declared Files (agent scope is limited to these)
[declared_files from Linear, one per line with - prefix]

## Hard Constraints
[hard_constraints from Linear]

## Acceptance Criteria
[auto-generated from goal + tests_required]

## Linear Ticket
[linear_url]

## Spec Approved By
PENDING
```

### Workflow 2: Telegram Command Handler

**Trigger:** Telegram Trigger node (polling mode)

**Commands:**
| Command | Action |
|---------|--------|
| `/approve TASK-XXX` | Update status → queued, trigger Queue Processor |
| `/reject TASK-XXX [reason]` | Update status → killed, notify Linear |
| `/kill TASK-XXX` | Kill OpenClaw session, release slot, clean up |
| `/extend TASK-XXX` | Extend branch TTL by 24h |
| `/status` | Show all non-terminal tasks with status |
| `/active` | Show currently executing tasks with elapsed time |
| `/queue` | Show queued + blocked + conflict_wait tasks |

### Workflow 3: Queue Processor

**Trigger:** n8n internal (called by Workflow 2 on approve, Workflow 4/7 on slot release)

**Flow:**
1. Count active tasks (status IN active, ci_running, self_fix). If >= 4, STOP.
2. Get all `queued` tasks ordered by created_at
3. For each queued task:
   - **Dependency check:** If blocked_by set, query Linear API. If dependency not merged, set status `blocked`, skip.
   - **File conflict check:** Query file_locks for overlap in same repo. If overlap, set status `conflict_wait`, skip.
   - If passes both: this is the next task. Break.
4. If no eligible task: STOP.
5. Update status → active, insert file_locks
6. Determine server node from repo affinity map
7. GitHub API: Create branch `agent/TASK-XXX-slug` from dev HEAD
8. Execute dispatcher script via SSH/Execute Command
9. Record session_started_at, branch_name, server_node

**Repo → Server Affinity:**
| Server | Repos |
|--------|-------|
| smo-brain | eo-assessment-system, EO-Build, eo-mena, smorch-brain |
| smo-dev | SaaSFast, SaaSFast-v2, ScrapMfast, ship-fast |

**File Conflict Detection Logic:**
```
For each declared_file in new task:
  For each locked file_path in same repo:
    If exact match OR one is prefix of other → CONFLICT
```

### Workflow 4: CI Monitor + Self-Fix Loop

**Trigger:** Webhook POST `/webhook/github-ci-status`
**Events:** check_suite (completed), filtered to agent/* branches

**On CI Pass:**
1. GitHub API: Create PR (head: agent/TASK-XXX-slug, base: dev)
2. Calculate risk tier (see Risk Tier section below)
3. GitHub API: Add labels (agent-generated + risk tier)
4. GitHub API: Request reviewer based on tier
5. SQLite: Update status → pr_open, record pr_number
6. Telegram: Notify with PR link + risk tier
7. Release file locks, trigger Workflow 3

**On CI Fail (first attempt, ci_attempts < 1):**
1. GitHub API: Get failure log from check run
2. SQLite: Update status → self_fix, increment ci_attempts
3. Dispatch self-fix session via OpenClaw (spec + failure log as context)
4. Telegram: Notify self-fix in progress

**On CI Fail (second attempt, ci_attempts >= 1):**
1. GitHub API: Create PR with labels `needs-human-debug`, `risk-high`
2. GitHub API: Add comment with both failure logs
3. SQLite: Update status → pr_open
4. Telegram: Alert — self-fix failed, human debug required
5. Release file locks, trigger Workflow 3

### Workflow 5: Session TTL Monitor

**Trigger:** Cron every 5 minutes

**Flow:**
1. Query active tasks (status IN active, self_fix)
2. For each:
   - **45 min elapsed, not alerted:** Telegram alert, set ttl_alerted = TRUE
   - **60 min elapsed:** Kill OpenClaw session, update status → killed, release file locks, Telegram alert, trigger Workflow 3

### Workflow 6: Branch TTL Monitor

**Trigger:** Cron every 6 hours

**Flow:**
1. Query tasks where status = pr_open AND branch_created_at > 48h AND branch_ttl_alerted = FALSE
2. For each: Telegram alert (/extend or /kill options), set branch_ttl_alerted = TRUE

### Workflow 7: PR Merge Handler

**Trigger:** Webhook POST `/webhook/github-pr-events`
**Events:** pull_request (closed + merged), filtered to agent/* branches

**Flow:**
1. SQLite: Update status → merged
2. SQLite: Unblock dependent tasks (blocked_by matches this task → status queued)
3. SQLite: Re-check conflict_wait tasks (file locks released → may be eligible)
4. GitHub API: Delete agent branch
5. Trigger Workflow 3 (slot opened)

---

## Risk Tier Calculation

```
HIGH if ANY of:
  - Diff touches infra/, auth/, billing/, security/
  - Diff touches files outside declared scope
  - Self-fix was applied (ci_attempts > 0)
  - Diff exceeds 200 lines

LOW if ALL files are:
  - tests/ only, OR
  - docs/ only, OR
  - prompts/ only

MEDIUM: everything else
```

**PR Labels:** `agent-generated` (always) + `risk-high|risk-medium|risk-low` + `self-fix-applied` (if applicable) + `needs-human-debug` (if self-fix failed)

**Reviewer Assignment:**
- High → smorchestraai-code (Mamoun directly)
- Medium → engineering team
- Low → no reviewer (async review)

---

## OpenClaw Agent Configuration

### Dispatcher Script

**Location:** `/root/.smo/queue/dispatch.sh` on smo-brain

```bash
#!/bin/bash
set -euo pipefail

TASK_ID=$1    # TASK-XXX
REPO=$2       # e.g. eo-assessment-system
SPEC_PATH=$3  # /root/.smo/queue/specs/TASK-XXX.md
SERVER=$4     # local or smo-dev
BRANCH=$5     # agent/TASK-XXX-slug

WORKSPACE="/workspaces/openclaw/$TASK_ID"

if [ "$SERVER" = "local" ]; then
  mkdir -p "$WORKSPACE"
  git clone "git@github.com:SMOrchestra-ai/$REPO.git" "$WORKSPACE/repo"
  cd "$WORKSPACE/repo"
  git checkout "$BRANCH"
  cp "$SPEC_PATH" ./SPEC.md

  openclaw agent \
    --message "Execute the task in SPEC.md. Follow ALL constraints. Do NOT touch files outside declared scope. Commit incrementally: agent($TASK_ID): [what changed]" \
    --session-id "$TASK_ID" \
    --timeout-seconds 3600 \
    --json > "$WORKSPACE/result.json" 2>&1 &

  echo $!

elif [ "$SERVER" = "smo-dev" ]; then
  ssh root@smo-dev "mkdir -p $WORKSPACE && git clone git@github.com:SMOrchestra-ai/$REPO.git $WORKSPACE/repo && cd $WORKSPACE/repo && git checkout $BRANCH"
  scp "$SPEC_PATH" "root@smo-dev:$WORKSPACE/repo/SPEC.md"

  ssh root@smo-dev "openclaw agent \
    --message 'Execute the task in SPEC.md. Follow ALL constraints. Do NOT touch files outside declared scope. Commit incrementally: agent($TASK_ID): [what changed]' \
    --session-id '$TASK_ID' \
    --timeout-seconds 3600 \
    --json > $WORKSPACE/result.json 2>&1" &

  echo $!
fi
```

### Workspace Cleanup Script

**Location:** `/root/.smo/queue/cleanup.sh` on smo-brain

```bash
#!/bin/bash
TASK_ID=$1
SERVER=$2

WORKSPACE="/workspaces/openclaw/$TASK_ID"

if [ "$SERVER" = "local" ]; then
  rm -rf "$WORKSPACE"
elif [ "$SERVER" = "smo-dev" ]; then
  ssh root@smo-dev "rm -rf $WORKSPACE"
fi
```

---

## Linear Custom Fields

Create these in Linear Settings > Custom Fields:

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| target_repo | Single Select | Yes | Options: all 8 repo names |
| agent_goal | Text | Yes | One-sentence goal |
| declared_files | Text | Yes | Comma-separated file paths |
| hard_constraints | Text | No | What must NOT change |
| tests_required | Checkbox | Yes | Default: checked |
| blocked_by | Text | No | TASK-XXX identifier |

Create Linear label: `agent-task` — only this label triggers the webhook flow.

---

## GitHub Webhook Setup

Create org-level webhook (one for all repos):

```bash
gh api /orgs/SMOrchestra-ai/hooks \
  --method POST \
  -f name="web" \
  -f 'config[url]=https://<n8n-public-url>/webhook/github-ci-status' \
  -f 'config[content_type]=json' \
  -f "config[secret]=<WEBHOOK_SECRET>" \
  -f 'events[]=check_suite' \
  -f 'events[]=pull_request' \
  -f active=true
```

---

## Telegram Bot Setup

1. Create bot via @BotFather: `SMOQueueBot`
2. Get bot token
3. Store in n8n credentials (Telegram API)
4. Use Telegram Trigger node in polling mode (no public endpoint needed)

---

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| Gateway down | Health cron (15 min) + Workflow 5 failure | Telegram alert, pause dispatches, queue holds state |
| smo-dev disconnected | Node alert (5 min) + SSH failure in dispatch | Telegram alert, skip smo-dev tasks, re-queue |
| CI hangs (>20 min) | Workflow 5 checks ci_running duration | Telegram alert, Mamoun can /kill |
| n8n down | Health cron on smo-brain | Queue pauses, active sessions hit TTL and die |
| Stale file locks | Workflow 5 cleanup step | Delete locks for killed/expired tasks |
| Orphaned workspace | Cleanup script triggered on task close | rm -rf workspace dir |

---

## Rollout Phases

### Phase 1: Foundation (Days 1-2)
- [ ] Create SQLite database on smo-brain
- [ ] Install better-sqlite3 in n8n
- [ ] Create Telegram bot via BotFather
- [ ] Build Workflow 2 (Telegram Handler) — /status, /active commands
- [ ] Test: send commands, verify responses

### Phase 2: Spec Pipeline (Days 2-3)
- [ ] Configure Linear custom fields
- [ ] Create Linear label `agent-task`
- [ ] Set up Linear webhook pointing to n8n
- [ ] Build Workflow 1 (Linear Intake + Spec Generator)
- [ ] Test: create Linear ticket → spec appears in repo → Telegram notification → /approve works

### Phase 3: Queue Engine (Days 3-5)
- [ ] Build Workflow 3 (Queue Processor)
- [ ] Create dispatcher script on smo-brain
- [ ] Create workspace dirs on both servers
- [ ] Build cleanup script
- [ ] Test: approve task → branch created → workspace cloned → agent dispatched → commits appear

### Phase 4: CI Loop (Days 5-7)
- [ ] Set up GitHub org webhook (check_suite + pull_request)
- [ ] Build Workflow 4 (CI Monitor + Self-Fix Loop)
- [ ] Build Workflow 7 (PR Merge Handler)
- [ ] Test full loop: Linear → spec → approve → dispatch → push → CI → PR → merge → slot release

### Phase 5: TTL + Validation (Days 7-10)
- [ ] Build Workflow 5 (Session TTL Monitor)
- [ ] Build Workflow 6 (Branch TTL Monitor)
- [ ] Test TTL alerts (45 min warning, 60 min kill)
- [ ] Run 3-4 concurrent tasks — verify concurrency gate holds at 4
- [ ] Test file conflict detection with overlapping tasks
- [ ] Test dependency blocking and unblocking
- [ ] Test error recovery (kill mid-session, disconnect smo-dev)

---

## Verification Checklist (Post-Build)

- [ ] Linear ticket with `agent-task` label → spec auto-generated in correct repo
- [ ] /approve in Telegram → task enters queue
- [ ] Queue processor respects max 4 concurrent slots
- [ ] File conflict blocks second task on same files
- [ ] Dependency blocking works (blocked task waits, unblocks on merge)
- [ ] Agent creates agent/TASK-XXX-slug branch, commits with correct prefix
- [ ] CI pass → PR created with correct risk tier label
- [ ] CI fail → self-fix attempt → second fail → needs-human-debug PR
- [ ] Session TTL: alert at 45 min, kill at 60 min
- [ ] Branch TTL: alert at 48h
- [ ] PR merge → slot released → blocked/conflict tasks re-evaluated
- [ ] /kill command works mid-session
- [ ] /status shows accurate queue state
- [ ] Workspace cleaned up after task completes
