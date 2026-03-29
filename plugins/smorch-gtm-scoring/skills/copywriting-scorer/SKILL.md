<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: copywriting-scorer
description: Scores written copy across 4 subsystems (cold email, VSL scripts, LinkedIn DMs, WhatsApp messages) against channel-specific criteria. Evaluates spam filter survival, scroll-stopping hooks, engagement quality, and action triggers. Uses 2026 Gmail/Microsoft mechanics, Instantly.ai benchmarks, and MENA WhatsApp data. Triggers on 'score my email', 'rate this copy', 'email quality check', 'VSL score', 'score my LinkedIn message', 'WhatsApp copy review', 'will this pass spam filters', 'copywriting audit', 'score outreach messages'.
---

# Copywriting Scorer

**System 3 of 6 — Battle-Tested Copywriter Hat**

**What this scores:** The actual written words in cold emails, VSL scripts, LinkedIn outreach messages, and WhatsApp messages. Four subsystems, each with channel-specific criteria calibrated to where the words actually appear and what they need to survive (spam filters, scroll behavior, conversation dynamics).

**Benchmark sources:** Instantly.ai 2026 Cold Email Benchmarks, CopyPosse VSL framework, LinkedIn 2026 engagement data, Gmail/Microsoft 2026 spam filter mechanics, MENA WhatsApp B2B data. Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/benchmarks-2026.md` for current numbers.

**Scoring rules:** Read `${CLAUDE_PLUGIN_ROOT}/skills/scoring-orchestrator/references/score-bands.md` for universal score bands, hard stop rules, and output formats.

---

## Subsystem Selection

When scoring copy, first identify which subsystem applies:

| Content | Subsystem | Criteria Count |
|---------|-----------|---------------|
| Cold email (outbound) | 3A: Cold Email | 9 criteria |
| Video sales letter script | 3B: VSL Script | 8 criteria |
| LinkedIn DMs and connection notes | 3C: LinkedIn DM | 7 criteria |
| WhatsApp business messages | 3D: WhatsApp | 8 criteria |

If scoring copy for a multi-channel campaign, score each channel separately and report the subsystem scores individually. The orchestrator uses the highest-scoring subsystem for the composite Campaign Health formula.

---

## Subsystem 3A: Cold Email Copy

**9 criteria** — Subject Line (15%), Opening Line (15%), Spam Filter Survival (12%), Body Value Density (12%), Social Proof (8%), CTA Clarity (15%), Personalization Depth (10%), Sequence Architecture (8%), Tone & Voice (5%).

Cold email copy must survive three gauntlets: the spam filter (technical), the inbox scan (2 seconds to earn the open), and the read (10 seconds to earn the reply).

**Full rubrics and calibration:** see `references/cold-email-rubrics.md`

---

## Subsystem 3B: VSL Script

**8 criteria** — Hook (20%), Problem Articulation (15%), Unique Mechanism (15%), Proof Stacking (15%), Objection Handling (10%), Retention Architecture (10%), CTA & Close (10%), Script Length & Pacing (5%).

Video Sales Letters combine visual + verbal persuasion. The script is the skeleton. Key metric: retention.

**Full rubrics and calibration:** see `references/vsl-rubrics.md`

---

## Subsystem 3C: LinkedIn DM

**7 criteria** — Connection Request (15%), First Message (20%), Value-First (15%), Conversation Sequencing (15%), Personalization Quality (15%), Tone & Authenticity (10%), CTA Progression (10%).

LinkedIn DMs operate in a trust-first environment. The platform punishes aggressive sales behavior with reduced visibility and connection blocks. Includes platform risk flags for volume, pattern detection, and InMail abuse.

**Full rubrics and calibration:** see `references/linkedin-dm-rubrics.md`

---

## Subsystem 3D: WhatsApp Messages

**8 criteria** — Opening Greeting (15%), Message Brevity (12%), Value Proposition (15%), Voice Note Readiness (10%), Timing Optimization (10%), Follow-Up Cadence (10%), Personalization & Relevance (13%), CTA Simplicity (15%).

WhatsApp is MENA's #1 warm B2B channel. Different rules: more personal, shorter messages, voice notes are acceptable, Arabic greetings expected for Gulf markets.

**Full rubrics and calibration:** see `references/whatsapp-rubrics.md`

---

## Scoring Execution

### Input Required
1. The copy to score (email text, VSL script, LinkedIn messages, WhatsApp messages)
2. Which subsystem (3A/3B/3C/3D) - auto-detect from content type
3. Target ICP and market (for calibrating MENA vs US benchmarks)

### Scoring Mindset

Think like a copywriter who has written 5,000+ cold emails and watched the analytics on every one. You know that:
- Subject lines determine whether everything else matters
- The first line is worth more than the rest of the email combined
- 50-80 words is the sweet spot; every word beyond 80 costs you replies
- Timeline hooks (referencing something they just did) outperform problem hooks 2.3x
- Follow-ups with new value recover 42% of total replies
- WhatsApp in MENA is a relationship channel first, sales channel second
- Voice notes from founders outperform text 2:1 in Gulf B2B

---

## Cross-System Dependencies

Copywriting is a downstream system. When copy scores poorly, the root cause is often upstream.

| Low Score In Copy | Likely Upstream Cause | Check This System & Criterion |
|-------------------|----------------------|-------------------------------|
| 3A C2: Opening line generic | No signal defined | Campaign Strategy: C1 Signal Clarity |
| 3A C4: Body has no value | Offer unclear | Offer/Positioning: C1 Dream Outcome Clarity |
| 3A C5: No social proof | No proof stacked | Offer/Positioning: C2 Perceived Likelihood |
| 3A C7: Can't personalize deeply | ICP too broad | Campaign Strategy: C2 ICP Precision |
| 3B C3: Mechanism explanation weak | No named mechanism | Offer/Positioning: C5 Unique Mechanism |
| 3B C4: Proof section thin | Offer lacks case studies | Offer/Positioning: C2 Perceived Likelihood |
| 3C C3: Value-first content missing | No value to share | Offer/Positioning: C7 Price-to-Value Gap |
| 3D C1: Greeting wrong for market | Channel-market mismatch | Campaign Strategy: C3 Channel-Market Fit |
| 3D C5: Timing off | No market timing plan | Campaign Strategy: C6 Timing & Velocity |
| All subsystems: CTA weak | Offer doesn't reduce friction | Offer/Positioning: C4 Effort Minimization |

If 3+ copywriting criteria trace to the same upstream system, flag it: "The copy isn't the problem. Fix [upstream system] first, then re-score copy."

---

## Multi-Subsystem Scoring

When scoring copy for a multi-channel campaign, score each subsystem independently, then compute:

```
Copy Composite = (Primary Channel Score x 0.50) +
                 (Secondary Channel Score x 0.30) +
                 (Tertiary Channel Score x 0.20)
```

Primary channel = the channel carrying the highest send volume. If all channels are equal volume, weight by expected reply contribution (typically: email > LinkedIn > WhatsApp for cold; WhatsApp > LinkedIn > email for warm).

The orchestrator uses the **best single subsystem score** for the Campaign Health composite (not this internal composite). This internal composite is for the copywriting scorer's own quality tracking.

---

## Calibration Anchor: Scored Example (Cold Email)

**Scenario:** Email 1 of a 5-step cold email sequence for SalesMfast Signal Engine, targeting VP Sales at Series A-B SaaS companies in UAE who recently hired new sales team members.

**Email being scored:**

```
Subject: quick q about {{company}}'s new sales hire

{{firstName}}, noticed {{company}} just brought on a new Head of Sales.

When teams expand in the Gulf, the first 90 days usually expose a gap: the pipeline was built on relationships, not systems. New sales leaders inherit contacts but not a repeatable engine.

We built a signal-based outbound system for [similar company] in Riyadh — went from 3 to 14 qualified meetings/month in 60 days, zero coffee meetings.

Worth a 15-min call to see if the same approach fits {{company}}?
```

**Score:**

| # | Criterion | Weight | Score | Rationale |
|---|-----------|--------|-------|-----------|
| C1 | Subject Line | 15% | 9.5 | 6 words, lowercase, personalized with {{company}}, curiosity gap ("quick q"), zero spam triggers. Feels like an internal email. |
| C2 | Opening Line | 15% | 9.0 | Timeline hook referencing verified signal (new hire). Specific and recent. "Noticed" framing is natural. Minor: could add the hire's name for deeper personalization. |
| C3 | Spam Filter Survival | 12% | 9.5 | Zero spam words, no links, no images, plain text, no HTML. Under 80 words (73 words). Single CTA. Would pass Instantly spam checker clean. |
| C4 | Body Value Density | 12% | 8.5 | Every sentence adds value. Demonstrates understanding of their specific situation (relationship-built pipeline). Gap: "usually expose a gap" is slightly generic — could be more specific about WHAT gap (stale data? no outbound? wrong market?). |
| C5 | Social Proof | 8% | 8.0 | Specific result (3→14 meetings, 60 days, Riyadh). Industry-relevant. "Zero coffee meetings" is the differentiator. Gap: company name bracketed as [similar company] — named logo would be stronger. |
| C6 | CTA Clarity | 15% | 9.0 | Single, binary, low-friction. "Worth a 15-min call?" Yes/no answer. No calendar link in email 1. |
| C7 | Personalization Depth | 10% | 8.5 | 2 layers: signal (new hire) + company context (expanding in Gulf). Missing third layer: role-specific pain for VP Sales specifically. |
| C8 | Sequence Architecture | 8% | 7.0 | This is email 1 of 5 — can't fully score architecture from one email. Assume 4-day spacing and new angles per follow-up. Score conservatively pending full sequence review. |
| C9 | Tone & Voice | 5% | 9.0 | Peer-to-peer. Casual but professional. No supplication, no aggression. "Worth a 15-min call?" is confident without being pushy. |

**OVERALL: 8.72 / 10 — VERDICT: STRONG**
**HARD STOPS: None**
**TOP FIX: C4 Body Value Density — replace "usually expose a gap" with the specific gap this ICP faces: "the pipeline was built on personal relationships that don't transfer — new hires start from zero." Lift: +0.5 on C4.**
