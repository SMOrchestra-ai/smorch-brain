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
