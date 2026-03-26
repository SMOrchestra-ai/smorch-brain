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
