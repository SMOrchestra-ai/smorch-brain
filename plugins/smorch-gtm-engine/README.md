# SMOrch GTM Engine

**Signal-to-Trust GTM Engine** — autonomous campaign management for MENA and global B2B markets.

Built by [SMOrchestra.ai](https://smorchestra.ai) | Mamoun Alamouri

## What This Plugin Does

Takes a campaign brief → runs the Signal-to-Trust methodology → produces 42 outreach assets per campaign → deploys across email, LinkedIn, WhatsApp, and social → monitors metrics → generates weekly optimization recommendations.

The core thesis: relationship-based selling is a tax on growth. Signal-based trust engineering is the replacement. This plugin operationalizes that thesis into a repeatable campaign machine.

## Quick Start

1. Install the plugin in Cowork
2. Connect MCP servers (see CONNECTORS.md) — optional but recommended for deployment
3. Run `/launch-campaign` with your BRD or answer the questionnaire
4. Review the 42 generated assets
5. Run `/deploy-campaign` to push to all platforms
6. Run `/weekly-review` every Monday for optimization

## Commands

| Command | What It Does |
|---------|-------------|
| `/launch-campaign [brd]` | Full campaign from BRD — runs entire skill chain, produces 42 assets |
| `/weekly-review` | Cross-platform performance review + optimization recommendations |
| `/detect-signals [icp]` | Signal detection and ICP validation with Trust/Intent classification |
| `/generate-assets [campaign] [week]` | Generate weekly assets from wedges — 6 emails, 4 LinkedIn, 3 WhatsApp, 1 social |
| `/deploy-campaign [campaign]` | Multi-platform deployment to Instantly + HeyReach + GHL |
| `/campaign-dashboard [campaign]` | Cross-platform metrics dashboard with funnel visualization |
| `/research-prospect [name]` | Deep signal-based prospect research with wedge recommendation |
| `/wedge [signal]` | Quick wedge from a signal — 3 variants + outreach sequence |

## Skills (13)

### Method Skills (Strategy Layer)

| Skill | Function |
|-------|----------|
| signal-to-trust-gtm | Master orchestrator — 12-question intake, 4 modes, 10 sub-skill chain |
| campaign-strategist | Q→M→W→D hierarchy alignment with domino validation |
| signal-detector | ICP Fit gate + Trust/Intent signal classification |
| wedge-generator | Signal → one-sentence wedge using core formula with hard stop rules |
| positioning-engine | Business positioning using Dunford + Brunson + Hormozi frameworks |
| asset-factory | 42 assets per campaign — 18 email, 12 LinkedIn, 9 WhatsApp, 3 social |

### Operator Skills (Execution Layer)

| Skill | Function |
|-------|----------|
| n8n-architect | Workflow design, build, deploy, debug across n8n instance |
| ghl-operator | CRM hub — contacts, pipelines, WhatsApp/SMS, social scheduling |
| instantly-operator | Cold email campaigns, deliverability, warmup, sequences |
| heyreach-operator | LinkedIn outbound — connection requests, InMail, sender rotation |
| outbound-orchestrator | Multi-channel coordination with collision prevention |
| clay-operator | Waterfall enrichment, credit optimization, provider stacking |
| scraper-layer | Signal sensory system — Apify, Firecrawl, Playwright orchestration |

## Signal-to-Trust Framework

The plugin implements the complete Signal-to-Trust GTM methodology:

**Quarterly → Monthly → Weekly → Daily** campaign hierarchy where each level derives from the one above (domino validation).

**Hard Stop Rules:**
1. Fit=Fail → STOP (no outreach regardless of signal strength)
2. Signal > 90 days → STOP (stale signals produce bad outreach)
3. Wedge must pass one-sentence test
4. Intent signals > Trust signals in sequence order

**Silence Types** (why prospects aren't responding):
- Proof Silence — they don't believe you can deliver
- Cost Silence — they think it's too expensive
- Trust Silence — they don't trust you yet
- Timing Silence — it's not the right time
- Clarity Silence — they don't understand what you do

**42 Assets Per Campaign:**
- 18 emails (6/week × 3 weeks, with A/B variants)
- 12 LinkedIn messages (4/week × 3 weeks)
- 9 WhatsApp variants (3/week × 3 weeks)
- 3 social posts (1/week × 3 weeks)

## Requirements

- Cowork desktop app
- MCP connections for deployment (see CONNECTORS.md)
- Active accounts: Instantly.ai, HeyReach, GoHighLevel (for execution)
- n8n instance (for workflow automation)

## MENA Market Optimization

This plugin is built MENA-first:
- Gulf Arabic conversational tone for WhatsApp and social
- Ramadan/holiday calendar awareness in sending schedules
- Sun-Thu sending schedule for MENA, Mon-Fri for US/EU
- Arabic name standardization in enrichment
- Relationship-aware messaging that bridges signal-based approach with cultural expectations
