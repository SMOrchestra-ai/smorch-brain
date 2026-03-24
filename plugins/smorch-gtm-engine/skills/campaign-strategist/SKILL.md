---
name: campaign-strategist
description: Aligns Quarterly -> Monthly -> Weekly -> Daily campaign hierarchy for Signal-to-Trust GTM. Use when creating campaign strategy, aligning Q->M->W->D domino effect, narrowing from quarterly theme to weekly wedges, or generating campaign briefs. Ensures each level derives from the one above for compounding impact.
---

# Campaign Strategist

## Purpose

This sub-skill handles the **strategic alignment** of the complete campaign hierarchy: **Quarterly -> Monthly -> Weekly -> Daily**. It ensures the "domino effect" where each level derives from and amplifies the level above it.

**Core Philosophy**: Compounding impact through hierarchical alignment.

**Reference Files:**
- [examples.md](examples.md) - ICP-specific considerations, full campaign examples, error handling

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
   - MENA SaaS Founders / US Real Estate Brokers / MENA Beauty Clinics / US eCommerce (DTC) / Other (custom)

2. **Quarterly Feature** (from Q3 of questionnaire)
   - One-sentence outcome-focused positioning

3. **Monthly Narrowing Strategy** (from Q4 of questionnaire)
   - A) By ICP segment (vertical focus)
   - B) By feature breakdown (3 sub-wedges)
   - C) By silence type (one silence all month)
   - D) Let skill decide based on signal density

4. **Weekly Wedge Strategy** (from Q6 of questionnaire)
   - A) Different angles on same monthly wedge (default)
   - B) Sequential story (Week 1->2->3 builds narrative)
   - C) A/B/C test variants (same core, different psychology)

### Optional
- Existing campaign context, signal data, performance metrics (if Mode C)

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
[Same format]

### Week 3
[Same format]

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

### Quarterly -> Monthly (The Narrowing)

**Strategy A: By ICP Segment**
```
Quarterly: "Capture 8x more revenue per contact than social followers"
  -> Monthly: "Instagram Follower Leakage for Beauty Clinics"
```

**Strategy B: By Feature Breakdown**
```
Quarterly: "Capture 8x ROI"
  -> Monthly Options: "8x Capture" / "20x Golden Window" / "50x Backend Nurture"
```

**Strategy C: By Silence Type**
```
Quarterly: "Consolidate scattered sales data"
  -> Monthly: "Proof Silence - Data Fragmentation Crisis"
```

**Strategy D: Signal-Driven**
```
Quarterly: "Respond within 5 minutes for 21x conversion"
  -> [Analyze signal data]
  -> Monthly: "Golden Window for Mobile Buyers"
```

### Monthly -> Weekly (The Angles)

**Strategy A: Different Angles (Default)**
```
Monthly: "Instagram Follower Leakage"
  -> Week 1: "Rented Land Risk" (platform dependency)
  -> Week 2: "8x Revenue Gap" (quantified opportunity cost)
  -> Week 3: "Capture Infrastructure" (solution mechanism)
```

**Strategy B: Sequential Story**
```
Monthly: "Data Fragmentation Crisis"
  -> Week 1: "The Scattered State" (identify problem)
  -> Week 2: "The Hidden Cost" (amplify pain)
  -> Week 3: "The Unified Solution" (present resolution)
```

**Strategy C: A/B/C Variants**
```
Monthly: "Golden Window Response Speed"
  -> Week 1: Variant A, B, C (same core, different psychology)
  -> Week 2: Winning variant refined
  -> Week 3: Optimized variant deployed
```

### Weekly -> Daily (The Messaging)

Each weekly wedge translates to:
- **3 emails** (Day 1, 3, 6 or custom cadence)
- **2 LinkedIn messages** (connection request + follow-up)
- **1 WhatsApp sequence** (3 variants: A/B/C psychology)
- **1 social post** (LinkedIn/Twitter for visibility)

**Tone adaptation** by ICP + geography:
- MENA: High-context, relationship-first, collective language
- US: Low-context, task-first, individual language
- Germany: Very low-context, principles-first, formal language

For ICP-specific quarterly themes, monthly preferences, weekly approaches, and daily tone guidelines, see [examples.md](examples.md).

---

## Domino Validation

Before outputting campaign brief, validate domino alignment:

### Test 1: Derivation Check
Can Monthly theme be traced back to Quarterly feature? Can each Weekly wedge be traced back to Monthly theme?

### Test 2: Specificity Increase
Is Monthly more specific than Quarterly? Is Weekly more specific than Monthly?

### Test 3: Consistency Check
Do all 3 weekly wedges relate to the same monthly theme?

### Test 4: ICP Resonance
Do themes use ICP-specific language and pain points?

If any test fails, revise the failing level before outputting.

---

## Integration with Other Sub-Skills

### Downstream Dependencies

After campaign-strategist outputs campaign brief:

1. **signal-detector** uses: ICP from campaign brief, Signal Type Priority from weekly wedges
2. **wedge-generator** uses: 3 weekly wedge themes, Monthly theme, ICP context
3. **asset-factory** uses: 3 weekly wedges, Channel mix, ICP + tone guidance

### Upstream Dependencies

**Inputs from meta skill questionnaire**: Q2 (ICP), Q3 (Quarterly Feature), Q4 (Monthly Narrowing), Q6 (Weekly Wedge Strategy)

---

## Conclusion

The campaign-strategist sub-skill ensures:
1. **Hierarchical alignment** (Q->M->W->D domino effect)
2. **Strategic narrowing** (each level more specific than above)
3. **ICP resonance** (themes match target audience pain points)
4. **Consistency** (all weekly wedges relate to monthly theme)

**Output**: Production-ready campaign brief that orchestrates all downstream sub-skills.

Next: Pass campaign brief to signal-detector for prospect validation.
