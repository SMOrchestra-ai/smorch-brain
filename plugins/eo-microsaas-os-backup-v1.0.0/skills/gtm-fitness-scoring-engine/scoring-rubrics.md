# GTM Fitness Scoring Engine v3.0 — Scoring Rubrics & Expert Gates

This file contains detailed scoring formulas, upstream bonus calculations, strategy path bonuses, upstream-to-motion fit mapping, and expert framework gate definitions.

Referenced from `SKILL.md` Sections 5, 7, and 8.

---

## 1. UPSTREAM BONUS CALCULATION

### Upstream Fit Bonus (from HTML scoring engine)

```
upstreamFitBonus = 0
if SC1 score > 70: +0.5
if SC2 score > 70: +0.5
if SC3 score > 70: +0.3
if SC4 score > 70: +0.3
Maximum upstream bonus: 1.6 (added to each motion's defaultFit)
```

### Strategy Path Bonus Matrix (from HTML scoring engine)

Each SC4 strategy path gives bonuses to specific motions:

| Motion | Replicate | Consulting | Micro-SaaS | Hammering |
|--------|-----------|------------|------------|-----------|
| 0. Waitlist Heat | +1 | 0 | +1 | 0 |
| 1. Build-in-Public | 0 | 0 | +2 | +1 |
| 2. Authority Education | +1 | +2 | 0 | 0 |
| 3. Wave Riding | 0 | 0 | +1 | 0 |
| 4. LTD Cash-to-MRR | 0 | 0 | +2 | 0 |
| 5. Signal Sniper | 0 | +1 | 0 | +2 |
| 6. Outcome Demo | +1 | +1 | +1 | +1 |
| 7. Hammering-Feature | 0 | 0 | +1 | +3 |
| 8. BOFU SEO | 0 | 0 | +2 | +1 |
| 9. Dream 100 | +1 | +2 | 0 | 0 |
| 10. 7x4x11 | 0 | +1 | 0 | +1 |
| 11. Value Trust Engine | +1 | +1 | +1 | 0 |
| 12. Paid VSL | 0 | 0 | 0 | 0 |

---

## 2. SCORING FORMULAS

### Motion Readiness Score (per motion)

For each of 13 motions, readiness is calculated from answers x weights:

```
readinessRaw = SUM(answer_value[q] x weight[motion][q]) for q = 0..11
readinessMax = SUM(4 x weight[motion][q]) for q = 0..11  // max possible
readiness = (readinessRaw / readinessMax) x 10   // scaled 0-10
```

If a motion has zero total weight (impossible with current matrix), default readiness = 5.

### Motion Fit Score

```
fit = defaultFit + upstreamFitBonus + pathBonus[motion]
fit = min(10, fit)  // cap at 10
```

Where:
- `defaultFit` is the motion's baseline fit (from MOTIONS array)
- `upstreamFitBonus` comes from SC1-SC4 scores > 70
- `pathBonus` comes from SC4 strategy path

### Motion MENA Score

```
mena = min(10, baseMena x menaMultiplier)
```

Where `menaMultiplier` = [0.3, 0.6, 1.0, 1.2] based on Q12 answer.

### Composite Score (per motion)

```
composite = (fit x 0.4) + (readiness x 0.3) + (mena x 0.3)
Range: 0.0 to 10.0
```

### Overall Score (0-100)

```
raw = ((sum_of_answers - num_answered) / (num_answered x 3)) x 85
bonus = SC1>70? +3 : 0 + SC2>70? +3 : 0 + SC3>70? +2 : 0 + SC4>70? +2 : 0
bonus += Q12 answer >= 3? +3 : (>= 2? +1 : 0)
overall = min(100, max(0, round(raw + bonus)))
```

---

## 3. EXPERT FRAMEWORK GATES

These are non-scoring diagnostic frameworks that add strategic context to the motion recommendations. They don't change scores but may reorder priorities, add prerequisites, or trigger interventions.

### Gate 1: Pattern of Inaction Early Check

**Trigger:** Founder has been working on idea >6 months AND has zero launches/products shipped to market.

**Detection signals during assessment:**
- High capability answers (Q1-Q6 averaging 3+) but no evidence of execution
- Answers include phrases like "still researching," "want to get it right," "building first"
- Expert archetype from SC4 with zero launched products

**Output (added to gtm-fitness.md):**

```
WARNING: PATTERN OF INACTION DETECTED

Your capability scores are strong, but your execution history shows zero GTM
motion activation in the past 90 days. This is the #1 failure mode for domain
experts entering entrepreneurship.

ROOT CAUSE: You're optimizing for CERTAINTY before action. In corporate, that's
rewarded. In entrepreneurship, it's fatal.

PRESCRIPTION -- The 72-Hour Rule:
Your first GTM motion should be activated within 72 HOURS of completing this
assessment. Not 72 days. Not "after I finish building."

RECOMMENDED FIRST MOTION: [Lowest-friction motion from top 3]
```

**Impact:** Does NOT reduce scores. Adds a prerequisite gate. Prioritizes SPEED over comprehensiveness in motion sequencing.

### Gate 2: Content Systems Check (Matt Gray Framework)

**Applied when:** Any content-dependent motion (Authority Education, Build-in-Public, Wave Riding) scores as PRIMARY.

**Evaluation:**
| System Status | Implication | Action |
|---|---|---|
| System exists (batch creation, scheduling, repurposing) | Can sustain 2-3 content motions | Proceed |
| Ad-hoc creation | High burnout risk; 1 motion max | Add "Build 30-in-30 content batch" as pre-launch task |
| No system | Must build first | 1-week content system design before launching motion |

### Gate 3: Solo Founder Bandwidth Calculator

**Input:** Weekly hours available (from SC4 A3 or inferred from answers)

**Bandwidth Rules (Non-Negotiable):**
- **20+ hours/week:** PRIMARY + 1 SECONDARY = 2 motions max
- **10-19 hours/week:** PRIMARY only; sequence SECONDARY to week 5+
- **<10 hours/week:** Part-time GTM; recommend Consulting-First or Dream 100 (lower friction)

**Motion Load Model:**
| Motion Type | Weekly Hours Required |
|---|---|
| PRIMARY motion | ~10 hrs/week |
| SECONDARY motion | ~5 hrs/week |
| Tertiary (simultaneous) | NOT recommended |

### Gate 4: Pattern Interrupt Readiness (Brendan Kane Framework)

**Applied to:** Authority Education, Build-in-Public, Wave Riding when scored as PRIMARY or SECONDARY.

**Brendan Kane's 5 Hook Point Formulas:**
1. Contrarian Take — Challenges conventional wisdom
2. Data Disruption — Surprising stats or findings
3. Behind-the-Curtain — Insider perspective
4. Challenge/Dare — Actionable challenge
5. Story Hook — Personal narrative that builds curiosity

**Evaluation:**
- **Green Flag (Readiness up):** Founder's planned content includes hook structures = proceed
- **Red Flag (Readiness down):** Content is generic/educational with no hooks = recommend 2-hour Pattern Interrupt training before activation, or delay 1 week for content reframing

### Gate 5: Engagement Audit (Nir Eyal Hook Model)

**Applied to:** Top 3 recommended motions before final ranking.

**Hook Model Components per Motion:**
1. **Trigger** — What brings customers back?
2. **Action** — What's the minimal next step?
3. **Reward** — What's the variable payoff?
4. **Investment** — What deepens engagement over time?

**Scoring:**
- 3-4/4 components: STRONG LOOP = boost priority
- 0-2/4 components: WEAK LOOP = lower priority; recommend adding engagement hooks

---

## 4. UPSTREAM DATA TO MOTION FIT MAPPING

This section defines how upstream scorecard data translates into motion fit adjustments. This is the intelligence layer that makes SC5 more than a standalone questionnaire.

### SC1 (Project Definition) to Motion Fit

| SC1 Signal | Motion Impact |
|---|---|
| Niche = 3-level defined | Boost: Signal Sniper (+1), BOFU SEO (+1) — narrow niche enables precise targeting |
| Positioning = category creator | Boost: Authority Education (+2), Build-in-Public (+1) — category creators need education-led GTM |
| Geography = MENA-first | Boost: Dream 100 (+1), Waitlist (+1), Value Trust (+1) — MENA-native motions |
| Geography = US/Global | Boost: BOFU SEO (+1), Paid VSL (+1), Build-in-Public (+1) — Western-native motions |
| ACV > $10K | Boost: 7x4x11 (+2), Dream 100 (+1), Signal Sniper (+1) — high-touch justified |
| ACV < $500 | Boost: LTD (+2), Build-in-Public (+1), BOFU SEO (+1) — self-serve motions |

### SC2 (ICP Clarity) to Motion Fit

| SC2 Signal | Motion Impact |
|---|---|
| ICP congregates on LinkedIn | Boost: Signal Sniper (+1), Build-in-Public (+1), Authority Education (+1) |
| ICP congregates at events | Boost: 7x4x11 (+1), Waitlist Heat (+1), Value Trust (+1) |
| ICP buying behavior = research-heavy | Boost: Authority Education (+2), BOFU SEO (+1) |
| ICP buying behavior = relationship-driven | Boost: Dream 100 (+2), 7x4x11 (+1) |
| ICP budget = low (<$1K) | Boost: LTD (+1), Build-in-Public (+1); Penalize: Paid VSL (-1) |
| ICP budget = high (>$10K) | Boost: 7x4x11 (+1), Signal Sniper (+1), Dream 100 (+1) |

### SC3 (Market Attractiveness) to Motion Viability

| SC3 Signal | Motion Impact |
|---|---|
| Pain reality = urgent | Boost: Signal Sniper (+1), Outcome Demo (+1) — urgency enables outbound |
| Pain reality = latent | Boost: Authority Education (+1) — need to educate market |
| Market growth = expanding | Boost: Wave Riding (+1), BOFU SEO (+1) — riding growth wave |
| Competition = high | Boost: Hammering-Feature (+1), BOFU SEO (+1) — differentiation motions |
| Competition = low | Boost: Authority Education (+1), Build-in-Public (+1) — category creation |
| Purchasing power = strong | Boost: Paid VSL (+1), 7x4x11 (+1) — budget for premium motions |

### SC4 (Strategy Selector) to Motion Selection

| SC4 Path | PRIMARY Motions | SECONDARY Motions | CONDITIONAL |
|---|---|---|---|
| **Replicate & Localize** | Authority Education, Value Trust, Dream 100 | Waitlist Heat, Outcome Demo | Signal Sniper, BOFU SEO |
| **Consulting-First SaaS** | Authority Education, Dream 100, 7x4x11 | Signal Sniper, Outcome Demo, Value Trust | Waitlist Heat |
| **Boring Micro-SaaS** | Build-in-Public, BOFU SEO, LTD | Hammering-Feature, Waitlist Heat, Outcome Demo | Wave Riding |
| **Hammering Deep** | Signal Sniper, Hammering-Feature, BOFU SEO | Build-in-Public, Outcome Demo | Wave Riding |

| SC4 Archetype | Motion Affinity |
|---|---|
| The Domain Expert | Authority Education (high), Dream 100 (high) |
| The Connector | Dream 100 (high), 7x4x11 (high), Waitlist Heat (medium) |
| The Builder | Hammering-Feature (high), Build-in-Public (high), BOFU SEO (medium) |
| The Operator | Signal Sniper (high), 7x4x11 (high), Outcome Demo (medium) |
