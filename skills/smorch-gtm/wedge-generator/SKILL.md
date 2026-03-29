<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: wedge-generator
description: "Creates one-sentence wedges from validated signals using ICP-specific templates. Enforces Hard Stop Rules 3 and 4 (one-sentence test, Intent greater than Trust). Use when generating wedges from signals, creating weekly messaging themes, or refining wedges based on performance. Outputs 3 validated weekly wedges ready for asset production."
---

# Wedge Generator

## Purpose

Transforms validated signals into precise, one-sentence wedges that form the foundation of all campaign messaging.

**Core Philosophy**: Every wedge must be signal-specific, ICP-resonant, and pass the one-sentence test.

## When to Call This Skill

Called by `signal-to-trust-gtm` during:
- **Mode A**: Third sub-skill (after signal-detector)
- **Mode B**: Refining wedges based on performance data
- **Mode D**: Direct "Generate wedge" or "Create messaging theme"

Direct invoke: "Create wedges from signals", "Generate messaging for [signal]", "Refine wedge with A/B variants"

## Inputs

### Required
1. **Validated Signal Data** (from signal-detector): Signal Type (Trust/Intent), Subtype, raw text, prospect ICP
2. **Monthly Theme** (from campaign-strategist): One-line theme, e.g. "Data Fragmentation Crisis"
3. **Weekly Strategy** (from campaign-strategist): A) Different angles (default) | B) Sequential story | C) A/B/C variants
4. **ICP Context**: MENA SaaS | US Real Estate | MENA Beauty Clinics | US eCommerce

### Optional
- Performance data (winning wedge from previous week)
- Geographic market override (Q10)
- Custom wedge templates

## Outputs

```markdown
# Weekly Wedges - [Campaign Name]
**Monthly Theme**: [theme]
**Strategy**: [A/B/C]
**ICP**: [target]

## Week 1: [Wedge sentence]
- Angle: [problem identification / cost amplification / peer proof]
- Signal source: [Intent/Trust]: [Subtype]
- Validation: One-sentence ✓ | Specificity ✓ | ICP resonance ✓

## Week 2: [Wedge sentence]
[same structure]

## Week 3: [Wedge sentence]
[same structure]

## Hard Stop Rules Applied
- Rule 3 (One-sentence test): ✓ | Rule 4 (Intent > Trust): ✓
```

<!-- IP:START - Wedge formula, hard stop rules, and weekly strategies -->
## Core Wedge Formula

```
[Observed Signal] is costing you [Specific Outcome]. [One-Line Solution].
```

**Variations**:
- Problem-focused: "[Signal] is creating [Pain]. [Solution] is the fix."
- Outcome-focused: "[Current State] generates [Low Metric]. [Better State] generates [High Metric]. That's [X]x ROI."
- Proof-focused: "[X Peers] faced [Signal]. After [Solution], they achieved [Outcome]."

**Full ICP-specific templates**: Read `references/wedge-templates-by-icp.md`

## Hard Stop Rules

### Rule 3: One-Sentence Test
Every wedge must pass 4 checks:
1. **Single sentence** (max 1 period/exclamation/question mark)
2. **No hedging** ("might", "could", "possibly", "perhaps")
3. **No vague language** ("better results", "improvement", "optimization")
4. **Contains specifics** (numbers, %, $, Xx multiplier)

**PASS**: "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."
**FAIL**: "You might be considering CRM alternatives. We could potentially help." (hedging)
**FAIL**: "You want better sales results." (vague, no specifics)

### Rule 4: Intent > Trust
When both signal types present for a prospect, Intent takes priority (active pain > passive engagement).

**Full validation logic and examples**: Read `references/hard-stop-rules-detail.md`

## Weekly Wedge Strategies

### Strategy A: Different Angles (Default)
3 wedges from same monthly theme, each hitting different angle: identify problem → amplify cost → provide proof

### Strategy B: Sequential Story
3 wedges building narrative arc: story opening → data reveal → resolution

### Strategy C: A/B/C Variants
Same week, 3 psychology variants: data-driven → story-driven → peer-driven

**Full strategy execution examples with geographic adaptation**: Read `references/strategy-and-adaptation.md`

<!-- IP:END -->

## Error Handling

| Error | Fix |
|-------|-----|
| Wedge fails one-sentence test | Narrow signal focus, remove complexity |
| No Intent signals available | Use Trust signals, note lower priority |
| Wedge too generic | Add ICP context (geography, vertical, specific pain) |
| Weekly wedges unrelated | Realign all 3 to monthly theme |

## Integration

**Upstream**: signal-detector (validated signals), campaign-strategist (monthly theme, strategy), wedge-sentence-map.md (templates)
**Downstream**: asset-factory (3 wedges → 42 multi-channel assets)

## Reference Files

| File | Content |
|------|---------|
| `references/wedge-templates-by-icp.md` | Full templates for MENA SaaS, US RE, Beauty Clinics, eCommerce |
| `references/hard-stop-rules-detail.md` | Python validation code, Intent>Trust priority logic |
| `references/strategy-and-adaptation.md` | Strategy A/B/C execution + MENA/US/Germany geographic adaptation |
| `references/wedge-examples.md` | 2 worked examples (MENA Intent, US RE multi-signal) |
