---
name: asset-factory
description: Produces multi-channel sequences (email, LinkedIn, WhatsApp, social) from validated wedges. Generates 18 emails, 12 LinkedIn messages, 9 WhatsApp variants, and 3 social posts per campaign. Use when creating campaign assets, generating sequences, producing A/B variants, or scaling content production. Outputs complete asset bundle ready for deployment.
---

# Asset Factory

## Purpose

This sub-skill is the **production workhorse** that transforms 3 validated wedges into complete multi-channel campaign assets. It generates **42 assets** per campaign across email, LinkedIn, WhatsApp, and social media.

**Core Philosophy**: High-volume, signal-based content that maintains quality and ICP resonance at scale.

---

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this sub-skill during:
- **Mode A (New Campaign)**: Fourth sub-skill called (after wedge-generator)
- **Mode B (Weekly Assets)**: When generating weekly asset bundles

Directly invoke when user asks:
- "Generate email sequences for these wedges"
- "Create LinkedIn messages for [campaign]"
- "Produce all campaign assets"
- "Generate A/B variants for Week 2"

---

## Inputs

### Required

1. **3 Weekly Wedges** (from wedge-generator)
   - Week 1, 2, 3 wedges (one sentence each)
   - Signal source (Intent/Trust)
   - ICP context

2. **Channel Mix** (from meta skill Q9)
   - Email + LinkedIn (default US/EU)
   - Email + LinkedIn + WhatsApp (default MENA)
   - Custom

3. **ICP Context**
   - MENA SaaS Founders
   - US Real Estate Brokers
   - MENA Beauty Clinics
   - US eCommerce (DTC)

4. **Geographic Market** (from meta skill Q10)
   - MENA (high-context, trust-first)
   - US (low-context, task-first)
   - Germany (very low-context, data-first)

### Optional

- **Performance data** (if Mode B - weekly refinement)
- **Brand voice guidelines**
- **Existing battle cards** (proven templates)

---

## Outputs

### Asset Bundle Structure

```
campaign-assets/
├── week-1/
│   ├── email-sequence-A.md (Day 1, 3, 6)
│   ├── email-sequence-B.md (Day 1, 3, 6)
│   ├── linkedin-sequence-A.md (Connection + Follow-up)
│   ├── linkedin-sequence-B.md (Connection + Follow-up)
│   ├── whatsapp-messages-ABC.md (Variant A, B, C)
│   └── social-post.md (LinkedIn/Twitter)
├── week-2/
│   └── [same structure]
├── week-3/
│   └── [same structure]
└── README.md (Usage guide + merge field mapping)
```

**Total Assets**:
- **18 emails** (3 weeks × 2 variants × 3 emails each)
- **12 LinkedIn** (3 weeks × 2 variants × 2 messages each)
- **9 WhatsApp** (3 weeks × 3 variants: A/B/C psychology)
- **3 social posts** (1 per week)
- **= 42 assets**

---

## Email Sequence Structure

### 3-Email Sequence (Days 1, 3, 6)

**Email 1: Education (The Gap)**
- Subject: Wedge-derived hook
- Body: Identify problem, introduce gap
- CTA: Soft (reply, resource, conversation)
- Length: 100-150 words
- P.S.: Micro-commitment or social proof

**Email 2: Proof (The Evidence)**
- Subject: Case study or data hook
- Body: Proof (peer success, data, testimonial)
- CTA: Medium (demo, assessment, meeting)
- Length: 120-180 words
- P.S.: Objection handling or urgency

**Email 3: Urgency (The Invitation)**
- Subject: Direct invitation
- Body: Clear next step, remove friction
- CTA: Direct (book meeting, start trial)
- Length: 80-120 words
- P.S.: Final nudge or scarcity

### A/B Variant Strategy

**Variant A: Data-Driven**
- Leads with numbers, metrics, ROI
- Proof-heavy (case studies, stats)
- Direct language

**Variant B: Story-Driven**
- Leads with narrative, scenario
- Emotion-forward (pain, opportunity)
- Relational language

---

## Email Templates by ICP

### MENA SaaS Founders (High-Context, Trust-First)

**Week 1, Email 1, Variant A (Data-Driven)**
```markdown
Subject: {{first_name}}, your sales data across 7 tools?

Hi {{first_name}},

I noticed [Company] is scaling fast—congrats on the growth.

Many MENA SaaS founders we work with face a similar challenge around this stage: sales data scattered across HubSpot, Pipedrive, Notion, and multiple spreadsheets.

The hidden cost? Decision paralysis. When your data lives in 7 different places, forecasting becomes guesswork.

After consolidating to a unified dashboard, founders in Dubai and Riyadh closed 40% more deals in the same quarter.

Worth a quick conversation to see if this resonates with your current setup?

Best,
[Name]

P.S. - Happy to share the 3-step consolidation framework we used with [Peer Company] if helpful.
```

**Week 1, Email 1, Variant B (Story-Driven)**
```markdown
Subject: The scattered data problem (I noticed this with [Company])

Hi {{first_name}},

I was looking at [Company]'s growth trajectory—impressive.

I'm reaching out because I recently worked with Ahmed at [Peer Company] on something you might be facing too.

He was managing sales data across 7 different systems. Every forecast felt like a guess. Every pipeline review surfaced new surprises.

After unifying everything into one view, his team closed 40% more deals. Not because they worked harder—because they finally had clarity.

Worth exploring if this is relevant for [Company]?

Best,
[Name]

P.S. - Ahmed mentioned you both faced similar challenges at the last [MENA SaaS event]. Thought this might resonate.
```

---

### US Real Estate Brokers (Low-Context, Task-First)

**Week 1, Email 1, Variant A (Data-Driven)**
```markdown
Subject: You're losing leads in the first 30 minutes

{{first_name}},

Your leads are booking with competitors before you even see the form fill.

Here's why: Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything.

Real scenario:
- 2:00pm: Lead fills your form
- 2:07pm: They book with a faster broker
- 5:00pm: You reply to dead lead

We help brokers capture leads in <60 seconds with instant auto-reply + mobile notifications.

15-minute call to show you the system?

[Book Here]

- [Name]

P.S. - [Broker Name] recovered $2.1M in commission using this. Happy to share how.
```

**Week 1, Email 1, Variant B (Story-Driven)**
```markdown
Subject: They booked at 2:07pm. You replied at 5pm.

{{first_name}},

Scenario from last week:

A family walked your open house Saturday. Loved the property. Filled your form at 2:00pm asking to see it again Monday.

By 2:07pm, they'd booked with another broker who replied instantly.

You replied at 5pm to a dead lead.

This isn't about working harder. It's about the Golden Window—the first 5 minutes where 21x more conversions happen.

Want to see how [Broker] automated instant response without hiring more staff?

15 minutes: [Book Here]

- [Name]

P.S. - Mobile app + auto-reply = never miss another Golden Window.
```

---

## LinkedIn Sequence Structure

### 2-Message Sequence

**Message 1: Connection Request (280 characters max)**
- Personalized hook (mutual connection, shared content, signal observation)
- Soft value hint
- Clear reason for connection

**Message 2: Follow-Up (1-2 days after connection accepted)**
- Reference wedge
- Proof or insight
- Soft CTA (resource, conversation)

---

## LinkedIn Templates by ICP

### MENA SaaS Founders

**Week 1, Message 1 (Connection Request), Variant A**
```
Hi {{first_name}}, I saw your post about scaling [Company] in the MENA market—impressive growth. I work with SaaS founders in Dubai and Riyadh on consolidating scattered sales data. Would love to connect and share what's working. - [Name]
```

**Week 1, Message 2 (Follow-Up), Variant A**
```
Hi {{first_name}},

Thanks for connecting!

I wanted to reach out because I recently helped Ahmed at [Peer Company] solve a challenge you might be facing: sales data scattered across 7+ tools creating decision paralysis.

After unifying to one dashboard, his team closed 40% more deals in Q1.

I put together a 3-step framework showing exactly how we did it. Worth sharing if this resonates with [Company]'s current setup?

Best,
[Name]
```

---

### US Real Estate Brokers

**Week 1, Message 1 (Connection Request), Variant A**
```
{{first_name}}, I help brokers recover lost commission from slow lead response. Responding after 30 min costs you 21x. First 5 min = everything. Worth connecting? - [Name]
```

**Week 1, Message 2 (Follow-Up), Variant A**
```
{{first_name}},

Quick scenario: Lead fills form at 2pm. You reply at 5pm. They booked with faster broker at 2:07pm.

This is the "Golden Window" problem—responding within 5 minutes produces 21x higher conversion than 30+ minutes.

[Broker] recovered $2.1M in commission by automating instant response (mobile notifications + auto-reply).

15-min call to show you the system: [Link]

Worth it?

- [Name]
```

---

## WhatsApp Message Structure

### 3 Variants: A/B/C Psychology

**Variant A: Pattern Interrupt**
- Unexpected angle
- Contrarian take
- Curiosity-driven

**Variant B: Problem Amplification**
- Pain-forward
- Cost of inaction
- Urgency-driven

**Variant C: Peer Reference**
- Social proof
- Trust-building
- Community-driven

---

## WhatsApp Templates by ICP

### MENA Beauty Clinics

**Week 1, Variant A (Pattern Interrupt)**
```
Hi {{first_name}} 👋

Your Instagram has 10k followers. Your CRM has 127 contacts.

You own 1.2% of your audience.

Instagram followers = $79 per 1000
Owned contacts = $582 per 1000

That's 8x ROI you're leaving on the table.

Most clinics capture <2%. The ones building owned lists own 40%+ of their audience.

Worth a quick call to show you the capture system?

Reply YES for the 5-min setup guide.

- [Name]
SalesMfast AI
```

**Week 1, Variant B (Problem Amplification)**
```
Hi {{first_name}},

Quick question: What happens to your 10k Instagram followers if your account gets suspended tomorrow?

All gone. Zero ownership.

This happened to 3 Dubai clinics last quarter. They lost their entire audience overnight.

The clinics with owned contact lists (WhatsApp, email) kept growing.

Instagram followers = rented audience ($79 per 1000)
Owned contacts = owned audience ($582 per 1000)

That's 8x ROI + platform security.

Want to see the capture system we built for [Clinic]?

Reply YES.

- [Name]
SalesMfast AI
```

**Week 1, Variant C (Peer Reference)**
```
Hi {{first_name}},

I recently worked with Dr. Sara at [Clinic] on something you might find relevant.

She had 8k Instagram followers but only 89 in her CRM. Capture rate: 1.1%.

After implementing the 8x capture system, she now owns 42% of her audience (3,360 contacts).

Result: $47k additional monthly revenue from owned list vs Instagram follower engagement.

She mentioned you're facing similar challenges with Instagram leakage.

Worth a 10-min call to show you the same system?

Reply YES or call me: [Phone]

- [Name]
SalesMfast AI
```

---

## Social Post Structure

### 1 Post Per Week (LinkedIn/Twitter)

**Purpose**:
- Visibility (support outbound with inbound)
- Thought leadership
- Social proof

**Format**:
- Hook (first line = wedge-derived)
- Body (insight, data, story)
- CTA (comment, engage, DM)
- Length: 150-250 words (LinkedIn), 280 characters (Twitter)

---

## Social Post Templates

### Week 1 Social Post (MENA SaaS)

**LinkedIn**:
```
Your sales data lives in 7 different tools.

Decision paralysis is costing you deals.

I see this with MENA SaaS founders scaling from 10 to 50 employees:

→ HubSpot for contacts
→ Pipedrive for deals
→ Notion for notes
→ 4 Google Sheets for everything else

Every forecast becomes guesswork. Every pipeline review surfaces surprises.

Last quarter, 5 founders in Dubai and Riyadh consolidated to unified dashboards.

Result: 40% more deals closed. Same team. Same effort. Just clarity.

The pattern: Scattered data = invisible pipeline. Unified view = predictable revenue.

---

If this resonates, I built a 3-step consolidation framework. DM "DATA" and I'll send it over.

#B2BSaaS #MENA #SalesAutomation
```

**Twitter**:
```
Your sales data across 7 tools = decision paralysis.

5 MENA SaaS founders unified their stack last quarter.

Result: 40% more deals. Same team. Just clarity.

Scattered data = invisible pipeline.
Unified dashboard = predictable revenue.

DM for framework.
```

---

## A/B Variant Psychology

### Variant A Psychology: Data-First
- **Leads with**: Numbers, metrics, ROI
- **Proof**: Stats, case studies, quantified results
- **Language**: Direct, explicit, task-focused
- **CTA**: Clear, action-oriented
- **Best for**: US markets, intent-driven buyers, analytical personas

### Variant B Psychology: Story-First
- **Leads with**: Narrative, scenario, relatable pain
- **Proof**: Peer stories, before/after, emotional resonance
- **Language**: Relational, high-context, trust-building
- **CTA**: Soft, conversation-oriented
- **Best for**: MENA markets, trust-driven buyers, relationship-oriented personas

---

## Geographic Tone Adaptation

### MENA Tone
- **Communicating**: High-context (implied vs explicit)
- **Language**: "We" (collective), relationship references, geographic mentions
- **Proof**: Peer names (if allowed), MENA-specific examples
- **Sequence length**: Longer (5-7 touches for relationship building)
- **Channel priority**: WhatsApp > Email > LinkedIn

### US Tone
- **Communicating**: Low-context (explicit, direct)
- **Language**: "You" (individual), data-driven, outcome-focused
- **Proof**: Numbers, metrics, ROI calculations
- **Sequence length**: Shorter (3 emails, fast-paced)
- **Channel priority**: Email > LinkedIn (no WhatsApp)

### Germany Tone
- **Communicating**: Very low-context (hyper-explicit, structured)
- **Language**: Formal, principle-first, evidence-heavy
- **Proof**: Research, studies, statistical significance
- **Sequence length**: Longer (5-7 emails with white papers)
- **Channel priority**: Email only (formal)

---

## Merge Field Mapping

### Standard Merge Fields (GHL/Instantly Compatible)

```
{{first_name}} → Contact first name
{{company_name}} → Company name
{{signal_data}} → Custom field: observed signal text
{{wedge_subject}} → Custom field: wedge-derived subject line
{{peer_company}} → Custom field: ICP peer reference
{{custom_metric}} → Custom field: ICP-specific metric (employees, agents, revenue)
```

---

## Output Format

### Asset Markdown Template

```markdown
# Week [N] - [Channel] Sequence [Variant]

## Wedge
**Core Message**: "[One-sentence wedge]"

## Sequence Details
**Channel**: Email / LinkedIn / WhatsApp
**Variant**: A / B / C
**Psychology**: Data-driven / Story-driven / Peer-proof
**ICP**: [Target ICP]
**Geographic Tone**: MENA / US / Germany

---

## Message 1 (Day 1)

**Subject**: [Subject line with merge fields]

**Body**:
[Email body with merge fields]

**CTA**: [Clear call-to-action]

**P.S.**: [Micro-commitment or social proof]

---

## Message 2 (Day 3)

[Same structure]

---

## Message 3 (Day 6)

[Same structure]

---

## Deployment Notes
- GHL workflow: [Workflow name]
- Instantly campaign: [Campaign ID]
- HeyReach sequence: [Sequence name]
- Merge fields required: {{first_name}}, {{company_name}}, {{signal_data}}
```

---

## Integration with Other Sub-Skills

### Downstream Dependencies

After asset-factory outputs 42 assets:

**integration-orchestrator** (Patch 2) uses:
- Asset files (markdown format)
- Merge field mappings
- Channel definitions
- To deploy to GHL/Instantly/HeyReach

**culture-adapter** (Patch 3) uses:
- Generated assets
- Geographic market
- To create culturally adapted variants

### Upstream Dependencies

**Inputs from**:
1. **wedge-generator**: 3 weekly wedges (validated)
2. **campaign-strategist**: ICP context, channel mix
3. **Meta skill questionnaire**: Q9 (channel mix), Q10 (geographic market)

---

## Conclusion

The asset-factory sub-skill ensures:
1. **High-volume production** (42 assets per campaign)
2. **Multi-channel coverage** (email, LinkedIn, WhatsApp, social)
3. **A/B variant creation** (data vs story psychology)
4. **ICP resonance** (tone, language, proof type)
5. **Geographic adaptation** (MENA vs US vs Germany)
6. **Deployment-ready format** (merge fields, GHL/Instantly compatible)

**Output**: Complete asset bundle ready for integration-orchestrator deployment or manual use.

**Patch 1 Complete**: All 4 foundation sub-skills built. Ready for end-to-end testing.
