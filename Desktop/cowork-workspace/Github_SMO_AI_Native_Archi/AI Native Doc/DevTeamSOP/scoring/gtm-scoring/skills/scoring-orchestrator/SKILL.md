---
name: scoring-orchestrator
description: >-
  Quality gate for all SMOrch GTM deliverables. Routes to 6 scoring systems
  (campaign strategy, offer/positioning, copywriting, social media, YouTube,
  LinkedIn branding) and computes composite Campaign Health scores. Triggers on
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

### Cross-System Dependency Protocol

When a scorer flags a criterion below 6.0, check the cross-system dependency table in that scorer's SKILL.md. If the dependency traces upstream:

1. Report the low score on the downstream criterion
2. Flag the upstream dependency: "This score is likely a symptom. Root cause: [upstream system] > [upstream criterion]"
3. Recommend fixing upstream first before re-scoring downstream
4. In the improvement roadmap, order the fix as: upstream fix → downstream re-score → downstream fix (if still needed)

### After Scoring: Track and Trend

If the workspace has a `scores/` directory, append the JSON output. Over time, this creates a scoring history that reveals:
- Which systems consistently score lowest
- Which criteria are perennial weak spots
- Whether scores are trending up or down after process changes

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
