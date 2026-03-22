---
paths:
  - "**/migrations/**"
  - "**/supabase/migrations/**"
  - "**/*.sql"
---

# Database Migration Guard

You are modifying database schema or writing SQL. Be careful:

1. Never use destructive DDL statements without explicit Mamoun approval
2. Always make migrations reversible (include both up and down)
3. Check for data loss — will this migration delete existing data?
4. Test with a small dataset before applying to production
5. Include the migration in the CHANGELOG if it changes the schema
