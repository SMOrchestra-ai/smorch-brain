<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: asset-factory
description: Produces multi-channel sequences (email, LinkedIn, WhatsApp, social) from validated wedges. Generates 18 emails, 12 LinkedIn messages, 9 WhatsApp variants, and 3 social posts per campaign. Use when creating campaign assets, generating sequences, producing A/B variants, or scaling content production. Outputs complete asset bundle ready for deployment.
---

# Asset Factory

## Purpose

This sub-skill is the **production workhorse** that transforms 3 validated wedges into complete multi-channel campaign assets. It generates **42 assets** per campaign across email, LinkedIn, WhatsApp, and social media.

**Core Philosophy**: High-volume, signal-based content that maintains quality and ICP resonance at scale.

**Reference Files:**
- [channel-templates.md](channel-templates.md) - Email, LinkedIn, WhatsApp, and social post templates by ICP, merge field mapping

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
   - Week 1, 2, 3 wedges (one sentence each), Signal source, ICP context

2. **Channel Mix** (from meta skill Q9)
   - Email + LinkedIn (default US/EU)
   - Email + LinkedIn + WhatsApp (default MENA)
   - Custom

3. **ICP Context**
   - MENA SaaS Founders / US Real Estate Brokers / MENA Beauty Clinics / US eCommerce (DTC)

4. **Geographic Market** (from meta skill Q10)
   - MENA (high-context, trust-first) / US (low-context, task-first) / Germany (very low-context, data-first)

### Optional
- Performance data (if Mode B), brand voice guidelines, existing battle cards

---

## Outputs

### Asset Bundle Structure

```
campaign-assets/
+-- week-1/
|   +-- email-sequence-A.md (Day 1, 3, 6)
|   +-- email-sequence-B.md (Day 1, 3, 6)
|   +-- linkedin-sequence-A.md (Connection + Follow-up)
|   +-- linkedin-sequence-B.md (Connection + Follow-up)
|   +-- whatsapp-messages-ABC.md (Variant A, B, C)
|   +-- social-post.md (LinkedIn/Twitter)
+-- week-2/
|   +-- [same structure]
+-- week-3/
|   +-- [same structure]
+-- README.md (Usage guide + merge field mapping)
```

**Total Assets**:
- **18 emails** (3 weeks x 2 variants x 3 emails each)
- **12 LinkedIn** (3 weeks x 2 variants x 2 messages each)
- **9 WhatsApp** (3 weeks x 3 variants: A/B/C psychology)
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

**Variant A: Data-Driven** - Leads with numbers, metrics, ROI. Proof-heavy. Direct language.
**Variant B: Story-Driven** - Leads with narrative, scenario. Emotion-forward. Relational language.

For full email templates by ICP, see [channel-templates.md](channel-templates.md).

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

For full LinkedIn templates by ICP, see [channel-templates.md](channel-templates.md).

---

## WhatsApp Message Structure

### 3 Variants: A/B/C Psychology

**Variant A: Pattern Interrupt** - Unexpected angle, contrarian take, curiosity-driven
**Variant B: Problem Amplification** - Pain-forward, cost of inaction, urgency-driven
**Variant C: Peer Reference** - Social proof, trust-building, community-driven

For full WhatsApp templates by ICP, see [channel-templates.md](channel-templates.md).

---

## Social Post Structure

### 1 Post Per Week (LinkedIn/Twitter)

**Purpose**: Visibility (support outbound with inbound), thought leadership, social proof

**Format**:
- Hook (first line = wedge-derived)
- Body (insight, data, story)
- CTA (comment, engage, DM)
- Length: 150-250 words (LinkedIn), 280 characters (Twitter)

---

## A/B Variant Psychology

### Variant A: Data-First
- **Best for**: US markets, intent-driven buyers, analytical personas
- Leads with numbers, uses stats/case studies, direct CTA

### Variant B: Story-First
- **Best for**: MENA markets, trust-driven buyers, relationship-oriented personas
- Leads with narrative, uses peer stories, soft CTA

---

## Geographic Tone Adaptation

### MENA Tone
- High-context (implied vs explicit), "we" language, relationship references
- Sequence length: Longer (5-7 touches), Channel priority: WhatsApp > Email > LinkedIn

### US Tone
- Low-context (explicit, direct), "you" language, data-driven
- Sequence length: Shorter (3 emails), Channel priority: Email > LinkedIn

### Germany Tone
- Very low-context (hyper-explicit, structured), formal, evidence-heavy
- Sequence length: Longer (5-7 emails with white papers), Channel priority: Email only

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
**Body**: [Email body with merge fields]
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

**integration-orchestrator** (Patch 2) uses: Asset files, merge field mappings, channel definitions
**culture-adapter** (Patch 3) uses: Generated assets, geographic market

### Upstream Dependencies

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
