-- AI-Native Organization — SQLite Queue Schema
-- Deploy to: smo-brain at /root/.smo/queue/queue.db
-- Source: openclaw-queue-integration-plan.md + extensions
-- Date: 2026-03-30

-- ═══════════════════════════════════════════════════════
-- BRD TABLE (Sprint 1, Fix #2 — BRD traceability)
-- ═══════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS brds (
  id TEXT PRIMARY KEY,                    -- BRD-001, BRD-002, etc.
  title TEXT NOT NULL,
  source TEXT DEFAULT 'telegram',         -- telegram, paperclip, manual
  raw_text TEXT,                          -- Original BRD text as submitted
  task_count INTEGER DEFAULT 0,           -- How many tasks were decomposed from this BRD
  status TEXT DEFAULT 'decomposing',      -- decomposing, pending_approval, approved, in_progress, completed, failed
  submitted_by TEXT DEFAULT 'mamoun',
  created_at TEXT DEFAULT (datetime('now')),
  completed_at TEXT
);

-- ═══════════════════════════════════════════════════════
-- CORE TABLES (from openclaw-queue-integration-plan.md)
-- ═══════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS tasks (
  id TEXT PRIMARY KEY,                    -- TASK-001, TASK-002, etc.
  brd_id TEXT,                            -- FK to brds table (Sprint 1, Fix #2)
  title TEXT NOT NULL,
  description TEXT,
  repo TEXT NOT NULL,                     -- e.g., "SMOrchestra-ai/eo-assessment-system"
  goal TEXT NOT NULL,                     -- What the agent must accomplish
  declared_files TEXT,                    -- JSON array of files agent will touch
  hard_constraints TEXT,                  -- JSON array of constraints
  tests_required TEXT,                    -- JSON array of test commands
  blocked_by TEXT,                        -- Comma-separated task IDs
  server_node TEXT DEFAULT 'smo-dev',     -- smo-brain, smo-dev, desktop
  role TEXT,                              -- vp_engineering, qa_lead, gtm, content, devops, data_eng
  tier TEXT DEFAULT 'staged_hybrid',      -- fast_track, staged_hybrid, agent_team, forbidden
  complexity_score INTEGER DEFAULT 0,     -- 0-30 from classify-task.sh
  branch TEXT,                            -- agent/TASK-XXX-slug
  pr_url TEXT,
  pr_number INTEGER,
  status TEXT DEFAULT 'pending_approval', -- pending_approval, queued, active, ci_pending,
                                         -- ci_passed, ci_failed, scoring, needs_human_debug,
                                         -- pr_open, merged, killed, failed
  risk_tier TEXT DEFAULT 'MEDIUM',        -- HIGH, MEDIUM, LOW
  retry_count INTEGER DEFAULT 0,
  max_retries INTEGER DEFAULT 2,
  scoring_attempts INTEGER DEFAULT 0,
  last_score REAL,
  scorer_feedback TEXT,
  session_pid INTEGER,
  session_started_at TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  updated_at TEXT DEFAULT (datetime('now')),
  completed_at TEXT,
  created_by TEXT DEFAULT 'openclaw'      -- openclaw, telegram, manual
);

CREATE TABLE IF NOT EXISTS file_locks (
  file_path TEXT NOT NULL,
  task_id TEXT NOT NULL,
  repo TEXT NOT NULL,
  locked_at TEXT DEFAULT (datetime('now')),
  PRIMARY KEY (file_path, repo),
  FOREIGN KEY (task_id) REFERENCES tasks(id)
);

CREATE TABLE IF NOT EXISTS audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id TEXT,
  event TEXT NOT NULL,        -- created, queued, dispatched, ci_pass, ci_fail, scored, merged, killed, etc.
  details TEXT,               -- JSON with context
  node TEXT,
  timestamp TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (task_id) REFERENCES tasks(id)
);

-- ═══════════════════════════════════════════════════════
-- SKILLS TABLES (from skills injection strategy)
-- ═══════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS role_skills (
  role TEXT NOT NULL,              -- vp_engineering, qa_lead, gtm, content, devops, data_eng
  skill_name TEXT NOT NULL,
  mandatory BOOLEAN DEFAULT 1,
  quality_gate TEXT,               -- which scorer validates this role's output
  pass_threshold REAL DEFAULT 8.0,
  PRIMARY KEY (role, skill_name)
);

CREATE TABLE IF NOT EXISTS skill_versions (
  node TEXT NOT NULL,              -- smo-brain, smo-dev, desktop
  skill_name TEXT NOT NULL,
  hash TEXT NOT NULL,              -- md5 of skill directory contents
  synced_at TEXT DEFAULT (datetime('now')),
  PRIMARY KEY (node, skill_name)
);

-- ═══════════════════════════════════════════════════════
-- ARTIFACTS TABLE (for inter-agent handoffs)
-- ═══════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS task_artifacts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id TEXT NOT NULL,
  artifact_type TEXT NOT NULL,     -- spec_json, report_json, approval_json, file_created, file_modified
  file_path TEXT,
  summary TEXT,
  content TEXT,                    -- Optional: artifact content for small artifacts
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (task_id) REFERENCES tasks(id)
);

-- ═══════════════════════════════════════════════════════
-- ACCOUNT TABLES (for multi-node cost control)
-- ═══════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS accounts (
  id TEXT PRIMARY KEY,             -- "A", "B", etc.
  name TEXT,                       -- "Mamoun Max", "smo-dev Max"
  monthly_cap_cents INTEGER DEFAULT 20000,
  auth_type TEXT DEFAULT 'oauth',
  active BOOLEAN DEFAULT 1
);

CREATE TABLE IF NOT EXISTS node_accounts (
  node TEXT PRIMARY KEY,           -- smo-brain, smo-dev, desktop
  account_id TEXT NOT NULL,
  max_concurrent INTEGER DEFAULT 3,
  priority INTEGER DEFAULT 5,      -- lower = higher priority on shared accounts
  FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- ═══════════════════════════════════════════════════════
-- DEAD LETTER QUEUE (Sprint 1, Fix #6 — permanently failed tasks)
-- ═══════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS dead_letters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_id TEXT NOT NULL,
  brd_id TEXT,
  original_status TEXT,               -- status before moving to dead letter
  failure_reason TEXT,                -- why it ended up here
  retry_count INTEGER DEFAULT 0,      -- how many retries were attempted
  last_error TEXT,                    -- last error message/exit code
  alerted BOOLEAN DEFAULT 0,          -- whether CEO was notified
  resolved BOOLEAN DEFAULT 0,         -- manually resolved
  resolved_at TEXT,
  resolved_by TEXT,
  created_at TEXT DEFAULT (datetime('now')),
  FOREIGN KEY (task_id) REFERENCES tasks(id)
);

-- ═══════════════════════════════════════════════════════
-- INDEXES
-- ═══════════════════════════════════════════════════════

CREATE INDEX IF NOT EXISTS idx_tasks_brd ON tasks(brd_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_role ON tasks(role);
CREATE INDEX IF NOT EXISTS idx_tasks_server ON tasks(server_node);
CREATE INDEX IF NOT EXISTS idx_tasks_created ON tasks(created_at);
CREATE INDEX IF NOT EXISTS idx_audit_task ON audit_log(task_id);
CREATE INDEX IF NOT EXISTS idx_audit_event ON audit_log(event);
CREATE INDEX IF NOT EXISTS idx_artifacts_task ON task_artifacts(task_id);
CREATE INDEX IF NOT EXISTS idx_dead_letters_task ON dead_letters(task_id);
CREATE INDEX IF NOT EXISTS idx_dead_letters_resolved ON dead_letters(resolved);

-- ═══════════════════════════════════════════════════════
-- SEED DATA: Accounts
-- ═══════════════════════════════════════════════════════

INSERT OR IGNORE INTO accounts (id, name, monthly_cap_cents, auth_type) VALUES
  ('A', 'Mamoun Max (shared)', 20000, 'oauth'),
  ('B', 'smo-dev Max', 20000, 'oauth');

INSERT OR IGNORE INTO node_accounts (node, account_id, max_concurrent, priority) VALUES
  ('smo-brain', 'A', 3, 1),    -- highest priority on Account A
  ('desktop',   'A', 2, 5),    -- lower priority on Account A (shared)
  ('smo-dev',   'B', 3, 1);    -- own account

-- ═══════════════════════════════════════════════════════
-- SEED DATA: Role Skills (from skill-router-matrix.md)
-- ═══════════════════════════════════════════════════════

-- VP Engineering
INSERT OR IGNORE INTO role_skills (role, skill_name, mandatory, quality_gate, pass_threshold) VALUES
  ('vp_engineering', 'test-driven-development', 1, 'engineering-scorer', 8.0),
  ('vp_engineering', 'writing-plans', 1, 'engineering-scorer', 8.0),
  ('vp_engineering', 'subagent-driven-development', 1, 'engineering-scorer', 8.0),
  ('vp_engineering', 'brainstorming', 1, 'engineering-scorer', 8.0),
  ('vp_engineering', 'executing-plans', 1, 'engineering-scorer', 8.0),
  ('vp_engineering', 'systematic-debugging', 1, 'engineering-scorer', 8.0),
  ('vp_engineering', 'verification-before-completion', 1, 'engineering-scorer', 8.0),
  ('vp_engineering', 'eo-microsaas-dev', 0, 'engineering-scorer', 8.0),
  ('vp_engineering', 'eo-tech-architect', 0, 'architecture-scorer', 8.0),
  ('vp_engineering', 'eo-db-architect', 0, 'architecture-scorer', 8.0),
  ('vp_engineering', 'mcp-builder', 0, 'engineering-scorer', 8.0),
  ('vp_engineering', 'n8n-architect', 0, 'engineering-scorer', 8.0);

-- QA Lead
INSERT OR IGNORE INTO role_skills (role, skill_name, mandatory, quality_gate, pass_threshold) VALUES
  ('qa_lead', 'qa', 1, 'qa-scorer', 8.0),
  ('qa_lead', 'qa-only', 0, 'qa-scorer', 8.0),
  ('qa_lead', 'benchmark', 1, 'qa-scorer', 8.0),
  ('qa_lead', 'review', 1, 'qa-scorer', 8.0),
  ('qa_lead', 'careful', 1, 'qa-scorer', 8.0),
  ('qa_lead', 'canary', 0, 'qa-scorer', 8.0),
  ('qa_lead', 'eo-qa-testing', 0, 'qa-scorer', 8.0),
  ('qa_lead', 'eo-security-hardener', 1, 'qa-scorer', 8.0),
  ('qa_lead', 'composite-scorer', 1, 'qa-scorer', 8.0),
  ('qa_lead', 'gap-bridger', 0, 'qa-scorer', 8.0);

-- GTM Specialist
INSERT OR IGNORE INTO role_skills (role, skill_name, mandatory, quality_gate, pass_threshold) VALUES
  ('gtm', 'signal-detector', 1, 'campaign-strategy-scorer', 8.0),
  ('gtm', 'signal-to-trust-gtm', 1, 'campaign-strategy-scorer', 8.0),
  ('gtm', 'wedge-generator', 1, 'campaign-strategy-scorer', 8.0),
  ('gtm', 'asset-factory', 1, 'copywriting-scorer', 8.0),
  ('gtm', 'outbound-orchestrator', 1, 'campaign-strategy-scorer', 8.0),
  ('gtm', 'positioning-engine', 0, 'offer-positioning-scorer', 8.0),
  ('gtm', 'lead-research-assistant', 0, 'campaign-strategy-scorer', 8.0),
  ('gtm', 'scraper-layer', 0, 'campaign-strategy-scorer', 8.0);

-- Content Lead
INSERT OR IGNORE INTO role_skills (role, skill_name, mandatory, quality_gate, pass_threshold) VALUES
  ('content', 'asset-factory', 1, 'copywriting-scorer', 8.0),
  ('content', 'eo-youtube-mamoun', 0, 'youtube-scorer', 8.0),
  ('content', 'linkedin-ar-creator', 0, 'linkedin-branding-scorer', 8.0),
  ('content', 'linkedin-en-gtm', 0, 'linkedin-branding-scorer', 8.0),
  ('content', 'content-systems', 0, 'social-media-scorer', 8.0),
  ('content', 'frontend-design', 0, 'copywriting-scorer', 8.0),
  ('content', 'web-artifacts-builder', 0, 'copywriting-scorer', 8.0);

-- DevOps
INSERT OR IGNORE INTO role_skills (role, skill_name, mandatory, quality_gate, pass_threshold) VALUES
  ('devops', 'eo-deploy-infra', 1, 'architecture-scorer', 8.0),
  ('devops', 'setup-deploy', 1, 'architecture-scorer', 8.0),
  ('devops', 'land-and-deploy', 1, 'architecture-scorer', 8.0),
  ('devops', 'canary', 0, 'architecture-scorer', 8.0),
  ('devops', 'benchmark', 0, 'architecture-scorer', 8.0),
  ('devops', 'eo-security-hardener', 1, 'architecture-scorer', 8.0);

-- Data Engineer
INSERT OR IGNORE INTO role_skills (role, skill_name, mandatory, quality_gate, pass_threshold) VALUES
  ('data_eng', 'scraper-layer', 1, 'product-scorer', 8.0),
  ('data_eng', 'clay-operator', 0, 'product-scorer', 8.0),
  ('data_eng', 'lead-research-assistant', 0, 'product-scorer', 8.0),
  ('data_eng', 'signal-detector', 0, 'product-scorer', 8.0),
  ('data_eng', 'eo-db-architect', 0, 'product-scorer', 8.0),
  ('data_eng', 'n8n-architect', 0, 'product-scorer', 8.0);

-- ═══════════════════════════════════════════════════════
-- VIEWS (for quick queries)
-- ═══════════════════════════════════════════════════════

CREATE VIEW IF NOT EXISTS v_active_tasks AS
SELECT t.id, t.title, t.status, t.server_node, t.role, t.tier,
       t.session_started_at,
       ROUND((julianday('now') - julianday(t.session_started_at)) * 24 * 60, 1) as minutes_elapsed
FROM tasks t
WHERE t.status = 'active';

CREATE VIEW IF NOT EXISTS v_queue_summary AS
SELECT status, COUNT(*) as count
FROM tasks
GROUP BY status
ORDER BY
  CASE status
    WHEN 'active' THEN 1
    WHEN 'queued' THEN 2
    WHEN 'ci_pending' THEN 3
    WHEN 'scoring' THEN 4
    WHEN 'pr_open' THEN 5
    WHEN 'pending_approval' THEN 6
    WHEN 'merged' THEN 7
    WHEN 'killed' THEN 8
    WHEN 'failed' THEN 9
  END;

CREATE VIEW IF NOT EXISTS v_brd_progress AS
SELECT b.id, b.title, b.status as brd_status, b.task_count,
       COUNT(CASE WHEN t.status = 'merged' THEN 1 END) as tasks_merged,
       COUNT(CASE WHEN t.status = 'active' THEN 1 END) as tasks_active,
       COUNT(CASE WHEN t.status IN ('failed', 'killed') THEN 1 END) as tasks_failed,
       ROUND(COUNT(CASE WHEN t.status = 'merged' THEN 1 END) * 100.0 / NULLIF(b.task_count, 0), 1) as progress_pct
FROM brds b
LEFT JOIN tasks t ON t.brd_id = b.id
GROUP BY b.id;

CREATE VIEW IF NOT EXISTS v_account_usage AS
SELECT
  na.account_id,
  a.name as account_name,
  na.node,
  na.max_concurrent,
  COUNT(CASE WHEN t.status = 'active' THEN 1 END) as active_count,
  na.max_concurrent - COUNT(CASE WHEN t.status = 'active' THEN 1 END) as available_slots
FROM node_accounts na
JOIN accounts a ON na.account_id = a.id
LEFT JOIN tasks t ON t.server_node = na.node AND t.status = 'active'
GROUP BY na.node;

-- ═══════════════════════════════════════════════════════
-- Done. Verify: SELECT name FROM sqlite_master WHERE type='table';
-- ═══════════════════════════════════════════════════════
