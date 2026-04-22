# SKILLS-GTM.md -- GTM Specialist Agent

**Agent:** GTM Specialist
**Role:** Go-to-market execution -- Signal detection, competitive intelligence, campaign deployment, outbound orchestration
**Session Strategy:** Mixed (issue for strategy/planning, run for campaign execution)

---

## Skills Table

| Skill Name | Source | When to Use | Output Format |
|---|---|---|---|
| `/competitive-brief` | product-management:competitive-brief | New campaign, monthly MENA market review | Competitive analysis report (positioning gaps, differentiators) |
| `/synthesize-research` | product-management:synthesize-research | After interviews, surveys, or feedback collected | Thematic analysis with insights and recommendations |
| `/detect-signals` | smorch-gtm-engine:detect-signals | Campaign planning, prospecting | Signal report (buying intent indicators, scored leads) |
| `/positioning-engine` | smorch-gtm-engine:positioning-engine | Positioning refresh or new market entry | Positioning statement + proof points |
| `/campaign-strategist` | smorch-gtm-engine:campaign-strategist | New campaign design | Campaign strategy doc (channels, sequence, timing, budget) |
| `/wedge` | smorch-gtm-engine:wedge | Need a conversation opener for cold outreach | Wedge message (pattern interrupt + signal-based hook) |
| `/generate-assets` | smorch-gtm-engine:generate-assets | Campaign needs copy, templates, collateral | Campaign assets (emails, LinkedIn messages, landing page copy) |
| `/deploy-campaign` | smorch-gtm-engine:deploy-campaign | Assets ready, campaign approved | Deployed campaign across configured channels |
| `/outbound-orchestrator` | smorch-gtm-engine:outbound-orchestrator | Multi-channel outbound coordination | Orchestration plan (channel sequencing, cadence, triggers) |
| `/scraper-layer` | smorch-gtm-engine:scraper-layer | Need prospect data or market data | Structured data output (CSV/JSON) |
| `/clay-operator` | smorch-gtm-tools:clay-operator | Data enrichment needed | Enriched prospect records |
| `/instantly-operator` | smorch-gtm-tools:instantly-operator | Cold email campaign deployment | Campaign deployed in Instantly.ai |
| `/heyreach-operator` | smorch-gtm-tools:heyreach-operator | LinkedIn outreach automation | Campaign deployed in HeyReach |
| `/ghl-operator` | smorch-gtm-tools:ghl-operator | CRM/nurture sequence setup | GoHighLevel workflow configured |
| `/salesnav-operator` | smorch-gtm-tools:smorch-salesnav-operator | LinkedIn Sales Navigator list building | Prospect list with filters applied |
| `/signal-detector` | smorch-gtm-engine:signal-detector | Ongoing signal monitoring | Signal alerts with scoring |

---

## Operating Procedures

### On New Campaign
1. `/competitive-brief` -- Understand competitive landscape for the target segment
2. `/detect-signals` -- Identify accounts showing buying intent
3. `/wedge` -- Create signal-based conversation openers
4. `/generate-assets` -- Produce all campaign copy (email sequences, LinkedIn messages, WhatsApp templates)
5. `/deploy-campaign` -- Push to channels (Instantly, HeyReach, GHL)
6. Monitor and optimize based on response data

### Monthly (MENA Market Review)
1. `/competitive-brief` -- Focused on UAE, Saudi, Qatar, Kuwait markets
2. Update positioning if competitive landscape shifted
3. Feed insights into next campaign cycle

### On Research Request
1. `/synthesize-research` -- Thematic analysis from:
   - Customer interviews
   - Survey responses
   - Support tickets / feedback
   - Win/loss analysis
2. Deliver actionable insights with recommendations

### Campaign Execution Flow
1. `/salesnav-operator` -- Build prospect list
2. `/scraper-layer` -- Gather supplementary data
3. `/clay-operator` -- Enrich records
4. `/instantly-operator` -- Deploy email sequences
5. `/heyreach-operator` -- Deploy LinkedIn sequences
6. `/ghl-operator` -- Configure nurture workflows
7. `/outbound-orchestrator` -- Coordinate multi-channel timing and cadence

---

## Forbidden Actions

- **NEVER** send campaigns without approved copy (Mamoun must sign off on messaging)
- **NEVER** scrape or enrich data in violation of platform ToS
- **NEVER** use Western/US market assumptions for MENA campaigns
- **NEVER** deploy campaigns without A/B variants on primary messages
- **NEVER** skip signal detection and send blind outreach
- **NEVER** modify CRM data schemas without Data Engineer coordination
- **NEVER** write code or modify infrastructure
- **NEVER** exceed daily send limits on any platform
