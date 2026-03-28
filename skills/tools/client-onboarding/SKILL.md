<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: client-onboarding
description: Client Management — onboarding, status reports, SOW generation, engagement tracking for SMOrchestra agency clients
category: tools
triggers:
  - client
  - onboarding
  - SOW
  - proposal
  - engagement
  - status report
  - client management
  - new client
---

# Client Onboarding & Management Skill

You manage the client lifecycle for SMOrchestra.ai agency engagements. From initial onboarding through ongoing management.

## Client Lifecycle

```
1. Discovery Call → 2. Proposal/SOW → 3. Onboarding → 4. Execution → 5. Reporting → 6. Renewal
```

## 1. Discovery → Proposal

### After discovery call, gather:
- Company name, industry, size, MENA market focus
- Current pain points (specific, not vague)
- Budget range (or indicators)
- Timeline expectations
- Decision maker(s) and process
- Competitors they've evaluated

### Proposal structure:
```
[client-name]-[type]-[date].docx

1. Executive Summary (1 page max)
   - The problem in their words
   - Our approach in one paragraph
   - Expected ROI with numbers

2. Scope of Work
   - Deliverables (specific, measurable)
   - Timeline with milestones
   - What's included vs excluded

3. Investment
   - Pricing tiers if applicable
   - Payment schedule
   - What triggers each payment

4. Why SMOrchestra
   - Relevant case study / proof
   - MENA market expertise
   - Signal-based approach differentiator

5. Next Steps
   - Low-friction CTA (sign here, schedule kick-off)
```

## 2. Onboarding Checklist

### MAMOUN-REQUIRED:
- [ ] SOW signed and filed
- [ ] Payment terms confirmed
- [ ] Project kickoff date set

### CLAUDE-AUTO:
- [ ] Create client folder: `~/clients/[client-name]/`
- [ ] Create GHL sub-account (if CRM work)
- [ ] Set up project in Linear
- [ ] Create CLAUDE.md for the client project
- [ ] Set up reporting cadence (weekly/biweekly)
- [ ] Create Slack channel or WhatsApp group

### Client folder structure:
```
clients/[client-name]/
  CLAUDE.md              # Project context for Claude Code
  SOW/                   # Signed agreements
  Proposals/             # Sent proposals
  Reports/               # Status reports, analytics
  Assets/                # Deliverables, creative
  Notes/                 # Meeting notes, decisions
```

## 3. Status Reports

### Weekly format:
```markdown
# [Client Name] — Weekly Status Report
**Week of:** YYYY-MM-DD
**Prepared by:** Mamoun Alamouri

## Summary
One paragraph: what happened, what's next, any blockers.

## Completed This Week
- [ ] Deliverable 1 — [status]
- [ ] Deliverable 2 — [status]

## In Progress
- [ ] Task 1 — ETA: date
- [ ] Task 2 — ETA: date

## Blocked / Needs Client Input
- Item needing decision — who, by when

## Next Week Plan
- Priority 1
- Priority 2

## Metrics (if applicable)
| Metric | Last Week | This Week | Change |
|--------|-----------|-----------|--------|
```

### Monthly format:
Add: ROI analysis, milestone progress, budget burn rate, strategic recommendations.

## 4. SOW Template

```markdown
# Statement of Work

## Parties
- **Provider:** SMOrchestra.ai (Mamoun Alamouri)
- **Client:** [Company Name] ([Contact Name])

## Scope
### Phase 1: [Name] (Weeks 1-4)
- Deliverable 1
- Deliverable 2

### Phase 2: [Name] (Weeks 5-8)
- Deliverable 3
- Deliverable 4

## Out of Scope
- [Explicitly list what's NOT included]

## Timeline
| Phase | Start | End | Deliverables |
|-------|-------|-----|-------------|

## Investment
| Phase | Amount | Due |
|-------|--------|-----|

## Assumptions
- Client provides [X] within [Y] days
- Changes to scope require written approval

## Acceptance
Signed by: _________________ Date: _______
```

## 5. Engagement Tracking

### In GHL:
- Tag: `agency-client`
- Pipeline: `Agency Engagements`
- Stages: Discovery → Proposal Sent → SOW Signed → Active → Renewal → Churned
- Custom fields: monthly retainer, contract end date, primary contact

### Health indicators:
| Signal | Meaning | Action |
|--------|---------|--------|
| No response in 5+ days | Client disengaged | Mamoun follow-up call |
| Missed 2+ meetings | At risk | Escalate with value recap |
| Asks for more scope | Expansion opportunity | Prepare upsell proposal |
| Mentions competitor | Churn risk | Deliver quick win immediately |
