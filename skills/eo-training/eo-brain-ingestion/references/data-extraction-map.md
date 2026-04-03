# Data Extraction Map - eo-brain-ingestion

Core mapping of which scorecard answers feed which output files.

## DATA EXTRACTION MAP

This is the core mapping: which scorecard answers feed which output files.

### companyprofile.md

| Field | Source |
|-------|--------|
| Venture Name | SC1 header: `**Venture:**` |
| One-Line Description | SC1 Q1 first paragraph (extract core problem statement) |
| Problem Statement | SC1 Q1 full answer (the specific problem being solved) |
| Product Category | SC1 Q4 "Category Definition" or SC1 positioning section |
| Target Market | SC1 Q3 "3-Level Niche" Market level |
| Sub-Market | SC1 Q3 Sub-Market level |
| Niche | SC1 Q3 Niche level |
| Niche Size | SC1 Q3 estimated niche size |
| MVP Features | SC1 Q5 core features list |
| Technical Approach | SC1 Q5 technical stack |
| Pricing Tiers | SC1 Q5 pricing section |
| Launch Geography | SC1 Q7 countries |
| Overall Readiness | Founder Brief overall score, or average of SC1-SC5 |
| Assessment Scores | All 5 scorecard scores in table format |

### founderprofile.md

| Field | Source |
|-------|--------|
| Founder Name | SC1 header or student input |
| Background | SC1 Q2 founder-problem fit (professional history) |
| Domain Expertise | SC1 Q2 specific experience relevant to the problem |
| Unfair Advantage | SC1 Q2 "Triple Assessment" or unique qualification |
| Archetype | SC4 "Founder Archetype" field |
| Strongest Skill | SC4 Q1 answer |
| Risk Profile | SC4 Q4 answer |
| Time Commitment | SC4 Q3 answer |
| Investment Capacity | SC4 Q2 answer |
| Network Strength | SC5 Q7 answer |
| Content Comfort | SC5 Q3 answer |
| MENA Experience | SC1 Q7 + SC4 Q10 MENA execution advantage |

### brandvoice.md

| Field | Source |
|-------|--------|
| Attractive Character Archetype | SC1 Q6 (Reluctant Hero, Leader, Adventurer, etc.) |
| Origin Story | SC1 Q6 founder story arcs |
| Brand Personality Traits | EXTRACT from SC1 Q6 tone + SC1 Q1 writing style |
| Language Defaults | SC1 Q7 language strategy |
| Tone Guidelines | **GAP-FILL** Round 1 Q2 |
| Content Voice Examples | **GAP-FILL** Round 1 Q2 (writing sample) |
| Words to Use | DERIVE from scorecard writing style + Gap-Fill Round 1 Q2 |
| Words to Avoid | **GAP-FILL** Round 1 Q3 |

### niche.md

| Field | Source |
|-------|--------|
| Market Level | SC1 Q3 Level 1 |
| Sub-Market Level | SC1 Q3 Level 2 |
| Niche Level | SC1 Q3 Level 3 |
| Niche Demographics | SC1 Q3 (age, geography, role, stage) |
| Niche Size Estimate | SC1 Q3 number |
| Validation Evidence | SC1 Q1 validation data (interviews, waitlist, etc.) |
| Niche Selection Rationale | SC1 Q3 reasoning for narrowing |
| Adjacent Niches | EXTRACT from SC1 Q3 if mentioned, otherwise note as expansion path |

### icp.md

| Field | Source |
|-------|--------|
| Persona Name | SC2 Q1 named persona |
| Demographics | SC2 Q1 (age, location, role, company size) |
| Psychographics | SC2 Q1 (motivations, fears, daily routine) |
| Current Workflow | SC2 Q1 "How he solves it today" section |
| Pain #1 | SC2 Q2 Pain 1 (urgency, frequency, cost) |
| Pain #2 | SC2 Q2 Pain 2 (urgency, frequency, cost) |
| Pain #3 | SC2 Q2 Pain 3 (urgency, frequency, cost) |
| Additional Pains | SC2 Q2 Pains 4-5 if present |
| Dream Outcome - Business | SC2 Q3 business metrics transformation |
| Dream Outcome - Emotional | SC2 Q3 emotional/identity shift |
| Buyer Journey - Current State | SC2 Q4 "Current State" section |
| Buyer Journey - Obstacles | SC2 Q4 obstacles list |
| Buyer Journey - Solution Bridge | SC2 Q4 "Solution Bridge" section |
| Access Channels - Online | SC2 Q5 online congregation points |
| Access Channels - Offline | SC2 Q5 offline gathering spots |
| Validation Plan | SC2 Q6 30-day reach plan |
| Validation Evidence | SC2 Q1 validation marker (interviews, survey, pilot) |

### positioning.md

| Field | Source |
|-------|--------|
| Category Definition | SC1 Q4 category statement |
| Competitive Alternatives | SC1 Q4 list of alternatives |
| Unique Mechanism | SC1 Q4 unique mechanism name + description |
| One-Line Wedge | SC1 Q4 wedge statement |
| Positioning Statement | SYNTHESIZE from SC1 Q4 (Category + For + Unlike + Because) |
| Value Proposition | SYNTHESIZE from SC1 Q4 + SC2 Q3 (problem + solution + dream outcome) |
| Key Differentiators | SC1 Q4 + SC4 Q10 (execution advantages) |
| Positioning Against Free | SC2 Q2 Pain 3 if about "free alternatives" |

### competitor-analysis.md

| Field | Source |
|-------|--------|
| Direct Competitors | SC1 Q4 competitive alternatives (extract names) |
| Competitor Weaknesses | SC1 Q4 "why each fails" reasoning |
| Regional Competitors | **GAP-FILL** Round 2 Q5 |
| Feature Comparison | **GAP-FILL** Round 2 Q6 (competitor weakness) |
| Pricing Comparison | SC3 B2 competitor pricing data if present |
| Positioning Gap | SYNTHESIZE from SC1 Q4 unique mechanism vs competitors |

### market-analysis.md

| Field | Source |
|-------|--------|
| Pain Reality Evidence | SC3 B1 full answer (proof stack) |
| Purchasing Power Evidence | SC3 B2 full answer (pricing benchmarks) |
| Evidence Grade | SC3 B3 selected option |
| TAM | SC3 C1 TAM section |
| SAM | SC3 C1 SAM section |
| SOM | SC3 C1 SOM section |
| Year 1 Revenue Projection | SC3 C1 SOM revenue range |
| Growth Signals | SC3 C2 full answer (all cited signals) |
| Competitive Moat | SC3 C3 selected option |
| MENA Market Dynamics | SC1 Q7 + SC3 C2 MENA-specific signals |

### strategy.md

| Field | Source |
|-------|--------|
| Recommended Path | SC4 "Recommended Path" field |
| Path Rationale | SC4 Q5 full answer (why this path) |
| Backup Path | SC4 "Backup Path" field |
| Backup Trigger | SC4 "Activate if" condition |
| Founder Archetype | SC4 "Founder Archetype" field |
| 90-Day Roadmap | SC4 "90-Day Roadmap" section |
| All Paths Comparison | SC4 "All 4 Paths Compared" section |
| Execution Advantage | SC4 Q10 MENA execution advantage |
| Biggest Challenge | SC4 Q10 biggest challenge + mitigation |

### gtm.md

| Field | Source |
|-------|--------|
| GTM Motions Ranked | SC5 full 13-motion table with scores and tiers |
| Top 5 Motions Detail | SC5 top 5 descriptions (Fit, Readiness, MENA, Best For, MENA Note) |
| PRIMARY Motions | SC5 all motions with tier = PRIMARY |
| SECONDARY Motions | SC5 all motions with tier = SECONDARY |
| CONDITIONAL Motions | SC5 all motions with tier = CONDITIONAL |
| SKIP Motions | SC5 all motions with tier = SKIP |
| 72-Hour Launch Commitment | SC5 "72-Hour Launch Commitment" section |
| How to Start Top 3 | SC5 "How to Start Your Top 3 Motions" section |
| Access Channels | SC2 Q5 (cross-reference for channel alignment) |
| Monthly Budget | SC5 Q6 answer |
| Outreach Stack | SC5 Q5 answer |
| Content Cadence | SC5 Q2 answer |

### personal-preferences.md [NEW]

| Field | Primary Source | Secondary Source |
|-------|---------------|------------------|
| Identity | founderprofile.md (name, background, expertise) | companyprofile.md (venture name, description) |
| Core Thesis | positioning.md (unique mechanism, wedge) + brandvoice.md (origin story) | **GAP-FILL** Round 1 Q1 |
| Decision Framework | strategy.md (archetype + path) + founderprofile.md (risk profile) | gtm.md (top motions as priority signals) |
| Operating Modes | founderprofile.md (archetype) + brandvoice.md (tone) | **GAP-FILL** Round 1 Q4 |
| Communication | brandvoice.md (tone guidelines, personality traits) | brandvoice.md (words to use) |
| Hard Constraints | brandvoice.md (words to avoid) | **GAP-FILL** Round 1 Q3 |

### cowork-instruction.md [REVISED: now founder-scoped]

| Field | Primary Source | Gap-Fill Source |
|-------|---------------|-----------------|
| Who I Am | founderprofile.md + companyprofile.md | None |
| What I Build | companyprofile.md (all product lines) | **GAP-FILL** Round 2 Q6 |
| My Tool Stack | companyprofile.md (technical approach) | **GAP-FILL** Round 2 Q7 |
| How I Work | strategy.md (archetype) + brandvoice.md (tone) | None |
| Quality Standards | brandvoice.md (tone by context) | **GAP-FILL** Round 2 Q8 |
| Language Defaults | brandvoice.md (language defaults) | None |
| File Naming | Derive from venture name | **GAP-FILL** Round 2 Q8 |
| What Not To Do | brandvoice.md (words to avoid) + positioning.md | None |

### project-instruction.md [REVISED: now includes technical execution]

| Section | Source |
|---------|--------|
| **BUSINESS CONTEXT** | |
| What This Project Is | companyprofile.md (one-liner + problem) |
| Who We Serve | icp.md (persona summary, top 3 pains) |
| Positioning | positioning.md (full statement + unique mechanism) |
| GTM Priority | gtm.md (top 3 motions with scores) |
| Strategy Path | strategy.md (recommended path + 90-day summary) |
| MENA Rules | niche.md (geography) + SC1 Q7 (cultural dynamics) |
| **TECHNICAL CONTEXT** | |
| Tech Stack | companyprofile.md (technical approach). Placeholder until eo-tech-architect. |
| Project Structure | Template derived from tech stack. Placeholder until scaffold. |
| Key Context Files | Point to project-brain/ directory |
| Build Instructions | Standard EO 6-step sequence |
| Design System | brandvoice.md (personality) + gap-fill for colors/fonts |
| Quality Gates | Standard EO gates |
| Current Status | Set to initial. Updated by downstream skills. |
| Voice for UI Copy | brandvoice.md filtered for UI rules |

---

## EXTRACTION SYNTHESIS RULES

Rules for handling conflicts, gaps, and quality checks when synthesizing data from multiple scorecards into single output fields.

### Multiple Valid Answers (Conflict Resolution)

When scorecard data provides conflicting or overlapping information for the same field:

1. **Apply Specificity Rule:** Use the MOST SPECIFIC answer. If SC1 says "solo brokers" and SC2 says "small teams of 2-3 brokers," use SC2 (more specific size qualifier).
2. **Apply Recency Rule:** If equally specific, use the LATER scorecard's answer. Score hierarchy: SC5 > SC4 > SC3 > SC2 > SC1. Example: If SC1 Q3 niche description conflicts with SC4 Q10 niche update, use SC4.
3. **Apply Evidence Rule:** If recency is equal, use whichever answer includes more evidence (specific numbers, names, quotes, data points). Example: "3-5 SMEs per team (based on 12 interviews in Q1 2026)" beats "small teams."
4. **Flag Inconsistency:** If all above rules result in substantive conflict (not just phrasing), add a "CONSISTENCY NOTE" to the output file and include both versions, marking the selected version with "[SELECTED]."

Example conflict:
- SC2 Q1: "Real estate agents in Lagos, Nigeria, working solo"
- SC4 Q10: "Real estate teams of 2-4 agents in tier-1 MENA cities"
- **Resolution:** Use SC4 (later, more specific). Add note: "CONSISTENCY NOTE: SC2 initially described solo agents; SC4 refined to small teams. Using SC4 definition."

### Empty Field Handling

If a field has no source data after checking all 5 scorecards AND gap-fill questions:

1. **Mark as [NEEDS INPUT]** in the output file with this format: `[NEEDS INPUT - [category]: [field name]. Ask student for: [specific guidance]]`
2. **Never fabricate.** Do not invent data, make assumptions, or use "typical" examples.
3. **Flag Count:** Track how many fields are marked [NEEDS INPUT]. If more than 3 fields in a single output file are empty, flag this to the student: "This output file needs additional input in [X] places. Do you want to refine these before I proceed?"
4. **Cascade Rule:** If a foundational field is [NEEDS INPUT], mark dependent fields as "Dependent on [parent field]" rather than filling them independently.

Example:
- Field: "Persona Name" (source: SC2 Q1) - No named persona in SC2 Q1
- Mark as: `**Persona Name:** [NEEDS INPUT - ICP: Persona Name. Ask student for: A single representative character name for this persona (e.g., "Ahmed," "Fatima," "Rashid"). This makes the persona more memorable and concrete.]`

### Field Length Rules

Apply these constraints when extracting and synthesizing answers to maintain consistency and readability:

| Field Type | Max Length | Guidance |
|-----------|-----------|----------|
| One-liners | 15 words | Venture name, positions, role titles, single data points |
| Descriptions | 2-4 sentences | Pain descriptions, feature summaries, validation evidence |
| Lists | 7 items max | Top pains, GTM motions, features, tools. If source has more, select top 7 by relevance/score. |
| Full sections | 200 words | Extended text blocks like origin stories, market analysis, strategy rationale |
| Personal identity | 50 words | Founder name, role, experience summary combined |
| Examples | 2 per section | Writing samples, competitor weaknesses, use cases. Include one strong + one weak example when comparing. |

**Truncation Rule:** If source data exceeds the max, apply this priority: (1) Quantified/named data, (2) Recent data (SC5 > SC1), (3) MENA-specific data, (4) Validation evidence.

Example:
- SC1 Q7 lists 12 MENA cultural rules
- Field limit: 7 items max
- **Select top 7:** Ramadan timing, WhatsApp preference, relationship-first trust, payment methods, language (Arabic/English), male/female segregation in some sectors, decision-making hierarchy

### Cross-Scorecard Validation (Consistency Checks)

When the same concept appears in multiple scorecards, the extracted values must be CONSISTENT.

**Concepts that appear in multiple scorecards:**

| Concept | Scorecard(s) | Consistency Check |
|---------|---------|----------|
| Niche/Sub-market | SC1 Q3, SC2 Q1, SC4 Q10 | Name + size + geography must align across all three. If not, use SC4 (latest) as source of truth. |
| Pain (primary) | SC2 Q2, SC5 Q8 | Description + urgency + cost must match. If SC5 adds new dimensions, integrate; if contradicts, use SC5. |
| Validation evidence | SC1 Q1, SC2 Q1, SC3 B1 | All mention validation type (interviews, waitlist, survey). Must be same or compatible. If different methods, include all. |
| Buyer journey | SC2 Q4, SC5 Q9 | Obstacles and decision stages must align. SC5 may add more specificity; integrate rather than replace. |
| GTM channels | SC2 Q5, SC5 (implicit in motions) | Access channels from SC2 should align with GTM motions in SC5. Flag if SC5 prioritizes channels not in SC2 Q5. |
| MENA dynamics | SC1 Q7, SC3 C2, SC4 Q10 | Regional factors, market signals, execution advantages must be consistent in tone and substance. SC4 Q10 is primary. |

**Validation Process:**

1. Extract the concept from all relevant scorecards into a comparison view.
2. Check: Do they describe the same thing, or do they add different dimensions?
3. If same thing, do the descriptions align, contradict, or refine each other?
4. If aligned: Merge and create a single authoritative entry.
5. If contradictory: Apply conflict resolution rules above.
6. If refining: Integrate newer detail into older foundation.
7. If discrepant: Add a "CONSISTENCY NOTE: [description]" to the output file.

Example validation:

**Niche Check:**
- SC1 Q3: "Real estate professionals in UAE, specifically brokers in Dubai and Abu Dhabi"
- SC2 Q1: "Real estate agents in emirates, age 28-45, working in mid-market agencies"
- SC4 Q10: "Real estate teams in tier-1 Gulf cities: Dubai, Riyadh, Doha. Focus on transaction volume builders."

**Finding:** SC1 and SC2 overlap but differ in scope (brokers vs. agents) and focus (geography vs. age/agency). SC4 is most recent and specific.

**Resolution:** "Use SC4 as primary definition. CONSISTENCY NOTE: SC1 focused on individual brokers; SC4 notes team structures are more relevant to ICP. Niche refined from individual professionals to small broker teams in tier-1 Gulf cities."

---

