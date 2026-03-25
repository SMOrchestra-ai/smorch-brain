# Quality Rubrics — Scoring Criteria Per Dimension

## PURPOSE
Specific 4/6/8/10 criteria for each of the 8 quality dimensions. Used during Phase 4 self-scoring. Each level includes remediation action if score falls below threshold.

---

## DIMENSION 1: EXTRACTION ACCURACY

| Score | Criteria |
|-------|----------|
| **10** | Every field has a source tag. Zero fabrication. Every claim traces to a specific input (file + slide/page, user quote, or research URL). No inferred data without [INFERRED] tag |
| **8** | 90%+ fields traceable. <10% inferred from context with [INFERRED] tags. No outright fabrication |
| **6** | 70%+ traceable. Some logical inferences without tags. No fabrication but some claims are "reasonable guesses" |
| **4** | Significant gaps in traceability. Claude filled in plausible-sounding data that wasn't in any input |

**DEEP threshold:** 8+ | **QUICK threshold:** 6+

**Remediation (below threshold):**
1. Re-read all source files
2. For every untagged claim, find the source or add [INFERRED] tag
3. For any fabricated data, delete and replace with [UNDEFINED: what's needed]
4. Re-score

---

## DIMENSION 2: SPECIFICITY

| Score | Criteria |
|-------|----------|
| **10** | All fields use named entities ("Rania, Head of Marketing at a 50-person real estate brokerage in Dubai"), numbers ("loses 3 deals/month"), and quoted language ("I spend 2 hours every Monday rebuilding this spreadsheet"). Zero generic statements |
| **8** | Most fields specific. 1-2 fields use role-level language ("marketing directors at mid-size brokerages") instead of named personas. Numbers present in >80% of quantifiable fields |
| **6** | Mix of specific and generic. Some fields say "businesses" or "companies" without decomposing to role + industry + geography. Numbers in ~50% of quantifiable fields |
| **4** | Mostly generic. ICP says "SMEs" or "businesses." Pain statements are abstract ("inefficient processes"). No numbers or quoted language |

**DEEP threshold:** 8+ | **QUICK threshold:** 6+

**Remediation (below threshold):**
1. For every generic term, ask: "Which specific [role/company/industry]?"
2. For every claim without numbers, ask: "How often? How much does it cost? How many affected?"
3. If user can't provide specifics, tag as [UNDEFINED] rather than leaving generic
4. Re-score

---

## DIMENSION 3: CONSISTENCY

| Score | Criteria |
|-------|----------|
| **10** | Zero contradictions across brain files. ICP pains in icp.md appear in positioning.md wedge. Offer pricing in offer.md is within ICP budget range. GTM channels match ICP access channels. Brand voice rules are followed in all example text |
| **8** | No major contradictions. 1-2 minor inconsistencies (e.g., slightly different wording for the same concept across files) that don't create confusion |
| **6** | 1-2 substantive inconsistencies (e.g., icp.md says budget is $500/month but offer.md prices at $2,000/month) |
| **4** | Multiple contradictions. Brain files tell different stories about who the customer is, what the product does, or how it's positioned |

**DEEP threshold:** 8+ | **QUICK threshold:** 6+

**Remediation (below threshold):**
1. Run cross-file validation rules (see SKILL.md Phase 2)
2. For each contradiction: identify which file has the "source of truth" (usually icp.md or user verbal input)
3. Update contradicting files to align
4. Re-run validation
5. Re-score

---

## DIMENSION 4: ACTIONABILITY

| Score | Criteria |
|-------|----------|
| **10** | A downstream skill (signal-to-trust-gtm, asset-factory, smo-offer-assets) could read any brain file and immediately produce output without asking a single follow-up question. Every field has enough detail to act on |
| **8** | 90%+ of fields are directly actionable. 1-2 fields might need minor interpretation but not a follow-up question |
| **6** | 70%+ actionable. Some fields are too vague to execute on ("reach customers through digital channels" — which channels? what message?) |
| **4** | Many fields require clarification before a downstream skill can use them. Brain creates more questions than answers |

**DEEP threshold:** 8+ | **QUICK threshold:** 6+

**Remediation (below threshold):**
1. For each non-actionable field: rewrite with specific action language
2. "Digital channels" → "LinkedIn (connection request + 3-touch sequence), WhatsApp (warm follow-up after LinkedIn reply)"
3. "Competitive pricing" → "$497/month, positioned 30% below Competitor X ($700/month) with more MENA-specific features"
4. Re-score

---

## DIMENSION 5: COMPLETENESS

| Score | Criteria |
|-------|----------|
| **10** | All required files exist. All required fields populated. Zero [UNDEFINED] tags in required fields. Optional files generated where applicable |
| **8** | All required files exist. 90%+ required fields populated. 1-3 [UNDEFINED] tags in non-critical fields. Most optional files generated |
| **6** | All required files exist. 70%+ required fields populated. Some [UNDEFINED] tags in important fields (e.g., pricing, top pain) |
| **4** | Missing required files or >30% of required fields are [UNDEFINED] |

**DEEP threshold:** 8+ | **QUICK threshold:** 5+ (QUICK mode expects fewer files)

**Remediation (below threshold):**
1. Identify every [UNDEFINED] field in required files
2. Run one targeted gap-fill round (3-5 questions max)
3. For remaining gaps: attempt (B) RESEARCH option
4. Re-score

---

## DIMENSION 6: MENA CONTEXT

| Score | Criteria |
|-------|----------|
| **10** | mena-context.md fully populated. Trust mechanics specific to target country (UAE vs Saudi vs Egypt are different). Arabic content rules specified. Payment methods named. WhatsApp vs email preference documented. Channel trust levels calibrated for region |
| **8** | mena-context.md populated with regional defaults. Country-level specifics present for primary market. Arabic rules defined. 1-2 areas use MENA-wide generalizations instead of country-specific data |
| **6** | mena-context.md exists but uses broad MENA generalizations without country-level detail. Basic Arabic/English defaults set |
| **4** | mena-context.md missing or contains only placeholder text. No regional specifics. Western defaults assumed |
| **N/A** | Project explicitly targets non-MENA market only. Score this dimension as 8 (neutral) and note "Non-MENA project" |

**DEEP threshold:** 8+ | **QUICK threshold:** 6+

**Remediation (below threshold):**
1. Read references/mena-context.md for regional framework
2. Ask: "Which specific MENA country is primary market? UAE, Saudi, Egypt, Jordan, Kuwait, Qatar, other?"
3. Apply country-specific trust mechanics, payment methods, and language rules
4. Re-score

---

## DIMENSION 7: POSITIONING CLARITY

| Score | Criteria |
|-------|----------|
| **10** | Positioning statement is a single sentence that a stranger could read and immediately understand what makes this different. Wedge is a pattern-interrupt opener that creates curiosity. Unique mechanism is defensible (not "we're easier to use"). Differentiators have evidence, not just claims. Positioning directly addresses a gap identified in competitive-landscape.md |
| **8** | Positioning statement clear. Wedge is strong. Unique mechanism is specific. 1-2 differentiators lack concrete evidence |
| **6** | Positioning statement exists but is generic ("we're the best solution for X"). Wedge is feature-focused, not signal-based. Mechanism is "better/faster/cheaper" without structural difference |
| **4** | No clear positioning. Reads like a feature list, not a market position. Could describe any competitor with minor word changes |

**DEEP threshold:** 8+ | **QUICK threshold:** 6+

**Remediation (below threshold):**
1. Read references/frameworks/positioning-framework.md
2. Apply the "Unlike [competitor], we [unique mechanism]" test
3. For each differentiator without evidence: find evidence or remove
4. Rewrite wedge using signal-based language (observed signal → specific outcome → one-line solution)
5. Re-score

---

## DIMENSION 8: COMMERCIAL GROUNDING

| Score | Criteria |
|-------|----------|
| **10** | Pricing is specific with tiers if applicable. Revenue math is present (price × expected customers = target). Budget reality checked against ICP's known spend. ROI framing included (customer pays X, gets Y value). Guarantee or risk reversal specified. Competitive pricing context present |
| **8** | Pricing specific. Basic revenue math present. Budget aligned with ICP. 1-2 commercial details missing (e.g., no guarantee, no competitive pricing comparison) |
| **6** | Pricing exists but lacks context ("$500/month" without explaining value relative to alternatives). No revenue math. Budget alignment assumed, not verified |
| **4** | No pricing, or pricing is "$TBD." No commercial framing. Offer reads like a feature list without business context |

**DEEP threshold:** 8+ | **QUICK threshold:** 5+ (QUICK mode may lack full commercial detail)

**Remediation (below threshold):**
1. If pricing missing: ask user directly or research competitor pricing for anchoring
2. Add revenue math: "At $X/month × Y customers = $Z MRR target"
3. Add ROI framing: "Customer's current cost of problem: $A/month. Our price: $B/month. ROI: [ratio]"
4. Re-score

---

## AGGREGATE SCORING

### Calculation
Overall score = average of all 8 dimensions (or 7 if MENA is N/A)

### Thresholds
| Mode | Minimum Overall | Minimum Per Dimension | Action if Below |
|------|----------------|----------------------|-----------------|
| DEEP | 8.5/10 | 7.0 | Auto-iterate on weakest 2 dimensions |
| QUICK | 7.0/10 | 5.0 | Auto-iterate on weakest 1 dimension |

### Auto-Iteration Protocol
1. Identify lowest-scoring dimension(s)
2. Apply dimension-specific remediation (listed above)
3. Re-score ONLY the remediated dimension(s)
4. If still below threshold after 1 iteration: flag to user with specific gap description
5. Maximum 2 auto-iteration rounds. After that, deliver with quality note

### Score Reporting Format
```
BRAIN QUALITY SCORE: [overall]/10 ([DEEP/QUICK] threshold: [threshold])

1. Extraction accuracy:  [X]/10
2. Specificity:          [X]/10
3. Consistency:          [X]/10
4. Actionability:        [X]/10
5. Completeness:         [X]/10
6. MENA context:         [X]/10
7. Positioning clarity:  [X]/10
8. Commercial grounding: [X]/10

[If any below threshold]: ⚠️ [Dimension] scored [X]/10 (threshold: [Y]). Remediating...
[After remediation]: ✓ [Dimension] improved from [X] to [Z]/10.
```
