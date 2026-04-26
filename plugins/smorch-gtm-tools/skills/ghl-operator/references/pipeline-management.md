# Pipeline Management Reference

> **v2 migration banner — 2026-04-26.** Bare tool names in this doc (e.g., `get_pipelines`, `create_opportunity`, `update_opportunity_status`) are now **operation names** under the new `mcp__salesmfast-ops__ghl-opportunities-{reader,updater}` routers. Call shape: `{ selectSchema: { operation, params } }`. See `SKILL.md → MCP Tools Reference` or `salesmfast-ops-mcp/docs/MIGRATION.md` for the full mapping.

## Table of Contents
1. [Pipeline Architecture](#pipeline-architecture)
2. [Stage Definitions](#stage-definitions)
3. [Opportunity Lifecycle](#opportunity-lifecycle)
4. [Stage Transition Rules](#stage-transition-rules)
5. [Pipeline Analytics](#pipeline-analytics)
6. [Multiple Pipelines](#multiple-pipelines)

---

## Pipeline Architecture

### Standard B2B Outbound Pipeline

```
New Lead → Signal Detected → Qualified → Meeting Booked → Proposal Sent → Negotiation → Closed Won
                                                                                      → Closed Lost
```

This is the default pipeline for outbound signal-based selling. Each stage has clear entry criteria and exit triggers.

### Pipeline Operations via MCP

```
List pipelines:      mcp__ghl-mcp__get_pipelines
Create opportunity:  mcp__ghl-mcp__create_opportunity
Update opportunity:  mcp__ghl-mcp__update_opportunity
Search opportunities: mcp__ghl-mcp__search_opportunities
Update status:       mcp__ghl-mcp__update_opportunity_status
Upsert opportunity:  mcp__ghl-mcp__upsert_opportunity
```

---

## Stage Definitions

### 1. New Lead
**Entry criteria:** Contact created in GHL from any source
**What happens:** Contact exists but no engagement signal detected yet
**Auto-entry:** Contacts from Clay enrichment, list imports, manual entry
**Exit trigger:** First engagement signal detected (email open, LinkedIn view, website visit)
**Typical duration:** 0-7 days (or never, if no engagement)

### 2. Signal Detected
**Entry criteria:** At least one engagement signal with `signal_score` >= 3
**What happens:** Contact has shown interest — actively being scored and monitored
**Auto-entry:** n8n workflow detects signal → updates tag → moves opportunity here
**Exit trigger:** Signal score reaches 7+ (qualifies) OR signal decays below 3 (drops back)
**Typical duration:** 1-5 days

### 3. Qualified
**Entry criteria:** `signal_score` >= 7 OR manual qualification by sales team
**What happens:** Contact is actively pursued — WhatsApp/email follow-up initiated
**Auto-entry:** Signal scoring workflow moves here when score threshold met
**Exit trigger:** Meeting booked (calendar confirmation) OR disqualification
**Typical duration:** 2-7 days

### 4. Meeting Booked
**Entry criteria:** Calendar appointment confirmed with the contact
**What happens:** Meeting prep mode — account research, deck preparation
**Auto-entry:** When appointment is created via GHL calendar
**Exit trigger:** Meeting happens → proposal follows OR no-show → follow-up sequence
**Typical duration:** 1-5 days (depends on scheduling lead time)

### 5. Proposal Sent
**Entry criteria:** Proposal/pricing document sent to contact
**What happens:** Waiting for response — follow-up cadence active
**Auto-entry:** When proposal email is sent (track via tag `status:proposal_sent`)
**Exit trigger:** Contact responds → negotiation OR no response after 7 days → follow-up escalation
**Typical duration:** 3-10 days

### 6. Negotiation
**Entry criteria:** Contact has engaged with proposal and is discussing terms
**What happens:** Active back-and-forth on scope, pricing, timeline
**Auto-entry:** Manual move when negotiation begins
**Exit trigger:** Deal agreed → Closed Won OR deal falls through → Closed Lost
**Typical duration:** 5-30 days

### 7. Closed Won
**Entry criteria:** Deal signed, payment confirmed or committed
**What happens:** Handoff to delivery/implementation team
**Auto-entry:** Manual move when contract signed
**Tags added:** `status:closed_won`, `client:active`
**Post-actions:** Remove from all outbound sequences, add to client nurture

### 8. Closed Lost
**Entry criteria:** Deal explicitly lost or abandoned
**What happens:** Capture loss reason, add to re-engagement pool
**Auto-entry:** Manual move with required `loss_reason` field
**Tags added:** `status:closed_lost`
**Loss reasons:** budget, timing, competitor, no_response, bad_fit, internal_change
**Re-engagement:** After 90 days, re-evaluate for fresh outbound (new signal cycle)

---

## Opportunity Lifecycle

### Creating Opportunities
```json
{
  "pipelineId": "<pipeline-id-from-get_pipelines>",
  "pipelineStageId": "<stage-id>",
  "name": "TechCorp - Ahmed Hassan",
  "contactId": "<contact-id>",
  "monetaryValue": 50000,
  "status": "open",
  "source": "instantly"
}
```

**Naming convention:** `{Company Name} - {Contact Name}`
- "TechCorp - Ahmed Hassan"
- "Gulf Solutions - Fatima Al-Rashid"
- "DataFlow Inc - John Smith"

**Monetary value is mandatory** — even if it's an estimate. Use these defaults by ICP:
- MENA SaaS Enterprise: $50,000
- MENA SME: $5,000
- US Real Estate: $10,000
- Contact Center (CXMfast): $100,000

### Updating Opportunities
When moving between stages, always:
1. Update the `pipelineStageId` to the new stage
2. Add a note explaining why: "Moved to Meeting Booked — calendar confirmed for Feb 25 at 10AM GST"
3. Update the monetary value if better information is available
4. Track the date of stage change (GHL does this automatically)

### Stage Skip Rules
Sometimes contacts skip stages based on strong signals:
- Reply + explicit meeting request → Skip to "Meeting Booked"
- Inbound inquiry with budget mentioned → Skip to "Qualified"
- Referral with warm intro → Skip to "Meeting Booked"
- Never skip past "Meeting Booked" — always meet before proposing

---

## Stage Transition Rules

### Auto-Transitions (Triggered by Tags/Signals)
| Trigger | From Stage | To Stage |
|---------|-----------|----------|
| Signal score >= 3 detected | New Lead | Signal Detected |
| Signal score >= 7 | Signal Detected | Qualified |
| Appointment created | Qualified | Meeting Booked |
| Tag `status:proposal_sent` added | Meeting Booked | Proposal Sent |
| Tag `status:negotiating` added | Proposal Sent | Negotiation |

### Manual Transitions (Require Human Decision)
| Transition | Requires |
|-----------|----------|
| Anything → Closed Won | Confirmation of signed deal + monetary value |
| Anything → Closed Lost | Loss reason (mandatory field) |
| Negotiation → Closed Won | Contract/PO confirmation |
| Any stage → Disqualified | Reason for disqualification |

### Stale Opportunity Rules
| Stage | Stale After | Action |
|-------|------------|--------|
| Signal Detected | 7 days no new signal | Re-score, consider downgrading |
| Qualified | 5 days no response | Escalate follow-up (WhatsApp if MENA) |
| Meeting Booked | 2 days past meeting date | Check if meeting happened, update |
| Proposal Sent | 7 days no response | Send follow-up, consider phone call |
| Negotiation | 14 days no movement | Escalate to direct call, reassess deal |

---

## Pipeline Analytics

### Key Metrics per Pipeline

**Pipeline Velocity**
Average days from New Lead to Closed Won. Break down by stage to find bottlenecks.
```
Velocity = Sum(days in each stage for won deals) / Count(won deals)
```

**Stage Conversion Rates**
```
New Lead → Signal Detected:  Target >30%
Signal Detected → Qualified: Target >40%
Qualified → Meeting Booked:  Target >50%
Meeting Booked → Proposal:   Target >70%
Proposal → Negotiation:      Target >60%
Negotiation → Closed Won:    Target >50%
```

**Pipeline Value**
Sum of monetary values for all open opportunities, weighted by stage:
```
Signal Detected:  10% weight
Qualified:        20% weight
Meeting Booked:   40% weight
Proposal Sent:    60% weight
Negotiation:      80% weight
```
Weighted Pipeline = Sum(value × weight) for all open opportunities

**Win Rate**
```
Win Rate = Closed Won / (Closed Won + Closed Lost)
Target: >25% for outbound, >40% for inbound
```

---

## Multiple Pipelines

The SalesMfast instance may have multiple pipelines for different ICPs:

| Pipeline | ICP | Market | Typical Deal Size |
|----------|-----|--------|-------------------|
| MENA SaaS Pipeline | B2B SaaS companies in Gulf | UAE, KSA, Qatar, Kuwait | $25K-$100K |
| US Real Estate Pipeline | Real estate agencies/brokers | United States | $5K-$20K |
| MENA SME Pipeline | Small businesses in Gulf | UAE, KSA | $2K-$10K |
| CXMfast Pipeline | Contact center buyers | MENA + Global | $50K-$500K |
| Beauty Clinics Pipeline | Beauty/wellness SMEs | UAE, KSA | $3K-$15K |

When creating opportunities, use the ICP tag to determine which pipeline:
- `icp:mena_saas` → MENA SaaS Pipeline
- `icp:us_realestate` → US Real Estate Pipeline
- `icp:mena_sme` → MENA SME Pipeline
- `icp:cxmfast` → CXMfast Pipeline
- `icp:beauty_clinic` → Beauty Clinics Pipeline

Always get the actual pipeline IDs via `mcp__ghl-mcp__get_pipelines` — don't hardcode them.
