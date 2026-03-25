# Clay Prompt Pack — AI Formulas & Claygent Templates

## SECTION 1: CREDIT-SAVING AI FORMULAS (FREE — 0 Credits)

AI Formulas run on data already in your table. They cost ZERO credits. Use them aggressively to filter, transform, and score BEFORE running paid enrichments.

### Formula #1: Data Validation & Pre-Filter

**Purpose:** Prevent wasting credits enriching fake/duplicate/disqualified companies.

```
"Validate this company data. Given:
- Company name: {{company_name}}
- Domain: {{domain}}
- Employee count: {{employee_count}}

Return ONLY one of these values:
- 'enrich' if: company name appears to be a real company AND employee count > {{min_employees}}
- 'skip_too_small' if: employee count < {{min_employees}}
- 'skip_invalid' if: company name looks fake, generic, or is a personal name
- 'skip_duplicate' if: company name is a variation of another row (e.g., 'Acme Inc' vs 'ACME')

Return only the single word/phrase, nothing else."
```

**Savings:** 30-50% credit reduction by eliminating disqualified rows before enrichment.

### Formula #2: ICP Fit Scoring

**Purpose:** Score prospects by ICP match before enrichment (only enrich high-fit rows).

```
"Score this company's fit for our ICP. Our ICP is:
- Industry: {{target_industries}} (e.g., SaaS, Technology, Financial Services)
- Company size: {{min_employees}}-{{max_employees}} employees
- Region: {{target_regions}}
- Revenue: {{min_revenue}}-{{max_revenue}}

Given:
- Company: {{company_name}}
- Industry: {{industry}}
- Employees: {{employee_count}}
- Location: {{location}}
- Revenue: {{revenue_estimate}}

Return a score 0-100 where:
- 80-100: Perfect ICP match (all criteria met)
- 60-79: Good match (3 of 4 criteria met)
- 40-59: Partial match (2 of 4 criteria met)
- 0-39: Poor match (1 or fewer criteria met)

Return ONLY the number, nothing else."
```

**Usage:** Set conditional run → Only enrich rows where ICP score > 60.

### Formula #3: Signal-Based Lead Scoring (Composite)

**Purpose:** Combine multiple data points into a single priority score.

```
"Calculate a lead score 0-100 based on these weighted factors:

ICP Fit (40% weight):
- Industry match: {{industry_match}} (yes/no → 100/0)
- Company size fit: {{size_fit}} (yes/no → 100/0)
- Region match: {{region_match}} (yes/no → 100/0)

Buying Signals (35% weight):
- Recent funding: {{has_funding}} (yes/no → 100/0)
- Active hiring: {{is_hiring}} (yes/no → 100/0)
- Technology change: {{tech_change}} (yes/no → 100/0)
- Job change signal: {{job_change}} (yes/no → 100/0)

Engagement (15% weight):
- Email opened: {{email_opened}} (yes/no → 100/0)
- LinkedIn viewed: {{linkedin_viewed}} (yes/no → 100/0)
- Website visited: {{website_visited}} (yes/no → 100/0)

Recency (10% weight):
- Signal age in days: {{signal_age_days}}
- Score: 100 if <7 days, 75 if 7-14, 50 if 14-30, 25 if 30-60, 0 if >60

Calculate: (ICP_avg × 0.40) + (Signals_avg × 0.35) + (Engagement_avg × 0.15) + (Recency_score × 0.10)

Return ONLY the final score as a whole number."
```

**Routing:**
- Score 80+ → Tier 1 (personalized, SDR-handled)
- Score 60-79 → Tier 2 (templated sequence)
- Score <60 → Tier 3 (automated nurture or skip)

### Formula #4: Tier Assignment

**Purpose:** Convert lead score into actionable routing tier.

```
"Given this lead score: {{lead_score}}

Return ONLY one of these values:
- 'tier_1' if score >= 80
- 'tier_2' if score >= 60 AND score < 80
- 'tier_3' if score < 60"
```

### Formula #5: Bulk Data Transformation

**Purpose:** Clean messy data in bulk without external tools.

```
"Convert this unstructured company description into structured fields:
Description: {{company_description}}

Return pipe-delimited format:
primary_industry|revenue_estimate_range|employee_count_range|top_3_tech_categories

Example output: SaaS|$10M-$50M|50-200|CRM,Marketing Automation,Analytics

If any field is unclear, use 'unknown'. Return ONLY the pipe-delimited string."
```

---

## SECTION 2: ARABIC NAME STANDARDIZATION (FREE — AI Formula)

### Formula #6: Arabic Name Parser

**Purpose:** Split Arabic names correctly for email personalization (Al-Qassimi, bin-Salman patterns).

```
"This person's full name is: {{full_name}}

Arabic names follow patterns like:
- 'Mohammed Al-Qassimi' → First: Mohammed, Last: Al-Qassimi
- 'Ahmed bin Salman Al-Rashid' → First: Ahmed, Last: Al-Rashid (bin-Salman is patronymic)
- 'Fatima bint Hassan' → First: Fatima, Last: Hassan (bint = daughter of)
- 'Omar Al-Khatib' → First: Omar, Last: Al-Khatib
- 'Abdullah bin Abdulaziz Al-Saud' → First: Abdullah, Last: Al-Saud

Rules:
1. 'Al-' prefix stays with last name
2. 'bin/ibn' (son of) is a patronymic — skip to the LAST compound for surname
3. 'bint' (daughter of) follows same rule as bin
4. Single-word names: First = name, Last = empty
5. Western-style names: Normal first/last split

Return pipe-delimited: first_name|last_name|email_greeting_name

email_greeting_name = the name you'd use in 'Hi {{name}}' in an email (usually first name, but 'Mr./Mrs.' for very formal Gulf contexts)

Return ONLY the pipe-delimited string."
```

### Formula #7: Arabic Name Variation Generator

**Purpose:** Handle name variations for dedupe and matching.

```
"Generate name variations for: {{full_name}}

Common Arabic name variations include:
- With/without 'Al-' prefix
- Mohammed/Mohamed/Mohammad/Muhammad
- Ahmed/Ahmad
- With/without patronymic (bin/ibn)
- Transliteration differences (th vs t, kh vs k)

Return up to 5 variations, pipe-delimited.
Example: Mohammed Al-Qassimi|Mohamed Al Qassimi|Mohammad Alqassimi|M. Al-Qassimi|Mohammed Qassimi"
```

---

## SECTION 3: CLAYGENT RESEARCH PROMPTS (5-20 Credits Each)

Use Claygent sparingly — 5-10% of list for high-value research. Always validate output.

### Claygent #1: Company Overview & Fit Assessment

```
"Visit {{company_website}}. Research and summarize:

1. What does this company do? (one sentence)
2. Who are their customers? (industry + company size)
3. Business model: SaaS / Services / Hybrid / Hardware / Other
4. Estimated company stage: Pre-revenue / Seed / Growth / Scale / Public
5. Estimated employee count (from website team page or LinkedIn)
6. Are they a fit for {{your_solution_description}}? Score 1-10.

Return structured format:
summary|customers|model|stage|headcount|fit_score

If you cannot find information, say 'unknown' for that field.
Do NOT make up data. Only report what you can verify on the website."
```

### Claygent #2: Prospect Research & Talking Points

```
"Research {{person_name}} at {{company_name}}:

1. Their current role and likely responsibilities
2. How long they've been in this role (if visible)
3. Previous companies/roles (career trajectory)
4. Any recent LinkedIn posts, publications, or speaking engagements
5. Their likely involvement in buying decisions for {{your_product_category}}

Generate 2-3 SPECIFIC talking points for outreach that reference their actual situation. No generic language.

Return structured:
role|tenure|career_path|recent_activity|talking_point_1|talking_point_2|talking_point_3

IMPORTANT: Only report verified information. If you can't find something, say 'not found'."
```

### Claygent #3: Recent Company News & Intent Signals

```
"Find recent news (last 6 months) about {{company_name}} ({{company_domain}}):

1. Funding announcements (amount, round, investors)
2. New product launches or major features
3. Executive changes (new C-suite, VP-level hires)
4. Press releases and partnerships
5. Expansion signals (new offices, new markets, hiring sprees)
6. Technology adoptions or migrations mentioned publicly

Score overall buying intent 1-10 based on what you find.

Return structured:
funding|products|exec_changes|partnerships|expansion|tech_changes|intent_score

CRITICAL: Only report factual, verifiable news. Do NOT hallucinate or invent events."
```

### Claygent #4: Competitive Landscape Analysis

```
"Identify {{company_name}}'s top 3 competitors:

For each competitor, provide:
1. Company name and website
2. Key differentiator vs {{company_name}}
3. Estimated size (employees, revenue range)

Then assess: How is {{company_name}} positioned vs competitors?
- Market leader / Challenger / Niche player

Return structured:
competitor_1_name|competitor_1_site|competitor_1_diff|competitor_1_size
competitor_2_name|competitor_2_site|competitor_2_diff|competitor_2_size
competitor_3_name|competitor_3_site|competitor_3_diff|competitor_3_size
positioning: leader/challenger/niche"
```

### Claygent #5: Technical Stack Discovery

```
"Determine {{company_name}}'s ({{company_domain}}) technology stack:

Look for evidence of:
1. CRM: HubSpot, Salesforce, Pipedrive, Zoho, GoHighLevel, other
2. Marketing automation: Marketo, HubSpot, Pardot, Mailchimp, other
3. Analytics: Google Analytics, Mixpanel, Amplitude, Segment, other
4. Communication: Slack, Teams, Zoom, other
5. Customer support: Zendesk, Intercom, Freshdesk, other
6. Other notable tools visible on their website or job postings

For each, indicate confidence: high/medium/low

Return structured (pipe-delimited):
crm:tool:confidence|marketing:tool:confidence|analytics:tool:confidence|comms:tool:confidence|support:tool:confidence|other:tools

Example: crm:HubSpot:high|marketing:Mailchimp:medium|analytics:GA4:high"
```

### Claygent #6: Hiring Pattern Analysis

```
"Analyze {{company_name}}'s hiring patterns:

1. Total open job postings (approximate count)
2. Top 3 departments hiring (and seniority levels)
3. Any visible salary ranges?
4. What do these patterns suggest about company strategy?
   - Scaling aggressively
   - Replacing turnover
   - Entering new market
   - Building new product
   - Survival mode (few/no hires)

Estimate hiring momentum: scaling / stable / scaling_back / survival

Return structured:
total_openings|dept_1:count:seniority|dept_2:count:seniority|dept_3:count:seniority|salary_visible:yes/no|momentum:scaling/stable/scaling_back/survival"
```

---

## SECTION 4: PERSONALIZATION HOOK GENERATORS (FREE — AI Formula)

### Formula #8: Signal-Based Personalization Hook

```
"Generate a personalized outreach hook based on this prospect's data:

Company: {{company_name}}
Person: {{first_name}} {{last_name}}
Role: {{job_title}}
Signal: {{buying_signal}} (e.g., 'just raised Series B', 'hired new VP Sales', 'adopted HubSpot')
Industry: {{industry}}

Create ONE opening sentence (max 25 words) that:
1. References the specific signal
2. Connects it to a pain point our solution addresses
3. Feels like a human wrote it (no 'I noticed' or 'I saw')
4. Creates curiosity, not a pitch

Our solution: {{your_solution_one_liner}}

Return ONLY the one sentence, nothing else."
```

### Formula #9: Multi-Hook Generator (3 Variants)

```
"Generate 3 different outreach opening lines for:

Person: {{first_name}} {{last_name}}, {{job_title}} at {{company_name}}
Signal: {{buying_signal}}
Industry: {{industry}}

Rules for each hook:
- Max 25 words
- Reference the signal specifically
- Different angle for each (problem, opportunity, peer comparison)
- No 'I noticed', 'I saw', 'I hope this finds you well'

Return pipe-delimited: hook_1|hook_2|hook_3"
```

---

## SECTION 5: CLAYGENT HALLUCINATION MITIGATION

### Validation Formula (Post-Claygent, FREE)

```
"Review this Claygent research output for {{company_name}}:

Research output: {{claygent_output}}
Company website: {{company_domain}}

Check for:
1. Does the company description match what you'd expect from the domain?
2. Are the numbers plausible (employee count, revenue)?
3. Do the competitors make sense for this industry?
4. Are there any obvious fabrications or impossible claims?

Return:
- 'verified' if output appears factual and consistent
- 'suspect' if any data points seem fabricated or implausible
- 'reject' if output is clearly wrong or hallucinated

Return ONLY one word: verified/suspect/reject"
```

### Best Practices for Claygent Accuracy

1. **Always include the company website URL** in the prompt — gives Claygent a starting point
2. **Ask for source evidence** — add "cite the URL where you found this" to reduce fabrication
3. **Use structured output formats** — pipe-delimited forces concise, verifiable answers
4. **Run on sample first** — test 10-20 rows, manually verify, then scale
5. **Combine with validation formula** — post-Claygent AI Formula to flag suspect data
6. **Never use Claygent data in outreach without verification** — especially names, titles, and contact info
