---
name: scorecard-effectiveness
description: "Scores lead magnets, assessments, scorecards, quizzes, and diagnostic tools on their conversion effectiveness using 10 research-backed dimensions. Triggers on: 'score my lead magnet', 'rate my assessment', 'is my scorecard effective', 'lead magnet quality check', 'quiz conversion review', 'score my diagnostic', 'will this convert', 'lead magnet audit', 'assessment effectiveness', 'scorecard review'. Also triggers when reviewing ANY self-assessment, quiz, calculator, or diagnostic tool before deployment. Fires for partial reviews too: 'is this quiz too long', 'will people finish this', 'how do I improve my lead magnet'."
---

# Scorecard Effectiveness Scorer

Evaluates lead magnets, self-assessments, scorecards, quizzes, calculators, and diagnostic tools on their ability to convert cold traffic into qualified leads and buyers. Based on conversion psychology research, interactive content benchmarks, and MENA B2B market data.

Channel-agnostic: works for web-based assessments, WhatsApp quizzes, PDF scorecards, GHL surveys, Typeform/ScoreApp tools, or custom-built diagnostic apps.

## WHEN TO USE

Score any lead magnet that asks the prospect to self-assess, answer questions, or receive a personalized output:
- Self-assessment scorecards (like "Digital Revenue Score", "Marketing Maturity Assessment")
- ROI calculators
- Diagnostic quizzes ("What type of X are you?")
- Readiness assessments, benchmark comparison tools
- Interactive worksheets that produce personalized output

Do NOT use for static lead magnets (PDFs, whitepapers, checklists), content offers (templates, swipe files), or tools that don't involve user input and personalized output.

## REFERENCE FILES

- `references/benchmarks.md` — Conversion rates, completion rates, follow-up timing data. Read when you need to cite specific numbers.
- `references/mena-adjustments.md` — MENA-specific scoring modifiers for WhatsApp, Arabic, trust mechanics. Read when the assessment targets MENA markets.

## THE 10 DIMENSIONS

Each dimension scores 1-10 with 0.5 increments. Dimensions are weighted: HIGH (1.5x) or MEDIUM (1.0x) in the composite calculation.

### D1: Problem Revelation (Weight: HIGH)

Does the assessment make the prospect SEE a problem they didn't know they had? The best lead magnets reframe reality. The prospect finishes thinking "I didn't realize we were this broken."

**Scoring rubric:**
- 1-3: Confirms what they already know. No reframe. Generic categories.
- 4-6: Reveals some gaps but doesn't quantify them or create urgency. The "so what" is missing.
- 7-8: Clear gap revelation. Specific dimensions they hadn't considered. Productive discomfort.
- 9-10: Complete reframe. The scoring dimensions themselves are insights. Reading the QUESTIONS teaches something new. They can't unsee the gaps.

**What to look for:**
- Are the scoring dimensions themselves educational? (Best: answer options teach what "good" looks like)
- Does output show gap between current state and ideal state?
- Is the gap framed as a cost, not just deficiency? ("You're losing $X" > "You scored low on Y")
- Does it create cognitive dissonance? (They thought they were doing well but the score says otherwise)

### D2: First Step Friction (Weight: HIGH)

How easy is it to START and FINISH the assessment? The sweet spot is 5-8 questions for B2B (enough depth for credibility, short enough to complete). See `references/benchmarks.md` for completion rate data by question count.

**Scoring rubric:**
- 1-3: 15+ questions, requires data lookup, 10+ minutes. Most won't finish.
- 4-6: 10-14 questions, some require thought or research. 5-8 minutes. Completion at risk.
- 7-8: 6-9 questions, all answerable from memory, 3-5 minutes. Progress bar visible.
- 9-10: 5-8 questions, under 3 minutes, framed as "2-minute check." Single-select answers. Smooth transitions. Mobile-friendly. The experience feels fast even if it takes 3 minutes.

**What to look for:** Question count (most important single factor), time framing in CTA, answer format (single-select > multi-select > free text), whether questions need data lookup, mobile responsiveness, progress indicator.

### D3: Score-to-CTA Bridge (Weight: HIGH)

How well does the results page connect the score to the offer? The assessment creates the diagnosis; the bridge makes the sale feel logical, not salesy.

**Scoring rubric:**
- 1-3: Generic CTA unrelated to scores. "Book a call" with no connection to gaps.
- 4-6: CTA acknowledges score band but doesn't map gaps to solutions. "Your score is low, we can help."
- 7-8: Score-band-specific CTAs with different offers for different segments. Maps 2-3 gaps to solution features.
- 9-10: Dynamic CTA references their SPECIFIC lowest dimension, calculates their SPECIFIC dollar gap, maps top 3 weaknesses to exact program components. Multiple tiers by score band. The offer feels like the only rational response.

**What to look for:** Does CTA change by score band? Does it reference specific dimensions? Personalized math? Gap-to-solution mapping? Low-friction CTA? (Apply vs Buy vs Book free call)

### D4: Trust Before Ask (Weight: HIGH)

Does the assessment give value BEFORE asking for anything? Value first, capture second. In MENA markets, this dimension carries extra weight because the trust threshold is structurally higher. See `references/mena-adjustments.md`.

**Scoring rubric:**
- 1-3: Gates everything behind email capture. No value until they submit contact info.
- 4-6: Shows partial results, gates full report. Standard but uninspired.
- 7-8: Full score visible immediately. Email/phone for detailed report. Social proof on results page.
- 9-10: Full results with rich output (radar chart, gap analysis, dollar calculation). Capture feels like a bonus not a gate. Industry benchmarks for context. Case studies at moment of max attention.

**What to look for:** When does email capture happen? Score shown immediately or gated? Social proof elements? Assessment design signals expertise? "People like you" comparison?

### D5: Specificity of Output (Weight: HIGH)

How personalized is the results page? Generic "you need help" outputs are worthless. The output should feel like a free consulting session.

**Scoring rubric:**
- 1-3: Generic text output. Same for everyone in same band. "You scored Intermediate."
- 4-6: Score with dimension breakdowns but no actionable insight. Numbers without context.
- 7-8: Dimension-specific insights with recommendations. Radar/spider chart vs benchmark. Weakest area gets extra attention.
- 9-10: Personalized dollar gap from their inputs. Radar chart vs industry benchmark. #1 gap gets 60% of results page real estate with "here's what this costs you" math. Actionable micro-recommendations per dimension. Downloadable branded report.

**What to look for:** Visual score representation? Output adapts to lowest dimension? Quantified impact (dollars, time, opportunity)? Specific vs generic recommendations? References their answers back?

### D6: Mobile/UX Quality (Weight: MEDIUM)

Does the assessment deliver a polished, fast, mobile-first experience? In MENA, 78% of B2B research happens on mobile. A clunky assessment kills completion regardless of content quality.

**Scoring rubric:**
- 1-3: Desktop-only or broken on mobile. Slow load. Generic form tool look. No transitions.
- 4-6: Mobile-responsive but not mobile-first. Adequate UX but nothing impressive. Standard form tool.
- 7-8: Mobile-first design. Fast load (<2s). Smooth transitions between questions. Touch-friendly targets (44px+). Custom UI that feels branded, not templated. Loading/processing animation.
- 9-10: Native-app-quality experience. Instant transitions with subtle animations. Gesture support. Offline-capable or instant-load. Custom illustrations or micro-interactions. The UX itself is a trust signal. Would make someone screenshot and share just because it looks polished.

**What to look for:** Load time on mobile, touch target sizes, transition quality, branded vs generic feel, progress indicator quality, error handling UX, Arabic RTL support (if MENA), accessibility basics (contrast, font size).

### D7: Data Capture and Shareability (Weight: MEDIUM)

What data do you collect, and can people share their results? Assessment answers are gold for segmentation. Every shared result is a free impression and new lead.

**Scoring rubric:**
- 1-3: Only captures email. No sharing mechanism. Results exist only in browser session.
- 4-6: Captures email + company. Can screenshot but no designed sharing. Assessment answers stored but not used.
- 7-8: Captures email, phone, company, role. Answers feed CRM tags and segmented sequences. Downloadable branded PDF. Social sharing buttons. Unique results URL.
- 9-10: Full profile: email, WhatsApp, company, deal size, team size. Answers create rich CRM profile. Score band routes to different automations. Branded PDF with radar chart, score, QR code linking back. WhatsApp share button (critical for MENA). "Share with your co-founder" CTA. Team comparison mode. Analytics dashboard shows distribution and conversion by band.

**What to look for:** Fields captured and their downstream purpose, CRM integration, sharing mechanisms (PDF, social, WhatsApp), branded shareable output with link back, team/comparison features, WhatsApp number with country code default.

### D8: Follow-Up Sequence Trigger (Weight: HIGH)

What happens AFTER they see their score? The assessment is the hook. The follow-up is the conversion engine. Without a sequence, you lose 80% of captured leads. See `references/benchmarks.md` for timing data.

**Scoring rubric:**
- 1-3: No follow-up. Single email with results. Dead end.
- 4-6: Generic drip sequence unrelated to score. Same emails for everyone.
- 7-8: Score-band-segmented email sequence. 3-5 emails over 10-14 days. Content adapts to weakest dimension.
- 9-10: Multi-channel nurture: WhatsApp (primary for MENA) + email. Score-band-segmented. 5-7 touches over 12 days. Day 0: score delivery + weakest dimension deep-dive. Day 2: voice note from founder. Day 5: case study matching their gap. Day 8: scarcity + CTA. Day 12: score expiry/retake trigger. Different sequences for <50, 50-70, 70+ bands.

**What to look for:** Any follow-up beyond results page? Segmented by score band? References specific gaps? WhatsApp included? Scarcity/urgency trigger? "Retake" trigger? Time span (12-14 days optimal)?

### D9: Competitive Differentiation (Weight: MEDIUM)

Does this assessment look and feel different from competitors? Most B2B lead magnets are "free consultation" or "download our guide." A scored diagnostic is already differentiated, but HOW differentiated?

**Scoring rubric:**
- 1-3: Standard Typeform survey. No proprietary framework. Could be anyone's.
- 4-6: Custom questions but generic presentation. Scoring framework isn't named or branded.
- 7-8: Named proprietary framework (e.g., "Digital Revenue Score"). Custom methodology. Dimensions feel researched and niche-specific.
- 9-10: Named, branded methodology that feels like IP. Dimensions themselves are insights no competitor offers. Industry benchmarks from real data. Assessment experience functions as a product demo. Custom UI. Prospect thinks "whoever built this really understands my problem."

**What to look for:** Methodology named and branded? Dimensions unique to niche? Experience feels custom or template-based? Demonstrates creator's expertise? Would a prospect screenshot and send to their team?

### D10: Conversion to Paid (Weight: HIGH)

How effectively does the assessment move people from "interesting free tool" to "I need to buy"? The ultimate measure.

**Scoring rubric:**
- 1-3: Assessment and offer feel disconnected. CTA could be pasted on any page.
- 4-6: Logical connection but weak emotional bridge. "I should probably do something" but not "I need THIS."
- 7-8: Assessment creates a problem the offer solves. Score-to-solution mapping clear. Multiple tiers. Risk reversal.
- 9-10: Designed backward from the offer. Every question plants a seed the offer harvests. Lowest dimension gets 60% of results page AND maps to specific program component. Personalized dollar math makes ROI obvious. Risk reversal tied to assessment metrics. NOT buying feels like the risky choice.

**What to look for:** Backward design (assessment reveals problems the offer solves)? Results page makes offer feel logical? Personalized ROI math? Tiered offers by score band? Risk reversal tied to metrics? Urgency that makes delaying feel costly?

## SCORING PROCESS

### Pre-Check

Before full scoring, confirm the subject qualifies:
1. Does it involve user input (questions, selections, data entry)?
2. Does it produce personalized output (score, report, recommendations)?
3. Is there a commercial intent (CTA, offer, or nurture connected)?

If any answer is "no," this scorer doesn't apply. Redirect to the appropriate content/offer scorer.

### Step 1: Gather the Assessment

Ask for or locate:
- The assessment questions (all, with answer options)
- The scoring logic (how answers map to scores)
- The results page design/content
- The CTA and offer it connects to
- Any follow-up sequences
- The delivery channel (web, WhatsApp, GHL, etc.)

If the assessment is still in design (architecture doc, not built), score the DESIGN. Note which dimensions are theoretical vs implemented. Theoretical dimensions cap at 8/10 because execution risk exists.

If a dimension doesn't exist at all (e.g., no follow-up sequence planned), score it 1/10 with a note: "Not designed. This is the highest-impact addition."

### Step 2: Score Each Dimension

For each of the 10 dimensions:
1. State the dimension name and weight
2. Assign a score (1-10) with 0.5 increments
3. Provide 2-3 sentences of evidence (what you observed)
4. State one specific improvement that would add 1-2 points

### Step 3: Calculate Weighted Composite

```
weighted_sum = (D1×1.5) + (D2×1.5) + (D3×1.5) + (D4×1.5) + (D5×1.5) + (D6×1.0) + (D7×1.0) + (D8×1.5) + (D9×1.0) + (D10×1.5)
max_possible = (1.5×7) + (1.0×3) = 13.5
composite = (weighted_sum / (max_possible × 10)) × 10
```

HIGH dimensions (D1, D2, D3, D4, D5, D8, D10) get 1.5x weight.
MEDIUM dimensions (D6, D7, D9) get 1.0x weight.

### Step 4: Identify Top 3 Fixes

From all 10 improvement suggestions, rank top 3 by impact-to-effort ratio. Prioritize HIGH-weight dimensions with low scores first.

### Step 5: Score Band and Verdict

- 0-4.0: **Critical.** Will burn ad spend. Redesign before deploying.
- 4.1-6.0: **Weak.** Some leads but conversion to paid will disappoint. Fix top 3 gaps.
- 6.1-7.5: **Developing.** Solid foundation, meaningful gaps. Close gaps before scaling spend.
- 7.6-8.5: **Strong.** Will convert. Fine-tune top 3 for maximum ROI.
- 8.6-9.5: **Excellent.** Ship it. Monitor data and iterate from live metrics.
- 9.6-10: **Elite.** Benchmark-setting. Document what you did; this is replicable IP.

## OUTPUT FORMAT

```
SCORECARD EFFECTIVENESS AUDIT
Assessment: [Name]
Date: [Date]
Scorer: SMOrchestra.ai
Status: [Live / Design Only / Partially Built]

DIMENSION SCORES:
D1  Problem Revelation     (HIGH)  [X/10]  [1-line evidence]
D2  First Step Friction    (HIGH)  [X/10]  [1-line evidence]
D3  Score-to-CTA Bridge    (HIGH)  [X/10]  [1-line evidence]
D4  Trust Before Ask       (HIGH)  [X/10]  [1-line evidence]
D5  Specificity of Output  (HIGH)  [X/10]  [1-line evidence]
D6  Mobile/UX Quality      (MED)   [X/10]  [1-line evidence]
D7  Data Capture & Share   (MED)   [X/10]  [1-line evidence]
D8  Follow-Up Sequence     (HIGH)  [X/10]  [1-line evidence]
D9  Competitive Diff       (MED)   [X/10]  [1-line evidence]
D10 Conversion to Paid     (HIGH)  [X/10]  [1-line evidence]

WEIGHTED COMPOSITE: [X.X/10] — [Band]

TOP 3 FIXES (by impact-to-effort):
1. [Dimension]: [Specific fix] → [Expected score lift]
2. [Dimension]: [Specific fix] → [Expected score lift]
3. [Dimension]: [Specific fix] → [Expected score lift]

PROJECTED SCORE AFTER FIXES: [X.X/10]
```

## CALIBRATION EXAMPLE

This example shows how to apply the rubrics to a real assessment. Use it as an anchor when scoring.

**Assessment:** Digital Revenue Score (SMOrchestra.ai)
**Type:** 8-question web assessment for B2B non-tech companies in MENA
**Offer:** Revenue Engine Mastermind ($5,000 cohort)

```
D1  Problem Revelation     (HIGH)  8.5/10  Questions themselves teach what "good" looks like
    (answer E options show the ideal state; most prospects pick B/C and see the gap)
    Fix: Add dollar cost to each gap on results page → +1

D2  First Step Friction    (HIGH)  9/10    8 questions, single-select, framed as "2-minute check"
    Fix: Already near-optimal; test 7 vs 8 questions for marginal completion lift → +0.5

D3  Score-to-CTA Bridge    (HIGH)  8/10    Score-band-specific CTAs (<50, 50-70, 70+) with
    different offers per band. Maps biggest gap to program component.
    Fix: Add personalized dollar math on CTA itself ("Your $90K gap → 8-week fix") → +1

D4  Trust Before Ask       (HIGH)  7.5/10  Full score visible before capture. Capture framed as
    "send to WhatsApp" not gate. Missing: named Gulf company social proof on results page.
    Fix: Add 2-3 named company logos + "200+ companies scored" counter → +1

D5  Specificity of Output  (HIGH)  8.5/10  Radar chart, biggest-gap section gets 60% of page,
    dollar gap calculated from their deal size input.
    Fix: Add micro-recommendations per dimension ("Here's what to do Monday") → +0.5

D6  Mobile/UX Quality      (MED)   7/10    Custom Next.js app (not Typeform), dark brand,
    smooth transitions. Not yet tested on actual mobile devices.
    Fix: Implement touch-optimized radio buttons + Arabic RTL toggle → +1.5

D7  Data Capture & Share   (MED)   7.5/10  Captures email, WhatsApp, company, deal size. PDF
    score card with radar chart and QR code. Missing: team comparison mode.
    Fix: Add "Share with your co-founder" WhatsApp forward button → +1

D8  Follow-Up Sequence     (HIGH)  8/10    WhatsApp-first + email, score-band-segmented,
    Mamoun voice note on Day 2. Missing: retake trigger on Day 12.
    Fix: Add score expiry email on Day 12 ("Your market has moved, retake?") → +0.5

D9  Competitive Diff       (MED)   8/10    Named framework ("Digital Revenue Score"), 8 proprietary
    dimensions, custom UI. No competitor in MENA offers this format.
    Fix: Add "Industry Benchmark" comparison using seeded data → +0.5

D10 Conversion to Paid     (HIGH)  8/10    Backward-designed from Mastermind offer. Each question
    plants a seed. Dollar gap math present. Missing: risk reversal on CTA.
    Fix: Add "Score guarantee: improve by 30+ points or money back" → +1

WEIGHTED COMPOSITE: 8.1/10 — Strong
TOP 3 FIXES: D4 social proof (+1), D3 dollar math on CTA (+1), D10 risk reversal (+1)
PROJECTED: 9.0/10
```

## EDGE CASES

**Assessment in design only (not built):** Score the design. Cap theoretical dimensions at 8/10 because execution risk is real. Note "design only" in the Status field.

**Missing dimension entirely:** Score 1/10. Note "Not designed" in evidence. This is almost always the highest-impact fix.

**Non-English assessments:** Score D9 higher if natively in the target market's language (not translated). For MENA: read `references/mena-adjustments.md` for Arabic-specific calibration.

**Multiple CTAs or offers:** Score D3 and D10 based on the PRIMARY CTA path. Note secondary paths as upside.

**Assessment with no commercial intent:** (e.g., pure brand awareness) This scorer is designed for conversion. If there's no offer, D3 and D10 are N/A. Score the remaining 8 dimensions and adjust the composite accordingly.
