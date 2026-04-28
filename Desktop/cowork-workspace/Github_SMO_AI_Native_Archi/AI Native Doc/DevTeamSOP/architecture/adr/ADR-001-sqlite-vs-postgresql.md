# ADR-001: SQLite over PostgreSQL for Queue Engine

**Date:** 2026-03-30
**Status:** ACCEPTED (migrate to PostgreSQL when ceiling is hit)
**Decision Maker:** Mamoun Alamouri
**Context:** AI-Native Development Organization — Queue Engine database selection

---

## Context

The AI-Native Org queue engine needs a persistent database for task management, file locking, audit logging, and cost control. Two options were evaluated:

- **SQLite** — file-based, zero-config, already available on all nodes
- **PostgreSQL** — running on smo-brain and all servers, full RDBMS

## Decision

**Use SQLite (WAL mode) as the queue database for Phase 1.**

Migrate to PostgreSQL when the system hits SQLite's architectural ceiling (estimated: >50 concurrent tasks or multi-writer requirements).

## Rationale

### Why SQLite now

| Factor | SQLite | PostgreSQL |
|--------|--------|------------|
| Setup time | 0 (already available) | ~2h (schema, roles, connection strings) |
| Deployment | Single file (`queue.db`), rsync backup | Service dependency, pg_dump, migrations |
| n8n integration | `better-sqlite3` npm, mounted as volume | Requires pg connection string, credential management |
| Shell script access | `sqlite3` CLI, zero dependencies | `psql` CLI, needs auth config |
| Debugging | Open DB with any SQLite viewer | Need psql/pgAdmin access |
| Backup | `cp queue.db queue.db.bak` | `pg_dump`, cron job, retention policy |
| Concurrent reads | Unlimited (WAL mode) | Unlimited |
| Concurrent writes | Single-writer (WAL mode serializes) | Multi-writer, row-level locking |
| Latency | ~0.1ms (local file) | ~1-5ms (TCP, even localhost) |
| Memory | ~2MB | ~50-100MB base |

### Why PostgreSQL later

SQLite will hit ceilings at scale:

| Ceiling | When It Hits | Impact |
|---------|-------------|--------|
| Single-writer bottleneck | >50 concurrent tasks, multiple dispatchers | Write contention, WAL file growth |
| No remote access | Need queue access from smo-dev or desktop | Can't query from non-smo-brain nodes |
| No pub/sub | Need real-time notifications (LISTEN/NOTIFY) | Polling required instead of push |
| No row-level locking | Multi-node dispatchers writing simultaneously | Race conditions on file_locks |
| No JSON operators | Complex queries on `declared_files`, `hard_constraints` | Parse in shell instead of SQL |

### Current scale (SQLite is fine)

- Tasks per day: 15-30
- Concurrent active: 6 max (2 OAuth accounts × 3 slots)
- Total tasks in DB: <100
- Single dispatcher (n8n cron on smo-brain)
- Single writer node (all writes from smo-brain)
- DB size: <1MB

### Migration trigger (move to PostgreSQL when ANY of these hit)

1. Queue has >500 total tasks and queries slow down
2. Need multi-node dispatchers (smo-dev dispatching independently)
3. Need real-time push notifications (LISTEN/NOTIFY replaces polling)
4. Need remote queue access from desktop/smo-dev without SSH tunneling
5. Write contention causes SQLITE_BUSY errors in production

### Migration path

PostgreSQL is already running on all servers. Migration is straightforward:

1. Create schema in PostgreSQL (direct translation, add `jsonb` for JSON columns)
2. `sqlite3 queue.db .dump | sed 's/AUTOINCREMENT/GENERATED ALWAYS AS IDENTITY/' | psql`
3. Update shell scripts: `sqlite3` → `psql -t -A -c`
4. Update n8n: `better-sqlite3` → `pg` node
5. Add connection pooling (pgBouncer or built-in)
6. Enable LISTEN/NOTIFY for real-time dispatch

Estimated migration effort: 4-6 hours.

## Consequences

### Positive
- Zero setup overhead — queue engine was operational in hours, not days
- Entire DB is a single file — trivial to backup, inspect, debug
- No service dependency — if PostgreSQL crashes, queue still works
- Shell scripts stay simple (`sqlite3` CLI is fast and reliable)

### Negative
- Single-writer limits future multi-node dispatching
- No remote query access (must SSH to smo-brain)
- Polling for notifications (2min cron) instead of push
- JSON columns stored as TEXT, not queryable with SQL operators

### Neutral
- PostgreSQL upgrade path is clear and low-risk
- Both databases support the same schema design
- No data loss risk during migration (dump + restore)

---

**Reviewed by:** Claude (Architecture Scorer)
**Score:** Correct decision for current scale. Revisit at 500 tasks or multi-dispatcher requirement.
