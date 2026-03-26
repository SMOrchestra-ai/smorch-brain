---
name: signal-detector
description: "Validates ICP Fit criteria and classifies signals (Trust vs Intent) for Signal-to-Trust GTM campaigns. Enforces Hard Stop Rules 1 and 2 (Fit=Fail, Signal over 90d). Use when validating prospects, detecting buying signals, classifying Trust vs Intent signals, or filtering prospect lists. Outputs validated prospects (Fit PASS only) with signal taxonomy."
---

# Signal Detector

## Purpose

Quality gatekeeper for Signal-to-Trust GTM campaigns. Two critical functions:

1. **Fit Validation**: Enforces Hard Stop Rule 1 (Fit = FAIL → No Outreach)
2. **Signal Classification**: Trust vs Intent + freshness validation (Hard Stop Rule 2: >90 days → Exclude)

## When to Call This Skill

Called by `signal-to-trust-gtm` during:
- **Mode A**: Second sub-skill (after campaign-strategist)
- **Mode D**: Direct "Validate signals" or "Check Fit criteria"

Direct invoke: "Validate these prospects", "Classify signals", "Filter my prospect list"

## Inputs

### Required
1. **Prospect List** (CSV/JSON): Company name, industry, size, geography. Optional: revenue, tech stack, signal data
2. **ICP Fit Criteria** (Q2): MENA SaaS | US Real Estate | MENA Beauty Clinics | US eCommerce | Custom
3. **Signal Data** (if available): Signal text, timestamp, source (LinkedIn/job board/news)

## Outputs

### 1. Signal Detection Report

```markdown
## Signal Detection Report
**ICP**: [Target] | **Date**: [YYYY-MM-DD] | **Total**: [N] prospects

### Fit Results
- PASS: [N] ([%]) | FAIL: [N] ([%])
- Failure reasons: [size/geography/industry/revenue breakdown]

### Signal Classification (Fit PASS only)
- Intent: [N] ([%]) | Trust: [N] ([%]) | No Signal: [N] ([%])

### Age Validation
- Fresh (<90d): [N] | Stale (>90d, EXCLUDED): [N]

### Final: [N] prospects proceeding to campaign
```

### 2. Validated Prospect List (CSV/JSON)
Fields: prospect_id, company_name, fit_status, signal_type, signal_subtype, signal_text, signal_age_days, proceed_to_campaign

### 3. Signal Taxonomy (for wedge-generator)
JSON with intent_signals[] and trust_signals[], each containing: prospect_id, company_name, signal_subtype, signal_text, signal_age_days, signal_source, wedge_priority

## Fit Validation Logic

### ICP Fit Criteria Summary

| ICP | Size | Geography | Industry | Revenue |
|-----|------|-----------|----------|---------|
| MENA SaaS | 5-50 employees | UAE, Saudi, Egypt, Qatar, Bahrain, Kuwait, Oman, Jordan, Lebanon | B2B SaaS | $200k-$5M ARR |
| US Real Estate | 10-100 agents | United States | Residential RE | $2M-$50M commission + CRM required |
| MENA Beauty | 2-20 staff | UAE, Saudi Arabia | Botox/fillers/laser/skincare | $300k-$3M annual |
| US eCommerce | 3-50 employees | United States | DTC eCommerce | $500k-$10M, physical goods, Shopify/WooCommerce/Magento |

**Detailed validation functions by ICP**: Read `references/fit-criteria-by-icp.md`

## Signal Classification Logic

### Trust vs Intent Decision Tree (summary)

```
Signal → Active problem indication? → YES: Intent (Active Problem)
       → Solution research behavior? → YES: Intent (Solution Research)
       → Procurement signal?         → YES: Intent (Procurement)
       → Urgency indicator?          → YES: Intent (Urgency)
       → Community engagement?       → YES: Trust (Community)
       → Authority building?         → YES: Trust (Authority)
       → Visibility action?          → YES: Trust (Visibility)
       → None matched                → No signal detected
```

### Key Rule: Intent > Trust (Hard Stop Rule 4)
When a signal could be classified as either, Intent takes priority (higher buying readiness).

**Full classification patterns with keywords and examples**: Read `references/signal-classification-tables.md`

## Signal Age Validation (Hard Stop Rule 2)

- **Fresh (<90 days)**: Proceed to campaign
- **Stale (>90 days)**: EXCLUDED, no exceptions

Rationale: B2B buying cycles are 30-90 days. Stale signals mean someone else already reached out, or the pain evolved/got solved.

## Signal Hierarchy Integration

This skill validates the complete taxonomy chain:

```
Fit → Trigger → Signal Type → Signal Subtype → Wedge
```

What gets passed to wedge-generator: Validated prospects (Fit PASS + Fresh signals) with Signal Type, Subtype, and raw text for wedge customization.

## Error Handling

| Error | Symptom | Fix |
|-------|---------|-----|
| Missing Fit fields | No company size data | Flag "INCOMPLETE", request missing data |
| Ambiguous classification | Could be Trust OR Intent | Apply Intent > Trust (Rule 4) |
| No signal data | Prospect list has no signal_text | Skip classification, output Fit validation only |
| Invalid date format | signal_date not YYYY-MM-DD | Attempt common formats, fallback: exclude |

## Integration

**Upstream**: campaign-strategist (ICP criteria), meta skill Q5 (signal status), user (prospect list)
**Downstream**: wedge-generator (signal type/subtype/text), asset-factory (prospect count, ICP context)

## Reference Files

| File | Content |
|------|---------|
| `references/fit-criteria-by-icp.md` | Python validation functions for each ICP |
| `references/signal-classification-tables.md` | Full decision tree, keyword patterns, examples |
| `references/detection-examples.md` | 2 worked examples (MENA SaaS mixed, US RE all-pass) |
