<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: campaign-strategist
description: "Aligns Quarterly to Monthly to Weekly to Daily campaign hierarchy for Signal-to-Trust GTM. Use when creating campaign strategy, aligning Q to M to W to D domino effect, narrowing from quarterly theme to weekly wedges, or generating campaign briefs. Ensures each level derives from the one above for compounding impact. Now includes trust engineering thesis alignment, psychological trigger mapping, and vulnerability-arc story architecture."
---

# Campaign Strategist

## Purpose

This sub-skill handles the **strategic alignment** of the complete campaign hierarchy: **Quarterly → Monthly → Weekly → Daily**. It ensures the "domino effect" where each level derives from and amplifies the level above it.

**Core Philosophy**: Compounding impact through hierarchical alignment. Every level narrows from the one above. Every asset activates psychological triggers mapped at the strategy level. Trust engineering thesis runs through everything.

---

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this sub-skill during:
- **Mode A (New Campaign)**: First sub-skill called after questionnaire
- **Mode C (Performance Analysis)**: When evaluating pivot options

Directly invoke when user asks:
- "Create campaign strategy for [ICP]"
- "Align my quarterly theme to monthly wedges"
- "Generate campaign brief for [target]"
- "Plan the campaign hierarchy for [offer]"

---

## Inputs

### Required

1. **ICP** (from Q2 of questionnaire or positioning-engine output)
   - MENA SaaS Founders
   - US Real Estate Brokers
   - MENA Beauty Clinics
   - US eCommerce (DTC)
   - MENA B2B Founders (general: past PMF, broken GTM)
   - Other (custom)

2. **Positioning Document** (from positioning-engine)
   - Core thesis, offer architecture, psychological triggers, mechanism visualization
   - If no positioning-engine output exists, gather: one-liner, ICP, offer, competitive alternatives

3. **Quarterly Feature** (from Q3 of questionnaire)
   - One-sentence outcome-focused positioning
   - Example: "Replace relationship selling with trust engineering in 6 weeks"

4. **Monthly Narrowing Strategy** (from Q4 of questionnaire)
   - A) By ICP segment (vertical focus)
   - B) By feature breakdown (3 sub-wedges)
   - C) By silence type (one silence all month)
   - D) By story arc (vulnerability arc: origin → science → proof)
   - E) Let skill decide based on signal density

5. **Weekly Wedge Strategy** (from Q6 of questionnaire)
   - A) Different angles on same monthly wedge (default)
   - B) Sequential story (Week 1→2→3 builds narrative)
   - C) A/B/C test variants (same core, different psychology)
   - D) Vulnerability arc (mirrors email sequence: failure → confession → proof)

### Optional
- **Existing campaign context** (if continuing from previous month)
- **Signal data** (to inform monthly narrowing if strategy = E)
- **Performance metrics** (if Mode C pivot evaluation)
- **Brand template/colors** (if not using SMOrch defaults)

---

## Outputs

### Campaign Brief (Markdown)

```markdown
# [ICP] - [Monthly Theme] Campaign

## Campaign ID
[Generated unique ID: YYYYMMDD-ICP-THEME]

## Trust Engineering Thesis Alignment
**Core thesis**: [How the trust engineering thesis applies to this ICP]
**Old way (status quo)**: [What they're doing now that's costing them]
**New way (engineered)**: [The systematic replacement]
**Identity threat frame**: [How status quo = losing, specifically for this ICP]

## Psychological Trigger Map
| Trigger | Activation Strategy | Deploy In |
|---------|-------------------|-----------|
| ★ Identity Threat | [Specific framing for this ICP] | All assets |
| ★ Costly Signal | [What proves competence for this audience] | Mid-sequence |
| ★ Temporal Window | [Real urgency mechanism] | CTAs |
| Asymmetric Info | [Insider knowledge angle] | Long-form |
| In-Group/Out-Group | [Who this IS and ISN'T for] | Qualifying |
| Transformation | [Before/after identity shift] | Offer sections |
| Cognitive Fluency | [System visualization] | Visual assets |

## Quarterly Alignment
**Feature**: [Quarterly hammering outcome: one sentence]
**Duration**: [Q1/Q2/Q3/Q4 YYYY]
**Rationale**: [Why this feature for this quarter]

## Monthly Focus
**Theme**: [How we narrowed from quarterly]
**Narrowing Strategy**: [ICP segment / Feature breakdown / Silence type / Story arc / Signal-driven]
**Duration**: [Month YYYY]
**Rationale**: [Why this monthly angle]

## Weekly Wedge Strategy
**Approach**: [Different angles / Sequential story / A/B/C variants / Vulnerability arc]

### Week 1
**Theme**: [One-line wedge theme]
**Story Beat**: [If vulnerability arc: origin/confession/proof]
**Angle**: [Specific angle or story element]
**Primary Trigger**: [Which of 7 triggers dominates]
**Signal Type Priority**: [Trust / Intent]

### Week 2
**Theme**: [One-line wedge theme]
**Story Beat**: [If vulnerability arc: origin/confession/proof]
**Angle**: [Specific angle or story element]
**Primary Trigger**: [Which trigger dominates]
**Signal Type Priority**: [Trust / Intent]

### Week 3
**Theme**: [One-line wedge theme]
**Story Beat**: [If vulnerability arc: origin/confession/proof]
**Angle**: [Specific angle or story element]
**Primary Trigger**: [Which trigger dominates]
**Signal Type Priority**: [Trust / Intent]

## Daily Messaging Focus
**Email sequence**: 3-email vulnerability arc (Day 1, 3, 6)
**LinkedIn DM**: Connect clean + single signal message (A/B test)
**LinkedIn posts**: 3 authority posts mirroring email arc
**Social**: 3 ICP-targeted posts
**VSL**: 5-min full + 1-min short (if campaign pack)
**Tone**: [Based on ICP + geographic market]

## Asset Production Checklist
- [ ] Cold email sequence (3 emails, vulnerability arc)
- [ ] LinkedIn DM messages (A/B variants)
- [ ] LinkedIn authority posts (3, mirroring email arc)
- [ ] Social posts (3, ICP-targeted)
- [ ] VSL scripts (5-min + 1-min)
- [ ] Branded DOCX (outreach sequences)
- [ ] 1-pager PDF
- [ ] Slide deck PPTX
- [ ] Landing page HTML

## Success Metrics
**Primary**: Reply rate target
**Secondary**: Meeting rate target
**Benchmarks**: ICP-specific benchmarks

## Next Steps
- [ ] Call signal-detector to validate prospects
- [ ] Call wedge-generator to create specific wedges
- [ ] Call asset-factory to produce campaign assets
- [ ] Call scoring-orchestrator to quality-gate all assets
```

---

<!-- IP:START - Q-M-W-D alignment logic, vulnerability arc, and domino validation -->
## Alignment Logic

### Quarterly → Monthly (The Narrowing)

**Strategy A: By ICP Segment**
```
Quarterly: "Replace relationship selling with trust engineering"
  ↓
Monthly: "Trust Engineering for MENA SaaS Founders past PMF"
  (Narrowed to: specific ICP vertical + stage)
```

**Strategy B: By Feature Breakdown**
```
Quarterly: "Install Revenue OS in 6 weeks"
  ↓
Monthly Options:
  - "GTM Diagnosis" (weeks 1-2 focus)
  - "Trust-Engine Motion Selection" (weeks 3-4 focus)
  - "AI-Operated Implementation" (weeks 5-6 focus)
  (Narrowed to: one phase of the offer)
```

**Strategy C: By Silence Type**
```
Quarterly: "Compress deal cycles from months to weeks"
  ↓
Monthly: "Proof Silence: They don't believe trust can be engineered"
  (Narrowed to: one of 7 silence types)
```

**Strategy D: By Story Arc (Vulnerability Arc)**
```
Quarterly: "Trust is engineerable. Your coffee meetings are not"
  ↓
Monthly: 3-week vulnerability arc
  - Week 1: Origin story (failure, study, discovery)
  - Week 2: Trust-as-science confession (weakness became edge)
  - Week 3: System proof (AI runs it, here's the evidence)
  (Narrowed to: sequential narrative that mirrors email sequence)
```

**Strategy E: Signal-Driven**
```
Quarterly: "13 trust-engine motions scored to your business"
  ↓
[Analyze signal data]
Monthly: "Signal Sniper Outbound for founders burning cash on SDR teams"
  (Narrowed based on: highest signal density detected)
```

---

### Monthly → Weekly (The Angles)

**Strategy A: Different Angles (Default)**
```
Monthly: "Trust Engineering for MENA SaaS Founders"
  ↓
Week 1: "Your coffee meetings cost 6-12 months per deal" (Identity Threat)
Week 2: "Trust is a science, not a personality trait" (Costly Signal)
Week 3: "AI runs 80% of my GTM. Better." (System Proof)

Each week = different lens on same monthly theme
```

**Strategy B: Sequential Story**
```
Monthly: "Revenue Engineering OS"
  ↓
Week 1: "The failure" (identify problem, build empathy)
Week 2: "The discovery" (amplify insight, build credibility)
Week 3: "The system" (present resolution, build urgency)

Each week = next chapter in narrative arc
```

**Strategy C: A/B/C Variants**
```
Monthly: "Signal-Based Trust Engineering"
  ↓
Week 1: Variant A, B, C (same core, different psychology)
Week 2: Winning variant refined
Week 3: Optimized variant deployed

Each week = iteration on best-performing message
```

**Strategy D: Vulnerability Arc (Recommended for MENA B2B)**
```
Monthly: "Trust is Engineerable"
  ↓
Week 1: Vulnerable Origin (failure → study → cracked it)
  Primary trigger: Identity Threat
Week 2: Confession + Science (weakness became methodology)
  Primary trigger: Identity Threat + Costly Signal
Week 3: System Proof (AI-operated, installed, running)
  Primary trigger: Costly Signal + Temporal Window

Each week = mirrors one email in the 3-email vulnerability arc
All channel assets (email, LinkedIn post, social, DM) align to the week's story beat
```

---

### Weekly → Daily (The Messaging)

Each weekly wedge translates to a coordinated multi-channel push:

| Channel | Structure | Key Rule |
|---------|-----------|----------|
| Cold email | 3-email vulnerability arc (Day 1, 3, 6) | One story arc, not 3 pitches |
| LinkedIn DM | Connect clean + single message (A/B test) | No connection note, ever |
| LinkedIn post | Authority post mirroring week's story beat | 55 chars/line, 150-300 words |
| Social post | ICP-targeted, trigger-activated | 150-210 words, copy-paste ready |
| WhatsApp | 3 psychology variants (MENA only) | Warm channel, not cold outreach |

**Tone adaptation** by ICP + geography:
| Market | Context | Language | Trust Mechanism |
|--------|---------|----------|----------------|
| MENA | High (implied, trust-first) | "We", vulnerability, peer references | Confession + costly signal |
| US | Low (explicit, data-first) | "You", metrics, directness | Data + social proof |

---

## ICP-Specific Considerations

### MENA B2B Founders (Past PMF, Broken GTM)

**Quarterly themes that resonate**:
- Trust engineering vs relationship selling (the replacement thesis)
- AI-operated Revenue OS (founder independence)
- 13 trust-engine motions (methodology as differentiator)

**Monthly narrowing preference**: Story arc (vulnerability arc) or by feature breakdown

**Weekly approach**: Vulnerability arc (origin → confession → proof)

**Daily tone**: Vulnerability-first, peer-to-peer operator energy, "we" language, MENA geographic specificity (Dubai, Riyadh, Gulf budget cycles)

**Key triggers**: Identity Threat (coffee meetings = expensive), Costly Signal (91 companies studied, 20 years, 200+ deals), Temporal Window (Q2 budget cycle)

---

### MENA SaaS Founders (Scaling 10-50 Employees)

**Quarterly themes that resonate**:
- Data consolidation (scattered tools pain)
- Regional distribution (Dubai, Riyadh, Cairo teams)
- Trust-building before product demo

**Monthly narrowing preference**: By ICP segment (vertical-specific)

**Weekly approach**: Different angles (high-context communication requires variety)

**Daily tone**: Relationship-first, "we" language, geographic name-dropping

---

### US Real Estate Brokers

**Quarterly themes that resonate**:
- Speed (Golden Window, 5-minute response)
- Lead leakage (backend nurture, follow-up automation)
- Listing capture (open house optimization)

**Monthly narrowing preference**: By silence type (speed-driven, direct)

**Weekly approach**: Sequential story (builds urgency)

**Daily tone**: Task-first, "you" language, data-driven

---

### MENA Beauty Clinics

**Quarterly themes that resonate**:
- Social follower leakage (Instagram → owned contacts)
- Backend nurture (98% say "I'll think about it")
- Response speed (DM → booking conversion)

**Monthly narrowing preference**: By feature breakdown (visual proof emphasis)

**Weekly approach**: Different angles (trust-building requires variety)

**Daily tone**: Visual-first, proof-heavy, WhatsApp-native

---

## Domino Validation

Before outputting campaign brief, validate domino alignment:

### Test 1: Derivation Check
Can Monthly theme be traced back to Quarterly feature? Can each Weekly wedge be traced back to Monthly theme? Both must pass.

### Test 2: Specificity Increase
Is Monthly more specific than Quarterly? Is Weekly more specific than Monthly? Each level must narrow.

### Test 3: Consistency Check
Do all 3 weekly wedges relate to the same monthly theme (different angles) or form a coherent arc (sequential story / vulnerability arc)?

### Test 4: ICP Resonance
Do themes use ICP-specific language and pain points? Would a founder in this geography feel this speaks to their specific reality?

### Test 5: Trigger Alignment
Does each weekly wedge have a clear primary psychological trigger? Do the 3 weeks together cover all 3 primary triggers (Identity Threat, Costly Signal, Temporal Window)?

### Test 6: Trust Engineering Lens
Does the campaign explicitly frame the status quo as expensive/manual/unscalable and the alternative as engineered/systematic/installable? If the campaign reads like generic outbound, it fails this test.

---

<!-- IP:END -->

## Integration with Other Sub-Skills

### Downstream Dependencies

After campaign-strategist outputs campaign brief:

1. **signal-detector** uses: ICP, signal type priority, to validate prospects and classify signals
2. **wedge-generator** uses: 3 weekly wedge themes, monthly theme, ICP context, to create one-sentence wedges
3. **asset-factory** uses: wedges, channel mix, ICP + tone, psychological trigger map, brand design system, to produce campaign assets
4. **scoring-orchestrator** uses: all produced assets, to quality-gate before deployment

### Upstream Dependencies

**From positioning-engine**: Core thesis, offer architecture, psychological trigger definitions, mechanism visualization
**From meta skill questionnaire**: Q2 (ICP), Q3 (Quarterly Feature), Q4 (Monthly Narrowing), Q6 (Weekly Strategy)

---

## Error Handling

### Error 1: No Positioning Document
**Symptom**: Campaign requested without positioning-engine output
**Fix**: Run positioning-engine first, or at minimum gather: one-liner thesis, ICP definition, competitive alternatives, offer structure

### Error 2: Quarterly Feature Too Vague
**Symptom**: Feature is generic ("improve sales results")
**Fix**: Prompt user for specific outcome with metric. "Improve sales results" → "Replace relationship selling with trust engineering. Compress deal cycles from 6-12 months to weeks"

### Error 3: Monthly Too Similar to Quarterly
**Symptom**: Monthly = Quarterly (no narrowing occurred)
**Fix**: Force narrowing by applying strategy (ICP segment, feature breakdown, silence type, or story arc)

### Error 4: Weekly Wedges Not Related
**Symptom**: 3 weekly wedges address different problems
**Fix**: Realign all 3 to monthly theme (different angles) or restructure as vulnerability arc (origin → confession → proof)

### Error 5: Missing Trigger Mapping
**Symptom**: Campaign brief has no psychological trigger assignments
**Fix**: Map each weekly wedge to a primary trigger. Ensure all 3 primary triggers appear across the 3 weeks

### Error 6: Generic Tone
**Symptom**: Campaign messaging could come from any consultant
**Fix**: Apply trust engineering lens. Add vulnerability hooks, contrarian claims, specific numbers, named tools. If it sounds like every other outbound agency, rewrite

---

## Campaign-Strategist → Asset-Factory Handoff

The campaign brief must include enough detail for asset-factory to produce without re-asking:

| Brief Element | Asset-Factory Uses It For |
|---------------|--------------------------|
| Trust Engineering thesis alignment | Email vulnerability arc framing |
| Psychological trigger map | Trigger deployment per email/post |
| Weekly wedge themes + story beats | Email subjects, LinkedIn hooks, social angles |
| ICP context + tone | Geographic adaptation, language choices |
| Mechanism visualization | VSL script, landing page, deck system diagram |
| Brand template (or "use default") | DOCX, PDF, PPTX, HTML color/font system |
| Success metrics | Scoring targets, performance benchmarks |

**Output**: Production-ready campaign brief that orchestrates all downstream sub-skills.

Next: Pass campaign brief to signal-detector for prospect validation, then wedge-generator for specific wedges, then asset-factory for production.
