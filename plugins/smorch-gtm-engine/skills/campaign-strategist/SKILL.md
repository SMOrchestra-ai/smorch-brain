---
name: campaign-strategist
description: "Aligns Quarterly to Monthly to Weekly to Daily campaign hierarchy for Signal-to-Trust GTM. Use when creating campaign strategy, aligning Q to M to W to D domino effect, narrowing from quarterly theme to weekly wedges, or generating campaign briefs. Ensures each level derives from the one above for compounding impact."
---

# Campaign Strategist

## Purpose

This sub-skill handles the **strategic alignment** of the complete campaign hierarchy: **Quarterly → Monthly → Weekly → Daily**. It ensures the "domino effect" where each level derives from and amplifies the level above it.

**Core Philosophy**: Compounding impact through hierarchical alignment.

---

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this sub-skill during:
- **Mode A (New Campaign)**: First sub-skill called after questionnaire
- **Mode C (Performance Analysis)**: When evaluating pivot options

Directly invoke when user asks:
- "Create campaign strategy for [ICP]"
- "Align my quarterly theme to monthly wedges"
- "Generate campaign brief for [target]"

---

## Inputs

### Required
1. **ICP** (from Q2 of questionnaire)
   - MENA SaaS Founders
   - US Real Estate Brokers
   - MENA Beauty Clinics
   - US eCommerce (DTC)
   - Other (custom)

2. **Quarterly Feature** (from Q3 of questionnaire)
   - One-sentence outcome-focused positioning
   - Example: "Capture 8x more revenue per contact than social followers"

3. **Monthly Narrowing Strategy** (from Q4 of questionnaire)
   - A) By ICP segment (vertical focus)
   - B) By feature breakdown (3 sub-wedges)
   - C) By silence type (one silence all month)
   - D) Let skill decide based on signal density

4. **Weekly Wedge Strategy** (from Q6 of questionnaire)
   - A) Different angles on same monthly wedge (default)
   - B) Sequential story (Week 1→2→3 builds narrative)
   - C) A/B/C test variants (same core, different psychology)

### Optional
- **Existing campaign context** (if continuing from previous month)
- **Signal data** (to inform monthly narrowing if strategy = D)
- **Performance metrics** (if Mode C pivot evaluation)

---

## Outputs

### Campaign Brief (Markdown)

```markdown
# [ICP] - [Monthly Theme] Campaign

## Campaign ID
[Generated unique ID: YYYYMMDD-ICP-THEME]

## Quarterly Alignment
**Feature**: [Quarterly hammering outcome - one sentence]
**Duration**: [Q1/Q2/Q3/Q4 YYYY]
**Rationale**: [Why this feature for this quarter]

## Monthly Focus
**Theme**: [How we narrowed from quarterly]
**Narrowing Strategy**: [ICP segment / Feature breakdown / Silence type / Signal-driven]
**Duration**: [Month YYYY]
**Rationale**: [Why this monthly angle]

## Weekly Wedge Strategy
**Approach**: [Different angles / Sequential story / A/B/C variants]

### Week 1
**Theme**: [One-line wedge theme]
**Angle**: [Specific angle or story element]
**Signal Type Priority**: [Trust / Intent]

### Week 2
**Theme**: [One-line wedge theme]
**Angle**: [Specific angle or story element]
**Signal Type Priority**: [Trust / Intent]

### Week 3
**Theme**: [One-line wedge theme]
**Angle**: [Specific angle or story element]
**Signal Type Priority**: [Trust / Intent]

## Daily Messaging Focus
**Sequence Type**: [Email / LinkedIn / WhatsApp]
**Cadence**: [Day 1, 3, 6 / Custom]
**Tone**: [Based on ICP + geographic market]

## Success Metrics
**Primary**: [Reply rate target]
**Secondary**: [Meeting rate target]
**Benchmarks**: [ICP-specific benchmarks]

## Next Steps
- [ ] Call signal-detector to validate prospects
- [ ] Call wedge-generator to create specific wedges
- [ ] Call asset-factory to produce sequences
```

---

## Alignment Logic

### Quarterly → Monthly (The Narrowing)

**Strategy A: By ICP Segment**
```
Quarterly: "Capture 8x more revenue per contact than social followers"
  ↓
Monthly: "Instagram Follower Leakage for Beauty Clinics"
  (Narrowed to: specific ICP vertical)
```

**Strategy B: By Feature Breakdown**
```
Quarterly: "Capture 8x ROI"
  ↓
Monthly Options:
  - "8x Capture" (capture mechanism focus)
  - "20x Golden Window" (response speed focus)
  - "50x Backend Nurture" (nurture automation focus)
  (Narrowed to: one sub-feature)
```

**Strategy C: By Silence Type**
```
Quarterly: "Consolidate scattered sales data"
  ↓
Monthly: "Proof Silence - Data Fragmentation Crisis"
  (Narrowed to: one of 7 silence types)
```

**Strategy D: Signal-Driven**
```
Quarterly: "Respond within 5 minutes for 21x conversion"
  ↓
[Analyze signal data]
Monthly: "Golden Window for Mobile Buyers"
  (Narrowed based on: highest signal density detected)
```

---

### Monthly → Weekly (The Angles)

**Strategy A: Different Angles (Default)**
```
Monthly: "Instagram Follower Leakage"
  ↓
Week 1: "Rented Land Risk" (platform dependency angle)
Week 2: "8x Revenue Gap" (quantified opportunity cost)
Week 3: "Capture Infrastructure" (solution mechanism)

Each week = different lens on same monthly theme
```

**Strategy B: Sequential Story**
```
Monthly: "Data Fragmentation Crisis"
  ↓
Week 1: "The Scattered State" (identify problem)
Week 2: "The Hidden Cost" (amplify pain)
Week 3: "The Unified Solution" (present resolution)

Each week = next chapter in narrative arc
```

**Strategy C: A/B/C Variants**
```
Monthly: "Golden Window Response Speed"
  ↓
Week 1: Variant A, B, C (same core message, different psychology)
Week 2: Winning variant refined with A/B
Week 3: Optimized variant deployed

Each week = iteration on best-performing message
```

---

### Weekly → Daily (The Messaging)

**Daily level = specific message sequences**

Each weekly wedge translates to:
- **3 emails** (Day 1, 3, 6 or custom cadence)
- **2 LinkedIn messages** (connection request + follow-up)
- **1 WhatsApp sequence** (3 variants: A/B/C psychology)
- **1 social post** (LinkedIn/Twitter for visibility)

**Tone adaptation** by ICP + geography:
- MENA: High-context, relationship-first, collective language
- US: Low-context, task-first, individual language
- Germany: Very low-context, principles-first, formal language

---

## ICP-Specific Considerations

### MENA SaaS Founders
**Quarterly themes that resonate**:
- Data consolidation (scattered tools pain)
- Regional distribution (Dubai, Riyadh, Cairo teams)
- Trust-building (proof before product)

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

### US eCommerce (DTC)
**Quarterly themes that resonate**:
- Checkout friction (cart abandonment)
- Email list ROI (owned vs paid traffic)
- Mobile optimization (conversion gaps)

**Monthly narrowing preference**: By silence type (friction-focused)

**Weekly approach**: A/B/C variants (fast optimization)

**Daily tone**: Data-first, conversion-focused, mobile-optimized

---

## Domino Validation

Before outputting campaign brief, validate domino alignment:

### Test 1: Derivation Check
```
Can Monthly theme be traced back to Quarterly feature?
  ✓ YES → Aligned
  ✗ NO → Monthly is off-track, revise

Can each Weekly wedge be traced back to Monthly theme?
  ✓ YES → Aligned
  ✗ NO → Weekly wedges are disconnected, revise
```

### Test 2: Specificity Increase
```
Is Monthly more specific than Quarterly?
  ✓ YES → Proper narrowing
  ✗ NO → Monthly too broad, narrow further

Is Weekly more specific than Monthly?
  ✓ YES → Proper narrowing
  ✗ NO → Weekly too generic, narrow further
```

### Test 3: Consistency Check
```
Do all 3 weekly wedges relate to the same monthly theme?
  ✓ YES → Consistent strategy
  ✗ NO → Weekly wedges are fragmented, realign
```

### Test 4: ICP Resonance
```
Do themes use ICP-specific language and pain points?
  ✓ YES → Will resonate
  ✗ NO → Too generic, add ICP context
```

---

## Examples

### Example 1: MENA SaaS - Proof Silence

**Input**:
- ICP: MENA SaaS Founders
- Quarterly Feature: "Consolidate scattered sales data into unified dashboard"
- Monthly Narrowing: By silence type (Proof Silence)
- Weekly Strategy: Different angles

**Output**:
```markdown
# MENA SaaS Founders - Proof Silence (Data Fragmentation) Campaign

## Campaign ID
20260211-MENA-SAAS-PROOF-SILENCE

## Quarterly Alignment
**Feature**: Consolidate scattered sales data into unified dashboard
**Duration**: Q1 2026
**Rationale**: MENA SaaS founders scaling from 5-50 employees consistently face data fragmentation across HubSpot, Pipedrive, Notion, spreadsheets. Unified visibility = predictable revenue.

## Monthly Focus
**Theme**: Proof Silence - Data Fragmentation Crisis
**Narrowing Strategy**: By silence type (Proof)
**Duration**: February 2026
**Rationale**: They understand the problem (scattered data) but don't believe consolidation is achievable. Need proof from MENA peers to build trust.

## Weekly Wedge Strategy
**Approach**: Different angles on same monthly theme

### Week 1
**Theme**: "Your sales data lives in 7 different tools. Decision paralysis is costing you deals."
**Angle**: Identify the problem (scattered state)
**Signal Type Priority**: Intent (active pain)

### Week 2
**Theme**: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."
**Angle**: Amplify the cost (visibility loss)
**Signal Type Priority**: Intent (outcome focus)

### Week 3
**Theme**: "5 MENA SaaS founders unified their stack. They closed 40% more deals."
**Angle**: Provide proof (peer validation)
**Signal Type Priority**: Trust (community proof)

## Daily Messaging Focus
**Sequence Type**: Email + LinkedIn + WhatsApp (MENA multi-channel)
**Cadence**: Day 1, 3, 6 (relationship-building pace)
**Tone**: High-context, relationship-first, "we" language, geographic mentions (Dubai, Riyadh)

## Success Metrics
**Primary**: Reply rate >6.2% (MENA SaaS benchmark)
**Secondary**: Meeting rate >0.8%
**Benchmarks**: MENA SaaS average = 6.2% reply, 0.8% meeting

## Next Steps
- [ ] Call signal-detector to validate MENA SaaS Fit criteria
- [ ] Call wedge-generator to create 3 specific one-sentence wedges
- [ ] Call asset-factory to produce 42 assets (18 emails, 12 LinkedIn, 9 WhatsApp, 3 social)
```

**Domino Validation**:
- ✓ Monthly traces to Quarterly (consolidation → proof of consolidation)
- ✓ Weekly traces to Monthly (all 3 wedges about data fragmentation)
- ✓ Specificity increases (Q: consolidation → M: proof silence → W: specific angles)
- ✓ ICP resonance (MENA language, trust-building, peer proof)

---

### Example 2: US Real Estate - Response Silence

**Input**:
- ICP: US Real Estate Brokers
- Quarterly Feature: "Respond within 5 minutes for 21x higher conversion"
- Monthly Narrowing: By silence type (Response Silence)
- Weekly Strategy: Sequential story

**Output**:
```markdown
# US Real Estate Brokers - Response Silence (Golden Window) Campaign

## Campaign ID
20260211-US-REALESTATE-RESPONSE-SILENCE

## Quarterly Alignment
**Feature**: Respond within 5 minutes for 21x higher conversion
**Duration**: Q1 2026
**Rationale**: US brokers with 10-100 agents lose deals to competitors who respond faster. Speed = competitive advantage in tight markets.

## Monthly Focus
**Theme**: Response Silence - Golden Window Lost
**Narrowing Strategy**: By silence type (Response)
**Duration**: February 2026
**Rationale**: They know they should respond fast but don't realize 21x conversion difference between <5 min vs >30 min. Need urgency.

## Weekly Wedge Strategy
**Approach**: Sequential story (Week 1→2→3 builds urgency)

### Week 1
**Theme**: "Your lead fills a form at 2pm. You reply at 5pm. They booked with someone else at 2:07pm."
**Angle**: The invisible loss (story opening)
**Signal Type Priority**: Intent (immediate pain)

### Week 2
**Theme**: "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."
**Angle**: The quantified gap (data reveal)
**Signal Type Priority**: Intent (outcome focus)

### Week 3
**Theme**: "Instant auto-reply + mobile notifications = never miss the Golden Window."
**Angle**: The solution (resolution)
**Signal Type Priority**: Intent (solution-seeking)

## Daily Messaging Focus
**Sequence Type**: Email + LinkedIn (US direct channels)
**Cadence**: Day 1, 3, 6 (fast-paced, urgency-driven)
**Tone**: Low-context, task-first, "you" language, data-driven

## Success Metrics
**Primary**: Reply rate >4.5% (US Real Estate benchmark)
**Secondary**: Meeting rate >1.2%
**Benchmarks**: US Real Estate average = 4.5% reply, 1.2% meeting

## Next Steps
- [ ] Call signal-detector to validate US Real Estate Fit criteria
- [ ] Call wedge-generator to create 3 specific one-sentence wedges
- [ ] Call asset-factory to produce 36 assets (18 emails, 12 LinkedIn, 3 social - no WhatsApp for US)
```

**Domino Validation**:
- ✓ Monthly traces to Quarterly (5-min response → response silence)
- ✓ Weekly traces to Monthly (all 3 about response speed)
- ✓ Specificity increases (Q: speed → M: response silence → W: sequential story)
- ✓ ICP resonance (US language, urgency, data-driven)

---

## Integration with Other Sub-Skills

### Downstream Dependencies

After campaign-strategist outputs campaign brief:

1. **signal-detector** uses:
   - ICP from campaign brief
   - Signal Type Priority from weekly wedges
   - To validate prospects and classify signals

2. **wedge-generator** uses:
   - 3 weekly wedge themes
   - Monthly theme
   - ICP context
   - To create one-sentence wedges

3. **asset-factory** uses:
   - 3 weekly wedges (once generated by wedge-generator)
   - Channel mix (from questionnaire)
   - ICP + tone guidance
   - To produce 42 assets

### Upstream Dependencies

**Inputs from meta skill questionnaire**:
- Q2: ICP Selection
- Q3: Quarterly Feature
- Q4: Monthly Narrowing Strategy
- Q6: Weekly Wedge Strategy

---

## Error Handling

### Error 1: Quarterly Feature Too Vague
**Symptom**: Feature is generic ("improve sales results")
**Fix**: Prompt user for specific outcome with metric
**Example**: "Improve sales results" → "Respond within 5 minutes for 21x higher conversion"

### Error 2: Monthly Too Similar to Quarterly
**Symptom**: Monthly = Quarterly (no narrowing occurred)
**Fix**: Force narrowing by applying strategy (ICP segment, feature breakdown, silence type)
**Example**: Q="Capture 8x ROI", M="Capture 8x ROI" → M="Instagram Follower Leakage for Beauty Clinics"

### Error 3: Weekly Wedges Not Related
**Symptom**: 3 weekly wedges address different problems
**Fix**: Realign all 3 to monthly theme, just different angles
**Example**: Week 1="Data scattered", Week 2="Slow response", Week 3="No proof" → All should focus on ONE monthly theme

### Error 4: ICP Mismatch
**Symptom**: Themes don't resonate with selected ICP
**Fix**: Replace with ICP-specific pain points and language
**Example**: MENA SaaS with US-style direct messaging → Add relationship-building, trust-first tone

---

## Conclusion

The campaign-strategist sub-skill ensures:
1. **Hierarchical alignment** (Q→M→W→D domino effect)
2. **Strategic narrowing** (each level more specific than above)
3. **ICP resonance** (themes match target audience pain points)
4. **Consistency** (all weekly wedges relate to monthly theme)

**Output**: Production-ready campaign brief that orchestrates all downstream sub-skills.

Next: Pass campaign brief to signal-detector for prospect validation.
