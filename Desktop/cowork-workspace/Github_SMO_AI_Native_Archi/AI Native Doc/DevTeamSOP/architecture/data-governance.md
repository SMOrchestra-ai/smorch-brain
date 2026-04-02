# Data Governance -- SMOrchestra AI-Native Organization

**Business line:** SMOrchestra.ai (AI Agency infrastructure)
**Last updated:** 2026-03-29
**Owner:** Mamoun Alamouri

---

## 1. Paperclip Database Schema (PostgreSQL on embedded port 54329)

Paperclip uses an embedded PostgreSQL instance at `~/.paperclip/instances/default/data/`.
ORM: Drizzle. Migrations: 46 files (0000-0045) in `paperclip/packages/db/src/migrations/`.

### 1.1 Core Tables (59 tables across 11 domains)

#### Organization & Auth
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `companies` | Tenant root entity | id, name, status, issue_prefix, issue_counter, budget/spent_monthly_cents |
| `company_memberships` | User-to-company mapping | company_id, user_id, role |
| `company_logos` | Logo assets per company | company_id, asset_id |
| `company_secrets` | Encrypted secrets vault | company_id, name, provider |
| `company_secret_versions` | Secret version history | secret_id, encrypted_value |
| `company_skills` | Registered skills per company | company_id, skill definition |
| `auth_users` | User accounts (Better Auth) | id, email, name |
| `auth_sessions` | Active sessions | user_id, token, expires_at |
| `auth_accounts` | OAuth provider links | user_id, provider, account_id |
| `auth_verifications` | Email/token verifications | identifier, value, expires_at |
| `instance_settings` | Global instance config | key, value |
| `instance_user_roles` | Instance-level roles | user_id, role |
| `invites` | Company join invites | company_id, email, role |
| `join_requests` | Pending join requests | company_id, user_id |
| `cli_auth_challenges` | CLI authentication flow | challenge, code, status |
| `principal_permission_grants` | Fine-grained permissions | principal_type, principal_id, permission |

#### Agents
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `agents` | Agent definitions | id, company_id, name, role, title, status, reports_to, adapter_type, adapter_config, budget/spent_monthly_cents |
| `agent_api_keys` | API keys per agent | agent_id, key_hash, revoked_at |
| `agent_config_revisions` | Config change history | agent_id, revision, config_snapshot |
| `agent_runtime_state` | Live runtime state (PK=agent_id) | adapter_type, session_id, status, pid, heartbeat |
| `agent_task_sessions` | Active task sessions | agent_id, issue_id, session metadata |
| `agent_wakeup_requests` | Pending wakeup queue | agent_id, reason, scheduled_at |
| `board_api_keys` | Board-level API keys | company_id, key_hash |

#### Projects & Goals
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `projects` | Project containers | company_id, name, status, lead_agent_id, color, archived_at, target_date |
| `project_workspaces` | Git workspace per project | project_id, cwd, repo_url |
| `project_goals` | Goal-to-project mapping | project_id, goal_id |
| `goals` | Hierarchical goals | company_id, title, level, status, parent_id, owner_agent_id |
| `execution_workspaces` | Per-execution sandbox dirs | company_id, project_id, project_workspace_id |
| `workspace_operations` | Workspace provisioning ops | workspace_id, operation, status |
| `workspace_runtime_services` | Runtime services in workspaces | workspace_id, service_type, config |

#### Issues & Work
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `issues` | Work items (tasks/bugs/etc) | company_id, project_id, goal_id, title, status, priority, assignee_agent_id, identifier, origin_kind, origin_id, hidden_at |
| `issue_comments` | Comments on issues | issue_id, author_agent_id, author_user_id, body |
| `issue_approvals` | Approval requests on issues | issue_id, approval_id |
| `issue_attachments` | File attachments | issue_id, asset_id |
| `issue_documents` | Linked documents | issue_id, document_id |
| `issue_labels` | Label assignments | issue_id, label_id |
| `issue_read_states` | Per-user read tracking | issue_id, user_id, last_read_at |
| `issue_work_products` | Output artifacts from work | issue_id, type, content |
| `issue_inbox_archives` | Archived inbox items | issue_id, user_id |
| `labels` | Reusable labels | company_id, name, color |

#### Routines (Scheduled Automation)
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `routines` | Recurring task definitions | company_id, project_id, title, assignee_agent_id, concurrency_policy, catch_up_policy, status |
| `routine_triggers` | Trigger configs (cron, webhook) | routine_id, kind, cron_expression, timezone, next_run_at, public_id, signing_mode |
| `routine_runs` | Execution history | routine_id, trigger_id, status, triggered_at, linked_issue_id, coalesced_into_run_id |

#### Execution & Monitoring
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `heartbeat_runs` | Agent execution runs | agent_id, status, started_at, finished_at, error, external_run_id, context_snapshot, wakeup_request_id |
| `heartbeat_run_events` | Events within a run | run_id, event_type, payload |
| `activity_log` | Audit trail | actor_type, actor_id, action, entity_type, entity_id, run_id |

#### Finance & Budget
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `cost_events` | LLM token cost tracking | agent_id, provider, model, input_tokens, output_tokens, cost_cents, billing_code |
| `finance_events` | Broader finance events | company_id, event_type, amount |
| `budget_policies` | Budget rules/limits | company_id, policy definition |
| `budget_incidents` | Budget violation events | company_id, policy_id, details |
| `approvals` | General approval workflow | type, status, payload, requested_by_agent_id, decided_by_user_id |
| `approval_comments` | Comments on approvals | approval_id, body |

#### Documents & Assets
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `documents` | Rich documents | company_id, title, content |
| `document_revisions` | Document version history | document_id, revision, content |
| `assets` | File/blob storage references | company_id, provider, object_key, content_type, size_bytes |

#### Plugin System
| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `plugins` | Installed plugins | plugin_key (unique), package_name, version, api_version, manifest_json, status |
| `plugin_config` | Plugin configuration | plugin_id, config_key, config_value |
| `plugin_company_settings` | Per-company plugin settings | plugin_id, company_id, settings |
| `plugin_state` | Plugin runtime state | plugin_id, state_key, state_value |
| `plugin_entities` | Plugin-managed entities | plugin_id, entity_type, entity_data |
| `plugin_jobs` | Plugin background jobs | plugin_id, job_type, status |
| `plugin_job_runs` | Job execution history | job_id, status, started_at |
| `plugin_webhook_deliveries` | Outbound webhook log | plugin_id, url, status, response |
| `plugin_logs` | Plugin log entries | plugin_id, level, message |

### 1.2 Key Relationships (Entity-Relationship Summary)

```
companies (tenant root)
  +-- agents (reports_to -> agents, self-referential hierarchy)
  |     +-- agent_api_keys
  |     +-- agent_config_revisions
  |     +-- agent_runtime_state (1:1)
  |     +-- agent_task_sessions
  |     +-- agent_wakeup_requests
  |     +-- heartbeat_runs
  |          +-- heartbeat_run_events
  +-- projects
  |     +-- project_workspaces
  |     +-- execution_workspaces
  |     +-- project_goals -> goals
  |     +-- routines
  |          +-- routine_triggers
  |          +-- routine_runs -> issues
  +-- goals (parent_id -> goals, self-referential hierarchy)
  +-- issues (parent_id -> issues, self-referential hierarchy)
  |     +-- issue_comments, issue_approvals, issue_attachments
  |     +-- issue_documents, issue_labels, issue_read_states
  |     +-- issue_work_products, issue_inbox_archives
  +-- cost_events (links to agent, issue, project, goal)
  +-- approvals -> approval_comments
  +-- activity_log (polymorphic: entity_type + entity_id)
  +-- documents -> document_revisions
  +-- assets
  +-- labels
  +-- company_secrets -> company_secret_versions
  +-- plugins -> plugin_config, plugin_state, plugin_entities, etc.
```

### 1.3 Connection Details

| Parameter | Value |
|-----------|-------|
| Host | localhost |
| Port | 54329 |
| User | paperclip |
| Database | paperclip |
| Data directory | `~/.paperclip/instances/default/data/` |
| Migration count | 46 (0000-0045) |
| ORM | Drizzle (TypeScript) |
| Schema source | `paperclip/packages/db/src/schema/` |

---

## 2. Data Storage Layout

```
~/.paperclip/instances/default/data/
  +-- run-logs/          14 MB   Agent run log files (JSONL/text)
  +-- agent_run_logs/     0 MB   Legacy log directory (empty)
  +-- backups/           23 MB   Hourly SQL dumps
  +-- storage/            0 MB   Blob storage (not yet used)
  +-- archive/            0 MB   Archive target (empty)
  +-- archived-runs/      0 MB   Archived runs (empty)
  +-- backup-status.json          Backup health metadata
```

---

## 3. Log Retention Policy

### Run Logs (`~/.paperclip/instances/default/data/run-logs/`)

| Rule | Value |
|------|-------|
| Hot retention | 30 days |
| Archive target | `~/.paperclip/instances/default/data/archive/run-logs/` |
| Archive format | gzip compressed, original directory structure preserved |
| Archive retention | 90 days, then delete |
| Max hot size | 500 MB total (warn at 400 MB) |

**Enforcement:** Run `cleanup-agent-data.sh` weekly via cron or manually. See section 8 for usage.

### Application Logs

| Rule | Value |
|------|-------|
| Paperclip server logs | Managed by system (stdout/stderr), no file rotation needed |
| n8n execution logs | Managed by n8n's built-in pruning (configure `EXECUTIONS_DATA_MAX_AGE=168` = 7 days) |

---

## 4. Workspace Governance Policy

### Problem
The CEO workspace was observed at 41 MB / 5,424 files, likely caused by `node_modules` or build artifacts leaking into agent workspaces.

### Rules

| Rule | Threshold | Action |
|------|-----------|--------|
| Max workspace size per agent | 100 MB | Warning issued by cleanup script |
| Critical workspace size | 250 MB | Requires immediate investigation |
| Prohibited contents | `node_modules/`, `.git/objects/` (if >50MB), `*.log` files >10MB | Must be in `.gitignore` or excluded |
| Cleanup cadence | Weekly | Run `cleanup-agent-data.sh --report` |

### Recommended `.gitignore` for Agent Workspaces
```
node_modules/
dist/
.next/
*.log
.cache/
tmp/
```

### Remediation Steps for Bloated Workspaces
1. Run `cleanup-agent-data.sh --report` to identify which workspaces exceed limits
2. Inspect the workspace: `du -sh workspace_path/*/ | sort -rh | head -10`
3. Remove `node_modules/` and build artifacts
4. Add proper `.gitignore` entries
5. If workspace is a project clone, consider shallow clones (`--depth 1`)

---

## 5. Backup Strategy

### Current State (already operational)

| Parameter | Value |
|-----------|-------|
| What | Full PostgreSQL SQL dump (`pg_dump`) |
| Frequency | Hourly |
| Location | `~/.paperclip/instances/default/data/backups/` |
| Format | Plain SQL (`paperclip-YYYYMMDD-HHMMSS.sql`) |
| Current size | ~1.4 MB per backup, ~23 MB total |
| Health check | `backup-status.json` verified at 2026-03-29T08:10 -- PASSED |
| Retention policy | 30 days, max 2-hour staleness, min 100 KB |

### What Is Backed Up
- All 59 PostgreSQL tables (full schema + data)
- Tracked in `backup-growth.csv` for trend analysis

### What Is NOT Backed Up (and should be)
| Data | Risk | Recommendation |
|------|------|----------------|
| Run log files | Medium -- recreatable but useful for debugging | Include in weekly archive (handled by cleanup script) |
| Agent workspace files | Low -- code is in git repos | Rely on git; no separate backup needed |
| Asset blob storage | High if used | When `storage/` has content, add to backup rotation |
| `.paperclip/instances/default/` config | Medium | Snapshot monthly to external location |

### Offsite Backup (recommended, not yet implemented)
- Copy weekly SQL dump to external storage (S3, Google Drive, or Tailscale-connected NAS)
- Encrypt with `gpg` before upload
- Retain offsite backups for 180 days

---

## 6. Data Classification

### Sensitive (requires encryption at rest + access control)
| Data | Location | Notes |
|------|----------|-------|
| `company_secrets` / `company_secret_versions` | PostgreSQL | API keys, tokens, credentials |
| `agent_api_keys.key_hash` | PostgreSQL | Hashed, but table access should be restricted |
| `auth_users` (email, PII) | PostgreSQL | User identity data |
| `auth_sessions` / `auth_accounts` | PostgreSQL | Session tokens, OAuth data |
| `cli_auth_challenges` | PostgreSQL | Temporary auth codes |
| SQL backup files | `~/.paperclip/.../backups/` | Contain all of the above in plaintext SQL |

### Internal (standard access controls)
| Data | Location |
|------|----------|
| All project/issue/goal data | PostgreSQL |
| Agent configurations and budgets | PostgreSQL |
| Cost tracking and finance events | PostgreSQL |
| Activity logs and audit trail | PostgreSQL |
| Run logs | `run-logs/` directory |
| Plugin state and configuration | PostgreSQL |

### Public (no special handling)
| Data | Location |
|------|----------|
| Plugin manifests (from public npm) | PostgreSQL `plugins.manifest_json` |
| Company names (non-confidential) | PostgreSQL |

---

## 7. Database Maintenance Recommendations

### Indexes to Monitor
The schema includes 30+ indexes. Key ones for query performance:
- `issues_company_status_idx` -- most-queried table
- `cost_events_company_agent_occurred_idx` -- budget dashboards
- `activity_log_company_created_idx` -- audit queries
- `heartbeat_runs_company_agent_started_idx` -- run history

### Table Growth Projections
| Table | Growth driver | Estimated monthly rows |
|-------|--------------|----------------------|
| `activity_log` | Every agent action | 10K-100K depending on agent count |
| `cost_events` | Every LLM call | 5K-50K |
| `heartbeat_runs` + `heartbeat_run_events` | Every agent execution | 1K-10K |
| `issue_comments` | Agent collaboration | 500-5K |
| `routine_runs` | Cron frequency x routine count | Varies |

### Recommended Actions
1. **Now:** Run `VACUUM ANALYZE` monthly on high-write tables
2. **At 100K rows:** Add partitioning to `activity_log` and `cost_events` by month
3. **At 1M rows:** Consider archiving old `heartbeat_runs` to cold storage

---

## 8. Cleanup Script Usage

### Location
```
AI-Native-Org/scripts/cleanup-agent-data.sh
```

### Commands

**Dry-run report (default, safe -- changes nothing):**
```bash
./scripts/cleanup-agent-data.sh
```

**Report workspace sizes only:**
```bash
./scripts/cleanup-agent-data.sh --report
```

**Archive old logs (moves logs older than 30 days to archive):**
```bash
./scripts/cleanup-agent-data.sh --archive
```

**Archive with custom retention (e.g., 14 days):**
```bash
./scripts/cleanup-agent-data.sh --archive --days 14
```

### Recommended Cron Schedule
```bash
# Weekly report + archive (Sundays at 3 AM)
0 3 * * 0 /path/to/AI-Native-Org/scripts/cleanup-agent-data.sh --archive >> /tmp/paperclip-cleanup.log 2>&1
```

---

## 9. Revision History

| Date | Change | Author |
|------|--------|--------|
| 2026-03-29 | Initial creation: schema documentation, governance policies, cleanup script | Mamoun Alamouri |
