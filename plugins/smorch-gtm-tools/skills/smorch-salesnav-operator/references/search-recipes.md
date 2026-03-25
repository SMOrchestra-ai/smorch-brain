# ICP Search Recipes for Sales Navigator

## Boolean Rules (Non-Negotiable)
- Operators MUST be uppercase: AND, OR, NOT
- Use straight quotes for exact phrases: "VP Sales" (not curly quotes)
- Parentheses for grouping: (A OR B) AND C
- Max ~15 operators per Boolean field
- No wildcards (*) - not supported
- Stop words may be ignored by search engine

## Recipe Library

### Recipe 1: MENA Midmarket Revenue Leaders (Growing Companies)

**Account Search:**
- Headquarters: UAE, Saudi Arabia
- Company headcount: 51-500
- Company headcount growth: Positive
- Job opportunities: Yes
- Recent activities: Yes

**Lead Search (layered on accounts):**
- Geography: UAE, Saudi Arabia
- Seniority: VP, CXO
- Current job title Boolean: `("VP Sales" OR "Head of Sales" OR "Sales Director" OR "Chief Revenue Officer" OR "CRO")`
- Spotlight: Posted on LinkedIn in 30 days (optional, narrows to active)

**Expected results**: 200-800 leads. If >2,500, add industry filter.

---

### Recipe 2: RevOps and Sales Ops in Scale-ups

**Account Search:**
- Company headcount: 201-2000
- Department headcount growth: Sales or Operations
- Job opportunities: Yes

**Lead Search:**
- Seniority: Director+, VP
- Current job title Boolean: `("RevOps" OR "Revenue Operations" OR "Sales Operations" OR "Sales Enablement")`
- Spotlight: Changed jobs in last 90 days

---

### Recipe 3: Marketing Ops and Demand Gen (Active Posters)

**Account Search:**
- Industry: Target vertical
- Company headcount growth: Positive

**Lead Search:**
- Current job title Boolean: `("Demand Gen" OR "Demand Generation" OR "Marketing Operations" OR "Growth Marketing")`
- Spotlight: Posted on LinkedIn in 30 days
- Spotlight: Following your company (if running brand content)

---

### Recipe 4: New Decision Makers at Priority Accounts

**Pre-requisite**: Have target accounts saved to a list.

**Lead Search:**
- Account lists: [your target list]
- Seniority: Director+
- Check alerts for "Senior hires at account"
- Save new hires as leads for monitoring

---

### Recipe 5: Active Users Only (High Response Probability)

**Lead Search:**
- Spotlight: Posted on LinkedIn in 30 days
- Plus your role cluster (title + function + seniority)

Use this when your offer requires conversation and engagement, not cold blasting.

---

### Recipe 6: Accounts Showing Hiring Velocity

**Account Search:**
- Save accounts in ICP
- Monitor daily for "Accounts preparing to grow" alerts
- Monitor for "Account accelerated growth" alerts

**Then**: Map buying committee using Mode E (Account Intelligence Deep Dive)

---

### Recipe 7: Bilingual MENA Executives (Split Runs)

**English Run:**
- Geography: UAE, Saudi Arabia, Qatar
- Profile language: English
- Title Boolean: `("Sales Director" OR "VP Sales" OR "Head of Growth")`

**Arabic Run:**
- Geography: UAE, Saudi Arabia, Qatar
- Profile language: Arabic
- Title Boolean (Keyword field): `("مدير مبيعات" OR "نائب الرئيس" OR "مدير التسويق")`

**Why split**: Mixed-language searches produce inconsistent results. Splitting by Profile language gives cleaner segments and better personalization targeting.

---

### Recipe 8: Exclude Non-Targets (Noise Reduction)

For any search, add these NOT clauses to title Boolean:
```
NOT ("Consultant" OR "Freelance" OR "Intern" OR "Student" OR "Executive Assistant" OR "EA" OR "Recruiter")
```

For MENA specifically, also exclude:
```
NOT ("مستشار" OR "متدرب")
```

---

### Recipe 9: Healthcare/Clinics in GCC

**Account Search:**
- Industry: Hospital & Health Care, Medical Practice
- Headquarters: UAE, Saudi Arabia, Qatar, Kuwait
- Job opportunities: Yes

**Lead Search:**
- Title Boolean: `("Clinic Manager" OR "Operations Manager" OR "Medical Director" OR "Practice Manager")`
- Geography: per country (run separately)
- Profile language: split English and Arabic runs

---

### Recipe 10: IT Distributors - Channel Sales MENA

**Account Search:**
- Industry: Information Technology
- Headquarters: UAE, Saudi Arabia
- Headcount: 51-500

**Lead Search:**
- Function: Partnerships, Business Development
- Seniority: Manager+
- Keyword Boolean: `"Channel Sales" AND "Middle East"`

## Segmentation Rules

If any search returns >2,500 results:
1. First split by geography (country by country)
2. Then split by seniority (VP separate from Director)
3. Then split by industry vertical
4. Never run a search you can't fully review

If a search returns <50 results:
1. Broaden title Boolean (add more synonyms)
2. Remove one signal filter (e.g., drop "Posted in 30 days")
3. Expand geography (add neighboring countries)
4. Check if Profile language filter is too restrictive
