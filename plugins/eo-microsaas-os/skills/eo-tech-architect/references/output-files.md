# Output Files - eo-tech-architect

Specification templates for tech-stack-decision.md, architecture-diagram.md, and brd.md.

## OUTPUT FILES

The skill produces 4 documents in `project-root/architecture/` plus 1 root-level CLAUDE.md:

### File 1: tech-stack-decision.md

Decision log format with explicit tradeoffs for every component choice.

```markdown
# Tech Stack Decision Log - [Venture Name]

## Decision Summary
[One paragraph: what stack was chosen and why]

## Application Stack

### Frontend: [Choice]
- **Selected:** [Technology]
- **Alternatives Evaluated:** [List with 1-line reason for rejection]
- **Rationale:** [2-3 sentences grounded in student's specific needs]
- **Cost:** [Monthly/annual]
- **Risk:** [Primary risk and mitigation]

### Backend: [Choice]
[Same format]

### Database: [Choice]
[Same format]

### Auth: [Choice]
[Same format]

### Hosting: [Choice]
[Same format]

### Payments: [Choice]
[Same format]

## Agentic / AI Stack
[Only if applicable. Same decision format per technology.]

## Infrastructure Stack
[Same decision format per component.]

## Monthly Cost Projection
| Component | Monthly Cost | Annual Cost | Scale Trigger |
|-----------|-------------|-------------|---------------|
[Full table]

## Risk Assessment
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|-----------|
[Top 5 technical risks]
```

### File 2: architecture-diagram.md

System architecture in Mermaid format with explanatory notes.

```markdown
# Architecture Diagram - [Venture Name]

## System Overview
[Mermaid diagram: services, data flows, external integrations]

## Deployment Topology
[Mermaid diagram: VPS, containers, domains, CDN]

## Data Flow
[Mermaid diagram: user request → frontend → API → DB → response]

## Integration Map
[Mermaid diagram: product ↔ external services with data direction arrows]

## Notes
- [Explanation of key architectural decisions visible in diagrams]
- [Scalability path: what changes when traffic 10x]
- [Security boundaries: what's public, what's behind auth]
```

### File 3: brd.md

Business Requirements Document: the primary input for all Step 5 development skills.

```markdown
# Business Requirements Document - [Venture Name]

## 1. Product Overview
[From companyprofile.md: what the product does, who it serves]

## 2. User Stories
[Derived from icp.md: minimum 10 user stories in standard format]
As a [persona], I want to [action], so that [outcome].

### MVP User Stories (Must Ship)
[5-8 stories that define the minimum viable product]

### Launch User Stories (Ship by Public Launch)
[3-5 stories needed for a credible public launch]

### Post-Traction User Stories (Build After PMF)
[5+ stories for after the first 20 paying customers]

## 3. Functional Requirements
[Organized by feature area. Each requirement has:]
- ID: FR-001
- Description: [What the system must do]
- Priority: MVP / LAUNCH / POST-TRACTION
- Acceptance Criteria: [Testable conditions]
- Dependencies: [Other requirements or integrations needed]

## 4. Non-Functional Requirements
- Performance: [Response times, concurrent users]
- Security: [Auth, data protection, HTTPS]
- i18n: [Arabic RTL, language switching, content translation]
- Accessibility: [WCAG level, Arabic screen reader support]
- Scalability: [Traffic expectations, data growth]

## 5. Technical Constraints
[From founderprofile.md and market-analysis.md]
- Budget: [Monthly infrastructure budget]
- Team: [Solo founder / small team capabilities]
- Timeline: [90-day roadmap from strategy.md]
- Market: [MENA-specific constraints]

## 6. MVP Scope Definition
[Explicit boundary: what is IN the MVP and what is OUT]

### In Scope
[Bulleted list with rationale]

### Out of Scope (Deferred)
[Bulleted list with when to revisit]

## 7. Success Metrics
[From strategy.md: what metrics prove the MVP works]
- Revenue: [Target MRR by Month 3]
- Users: [Target active users]
- Engagement: [Key product metrics]
```

### File 4: mcp-integration-plan.md

Which MCPs and third-party services the product should support.

```markdown
# MCP Integration Plan - [Venture Name]

## Integration Overview
[Which external services the product connects to and why]

## MVP-Critical Integrations
| Service | Purpose | API Type | Priority |
|---------|---------|----------|----------|
[Table of must-have integrations]

## Launch-Day Integrations
[Same format, lower priority]

## Post-Traction Integrations
[Same format, deferred]

## MCP Server Candidates
[If the student's product could benefit from Claude MCP integration:]
- Which data/services could be exposed via MCP
- Estimated build effort
- Priority relative to core product

## Implementation Notes
[Per integration: auth method, rate limits, MENA-specific gotchas, webhook requirements]
```

### File 5: CLAUDE.md (Root Level)

This file goes at the PROJECT ROOT (not in architecture/). Claude Code reads it automatically on startup. It is the single source of truth that eliminates cold-start friction.

```markdown
# CLAUDE.md - [Venture Name] MicroSaaS

## What This Project Is
[1-2 sentences from companyprofile.md: what the product does and who it serves]

## Tech Stack
[Compact summary from tech-stack-decision.md]
- Frontend: [choice]
- Backend: [choice]
- Database: [choice]
- Auth: [choice]
- Hosting: [choice]
- Payments: [choice]
- AI: [if applicable]

## Project Structure
```
project-brain/        # Business context (12 files) - READ these for product context
architecture/         # BRD, stack decisions, diagrams - READ brd.md for requirements
src/                  # Application code (created during Step 5b)
```

## Key Context Files
- `project-brain/icp.md` - Who the users are, their pains, their language
- `project-brain/positioning.md` - How this product is positioned, the wedge
- `architecture/brd.md` - Full requirements, user stories, MVP scope
- `architecture/tech-stack-decision.md` - Why each technology was chosen

## Build Instructions
This project uses the EO MicroSaaS OS plugin. The build follows this sequence:
1. eo-db-architect - Database schema, migrations, RLS policies
2. eo-microsaas-dev - Application code (5-phase build pipeline)
3. eo-api-connector - Third-party integrations
4. eo-qa-testing - Code quality + functional + UX testing
5. eo-security-hardener - 7-domain security audit
6. eo-deploy-infra - Docker, CI/CD, production deployment

Say "/eo" to check progress and get routed to the right step.

## MENA-Specific Rules
[From brandvoice.md and market-analysis.md]
- Language: [Arabic-first / English-first / bilingual]
- RTL: [YES/NO - if yes, note Tailwind RTL plugin required]
- Payments: [Regional gateway requirements]
- WhatsApp: [Integration requirements]

## MCP Dependencies
[From mcp-integration-plan.md - list which MCPs should be installed]
- [MCP name] - [purpose]

## Quality Gates
No step can be skipped. Gates are enforced by the plugin:
- Gate 3: 5+ source files before QA
- Gate 4: qa-report.md PASS before security
- Gate 5: security-audit.md zero CRITICAL before deploy
```

---

