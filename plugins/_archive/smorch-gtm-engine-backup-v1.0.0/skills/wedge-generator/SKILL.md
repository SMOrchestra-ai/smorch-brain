<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: wedge-generator
description: Creates one-sentence wedges from validated signals using ICP-specific templates. Enforces Hard Stop Rules 3 and 4 (one-sentence test, Intent>Trust). Use when generating wedges from signals, creating weekly messaging themes, or refining wedges based on performance. Outputs 3 validated weekly wedges ready for asset production.
---

# Wedge Generator

## Purpose

This sub-skill transforms **validated signals** into **precise, one-sentence wedges** that form the foundation of all campaign messaging. It's the creative heart of the Signal-to-Trust framework.

**Core Philosophy**: Every wedge must be signal-specific, ICP-resonant, and passable in one sentence.

**Reference Files:**
- [wedge-templates.md](wedge-templates.md) - ICP-specific templates, validation logic, geographic adaptation, strategy execution, examples

---

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this sub-skill during:
- **Mode A (New Campaign)**: Third sub-skill called (after signal-detector)
- **Mode B (Weekly Assets)**: When refining wedges based on performance
- **Mode D (One-Off Task)**: When user requests "Generate wedge" or "Create messaging theme"

Directly invoke when user asks:
- "Create wedges from these signals"
- "Generate messaging for [signal]"
- "Refine this wedge with A/B variants"
- "Turn this LinkedIn post into a wedge"

---

## Inputs

### Required

1. **Validated Signal Data** (from signal-detector)
   - Signal Type (Trust / Intent), Signal Subtype, Signal text, Prospect ICP

2. **Monthly Theme** (from campaign-strategist)
   - One-line monthly wedge theme

3. **Weekly Wedge Strategy** (from campaign-strategist)
   - A) Different angles (default) / B) Sequential story / C) A/B/C variants

4. **ICP Context**
   - MENA SaaS Founders / US Real Estate Brokers / MENA Beauty Clinics / US eCommerce

### Optional
- Performance data (if Mode B), existing wedges (for A/B variants), geographic market

---

## Outputs

### 3 Weekly Wedges (Validated)

```markdown
## Weekly Wedges - [Campaign Name]

### Week 1 Wedge
**Wedge**: "[One-sentence wedge]"
**Signal Source**: [Intent/Trust: Subtype]
**ICP**: [Target ICP]
**Angle**: [Identify problem / Amplify pain / Provide solution / etc.]
**Validation**:
  - One-sentence test: PASS
  - No hedging: PASS
  - Specific (not vague): PASS
  - ICP resonance: PASS

### Week 2 Wedge
[Same format]

### Week 3 Wedge
[Same format]

## Hard Stop Rules Applied
- Rule 3 (One-sentence test): All wedges pass
- Rule 4 (Intent > Trust): Applied where both present
```

---

## Wedge Creation Logic

### Core Formula (from wedge-sentence-map.md)

```
[Observed Signal] is costing you [Specific Outcome]. [One-Line Solution].
```

**Variations**:
- Problem-focused: "[Signal] is creating [Pain]. [Solution] is the fix."
- Outcome-focused: "[Current State] generates [Low Metric]. [Better State] generates [High Metric]. That's [X]x ROI."
- Proof-focused: "[X Peers] faced [Signal]. After [Solution], they achieved [Outcome]."

For complete ICP-specific templates (MENA SaaS, US Real Estate, MENA Beauty Clinics, US eCommerce), see [wedge-templates.md](wedge-templates.md).

---

## Hard Stop Rules

### Rule 3: One-Sentence Test

Every wedge must pass 4 checks before output:
1. **Single sentence** (no multi-sentence wedges)
2. **No hedging** ("might", "could", "possibly", "perhaps", "maybe", "potentially")
3. **No vague language** ("better results", "improvement", "optimization")
4. **Specificity required** (must include numbers, %, $, or Xx multipliers)

See [wedge-templates.md](wedge-templates.md) for the full validation code and PASS/FAIL examples.

### Rule 4: Intent > Trust

When both Intent and Trust signals are available for a prospect, always use the Intent signal. Intent shows active pain (right now). Trust shows thought leadership (passive).

---

## Weekly Wedge Strategies

### Strategy A: Different Angles (Default)
3 wedges that each approach the monthly theme from a different lens:
- Week 1: Identify problem
- Week 2: Amplify cost
- Week 3: Provide proof

### Strategy B: Sequential Story
3 wedges that build a narrative arc:
- Week 1: Story opening (the invisible loss)
- Week 2: Data reveal (the quantified gap)
- Week 3: Resolution (the solution)

### Strategy C: A/B/C Variants
3 variants of the same core message with different psychology:
- Variant A: Data-driven
- Variant B: Story-driven
- Variant C: Peer-driven

Week 2 refines the winning variant. Week 3 deploys the optimized version.

---

## Geographic Adaptation

Wedges must be adapted to the target market's communication style:
- **MENA**: Add relationship references, soften directness, use "we" framing, imply outcomes
- **US**: Direct problem statement, specific data, clear outcome, no softening
- **Germany**: Formal language, statistical significance, principle-first reasoning

See [wedge-templates.md](wedge-templates.md) for adaptation examples.

---

## Integration with Other Sub-Skills

### Downstream Dependencies

After wedge-generator outputs 3 validated wedges:

**asset-factory** uses:
- 3 weekly wedges (exact text)
- ICP context
- Geographic market
- Channel mix
- To produce 42 assets (18 emails, 12 LinkedIn, 9 WhatsApp, 3 social)

### Upstream Dependencies

1. **signal-detector**: Validated signals (Fit PASS, Fresh, Trust/Intent classified)
2. **campaign-strategist**: Monthly theme, weekly strategy, ICP context
3. **wedge-sentence-map.md**: ICP-specific templates

---

## Error Handling

| Error | Symptom | Fix |
|-------|---------|-----|
| Fails one-sentence test | Multiple sentences needed | Narrow signal focus, remove complexity |
| No Intent signals | Only Trust signals available | Use Trust signals, note lower priority |
| Too generic | Lacks ICP-specific language | Add geography, vertical, specific pain |
| Wedges not related | 3 wedges address different problems | Realign all 3 to monthly theme |

---

## Conclusion

The wedge-generator sub-skill ensures:
1. **Signal-specific wedges** (not generic value props)
2. **One-sentence clarity** (Hard Stop Rule 3)
3. **Intent prioritization** (Hard Stop Rule 4)
4. **ICP resonance** (templates + language)
5. **Weekly consistency** (all 3 relate to monthly theme)

**Output**: 3 validated, one-sentence wedges ready to power 42 multi-channel assets.

Next: Pass 3 wedges to asset-factory for email, LinkedIn, WhatsApp, and social production.
