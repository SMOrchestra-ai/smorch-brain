# EO Brain Ingestion - Validation Rules & Coaching Logic

This file contains quality gate details, dimension-level thresholds, coaching loop protocol, score extraction patterns, and error handling. Referenced from SKILL.md.

---

## SCORE EXTRACTION

Each scorecard file contains an overall score. Extract it from the header area:

| Scorecard | Score Location Pattern |
|-----------|----------------------|
| SC1 | `**Score:** XX/100` or line containing `/100` near top |
| SC2 | `**Clarity Score:** XX/100` |
| SC3 | `**Overall Score:** XX/100` |
| SC4 | `**Score:** XX/100` |
| SC5 | `**Score:** XX/100` |

### SC1 Score Pattern
Look for: `**Score:** XX/100` in first 10 lines
Dimension scores: Look for Section headers with `(XX points)` and scored answers

### SC2 Score Pattern
Look for: `**Clarity Score:** XX/100` in first 10 lines
Dimension scores: Look for table with columns `| Dimension | Score | Status |`

### SC3 Score Pattern
Look for: `**Overall Score:** XX/100` in first 10 lines
Dimension scores: Look for table with columns `| Dimension | Score | Max | Percentage |`

### SC4 Score Pattern
Look for: `**Score:** XX/100` in first 10 lines
No dimension-level scores (path selection is holistic)

### SC5 Score Pattern
Look for: `**Score:** XX/100` in first 10 lines
Motion scores: Look for table with columns `| # | Motion | Fit | Readiness | MENA | Score | Tier |`
Count motions with Tier = PRIMARY. Need >= 3.

---

## DIMENSION-LEVEL CHECKS

Beyond the overall score, check dimension scores within each scorecard:

**SC1 Dimensions:**
| Dimension | Source | Threshold |
|-----------|--------|-----------|
| Founder Context | Section A (15 pts) | >= 12 |
| Niche Definition | Section B (25 pts) | >= 20 |
| Positioning | Section C (20 pts) | >= 16 |
| Product Vision | Section D (20 pts) | >= 16 |
| Brand Voice | Section E (10 pts) | >= 7 |
| MENA Context | Section F (10 pts) | >= 7 |

**SC2 Dimensions:**
| Dimension | Threshold |
|-----------|-----------|
| Customer Definition | >= 85/100 |
| Pain Clarity | >= 85/100 |
| Dream Outcome | >= 85/100 |
| Buyer Journey | >= 85/100 |
| Access Channels | >= 85/100 |
| Validation Plan | >= 85/100 |

**SC3 Dimensions:**
| Dimension | Threshold |
|-----------|-----------|
| Pain Reality | >= 20/25 |
| Purchasing Power | >= 12/15 |
| Market Sizing | >= 12/15 |
| Growth Signals | >= 20/25 |

**SC4:** Overall score check only (path selection is binary, not dimensional)

**SC5 Dimensions:**
Check that at least 3 GTM motions score >= 7.0 composite. If fewer than 3 motions reach PRIMARY tier, flag for coaching.

---

## COACHING LOOP PROTOCOL

When a scorecard or dimension falls in the 70-84 range:

### Step 1: Identify Weak Dimensions

Read the scorecard's "Recommended Fixes" section. Extract the specific dimensions below threshold.

### Step 2: Targeted Coaching Questions

For each weak dimension, ask ONE targeted question that directly addresses the gap. Do NOT re-run the entire scorecard. Examples:

**SC1 - Niche too broad:**
"Your niche definition scored [X]. The gap: [specific issue from recommended fixes]. Can you narrow your sub-market? Tell me: who specifically are the 100 people who would pay you $50/month within 90 days? Name the role, the company size, the geography, and what they are doing right now that is broken."

**SC2 - Pain not quantified:**
"Your pain clarity scored [X]. The gap: costs are not quantified. For your top pain: how many hours per week does your ICP waste on this? What does that cost them in dollars per month? Have you heard a real customer say this in their own words?"

**SC3 - Market sizing weak:**
"Your market sizing scored [X]. The gap: no bottom-up SOM. Walk me through: how many potential customers can you physically reach in the next 12 months through your existing channels? Be specific: LinkedIn reach, email list, WhatsApp groups, events."

### Step 3: Integrate Answer

Take the student's coaching answer and merge it with the original scorecard data. The coached answer REPLACES the weak section, not supplements it.

### Step 4: Re-Score (Optional)

After coaching, tell the student: "Your [dimension] is now stronger. You can optionally re-run the full scorecard to get an updated score, but it is not required. The data I have is sufficient to proceed."

### Coaching Rules

- Maximum 3 coaching questions per scorecard
- Maximum 2 rounds of iteration per dimension
- If after 2 rounds a dimension still feels weak, proceed anyway and flag it in the output files as "COACHING NOTE: [dimension] may need further refinement"
- Never coach on dimensions that already pass threshold
- Keep coaching questions sharp and specific, not open-ended

---

## ERROR HANDLING

| Error | Response |
|-------|----------|
| Missing scorecard file | "I cannot find [SC name]. Have you completed this scorecard? If yes, tell me the exact filename." |
| Score not parseable | "I cannot read the score from [filename]. Can you tell me your score for [SC name]?" |
| File is empty or corrupt | "The file [filename] appears empty. Please check it and re-upload." |
| Student wants to skip coaching | "I can proceed, but I will flag the weak areas in your output files. Downstream skills may ask you to strengthen these later." |
| Student wants to re-run a scorecard | "Go ahead. Run the scorecard skill, then come back here and I will re-ingest. I will not lose your other data." |
| Dimension data is missing from file | "Your [SC name] file is missing [field]. This sometimes happens with older scorecard versions. Can you answer this quickly: [targeted question]?" |

---

*Reference file for EO Brain Ingestion Engine v1.0*
