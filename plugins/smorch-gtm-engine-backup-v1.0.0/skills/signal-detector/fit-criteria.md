# Signal Detector - Fit Criteria & Signal Patterns

Reference file for ICP-specific fit validation logic, signal classification patterns, and examples.

---

## ICP-Specific Fit Criteria

### MENA SaaS Founders

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

### US Real Estate Brokers

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

### MENA Beauty Clinics

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

### US eCommerce (DTC)

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
Signal observed -> Analyze behavior type

+-- Active problem indication?
|   +-- YES -> Intent Signal (Subtype: Active Problem)
|   +-- NO -> Continue
|
+-- Solution research behavior?
|   +-- YES -> Intent Signal (Subtype: Solution Research)
|   +-- NO -> Continue
|
+-- Procurement signal?
|   +-- YES -> Intent Signal (Subtype: Procurement)
|   +-- NO -> Continue
|
+-- Urgency indicator?
|   +-- YES -> Intent Signal (Subtype: Urgency)
|   +-- NO -> Continue
|
+-- Community engagement?
|   +-- YES -> Trust Signal (Subtype: Community Engagement)
|   +-- NO -> Continue
|
+-- Authority building?
|   +-- YES -> Trust Signal (Subtype: Authority Building)
|   +-- NO -> Continue
|
+-- Visibility action?
    +-- YES -> Trust Signal (Subtype: Visibility)
    +-- NO -> No signal detected
```

### Intent Signal Patterns (Keyword Matching)

**Active Problem Indication**
Keywords: "our [system] is a mess", "can't see", "losing", "scattered", "too slow", "broken", "frustrated with"
Examples:
- "Our sales data lives in 7 different tools" -> Intent: Fragmentation Pain
- "Can't see full pipeline" -> Intent: Visibility Loss
- "Losing leads to faster competitors" -> Intent: Speed Issues
- "98% say I'll think about it" -> Intent: Leakage

**Solution Research**
Keywords: "looking for", "recommendations for", "evaluating", "comparing", "need solution for"

**Procurement**
Keywords: "RFP", "RFQ", "budget allocated", "Q4 purchase", "contract ending"

**Urgency**
Keywords: "need by", "urgent", "ASAP", "this quarter", "losing deals", "costing us"

### Trust Signal Patterns

**Community Engagement**
Keywords: "posted about", "commented on", "shared", "discussed", "asked peers"

**Authority Building**
Keywords: "published", "speaking at", "webinar host", "wrote article", "podcast guest"

**Visibility**
Keywords: "updated profile", "new role", "company milestone", "expansion announced"

---

## Signal Age Validation

### Hard Stop Rule 2: Signal > 90 Days -> Exclude

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
1. **Acme SaaS**: Fit PASS, Intent: Fragmentation Pain (14 days) -> **Proceed: YES**
2. **Beta Corp**: Fit FAIL (60 employees, range 5-50) -> **Proceed: NO**
3. **Gamma Inc**: Fit PASS, Trust: Authority Building (119 days, STALE) -> **Proceed: NO**
4. **Delta LLC**: Fit PASS, Intent: Solution Research (10 days) -> **Proceed: YES**

**Result**: 2 of 4 prospects proceed to campaign.

### Example 2: US Real Estate - All Pass

All 3 prospects pass Fit, all have fresh Intent signals -> All proceed.

---

## Error Handling

### Error 1: Missing Fit Criteria Fields
**Fix**: Flag prospect as "INCOMPLETE" and request missing data

### Error 2: Ambiguous Signal Classification
**Fix**: Apply Intent > Trust rule (Hard Stop Rule 4)

### Error 3: No Signal Data Provided
**Fix**: Skip signal classification, output Fit validation only

### Error 4: Invalid Date Format
**Fix**: Attempt to parse common formats. Fallback: flag as "Unable to validate age"
