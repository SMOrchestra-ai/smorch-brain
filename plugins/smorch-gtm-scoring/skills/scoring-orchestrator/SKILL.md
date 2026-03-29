<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: scoring-orchestrator
description: >-
  Quality gate for all SMOrch GTM deliverables. Routes to 7 scoring systems
  (campaign strategy, offer/positioning, copywriting, social media, YouTube,
  LinkedIn branding, scorecard/lead magnet effectiveness) and computes composite Campaign Health scores. Triggers on
  "score this", "rate this", "quality check", "is this ready to ship", "score my
  campaign", "score my email", "score my post", "how good is this", "grade this",
  "scoring", "quality gate", "ready to deploy", "ship check". Also triggers when
  reviewing ANY deliverable before deployment. The most important plugin in the
  stack; nothing ships without a score.
---

# Scoring Orchestrator

**Purpose:** Route scoring requests to the right specialist scorer, enforce hard stops, compute composite Campaign Health, and track improvement priority.

This is the quality gate for SMOrchestra.ai's GTM output. Every campaign asset, every piece of copy, every social post, every YouTube video, every LinkedIn post passes through this system before shipping. The premise: systematic scoring against expert-grade benchmarks catches quality problems that intuition misses. A 7.0 floor with hard stop enforcement means nothing mediocre gets to market.

---

## How Scoring Works

### Step 1: Identify What's Being Scored

When the user presents content for scoring, determine which system applies:

| Content Type | Scoring System | Skill to Invoke |
|-------------|----------------|-----------------|
| Campaign plan, outbound strategy, GTM architecture | System 1: Campaign Strategy | campaign-strategy-scorer |
| Offer structure, pricing, positioning statement, value prop | System 2: Offer & Positioning | offer-positioning-scorer |
| Cold email, VSL script, LinkedIn DM, WhatsApp message | System 3: Copywriting | copywriting-scorer |
| Organic social post (LinkedIn/Twitter/Instagram) | System 4: Social Media | social-media-scorer |
| YouTube thumbnail, title, script, or description | System 5: YouTube | youtube-scorer |
| LinkedIn personal brand post (English B2B or Arabic EO) | System 6: LinkedIn Branding | linkedin-branding-scorer |
| Lead magnet, scorecard, quiz, self-assessment, diagnostic tool, ROI calculator | System 7: Scorecard Effectiveness | scorecard-effectiveness |

If the content spans multiple systems (e.g., "score my entire campaign"), run each applicable scorer and then compute the composite.

### Step 2: Route to Specialist Scorer

Each scorer is an independent skill with its own criteria, weights, descriptors, and benchmarks. The orchestrator does not contain scoring logic; it routes and aggregates.

When routing:
1. Read the content or ask the user to paste/upload it
2. Identify the correct scorer(s)
3. Invoke the scorer skill
4. Collect the output (score JSON + narrative assessment)

### Step 3: Enforce Hard Stops

After each scorer returns results, check hard stop rules from `references/score-bands.md`:

- **Rule 1:** Any criterion below 5.0 = mandatory rework (blocks shipping)
- **Rule 2:** Primary channel scoring below 6.0 = deployment blocked
- **Rule 3:** MENA-targeted deliverables must score 6.0+ on MENA Contextualization

If hard stops trigger, report them prominently. Do not bury them in the narrative.

### Step 4: Compute Composite (Multi-System Scoring)

When scoring a full campaign across multiple systems, calculate Campaign Health using the formula in `references/composite-formula.md`:

```
Campaign Health = (Campaign Strategy x 0.25) +
                  (Offer/Positioning x 0.20) +
                  (Best Copywriting Subsystem x 0.25) +
                  (Social Media x 0.15) +
                  (YouTube OR LinkedIn x 0.15)
```

Normalize weights for systems not scored.

**Worked example:**

Campaign: Q2 MENA SaaS expansion
- Campaign Strategy: 8.5
- Offer/Positioning: 8.7
- Email Copy (primary channel): 8.2
- LinkedIn Posts (authority layer): 7.8
- YouTube: not scored (no video assets this campaign)

Applicable weights: 0.25 + 0.20 + 0.25 + 0.15 = 0.85 (YouTube excluded)

Normalized weights:
- Strategy: 0.25 / 0.85 = 0.294
- Offer: 0.20 / 0.85 = 0.235
- Email: 0.25 / 0.85 = 0.294
- LinkedIn: 0.15 / 0.85 = 0.176

Campaign Health = (8.5 × 0.294) + (8.7 × 0.235) + (8.2 × 0.294) + (7.8 × 0.176)
= 2.499 + 2.045 + 2.411 + 1.373
= **8.33 / 10 — YELLOW (Deploy with monitoring)**

Weakest link: LinkedIn Posts at 7.8. Fix: sharpen authority signal and contrarian angle.
Strongest asset: Offer/Positioning at 8.7. The value prop is clear; copy and content need to express it better.

### Step 5: Assign Improvement Priority

Using the 7-level matrix in `references/composite-formula.md`, assign the improvement priority level (P0-P6) and recommend the single highest-impact fix.

---

## Output Format

### Single System Score

```
SCORE REPORT: [Deliverable Name]
System: [Name] | Subsystem: [if applicable]
Date: [YYYY-MM-DD]

CRITERIA BREAKDOWN:
| # | Criterion | Weight | Score | Status |
|---|-----------|--------|-------|--------|
| 1 | [Name]    | [%]    | [X]   | [OK/FIX/HARD STOP] |
...

OVERALL: [X.X] / 10
VERDICT: [SHIP / TWEAK / IMPROVE / REWORK / RESTART]
HARD STOPS: [None / List]

TOP 3 FIXES (by impact):
1. [Criterion]: [Specific fix action] — estimated lift: +[X] points
2. [Criterion]: [Specific fix action] — estimated lift: +[X] points
3. [Criterion]: [Specific fix action] — estimated lift: +[X] points

BENCHMARK COMPARISON:
[How this deliverable compares to 2026 benchmarks from references/benchmarks-2026.md]
```

### Composite Campaign Score

```
CAMPAIGN HEALTH REPORT: [Campaign Name]
Date: [YYYY-MM-DD]

SYSTEM SCORES:
| System | Score | Weight | Weighted |
|--------|-------|--------|----------|
| Campaign Strategy | [X.X] | 25% | [Y.Y] |
| Offer/Positioning | [X.X] | 20% | [Y.Y] |
| Copywriting ([subsystem]) | [X.X] | 25% | [Y.Y] |
| Social Media | [X.X] | 15% | [Y.Y] |
| YouTube/LinkedIn | [X.X] | 15% | [Y.Y] |

CAMPAIGN HEALTH: [X.X] / 10
STATUS: [GREEN / YELLOW / ORANGE / RED]
PRIORITY LEVEL: [P0-P6]

WEAKEST LINK: [System] at [X.X] — [Specific fix]
STRONGEST ASSET: [System] at [X.X]

IMPROVEMENT ROADMAP:
1. [P-level]: [Fix this first because...]
2. [Next priority]: [Then fix this...]
3. [Optimization]: [Finally, optimize...]
```

### JSON Output (for programmatic tracking)

Save to workspace as `scores/[deliverable-slug]-[date].json`:

```json
{
  "system": "campaign-strategy",
  "subsystem": null,
  "deliverable": "Q2-MENA-SaaS-Campaign",
  "date": "2026-03-26",
  "scorer": "claude",
  "criteria": [
    {"id": "C1", "name": "Signal Clarity", "weight": 15, "score": 8.5, "status": "OK", "fix_action": null}
  ],
  "overall_score": 7.8,
  "hard_stops": [],
  "verdict": "STRONG",
  "priority": "P5",
  "top_fix": "Improve multi-channel coordination",
  "timestamp": "2026-03-26T14:30:00Z"
}
```

---

## Scoring Protocol

### Before Scoring: Context Check

Before scoring any deliverable, establish:
1. **Target market:** MENA, US, EU, or multi-market? (changes MENA context weight)
2. **ICP:** Who is this for? (changes relevance of criteria)
3. **Campaign context:** Is this standalone or part of a larger campaign? (determines whether composite scoring applies)
4. **Business line:** SMOrchestra consulting, SalesMfast Signal Engine, SalesMfast SME, CXMfast, or EO? (changes benchmarks)

### During Scoring: Calibration

Score honestly. The system only works if scores reflect reality. Common calibration errors:
- **Generosity bias:** Scoring 7-8 on everything. If the deliverable has clear gaps, score them.
- **Anchoring:** Letting a strong first criterion inflate subsequent scores. Score each criterion independently.
- **Recency bias:** Scoring based on what the last deliverable looked like rather than the absolute benchmark.

**Calibration Reference Points:**

Use these anchor examples to maintain consistent scoring across sessions:

| Score | What it looks like (cold email example) |
|-------|----------------------------------------|
| 9.5 | "quick q about {{company}} expansion" — 4 words, lowercase, personalized, zero spam. Timeline hook opening with verified signal. 52 words total. Single binary CTA. |
| 7.5 | "thoughts on {{company}}'s outbound" — decent subject. Problem-hook opening (not signal-based). 85 words. CTA slightly high friction. |
| 5.0 | "Partnership opportunity" — generic subject. "Many companies struggle with..." opener. 140 words. Feature dump. Calendar link in email 1. |
| 2.0 | "UNLOCK YOUR GROWTH POTENTIAL!!!" — all caps, exclamation. "Dear Sir/Madam." 250 words. HTML template with images. Multiple links. |

When you're unsure whether something is a 7 or an 8, ask: "Would this survive in a competitive market against other well-crafted versions?" If yes, it's 8+. If it would work but wouldn't stand out, it's 7. If a busy prospect would skip it, it's below 7.

**Calibration anchors by system (what 9.0+ looks like):**

| System | What a 9.0+ looks like |
|--------|----------------------|
| Campaign Strategy | All 10 criteria above 7.5. Signals defined with detection infrastructure. ICP at 3-level niche. Channel mix MENA-native. Full Q>M>W>D hierarchy documented. 48-hour signal-to-touch. |
| Offer/Positioning | Hormozi Value Equation ratio >4.0. Dunford 5/5 present with narrative coherence. Named mechanism with diagram. Explicit ROI math. Performance guarantee. |
| Copywriting (Email) | Timeline hook from verified signal. Under 80 words. Zero spam triggers. Single binary CTA. 3-layer personalization. 4-7 email sequence with new value per follow-up. |
| Copywriting (LinkedIn DM) | Under 300 char connection note with shared context. No pitch until message 3+. Value-first content shared. Conversation, not sequence. |
| Copywriting (WhatsApp) | Gulf Arabic greeting. Under 60 words. Voice note ready. Sunday-Thursday timing. 2-3 follow-ups max. One-tap CTA. |
| Social Media (TOFU) | Scroll-stopping hook with specific number. Shareability trigger. Authority through specificity. Brand signature present. |
| Social Media (MOFU) | Framework that changes thinking. Vulnerable behind-the-scenes. Case study with before/after numbers. |
| Social Media (BOFU) | Legitimate urgency. One-step CTA. Stacked proof (metric + quote + screenshot). |
| YouTube (Thumbnail) | Readable at 120x90px. Emotional expression. 0-3 words. High contrast. Brand consistent. |
| YouTube (Script) | Hook in first 15 seconds with bold claim. Pattern interrupts every 90s. Actionable frameworks with stories. |
| LinkedIn Branding (Track A) | Contrarian take backed by Gulf data. Client trigger density. 80%+ value. Named framework. |
| LinkedIn Branding (Track B) | Gulf Arabic. Build-in-public energy. Aspiration trigger with specific transformation. AI demystified. Movement language. |

### Cross-System Dependency Protocol

When a scorer flags a criterion below 6.0, check the cross-system dependency table in that scorer's SKILL.md. If the dependency traces upstream:

1. Report the low score on the downstream criterion
2. Flag the upstream dependency: "This score is likely a symptom. Root cause: [upstream system] > [upstream criterion]"
3. Recommend fixing upstream first before re-scoring downstream
4. In the improvement roadmap, order the fix as: upstream fix → downstream re-score → downstream fix (if still needed)

### System Disagreement Protocol

When upstream and downstream systems show contradictory scores (e.g., Offer scores 9.0 but Copywriting scores 5.0), diagnose:

| Pattern | Likely Cause | Action |
|---------|-------------|--------|
| Strategy high, Copy low | Good plan, poor execution | Fix copy. Strategy is sound. |
| Strategy low, Copy high | Polished lipstick on a pig | Fix strategy first. Good copy on bad strategy wastes it. |
| Offer high, Copy low | Strong value prop, weak articulation | Copy fix. The raw material exists. |
| Offer low, Copy high | Great writing, nothing to say | Fix offer. No amount of wordsmithing saves a weak offer. |
| Offer high, Social/YouTube low | Product-market fit exists, visibility gap | Fix content. The offer sells when people hear it. |
| All systems 6-7 | Mediocre everything, nothing great | Pick the highest-weighted system and push it to 9.0. One excellent system lifts the composite more than incremental improvement across all. |

**Rule of thumb:** When scores disagree, always fix upstream first. Strategy feeds Offer feeds Copy feeds Social/YouTube. A downstream fix on an upstream problem is temporary.

### After Scoring: Track and Trend

If the workspace has a `scores/` directory, append the JSON output. Over time, this creates a scoring history that reveals:
- Which systems consistently score lowest
- Which criteria are perennial weak spots
- Whether scores are trending up or down after process changes

### Score Presentation Guidelines

When presenting scores to the user:

1. **Lead with the verdict**, not the number. "This campaign is ready to ship with monitoring" > "Your score is 8.33."
2. **Always present the full criteria table.** Even when all criteria are green, the table shows what's working.
3. **Top 3 fixes are mandatory** for any score below 9.0. Each fix must include: which criterion, what to do specifically, and estimated point lift.
4. **Hard stops are highlighted first**, before any narrative. Use bold or emphasis.
5. **Offer to fix.** After every score report, offer to implement the #1 fix immediately. "Want me to rewrite the opening line with a timeline hook? That should lift C2 by 1-2 points."
6. **Save JSON.** If in a project workspace, always save the score JSON. Trends matter more than individual scores.

---

## Reference Files

Read these as needed during scoring:
- `references/score-bands.md` — Score interpretation, hard stop rules, verdict mapping
- `references/benchmarks-2026.md` — Current benchmark data for all channels
- `references/composite-formula.md` — Campaign Health calculation and Improvement Priority Matrix

---

## Interaction Pattern

When a user asks for scoring:

1. **Immediate:** "What are we scoring?" If obvious from context, skip the question and state what you're about to score.
2. **Load content:** Read the deliverable (from file, pasted text, or conversation context).
3. **Route:** Invoke the appropriate scorer skill(s).
4. **Report:** Present the score report in the format above.
5. **Fix:** If score is below 8.0, offer to implement the top fix immediately. If hard stops trigger, implement fixes before anything else.
6. **Save:** If in a project workspace, save the JSON output.

Do not ask "shall I score this?" when the user clearly wants scoring. Score it.
