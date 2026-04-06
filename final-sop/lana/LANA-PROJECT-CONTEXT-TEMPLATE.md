# Project Context: [PROJECT NAME]

> Fill this template when onboarding to a new project. Place the completed file in the project root as `CLAUDE.md` or in `docs/project-context.md`.
> This gives Claude Code the context it needs to assist you effectively.

---

## What This Project Does

**One-liner**: [What does this project do in one sentence?]

**Business context**: [Which SMOrchestra.ai business line does it serve? Who are the end users?]

**Current status**: [Active development / Maintenance / Pre-launch / Deprecated]

**Key URLs**:
- Repo: https://github.com/SMOrchestra-ai/[repo-name]
- Staging: [URL if applicable]
- Production: [URL if applicable]
- Linear project: [URL]

---

## Architecture (Current)

**Stack**:
- Frontend: [e.g., Next.js 14, React, Tailwind]
- Backend: [e.g., Node.js, Express, Supabase Edge Functions]
- Database: [e.g., Supabase PostgreSQL, Redis]
- Infrastructure: [e.g., Vercel, Contabo VPS, Docker]
- CI/CD: [e.g., GitHub Actions]

**Key directories**:
```
/src
  /api          -- [what lives here]
  /components   -- [what lives here]
  /lib          -- [what lives here]
  /services     -- [what lives here]
/tests          -- [test structure]
/scripts        -- [deployment, migration scripts]
```

**Data flow** (describe or paste a Mermaid diagram):
```
[Input source] --> [Processing layer] --> [Storage] --> [Output/API]
```

---

## Critical Constraints

List anything that MUST NOT be changed or has hard dependencies:

- [ ] [e.g., Supabase schema is shared with SalesMfast SME -- do not modify shared tables]
- [ ] [e.g., Webhook endpoint must stay at /api/webhooks/signal -- external systems depend on it]
- [ ] [e.g., Node version pinned to 18.x -- server compatibility]
- [ ] [e.g., Environment variables are managed by Mamoun -- never hardcode]

---

## Known Technical Debt

| Item | Severity | Ticket | Notes |
|------|----------|--------|-------|
| [e.g., No error handling on signal ingestion] | High | SSE-XXX | [context] |
| [e.g., Tests only cover 30% of scoring logic] | Medium | SSE-XXX | [context] |
| [e.g., Legacy endpoint still serves v1 clients] | Low | -- | [context] |

---

## Recent ADRs (Architecture Decision Records)

| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| [YYYY-MM-DD] | [e.g., Switched from REST to tRPC] | [why] | [what changed] |
| [YYYY-MM-DD] | [e.g., Added Redis for signal caching] | [why] | [what changed] |

> If the project has an `docs/adr/` directory, reference those files instead of duplicating.

---

## Integration Map

List all external systems this project connects to:

| System | Direction | Protocol | Auth | Notes |
|--------|-----------|----------|------|-------|
| [e.g., Linear] | Outbound | REST API | Bearer token | Bug tracking |
| [e.g., n8n] | Inbound | Webhook | HMAC | Signal processing triggers |
| [e.g., Supabase] | Both | SDK | Service key | Primary database |
| [e.g., Instantly.ai] | Outbound | REST API | API key | Campaign triggers |

---

## Escalation Triggers

Situations where Lana must immediately notify Mamoun via Telegram:

- [ ] Production is down or returning 5xx errors
- [ ] Security vulnerability found (Critical severity)
- [ ] Data loss or corruption detected
- [ ] External integration breaks (webhook failures, API auth expired)
- [ ] Quality gate scores drop below 6/10 on any dimension
- [ ] A PR has been blocked for >48 hours with no response

---

## How to Fill This Template

1. **Start with the repo README** -- most answers to "What This Project Does" are there
2. **Check package.json / requirements.txt** -- tells you the stack
3. **Run `ls -la` in the root** -- shows directory structure
4. **Check `.env.example`** -- shows what integrations exist
5. **Read the most recent 10 commits** -- `git log --oneline -10` shows what's active
6. **Search for TODO/FIXME** -- `grep -r "TODO\|FIXME" src/` reveals known debt
7. **Check the Linear project** -- open tickets show current priorities and known issues
8. **Ask Claude Code**: run `claude` in the repo and ask "Summarize this project's architecture"

> Time estimate: 30-45 minutes per project for initial fill. Update monthly or after major changes.
