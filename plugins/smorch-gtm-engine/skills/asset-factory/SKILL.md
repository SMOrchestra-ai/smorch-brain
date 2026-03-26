---
name: asset-factory
description: "Produces multi-channel sequences (email, LinkedIn, WhatsApp, social) from validated wedges. Generates 18 emails, 12 LinkedIn messages, 9 WhatsApp variants, and 3 social posts per campaign. Use when creating campaign assets, generating sequences, producing A/B variants, or scaling content production. Outputs complete asset bundle ready for deployment."
---

# Asset Factory

## Purpose

Transforms 3 validated wedges into complete multi-channel campaign assets: **42 assets** per campaign across email, LinkedIn, WhatsApp, and social media.

**Core Philosophy**: High-volume, signal-based content that maintains quality and ICP resonance at scale.

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this during:
- **Mode A (New Campaign)**: Fourth sub-skill (after wedge-generator)
- **Mode B (Weekly Assets)**: Weekly asset bundles

Direct invoke: "Generate email sequences", "Create LinkedIn messages", "Produce all campaign assets", "Generate A/B variants"

## Inputs

### Required

1. **3 Weekly Wedges** (from wedge-generator): Week 1/2/3 wedges, signal source (Intent/Trust), ICP context
2. **Channel Mix** (Q9): Email+LinkedIn (US/EU) | +WhatsApp (MENA) | Custom
3. **ICP Context**: MENA SaaS Founders | US Real Estate Brokers | MENA Beauty Clinics | US eCommerce (DTC)
4. **Geographic Market** (Q10): MENA (high-context) | US (low-context) | Germany (data-first)

### Optional
- Performance data (Mode B refinement), Brand voice guidelines, Existing battle cards

## Outputs

```
campaign-assets/
├── week-1/
│   ├── email-sequence-A.md (Day 1, 3, 6)
│   ├── email-sequence-B.md (Day 1, 3, 6)
│   ├── linkedin-sequence-A.md (Connection + Follow-up)
│   ├── linkedin-sequence-B.md (Connection + Follow-up)
│   ├── whatsapp-messages-ABC.md (3 psychology variants)
│   └── social-post.md (LinkedIn/Twitter)
├── week-2/ [same structure]
├── week-3/ [same structure]
└── README.md (merge field mapping)
```

**Totals**: 18 emails, 12 LinkedIn, 9 WhatsApp, 3 social = **42 assets**

## Email Sequence Structure

3-email sequence per week per variant (Days 1, 3, 6):

| Email | Role | Body | CTA | Length |
|-------|------|------|-----|--------|
| 1: Education | Identify problem, introduce gap | Wedge-derived hook | Soft (reply, resource) | 100-150 words |
| 2: Proof | Case study, data, testimonial | Medium (demo, assessment) | 120-180 words |
| 3: Urgency | Clear next step, remove friction | Direct (book meeting) | 80-120 words |

Each email includes P.S. line (micro-commitment or social proof).

**ICP-specific email templates**: Read `references/email-templates.md`

## LinkedIn Sequence Structure

2-message sequence per week per variant:

| Message | Content | Max Length |
|---------|---------|------------|
| 1: Connection Request | Personalized hook + value hint + reason | 280 chars |
| 2: Follow-Up (1-2 days) | Reference wedge + proof + soft CTA | No limit |

**ICP-specific LinkedIn templates**: Read `references/linkedin-templates.md`

## WhatsApp Message Structure

3 variants per week (A/B/C psychology):

| Variant | Psychology | Lead With |
|---------|-----------|-----------|
| A: Pattern Interrupt | Contrarian, curiosity-driven | Unexpected angle |
| B: Problem Amplification | Pain-forward, urgency | Cost of inaction |
| C: Peer Reference | Social proof, trust | Peer success story |

**ICP-specific WhatsApp templates**: Read `references/whatsapp-templates.md`

## Social Post Structure

1 post per week (LinkedIn + Twitter). Hook = wedge-derived first line. Body = insight/data/story. CTA = comment/engage/DM. LinkedIn: 150-250 words. Twitter: 280 chars.

**Social post templates**: Read `references/social-templates.md`

## A/B Variant Psychology

| Dimension | Variant A (Data-First) | Variant B (Story-First) |
|-----------|----------------------|----------------------|
| Leads with | Numbers, metrics, ROI | Narrative, scenario, pain |
| Proof | Stats, case studies | Peer stories, before/after |
| Language | Direct, explicit | Relational, high-context |
| CTA | Clear, action-oriented | Soft, conversation-oriented |
| Best for | US, intent-driven, analytical | MENA, trust-driven, relational |

## Geographic Tone Adaptation

| Dimension | MENA | US | Germany |
|-----------|------|-------|---------|
| Context | High (implied) | Low (explicit) | Very low (hyper-explicit) |
| Language | "We", relationship refs | "You", data-driven | Formal, principle-first |
| Proof | Peer names, MENA examples | Numbers, ROI | Research, studies |
| Sequence | Longer (5-7 touches) | Shorter (3 emails) | Longer (5-7 + white papers) |
| Channel priority | WhatsApp > Email > LinkedIn | Email > LinkedIn | Email only |

## Merge Field Mapping

Standard merge fields (GHL/Instantly compatible):
- `{{first_name}}`, `{{company_name}}`, `{{signal_data}}`, `{{wedge_subject}}`, `{{peer_company}}`, `{{custom_metric}}`

## Output Format

Each asset file follows this template:

```markdown
# Week [N] - [Channel] Sequence [Variant]
## Wedge: "[One-sentence wedge]"
**Channel**: Email/LinkedIn/WhatsApp | **Variant**: A/B/C | **ICP**: [Target] | **Tone**: MENA/US/Germany

### Message 1 (Day 1)
**Subject**: [with merge fields]
**Body**: [content]
**CTA**: [action]
**P.S.**: [micro-commitment]

### Deployment Notes
- GHL workflow: [name] | Instantly campaign: [ID] | HeyReach sequence: [name]
- Merge fields required: {{first_name}}, {{company_name}}, {{signal_data}}
```

## Integration

**Upstream**: wedge-generator (3 wedges), campaign-strategist (ICP, channel mix), meta skill Q9/Q10
**Downstream**: integration-orchestrator (deployment), culture-adapter (geographic variants)

## Reference Files

| File | Content |
|------|---------|
| `references/email-templates.md` | Full email templates by ICP (MENA SaaS, US Real Estate) |
| `references/linkedin-templates.md` | LinkedIn connection + follow-up templates by ICP |
| `references/whatsapp-templates.md` | WhatsApp A/B/C variants by ICP (Beauty Clinics) |
| `references/social-templates.md` | LinkedIn + Twitter post templates |
