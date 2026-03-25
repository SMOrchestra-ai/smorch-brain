---
name: signal-detector
description: Validates ICP Fit criteria and classifies signals (Trust vs Intent) for Signal-to-Trust GTM campaigns. Enforces Hard Stop Rules 1 and 2 (Fit=Fail, Signal>90d). Use when validating prospects, detecting buying signals, classifying Trust vs Intent signals, or filtering prospect lists. Outputs validated prospects (Fit PASS only) with signal taxonomy.
---

# Signal Detector

## Purpose

This sub-skill is the **quality gatekeeper** for Signal-to-Trust GTM campaigns. It performs two critical functions:

1. **Fit Validation**: Enforces Hard Stop Rule 1 (Fit = FAIL → No Outreach)
2. **Signal Classification**: Identifies Trust vs Intent signals and validates freshness (Hard Stop Rule 2: Signal > 90 days)

**Core Philosophy**: Quality over quantity. Only Fit PASS prospects with fresh signals proceed to campaign.

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
   - MENA SaaS Founders
   - US Real Estate Brokers
   - MENA Beauty Clinics
   - US eCommerce (DTC)
   - Custom (with explicit criteria)

3. **Signal Data** (if available)
   - Signal text (e.g., LinkedIn post content, job listing, tech change)
   - Signal timestamp (when observed)
   - Signal source (LinkedIn, website, job board, etc.)

### Optional

- **Signal age threshold** (default: 90 days)
- **Fit tolerance** (strict vs lenient for edge cases)

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
003,Gamma Inc,PASS,Trust,Community,"Posted about sales challenges",42,YES
004,Delta LLC,PASS,Intent,Visibility Loss,"Can't see pipeline",120,NO (Stale)
```

### 3. Signal Taxonomy (for wedge-generator)

```json
{
  "intent_signals": [
    {
      "prospect_id": "001",
      "company_name": "Acme SaaS",
      "signal_subtype": "Fragmentation Pain",
      "signal_text": "Our sales data lives in 7 different tools. Decision paralysis is real.",
      "signal_age_days": 15,
      "signal_source": "LinkedIn post",
      "wedge_priority": "high"
    }
  ],
  "trust_signals": [
    {
      "prospect_id": "003",
      "company_name": "Gamma Inc",
      "signal_subtype": "Community Engagement",
      "signal_text": "Posted about sales team alignment challenges",
      "signal_age_days": 42,
      "signal_source": "LinkedIn comment",
      "wedge_priority": "medium"
    }
  ]
}
```

---

## Fit Validation Logic

### ICP-Specific Fit Criteria

#### MENA SaaS Founders

```python
def validate_mena_saas_fit(prospect):
    fit_pass = True
    reasons = []

    # Company size: 5-50 employees
    if prospect.employees < 5 or prospect.employees > 50:
        fit_pass = False
        reasons.append(f"Company size: {prospect.employees} (range: 5-50)")

    # Geography: MENA region
    mena_countries = ['UAE', 'Saudi Arabia', 'Egypt', 'Qatar', 'Bahrain',
                      'Kuwait', 'Oman', 'Jordan', 'Lebanon']
    if prospect.country not in mena_countries:
        fit_pass = False
        reasons.append(f"Geography: {prospect.country} (required: MENA)")

    # Industry: B2B SaaS
    if prospect.industry != 'B2B SaaS':
        fit_pass = False
        reasons.append(f"Industry: {prospect.industry} (required: B2B SaaS)")

    # Revenue: $200k-$5M ARR
    if prospect.arr < 200000 or prospect.arr > 5000000:
        fit_pass = False
        reasons.append(f"Revenue: ${prospect.arr} (range: $200k-$5M)")

    return {
        'fit_status': 'PASS' if fit_pass else 'FAIL',
        'reasons': reasons
    }
```

#### US Real Estate Brokers

```python
def validate_us_realestate_fit(prospect):
    fit_pass = True
    reasons = []

    # Company size: 10-100 agents
    if prospect.agents < 10 or prospect.agents > 100:
        fit_pass = False
        reasons.append(f"Agent count: {prospect.agents} (range: 10-100)")

    # Geography: United States
    if prospect.country != 'United States':
        fit_pass = False
        reasons.append(f"Geography: {prospect.country} (required: US)")

    # Industry: Residential real estate
    if prospect.vertical != 'Residential Real Estate':
        fit_pass = False
        reasons.append(f"Vertical: {prospect.vertical} (required: Residential RE)")

    # Revenue: $2M-$50M annual commission volume
    if prospect.commission_volume < 2000000 or prospect.commission_volume > 50000000:
        fit_pass = False
        reasons.append(f"Commission: ${prospect.commission_volume} (range: $2M-$50M)")

    # Tech stack: Must use at least one CRM
    if not prospect.crm_present:
        fit_pass = False
        reasons.append("No CRM detected (required: any CRM)")

    return {
        'fit_status': 'PASS' if fit_pass else 'FAIL',
        'reasons': reasons
    }
```

#### MENA Beauty Clinics

```python
def validate_mena_beauty_fit(prospect):
    fit_pass = True
    reasons = []

    # Company size: 2-20 staff
    if prospect.staff < 2 or prospect.staff > 20:
        fit_pass = False
        reasons.append(f"Staff count: {prospect.staff} (range: 2-20)")

    # Geography: UAE, Saudi Arabia (primary focus)
    if prospect.country not in ['UAE', 'Saudi Arabia']:
        fit_pass = False
        reasons.append(f"Geography: {prospect.country} (required: UAE/Saudi)")

    # Services: Must offer at least one: Botox, fillers, laser, skincare
    required_services = ['Botox', 'fillers', 'laser', 'skincare']
    if not any(service in prospect.services for service in required_services):
        fit_pass = False
        reasons.append(f"Services: {prospect.services} (required: Botox/fillers/laser/skincare)")

    # Revenue: $300k-$3M annual
    if prospect.revenue < 300000 or prospect.revenue > 3000000:
        fit_pass = False
        reasons.append(f"Revenue: ${prospect.revenue} (range: $300k-$3M)")

    return {
        'fit_status': 'PASS' if fit_pass else 'FAIL',
        'reasons': reasons
    }
```

#### US eCommerce (DTC)

```python
def validate_us_ecommerce_fit(prospect):
    fit_pass = True
    reasons = []

    # Company size: 3-50 employees
    if prospect.employees < 3 or prospect.employees > 50:
        fit_pass = False
        reasons.append(f"Employee count: {prospect.employees} (range: 3-50)")

    # Geography: United States
    if prospect.country != 'United States':
        fit_pass = False
        reasons.append(f"Geography: {prospect.country} (required: US)")

    # Business model: DTC eCommerce
    if prospect.business_model != 'DTC eCommerce':
        fit_pass = False
        reasons.append(f"Business model: {prospect.business_model} (required: DTC eCommerce)")

    # Revenue: $500k-$10M annual
    if prospect.revenue < 500000 or prospect.revenue > 10000000:
        fit_pass = False
        reasons.append(f"Revenue: ${prospect.revenue} (range: $500k-$10M)")

    # Platform: Shopify, WooCommerce, Magento, or custom
    valid_platforms = ['Shopify', 'WooCommerce', 'Magento', 'Custom']
    if prospect.platform not in valid_platforms:
        fit_pass = False
        reasons.append(f"Platform: {prospect.platform} (required: Shopify/WooCommerce/Magento/Custom)")

    # Products: Physical goods only (not digital/services)
    if prospect.product_type in ['Digital', 'Services']:
        fit_pass = False
        reasons.append(f"Product type: {prospect.product_type} (required: Physical goods)")

    return {
        'fit_status': 'PASS' if fit_pass else 'FAIL',
        'reasons': reasons
    }
```

---

## Signal Classification Logic

### Trust vs Intent Decision Tree

```
Signal observed → Analyze behavior type

├─ Active problem indication?
│  ├─ YES → Intent Signal (Subtype: Active Problem)
│  └─ NO → Continue
│
├─ Solution research behavior?
│  ├─ YES → Intent Signal (Subtype: Solution Research)
│  └─ NO → Continue
│
├─ Procurement signal?
│  ├─ YES → Intent Signal (Subtype: Procurement)
│  └─ NO → Continue
│
├─ Urgency indicator?
│  ├─ YES → Intent Signal (Subtype: Urgency)
│  └─ NO → Continue
│
├─ Community engagement?
│  ├─ YES → Trust Signal (Subtype: Community Engagement)
│  └─ NO → Continue
│
├─ Authority building?
│  ├─ YES → Trust Signal (Subtype: Authority Building)
│  └─ NO → Continue
│
└─ Visibility action?
   ├─ YES → Trust Signal (Subtype: Visibility)
   └─ NO → No signal detected
```

### Intent Signal Patterns (Keyword Matching)

#### Active Problem Indication
**Keywords**: "our [system] is a mess", "can't see", "losing", "scattered", "too slow", "broken", "frustrated with"

**Examples**:
- "Our sales data lives in 7 different tools" → Intent: Fragmentation Pain
- "Can't see full pipeline" → Intent: Visibility Loss
- "Losing leads to faster competitors" → Intent: Speed Issues
- "98% say I'll think about it" → Intent: Leakage

#### Solution Research
**Keywords**: "looking for", "recommendations for", "evaluating", "comparing", "need solution for"

**Examples**:
- "Looking for CRM alternatives" → Intent: Solution Research
- "Evaluating automation tools" → Intent: Solution Research
- "Need better lead capture" → Intent: Solution Research

#### Procurement
**Keywords**: "RFP", "RFQ", "budget allocated", "Q4 purchase", "contract ending"

**Examples**:
- "Issuing RFP for sales automation" → Intent: Procurement
- "Current contract ends Q2" → Intent: Procurement
- "Budget approved for CRM upgrade" → Intent: Procurement

#### Urgency
**Keywords**: "need by", "urgent", "ASAP", "this quarter", "losing deals", "costing us"

**Examples**:
- "Need solution by Q4" → Intent: Urgency
- "This is costing us deals daily" → Intent: Urgency
- "Can't wait any longer" → Intent: Urgency

### Trust Signal Patterns

#### Community Engagement
**Keywords**: "posted about", "commented on", "shared", "discussed", "asked peers"

**Examples**:
- "Posted about sales team alignment challenges" → Trust: Community
- "Asked for recommendations in LinkedIn group" → Trust: Community
- "Shared article about GTM challenges" → Trust: Community

#### Authority Building
**Keywords**: "published", "speaking at", "webinar host", "wrote article", "podcast guest"

**Examples**:
- "Published blog post on B2B sales trends" → Trust: Authority
- "Speaking at SaaStr conference" → Trust: Authority
- "Hosting webinar on lead generation" → Trust: Authority

#### Visibility
**Keywords**: "updated profile", "new role", "company milestone", "expansion announced"

**Examples**:
- "Updated LinkedIn: now Head of Sales" → Trust: Visibility
- "Company announced Series A" → Trust: Visibility (also Trigger)
- "Opened new office in Dubai" → Trust: Visibility (also Trigger)

---

## Signal Age Validation

### Hard Stop Rule 2: Signal > 90 Days → Exclude

```python
from datetime import datetime, timedelta

def validate_signal_age(signal_timestamp):
    today = datetime.now()
    signal_date = datetime.strptime(signal_timestamp, '%Y-%m-%d')
    signal_age_days = (today - signal_date).days

    if signal_age_days > 90:
        return {
            'status': 'STALE',
            'age_days': signal_age_days,
            'reason': f'Signal is {signal_age_days} days old (threshold: 90 days)',
            'proceed': False
        }
    else:
        return {
            'status': 'FRESH',
            'age_days': signal_age_days,
            'proceed': True
        }
```

**Rationale**:
- B2B buying cycles: 30-90 days typical
- Signal relevance decays rapidly
- Competitive timing matters (someone else likely reached out)
- Pain evolves or gets solved

---

## Integration with signal-hierarchy.md

This sub-skill enforces the complete taxonomy:

```
Fit → Trigger → Signal Type → Signal Subtype → Wedge
```

**What signal-detector validates**:
1. **Fit**: Company size, geography, industry, revenue (Hard Stop Rule 1)
2. **Signal Type**: Trust vs Intent classification
3. **Signal Subtype**: Specific behavior category
4. **Signal Age**: <90 days validation (Hard Stop Rule 2)

**What gets passed to wedge-generator**:
- Validated prospects (Fit PASS, Fresh signals)
- Signal Type + Subtype (for wedge template selection)
- Signal text (for wedge customization)

---

## Examples

### Example 1: MENA SaaS - Mixed Signals

**Input Prospect List**:
```csv
company_name,employees,country,industry,arr,signal_text,signal_date
Acme SaaS,25,UAE,B2B SaaS,800000,"Our sales data lives in 7 tools",2026-01-28
Beta Corp,60,UAE,B2B SaaS,1200000,"Posted about scaling challenges",2026-02-05
Gamma Inc,15,Saudi Arabia,B2B SaaS,450000,"Wrote article on MENA sales",2025-10-15
Delta LLC,8,Egypt,B2B SaaS,350000,"Looking for CRM alternatives",2026-02-01
```

**Processing**:

1. **Acme SaaS**:
   - Fit Check: 25 employees ✓, UAE ✓, B2B SaaS ✓, $800k ARR ✓ → **PASS**
   - Signal: "sales data lives in 7 tools" → Intent: Fragmentation Pain
   - Age: 14 days → **FRESH**
   - **Proceed: YES**

2. **Beta Corp**:
   - Fit Check: 60 employees ✗ (range: 5-50) → **FAIL**
   - Signal: N/A (Fit FAIL excludes from processing)
   - **Proceed: NO**

3. **Gamma Inc**:
   - Fit Check: 15 employees ✓, Saudi Arabia ✓, B2B SaaS ✓, $450k ARR ✓ → **PASS**
   - Signal: "Wrote article on MENA sales" → Trust: Authority Building
   - Age: 119 days → **STALE** (>90 days)
   - **Proceed: NO**

4. **Delta LLC**:
   - Fit Check: 8 employees ✓, Egypt ✓, B2B SaaS ✓, $350k ARR ✓ → **PASS**
   - Signal: "Looking for CRM alternatives" → Intent: Solution Research
   - Age: 10 days → **FRESH**
   - **Proceed: YES**

**Output Summary**:
```
Total Prospects: 4
Fit PASS: 3 (75%)
Fit FAIL: 1 (25%)
  - Company size out of range: 1

Fresh Signals: 2 (67% of Fit PASS)
Stale Signals: 1 (33% of Fit PASS)

Intent Signals: 2 (Acme, Delta)
Trust Signals: 0 (Gamma excluded due to stale signal)

Prospects Proceeding to Campaign: 2
Prospects Excluded: 2
```

**Validated Prospect List** (passed to wedge-generator):
```json
[
  {
    "prospect_id": "001",
    "company_name": "Acme SaaS",
    "fit_status": "PASS",
    "signal_type": "Intent",
    "signal_subtype": "Fragmentation Pain",
    "signal_text": "Our sales data lives in 7 different tools",
    "signal_age_days": 14,
    "wedge_priority": "high"
  },
  {
    "prospect_id": "004",
    "company_name": "Delta LLC",
    "fit_status": "PASS",
    "signal_type": "Intent",
    "signal_subtype": "Solution Research",
    "signal_text": "Looking for CRM alternatives",
    "signal_age_days": 10,
    "wedge_priority": "high"
  }
]
```

---

### Example 2: US Real Estate - All Pass

**Input Prospect List**:
```csv
company_name,agents,country,vertical,commission_volume,crm_present,signal_text,signal_date
Apex Realty,45,United States,Residential Real Estate,15000000,Yes,"Losing leads to faster brokers",2026-02-08
Summit Homes,22,United States,Residential Real Estate,8500000,Yes,"Form fills at 2pm, reply at 5pm",2026-02-09
Peak Properties,80,United States,Residential Real Estate,35000000,Yes,"Need automation for follow-up",2026-02-10
```

**Processing**:

1. **Apex Realty**: PASS (Intent: Speed Issues, 3 days) → **Proceed: YES**
2. **Summit Homes**: PASS (Intent: Speed Issues, 2 days) → **Proceed: YES**
3. **Peak Properties**: PASS (Intent: Solution Research, 1 day) → **Proceed: YES**

**Output Summary**:
```
Total Prospects: 3
Fit PASS: 3 (100%)
Fit FAIL: 0

Fresh Signals: 3 (100%)
Stale Signals: 0

Intent Signals: 3
Trust Signals: 0

Prospects Proceeding to Campaign: 3
Prospects Excluded: 0
```

**All prospects proceed to wedge-generator with high priority Intent signals.**

---

## Error Handling

### Error 1: Missing Fit Criteria Fields
**Symptom**: Prospect data lacks required fields (e.g., no company size)
**Fix**: Flag prospect as "INCOMPLETE" and request missing data
**Output**: Include in "Data Quality Issues" section of report

### Error 2: Ambiguous Signal Classification
**Symptom**: Signal text could be Trust OR Intent
**Fix**: Apply Intent > Trust rule (Hard Stop Rule 4)
**Example**: "Posted job listing for SDR" = Trigger + Intent (hiring), not just Trust (visibility)

### Error 3: No Signal Data Provided
**Symptom**: Prospect list has no signal_text field
**Fix**: Skip signal classification, output Fit validation only
**Output**: "Signal classification skipped - no signal data provided"

### Error 4: Invalid Date Format
**Symptom**: signal_date not in YYYY-MM-DD format
**Fix**: Attempt to parse common formats (MM/DD/YYYY, DD-MM-YYYY)
**Fallback**: Flag as "Unable to validate age" and exclude from campaign

---

## Integration with Other Sub-Skills

### Downstream Dependencies

After signal-detector outputs validated prospect list:

1. **wedge-generator** uses:
   - Signal Type (Trust vs Intent)
   - Signal Subtype (for template selection)
   - Signal text (for customization)
   - Wedge priority (high/medium/low)

2. **asset-factory** uses:
   - Prospect count (to scale asset production)
   - ICP context (for tone/channel selection)

### Upstream Dependencies

**Inputs from**:
1. **campaign-strategist**: ICP Fit criteria from campaign brief
2. **Meta skill questionnaire**: Q5 (Signal collection status)
3. **User**: Prospect list (CSV/JSON)

---

## Conclusion

The signal-detector sub-skill ensures:
1. **Quality gating** (Fit = FAIL → No outreach)
2. **Signal freshness** (>90 days → Excluded)
3. **Accurate classification** (Trust vs Intent with subtypes)
4. **Clean handoff** (Validated prospects → wedge-generator)

**Output**: Filtered, classified prospect list ready for wedge generation.

Next: Pass validated prospects + signal taxonomy to wedge-generator for one-sentence wedge creation.
