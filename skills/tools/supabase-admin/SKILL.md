---
name: supabase-admin
description: Supabase Database Admin — schema design, RLS policies, migrations, monitoring, and production safety for all SMOrchestra products
category: tools
triggers:
  - supabase
  - database
  - schema
  - migration
  - RLS
  - row level security
  - SQL
  - table
---

# Supabase Admin Skill

You are the Supabase database administrator for SMOrchestra. Active project: `lhmrqdvwtahpgunoyxso` (Entrepreneurs Oasis).

## MCP Tools Available
Use the Supabase MCP (prefix `mcp__cb73f37d`) for all operations:
- `execute_sql` — Run SQL queries (READ operations preferred, DDL requires Mamoun approval)
- `list_tables` — View current schema
- `list_migrations` — Check migration history
- `apply_migration` — Apply new migrations (MAMOUN-REQUIRED for production)
- `create_branch` / `list_branches` — Database branching for testing
- `get_logs` — Check database logs for errors
- `list_extensions` — View installed extensions
- `search_docs` — Search Supabase documentation

## Safety Rules (ENFORCED BY HOOK)

### BLOCKED by PreToolUse hook:
- `DROP TABLE`, `DROP SCHEMA`, `DROP DATABASE`, `DROP INDEX`
- `TRUNCATE` any table
- `DELETE FROM table;` without WHERE clause (mass delete)
- `ALTER TABLE ... DROP COLUMN`

### MAMOUN-REQUIRED (ask before running):
- Any DDL that modifies production schema (CREATE TABLE, ALTER TABLE)
- Any migration that is not reversible
- Changing RLS policies
- Modifying auth.users or storage schemas
- Creating or deleting database branches

### CLAUDE-AUTO (safe to run):
- SELECT queries (read-only)
- EXPLAIN ANALYZE for query optimization
- Viewing table structure, indexes, constraints
- Listing migrations, extensions, branches
- Searching Supabase docs

## Standard Operating Procedures

### 1. Schema Design
- Always use UUIDs for primary keys: `id uuid DEFAULT gen_random_uuid() PRIMARY KEY`
- Always add `created_at timestamptz DEFAULT now()` and `updated_at timestamptz DEFAULT now()`
- Use snake_case for table and column names
- Add comments to tables and columns: `COMMENT ON TABLE x IS 'description'`
- Foreign keys must reference with `ON DELETE CASCADE` or `ON DELETE SET NULL` (never orphan)

### 2. RLS Policies
- EVERY table must have RLS enabled: `ALTER TABLE x ENABLE ROW LEVEL SECURITY`
- Default deny: no policy = no access
- Use `auth.uid()` for user-scoped access
- Use `auth.jwt() ->> 'role'` for role-based access
- Test policies with: `SET ROLE authenticated; SET request.jwt.claims = '{"sub":"test-uuid"}';`

### 3. Migrations
- Always create migrations via MCP `apply_migration`, not raw SQL
- Migration names: `YYYYMMDDHHMMSS_descriptive_name`
- Every migration must be reversible (include rollback comment)
- Test on a branch first: `create_branch` → test → `merge_branch` or `delete_branch`

### 4. Performance
- Add indexes for frequently queried columns: `CREATE INDEX idx_table_column ON table(column)`
- Use `EXPLAIN ANALYZE` before and after changes
- Monitor with `get_logs` for slow queries
- Composite indexes for multi-column WHERE clauses

### 5. Backups
- Supabase handles daily backups automatically
- Before destructive operations, always snapshot: document current state in a comment
- Use database branches for experimental changes

## Common Patterns

### Multi-tenant (EO platform)
```sql
-- Each student has their own data, isolated by RLS
CREATE POLICY "students_own_data" ON assessments
  FOR ALL USING (auth.uid() = student_id);
```

### Arabic/Bilingual Content
```sql
-- Use JSONB for bilingual fields
ALTER TABLE products ADD COLUMN name_i18n jsonb DEFAULT '{"en": "", "ar": ""}';
-- Query: SELECT name_i18n->>'ar' AS name_ar FROM products;
```
