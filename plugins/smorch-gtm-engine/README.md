# SMOrch GTM Engine

**Signal-to-Trust GTM Engine** — autonomous campaign management for MENA and global B2B markets.

Built by [SMOrchestra.ai](https://smorchestra.ai) | Mamoun Alamouri

## What This Plugin Does

Takes a campaign brief, runs the Signal-to-Trust methodology with trust engineering and psychological trigger mapping, produces precision outreach assets per campaign, deploys across email, LinkedIn, WhatsApp, and social, monitors metrics, and generates weekly optimization recommendations.

The core thesis: relationship-based selling is a tax on growth. Signal-based trust engineering is the replacement. This plugin operationalizes that thesis into a repeatable campaign machine.

## Quick Start

1. Install the plugin in Cowork
2. Connect MCP servers (see CONNECTORS.md) — optional but recommended for deployment
3. Run `/launch-campaign` with your BRD or answer the questionnaire
4. Review the generated assets (vulnerability arc emails, LinkedIn DMs + authority posts, social, VSL scripts, branded DOCX/PDF/PPTX)
5. Run `/deploy-campaign` to push to all platforms
6. Run `/weekly-review` every Monday for optimization

## Commands

| Command | What It Does |
|---------|-------------|
| `/launch-campaign [brd]` | Full campaign from BRD — runs entire skill chain, produces complete asset bundle |
| `/weekly-review` | Cross-platform performance review + optimization recommendations |
| `/detect-signals [icp]` | Signal detection and ICP validation with Trust/Intent classification |
| `/generate-assets [campaign] [week]` | Generate weekly assets from wedges — emails, LinkedIn, social, VSL |
| `/deploy-campaign [campaign]` | Multi-platform deployment to Instantly + HeyReach + GHL |
| `/campaign-dashboard [campaign]` | Cross-platform metrics dashboard with funnel visualization |
| `/research-prospect [name]` | Deep signal-based prospect research with wedge recommendation |
| `/wedge [signal]` | Quick wedge from a signal — 3 variants + outreach sequence |
| `/campaign-guide` | Walk through all 9 phases of a B2B Signal Sales campaign |

## Skills (15)

### Method Skills (Strategy Layer)

| Skill | Function |
|-------|----------|
| signal-to-trust-gtm | Master orchestrator — 12-question intake, 4 modes, 10 sub-skill chain |
| campaign-strategist | Q→M→W→D hierarchy with trust engineering alignment and psychological trigger mapping |
| campaign-guide | 9-phase SOP orchestrator with quality gates between phases |
| signal-detector | ICP Fit gate + Trust/Intent signal classification |
| wedge-generator | Signal → one-sentence wedge using core formula with hard stop rules |
| positioning-engine | Business positioning: Dunford + Brunson + Hormozi + Trust Engineering thesis + 7 psychological triggers |
| asset-factory | Precision campaign assets: 3-email vulnerability arc, LinkedIn DM A/B, authority posts, social, VSL, branded DOCX/PDF/PPTX |

### Operator Skills (Execution Layer)

| Skill | Function |
|-------|----------|
| outbound-orchestrator | Multi-channel coordination with collision prevention |
| scraper-layer | Signal sensory system — Apify, Firecrawl, Playwright orchestration |
| smorch-linkedin-intel | LinkedIn intelligence: profile research, content signals, competitor tracking |
| smorch-perfect-webinar | Perfect Webinar framework with signal-to-trust extensions |
| smorch-skill-creator | Skill creation and optimization with enforced naming validation |
| lead-research-assistant | Lead identification with ICP-matched contact strategies |

<!-- IP:START - Signal-to-Trust framework summary -->
## Signal-to-Trust Framework

The plugin implements the complete Signal-to-Trust GTM methodology:

**Quarterly → Monthly → Weekly → Daily** campaign hierarchy where each level derives from the one above (domino validation).

**Trust Engineering Thesis:** MENA isn't a relationship market. It's a trust market. Trust is engineerable. Every asset activates psychological triggers in a deliberate sequence, not random feature messaging.

**7 Psychological Positioning Triggers** (priority order):
1. Identity Threat (PRIMARY) — "Your competitors already have this"
2. Costly Signal (PRIMARY) — Proof that can't be faked
3. Temporal Window (PRIMARY) — "This window closes"
4. Asymmetric Information — "You don't know what you don't know"
5. In-Group/Out-Group — "The operators who get it vs. those who don't"
6. Transformation Narrative — Before/after system proof
7. Cognitive Fluency — Simple frameworks that stick

**Hard Stop Rules:**
1. Fit=Fail → STOP (no outreach regardless of signal strength)
2. Signal > 90 days → STOP (stale signals produce bad outreach)
3. Wedge must pass one-sentence test
4. Intent signals > Trust signals in sequence order

**3-Email Vulnerability Arc** (replaces 6-email volume approach):
- E1 (Day 1): Origin Story — why you built this, personal vulnerability
- E2 (Day 3): Trust-as-Science Confession — the "Still is" pattern
- E3 (Day 6): System Proof — specific numbers, binary CTA

**Silence Types** (why prospects aren't responding):
- Proof Silence — they don't believe you can deliver
- Cost Silence — they think it's too expensive
- Trust Silence — they don't trust you yet
- Timing Silence — it's not the right time
- Clarity Silence — they don't understand what you do

<!-- IP:END -->

## Scoring Gates

All assets pass through the GTM Scoring Suite before deployment:
- Cold emails: 9.0+ (Copywriting Scorer)
- LinkedIn authority posts: 9.0+ (LinkedIn Branding Scorer)
- LinkedIn DMs: 9.0+ (Copywriting Scorer)
- Headlines/positioning: 9.5+ (Offer Positioning Scorer)
- Social posts: 8.5+ (Social Media Scorer)
- VSL scripts: 8.5+ (YouTube/Campaign Scorer)

## Brand Design System (Default)

Document colors: ORANGE #E8612D, DARK #1B2A3D, GRAY #555555, LGRAY #888888
Digital colors: BG #0A0A0A, ORANGE #FF6600, WHITE #FFFFFF, MUTED #999999
Typography: Inter (EN), Cairo (AR), JetBrains Mono (code)

Override with any brand template the user provides.

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
- Trust engineering messaging that bridges signal-based approach with cultural expectations
