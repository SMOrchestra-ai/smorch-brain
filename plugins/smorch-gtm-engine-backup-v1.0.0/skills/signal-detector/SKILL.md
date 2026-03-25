---
name: signal-detector
description: Validates ICP Fit criteria and classifies signals (Trust vs Intent) for Signal-to-Trust GTM campaigns. Enforces Hard Stop Rules 1 and 2 (Fit=Fail, Signal>90d). Use when validating prospects, detecting buying signals, classifying Trust vs Intent signals, or filtering prospect lists. Outputs validated prospects (Fit PASS only) with signal taxonomy.
---

# Signal Detector

## Purpose

This sub-skill is the **quality gatekeeper** for Signal-to-Trust GTM campaigns. It performs two critical functions:

1. **Fit Validation**: Enforces Hard Stop Rule 1 (Fit = FAIL -> No Outreach)
2. **Signal Classification**: Identifies Trust vs Intent signals and validates freshness (Hard Stop Rule 2: Signal > 90 days)

**Core Philosophy**: Quality over quantity. Only Fit PASS prospects with fresh signals proceed to campaign.

**Reference Files:**
- [fit-criteria.md](fit-criteria.md) - ICP-specific fit validation code, signal classification patterns, signal age validation, examples

---

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this sub-skill during:
- **Mode A (New Campaign)**: Second sub-skill called (after campaign-strategist)
- **Mode D (One-Off Task)**: When user requests "Validate signals" or "Check Fit criteria"

Directly invoke when user asks:
- "Validate these prospects against Fit criteria"
- "Classify these signals as Trust or Intent"
- "Check if these signals are fresh enough"
- "Filter my prospect list for [ICP]"

---

## Inputs

### Required

1. **Prospect List** (CSV, JSON, or structured data)
   - Minimum fields: Company name, industry, company size, geography
   - Optional fields: Revenue, tech stack, LinkedIn URL, signal data

2. **ICP Fit Criteria** (from campaign brief or meta skill Q2)
   - MENA SaaS Founders / US Real Estate Brokers / MENA Beauty Clinics / US eCommerce (DTC) / Custom

3. **Signal Data** (if available)
   - Signal text, signal timestamp, signal source

### Optional
- Signal age threshold (default: 90 days)
- Fit tolerance (strict vs lenient for edge cases)

---

## Outputs

### 1. Validation Summary

```markdown
## Signal Detection Report
**Run Date**: [YYYY-MM-DD]
**ICP**: [Target ICP]
**Total Prospects Analyzed**: [N]

### Fit Validation Results
- **Fit PASS**: [N] prospects ([%])
- **Fit FAIL**: [N] prospects ([%])

#### Fit Failure Breakdown
- Company size out of range: [N]
- Wrong geography: [N]
- Wrong industry: [N]
- Revenue out of range: [N]
- Other: [N]

### Signal Classification Results (Fit PASS only)
- **Intent Signals**: [N] prospects ([%])
- **Trust Signals**: [N] prospects ([%])
- **No Signal Detected**: [N] prospects ([%])

### Signal Age Validation
- **Fresh (<90 days)**: [N] signals ([%])
- **Stale (>90 days)**: [N] signals ([%]) - EXCLUDED

### Final Output
- **Prospects Proceeding to Campaign**: [N]
- **Prospects Excluded**: [N]
```

### 2. Validated Prospect List (CSV/JSON)

```csv
prospect_id,company_name,fit_status,signal_type,signal_subtype,signal_text,signal_age_days,proceed_to_campaign
001,Acme SaaS,PASS,Intent,Fragmentation Pain,"Data lives in 7 tools",15,YES
002,Beta Corp,FAIL,N/A,N/A,N/A,N/A,NO
```

### 3. Signal Taxonomy (for wedge-generator)

```json
{
  "intent_signals": [
    {
      "prospect_id": "001",
      "company_name": "Acme SaaS",
      "signal_subtype": "Fragmentation Pain",
      "signal_text": "Our sales data lives in 7 different tools.",
      "signal_age_days": 15,
      "signal_source": "LinkedIn post",
      "wedge_priority": "high"
    }
  ],
  "trust_signals": [...]
}
```

---

## Fit Validation Logic

For each ICP, specific criteria determine PASS/FAIL. See [fit-criteria.md](fit-criteria.md) for the complete validation code per ICP:
- MENA SaaS Founders: 5-50 employees, MENA geography, B2B SaaS, $200k-$5M ARR
- US Real Estate Brokers: 10-100 agents, US, Residential RE, $2M-$50M commission, CRM present
- MENA Beauty Clinics: 2-20 staff, UAE/Saudi, aesthetic services, $300k-$3M revenue
- US eCommerce (DTC): 3-50 employees, US, DTC model, $500k-$10M, Shopify/WooCommerce/etc., physical goods

---

## Signal Classification Overview

Signals are classified as Intent or Trust based on behavior type. See [fit-criteria.md](fit-criteria.md) for the complete decision tree and keyword patterns.

**Intent Signals** (active buying behavior):
- Active Problem Indication: "our system is a mess", "can't see", "losing"
- Solution Research: "looking for", "evaluating", "comparing"
- Procurement: "RFP", "budget allocated", "contract ending"
- Urgency: "need by", "urgent", "costing us"

**Trust Signals** (passive engagement):
- Community Engagement: "posted about", "commented on", "shared"
- Authority Building: "published", "speaking at", "wrote article"
- Visibility: "updated profile", "new role", "expansion announced"

---

## Signal Age Validation

### Hard Stop Rule 2: Signal > 90 Days -> Exclude

B2B buying cycles are 30-90 days. Signals older than 90 days are stale -- the pain may have evolved or been solved, and a competitor likely already reached out.

---

## Integration with signal-hierarchy.md

This sub-skill enforces the complete taxonomy:

```
Fit -> Trigger -> Signal Type -> Signal Subtype -> Wedge
```

**What signal-detector validates**: Fit, Signal Type, Signal Subtype, Signal Age
**What gets passed to wedge-generator**: Validated prospects (Fit PASS, Fresh signals) with Signal Type + Subtype + text

---

## Integration with Other Sub-Skills

### Downstream Dependencies

1. **wedge-generator** uses: Signal Type, Signal Subtype, Signal text, Wedge priority
2. **asset-factory** uses: Prospect count, ICP context

### Upstream Dependencies

1. **campaign-strategist**: ICP Fit criteria from campaign brief
2. **Meta skill questionnaire**: Q5 (Signal collection status)
3. **User**: Prospect list (CSV/JSON)

---

## Conclusion

The signal-detector sub-skill ensures:
1. **Quality gating** (Fit = FAIL -> No outreach)
2. **Signal freshness** (>90 days -> Excluded)
3. **Accurate classification** (Trust vs Intent with subtypes)
4. **Clean handoff** (Validated prospects -> wedge-generator)

**Output**: Filtered, classified prospect list ready for wedge generation.

Next: Pass validated prospects + signal taxonomy to wedge-generator for one-sentence wedge creation.
