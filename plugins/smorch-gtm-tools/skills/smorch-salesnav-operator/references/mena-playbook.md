# MENA-Specific LinkedIn Sales Navigator Playbook

## The Core Problem in MENA LinkedIn Targeting

LinkedIn in MENA has split language patterns, inconsistent title conventions, and geography quirks that break every Western playbook. This document captures the operational adjustments that actually work.

## Language-First Filtering

**Rule**: Treat Profile language as a first-class filter. Pin it as default in every search.

Why: A "Sales Director" in Riyadh might have their profile in English, Arabic, or both. Searching without language filtering mixes two fundamentally different outreach contexts: an English-profile exec expects English outreach, an Arabic-profile exec may respond better to Arabic.

**Execution**:
- Run every ICP search TWICE: once with Profile language = English, once = Arabic
- Build separate lists for each language segment
- Route English-profile leads to English sequences, Arabic to Arabic sequences
- Mixed-language profiles (title in English, posts in Arabic): default to English outreach but reference Arabic content if engaging

## Geography Traps

**Trap 1: HQ vs. Lead Location**
Many senior MENA decision-makers work for companies HQ'd in London, Singapore, New York. Filtering by "Account HQ: UAE" misses them.

**Fix**: Use "Lead Geography: UAE" for finding people who are IN the UAE, regardless of company HQ. Use "Account HQ: UAE" only when targeting UAE-founded companies specifically.

**Trap 2: Expat Drift**
Common pattern: exec's LinkedIn says "Dubai" but they relocated to Singapore or London 6 months ago. Profile location lags reality.

**Fix**: Cross-reference with recent activity. If their posts mention a different city, flag for manual verification. Run geo-validation monthly.

**Trap 3: Postal vs. Region**
Sales Nav Personas let you add regions OR postal codes, not both simultaneously. For MENA, use regions (country-level) since postal code coverage is spotty.

## Title Localization Challenges

**Problem**: The same role can appear as 5+ different titles in MENA:
- Sales Director = مدير المبيعات = Sales Lead = Head of Sales = Commercial Director
- CEO = الرئيس التنفيذي = Managing Director = Owner = Founder (used interchangeably in SME)

**Fix**: Build title clusters, not single-title searches. Each cluster captures the English + Arabic + regional variants.

Example cluster for "Revenue Leader":
```
English: ("VP Sales" OR "Head of Sales" OR "Sales Director" OR "Chief Revenue Officer" OR "CRO" OR "Commercial Director" OR "GM Sales")
Arabic: ("نائب رئيس المبيعات" OR "مدير المبيعات" OR "مدير تجاري")
```

**Seniority filter as guardrail**: Always pair title Boolean with Seniority filter (Director+, VP, CXO) to catch variants while excluding junior roles with similar keywords.

## Cultural Timing Rules

| Day | Activity Level |
|-----|---------------|
| Sunday | Full day - start of work week in GCC |
| Monday-Wednesday | Full days - peak activity |
| Thursday | Half day - wind down by 1-2pm GST |
| Friday | OFF - no outreach, no activity |
| Saturday | Some activity (varies by company) - light engagement only |

**Ramadan 2026 (Feb 28 - Mar 30):**
- Reduce outreach volume by 50%+
- Shift timing to evening hours (after Iftar, typically 7-10pm GST)
- Tone: respectful, no aggressive CTAs, no urgency language
- Many deals pause during Ramadan and close in the weeks after Eid
- Post-Eid (first week of April 2026): highest deal velocity of the year

**Other key periods:**
- National Day holidays (UAE: Dec 2-3, KSA: Sep 23): No outreach
- Summer (July-August): Many Gulf executives travel to Europe. Response rates drop 30-40%
- Q4 budget season: Decision-making accelerates Sep-Nov in most MENA corporates

## The "Majlis Effect" (Trust Mechanics)

In MENA B2B, personal trust still compresses deal cycles more than any signal. BUT the contrarian insight: you can engineer trust signals digitally without 47 coffee meetings.

**Digital trust signals that matter in MENA:**
1. Mutual connections (check in Sales Nav before any outreach)
2. Content engagement visible in their feed (like/comment their posts BEFORE CR)
3. Shared professional background (same industry, same companies, same conferences)
4. Arabic-language content creation (signals cultural competence)
5. Reference to local initiatives (Vision 2030, ADGM, DIFC, NEOM) when relevant

**Connection request priority:**
1. 1st degree connection exists → message directly
2. Mutual connections exist → reference them in CR note
3. Shared content engagement → reference their post
4. No connections → use signal-based angle (job change, growth)

## Signal Interpretation for MENA

Some signals mean different things in MENA:

| Signal | Western Interpretation | MENA Interpretation |
|--------|----------------------|-------------------|
| Headcount growth Q4 | Budget expansion | Could be seasonal (retail, logistics) - verify department |
| Job change | New leader evaluating vendors | Could be title change only (same company restructured) |
| Following your company | Weak interest | Might be competitor intelligence - check their company |
| VP title | Decision maker | In smaller MENA companies, VP can mean senior individual contributor |
| "Strategy" in title | Planning role | In GCC government entities, often operational with budget authority |

## Arabic Boolean Patterns

For Keyword field in Sales Nav (not Title field - Title field requires exact):

**Real Estate:**
```
("Property Management" OR "عقارات" OR "Real Estate" OR "إدارة العقارات")
```

**Healthcare:**
```
("Patient Experience" OR "تجربة المريض" OR "Practice Management" OR "إدارة العيادة")
```

**Government/Semi-Gov:**
```
("Vision 2030" OR "رؤية 2030" OR "NEOM" OR "PIF" OR "صندوق الاستثمارات")
```

**Sales/Commercial:**
```
("مدير مبيعات" OR "تطوير الأعمال" OR "Business Development" OR "المبيعات")
```

## Data Quality Checklist (Monthly)

1. **Geo Validation**: Verify UAE/KSA lists don't contain people who moved to Singapore/London
2. **Title Drift**: Check if champions got promoted to decision makers (expansion play)
3. **Duplicate Check**: Cross-reference Sales Nav lists against HeyReach and Instantly lists
4. **Language Accuracy**: Verify profile language matches assigned sequence language
5. **Company Status**: Check if any saved accounts were acquired, merged, or closed
