# GTM Fitness Scoring: Weight Matrix & Upstream Bonuses

This document contains the complete weight matrix, upstream bonus calculations, and strategy path bonuses that feed into motion scoring.

---

## The 13x13 Weight Matrix

This matrix determines how each assessment question (Q0-Q11) influences each motion's readiness score.

Reading the matrix: Weight 3 = critical dependency | Weight 2 = strong influence | Weight 1 = moderate | Weight 0 = irrelevant

```
                   Q0   Q1   Q2   Q3   Q4   Q5   Q6   Q7   Q8   Q9  Q10  Q11  Q12
                  list cont  vis  demo outb budg netw deal ship srch sale evnt mena
0  Waitlist        3    1    2    1    0    1    2    0    1    0    1    3    0
1  Build-Public    1    3    3    1    0    0    1    0    2    0    0    0    0
2  Authority Ed    2    3    3    0    0    0    1    0    0    1    0    2    0
3  Wave Riding     0    2    1    1    0    1    1    0    3    1    0    0    0
4  LTD             1    0    0    3    0    0    0    0    3    1    0    0    0
5  Signal Sniper   0    0    0    0    3    1    0    2    0    1    3    0    0
6  Outcome Demo    0    0    1    3    1    0    0    1    0    0    2    0    0
7  Hammering       0    0    0    2    1    0    0    0    3    3    0    0    0
8  BOFU SEO        0    2    0    1    0    1    0    0    2    3    0    0    0
9  Dream 100       0    1    2    0    1    0    3    1    0    0    2    1    0
10 7x4x11          0    0    0    0    2    2    2    3    0    0    3    2    0
11 Value Trust     2    1    2    1    0    1    0    0    0    0    1    3    0
12 Paid VSL        1    0    0    2    0    3    0    1    0    2    0    0    0
```

### Weight Legend

| Weight | Dependency | Example |
|--------|----------|---------|
| **3** | Critical | Signal Sniper requires Q4 (outbound tools) and Q10 (sales capacity). Missing either = motion fails. |
| **2** | Strong Influence | Authority Education depends heavily on Q1 (content frequency) and Q2 (visibility). Can execute without them but much harder. |
| **1** | Moderate | Waitlist Heat benefits from email list (Q0) but works with organic audience. Influences score but not disqualifying. |
| **0** | Irrelevant | Build-in-Public doesn't care about outbound tools (Q4) or network (Q6). Founder alone can succeed. |

### How to Use This Matrix

**For scoring an individual motion:**

```
readinessRaw = SUM(answer_value[q] × weight[motion][q]) for q = 0..11

Example: Signal Sniper with answers [1,2,1,2,3,2,1,2,1,1,2,1]
readinessRaw = (1×0 + 2×0 + 1×0 + 2×0 + 3×3 + 2×1 + 1×0 + 2×2 + 1×0 + 1×1 + 2×3 + 1×0)
             = 0 + 0 + 0 + 0 + 9 + 2 + 0 + 4 + 0 + 1 + 6 + 0
             = 22

readinessMax = SUM(4 × weight[motion][q]) for all q
readinessMax = (4×0 + 4×0 + 4×0 + 4×0 + 4×3 + 4×1 + 4×0 + 4×2 + 4×0 + 4×1 + 4×3 + 4×0)
             = 0 + 0 + 0 + 0 + 12 + 4 + 0 + 8 + 0 + 4 + 12 + 0
             = 40

readiness = (readinessRaw / readinessMax) × 10 = (22 / 40) × 10 = 5.5
```

---

## Weight Matrix Patterns & Logic

### High-Dependency Motions (Q-weights heavily concentrated)

These motions have 2-3 critical dependencies and fail without them:

| Motion | Critical Weights | Implication |
|--------|-----------------|-----------|
| Signal Sniper | Q4 (w=3), Q10 (w=3) | Needs tools + sales capacity. Missing both = SKIP |
| Hammering-Feature | Q8 (w=3), Q9 (w=3) | Needs speed + search demand. Slow ship speed = SKIP |
| 7x4x11 | Q7 (w=3), Q10 (w=3) | Needs high ACV + sales time. Low deal size = SKIP |
| BOFU SEO | Q9 (w=3) | Needs search demand. No search volume = SKIP |

### Balanced Motions (Weights distributed across multiple Q)

These motions work with different founder profiles:

| Motion | Weight Distribution | Meaning |
|--------|------------------|---------|
| Authority Education | Q0, Q1, Q2 (w=2-3), Q11 (w=2) | Works for experts who create content + can present. No single blocker. |
| Value Trust Engine | Q0, Q1, Q2, Q11 (w=1-3) | Works for generous founders with content systems. Flexible |
| Dream 100 | Q2, Q6, Q10, Q11 (w=1-3) | Works for networkers, visibles, salespeople. Multiple paths to success. |

### Independent Motions (Few high weights)

These motions have few critical dependencies and work for many profiles:

| Motion | Weights | Meaning |
|--------|---------|---------|
| Wave Riding | Q8 (w=3), Q9 (w=1) | Mostly needs speed + optional search. Can work with limited infrastructure. |
| LTD | Q3 (w=3), Q8 (w=3) | Just needs demo ability + ship speed. Everything else is secondary. |
| Build-in-Public | Q1 (w=3), Q2 (w=3), Q8 (w=2) | Needs content frequency + visibility + speed. No budget or network needed. |

---

## Upstream Fit Bonus Calculation

Before calculating motion scores, check if upstream scorecards (SC1-SC4) scored >70. Each upstream score >70 adds a bonus to the motion's defaultFit.

### Upstream Bonus Formula

```
upstreamFitBonus = 0

IF SC1 (Project Definition) score > 70:
    upstreamFitBonus += 0.5  // Well-defined niche, positioning, ACV

IF SC2 (ICP Clarity) score > 70:
    upstreamFitBonus += 0.5  // Clear buyer profile, buying behavior, pain points

IF SC3 (Market Attractiveness) score > 70:
    upstreamFitBonus += 0.3  // Market is real, growing, accessible

IF SC4 (Strategy Selector) score > 70:
    upstreamFitBonus += 0.3  // Founder is aligned with strategy, archetype clear

Maximum upstream bonus: 1.6 (added to each motion's defaultFit)
```

### Example

Founder completes SC1-SC4:
- SC1 = 75 (GOOD — clear niche & positioning) → +0.5
- SC2 = 82 (STRONG — ICP clarity is excellent) → +0.5
- SC3 = 65 (OK — market attractiveness is okay) → +0.0
- SC4 = 88 (STRONG — founder-strategy alignment is clear) → +0.3

**upstreamFitBonus = 0.5 + 0.5 + 0.0 + 0.3 = 1.3**

All motions get +1.3 to their defaultFit (capped at 10).

---

## Strategy Path Bonus Matrix

SC4 provides a strategy path (Replicate & Localize | Consulting-First SaaS | Boring Micro-SaaS | Hammering Deep). Each path adds bonuses to specific motions.

```
Motion                          Replicate  Consulting  Micro-SaaS  Hammering
                               & Localize  First SaaS
0  Waitlist Heat                  +1         0           +1          0
1  Build-in-Public                 0         0           +2          +1
2  Authority Education            +1         +2           0          0
3  Wave Riding                     0         0           +1          0
4  LTD Cash-to-MRR                0         0           +2          0
5  Signal Sniper                  0         +1           0          +2
6  Outcome Demo                   +1         +1          +1          +1
7  Hammering-Feature              0         0           +1          +3
8  BOFU SEO                        0         0           +2          +1
9  Dream 100                      +1         +2           0          0
10 7x4x11                          0         +1           0          +1
11 Value Trust Engine             +1         +1          +1          0
12 Paid VSL                        0         0           0          0
```

### Strategy Path Definitions & Bonuses

**Replicate & Localize** (+1 to 6 motions)
- Core play: Take successful US/global SaaS, adapt for MENA market
- Bonus motions: Authority (you're expert on localization), Dream 100 (partnerships scale faster), Waitlist (MENA loves limited scarcity)
- Example: Adapt Mailchimp for Arabic SMEs

**Consulting-First SaaS** (+1 to 6 motions)
- Core play: Sell consulting service, productize the methodology
- Bonus motions: Authority (consulting builds authority), Dream 100 (partners send referrals), Signal Sniper (consult to SMB awareness)
- Example: Agency becomes productized service + SaaS

**Boring Micro-SaaS** (+1 to 6 motions)
- Core play: Build niche tool for passionate audience, focus on retention
- Bonus motions: Build-in-Public (show the build), LTD (early revenue), BOFU SEO (niche keyword strategy), Hammering-Feature (feature-driven growth)
- Example: 10xAI is built via Build-in-Public + BOFU SEO

**Hammering Deep** (+1 to 6 motions)
- Core play: Pick one buyer segment and sell to them relentlessly
- Bonus motions: Signal Sniper (precision outbound to segment), Hammering-Feature (segment-first features), BOFU SEO (segment-specific keywords)
- Example: Intercom started by hammering in-app messaging for SaaS

### Applying Strategy Path Bonuses

Add strategy path bonus to motion's fit AFTER upstream bonus is applied.

```
motion_fit = defaultFit + upstreamBonus + strategyPathBonus
motion_fit = min(10, motion_fit)  // Cap at 10
```

---

## BORDERLINE CALIBRATION EXAMPLES

These examples show the hardest motion fit scoring decisions — when a motion could score as "applicable" or "not applicable" depending on founder readiness interpretation.

---

### Borderline: Motion Fit Score 5 vs 6

**Motion:** Signal Sniper Outbound | **Founder:** SalesMfast CRM targeting real estate brokers in UAE

**Assessment Answers:**
- Q4 (Outbound tools): "I use Instantly for cold email, HeyReach for LinkedIn, Clay for list building" = 3/4
- Q10 (Sales capacity): "I can do 10-15 sales calls per week if I prioritize it, but usually balance with product work" = 2.5/4
- Q7 (Deal size): "Our ACV is AED 1200/year ($330/year), which is $25/month" = 1/4

**Score 5 argument:** Tools are set up (Q4=3, w=3 critical), and sales capacity is present at 10-15 calls/week (Q10=2.5, w=3). Deal size is low (AED 1200) but the weight (w=2) is moderate, not critical. The motion is applicable: founder can run Signal Sniper targeting 100+ brokers. Readiness = raw score adequate.

**Score 6 argument:** The founder has professional-grade tools, proven calling capacity, and low deal friction (AED 1200 is easy to close via call). Signal Sniper at this deal size is profitable: 20% close rate on 50 dials = 10 deals/month × AED 1200 = AED 12K/month. This is a strong fit, potentially the primary motion.

**RULING: 5** — Tiebreaker: The deal size (AED 1200 = low ACV) means Signal Sniper works but isn't the BEST fit. For Signal Sniper to score 6, ACV needs to justify the sales time investment. Typically 6+ fit is for $5K+ ACV where 10 calls closing 2 deals = $10K/month revenue. At AED 1200, Signal Sniper is viable but founder should supplement with Wave Riding or Hammering-Feature (volume plays). A 5 is appropriate: "This motion works; pursue it, but don't rely on it as sole GTM."

---

### Borderline: Fit Score 4 vs 5 (MENA Multiplier Ambiguity)

**Motion:** Dream 100 Strategy (partner/affiliate-driven growth) | **Founder:** Building a no-code workflow automation tool (MENA-targeted)

**Assessment Answers:**
- Q6 (Network): "I have 200+ LinkedIn connections, mostly MENA-based. Half are founders, half are operators. Maybe 30 would be interested in an affiliate arrangement" = 3/4
- Q2 (Visibility): "I post 2x/week on LinkedIn about automation. Decent engagement (50-100 likes per post). Not famous, but visible in my circles" = 2.5/4
- Q7 (Deal size): "SaaS pricing AED 1500/year. Affiliate commission 20% = AED 300 per customer" = 1.5/4

**Geography question (Q12 MENA-specific):** "Is your market MENA-native or international?"
- Answer: "Mostly MENA (UAE, KSA) but I'm open to Egypt and Levant expansion. Not focused on non-MENA"

**Score 4 argument:** Dream 100 is a "balanced" motion (weights distributed: Q2, Q6, Q10, Q11). With Q6=3 (good network), Q2=2.5 (visible), and Q12=MENA-focused (MENA market = higher Dream 100 fit because relationship networks matter more), the motion is strong. Dream 100 bonus in MENA context should apply.

**Score 5 argument:** The 30 potential affiliates in MENA network is credible. Q6=3 (w=3) is critical dependency. Q2=2.5 (w=2) is strong. In MENA specifically, founder relationships and word-of-mouth affiliate networks are extremely powerful (higher effectiveness than Western markets). MENA multiplier should boost from 4 to 5.

**RULING: 4** — Tiebreaker: While Dream 100 is strong for MENA, the ACV (AED 1500 = $410/year) is low, and affiliate commission (AED 300 = $82) is marginal. 30 affiliates closing 1-2 customers each/month = 30-60 customers × AED 300 = AED 9-18K/month commission. This is supplementary, not primary GTM. A 5 would require either: (a) higher ACV (AED 5-10K), or (b) 100+ affiliates with 5-10 closure rate each. Score 4: "Dream 100 is viable and should be part of mix, but position as secondary to direct acquisition or Wave Riding."

---

### Borderline: Motion Readiness — "Somewhat MENA" vs. "Clearly MENA"

**Motion:** BOFU SEO (Bottom-of-Funnel Search Engine Optimization) | **Founder:** Accounting SaaS tool, initially for UAE, now expanding to Turkey and Southeast Asia

**Scenario A (Borderline 4 vs 5):**

**Founder states:** "Our primary market is UAE and KSA (90% of ARR). But we're testing with a Turkey partner and have 10% of users in Indonesia. We're doing English BOFU keywords ('best accounting software,' 'QuickBooks alternative') where we have no competition yet. But Turkey and Indonesia use different languages and search behavior."

**Readiness Assessment:**
- Q9 (Search demand): "Clear demand in UAE/KSA for English business accounting searches. ~1500 searches/month for 'best accounting SaaS UAE'" = 3.5/4
- Geography focus: "Primarily UAE/KSA (clear), but exploring Turkey/Indonesia (unclear)"

**Score 4 argument:** BOFU SEO works well for UAE/KSA (clear market, high English adoption, strong search demand). This is a 4: clear fit for the primary market, strong dependency on Q9 (w=3).

**Score 5 argument:** If founder commits BOFU to MENA-first (UAE/KSA only) and focuses on local, high-intent keywords ("أفضل برنامج محاسبة للشركات الصغيرة" in Arabic), they could rank faster and capture more intent. But the expansion to Turkey/Indonesia muddies the focus.

**RULING: 4** — Tiebreaker: The motion is 4 for "clear MENA + English BOFU". The expansion to Turkey/Indonesia makes execution messy and splits content/SEO efforts. Recommendation: "BOFU SEO is strong for UAE/KSA (score 4, pursue now). But pause Turkey/Indonesia expansion until MENA is dominant. Once MENA is 80%+ ARR and ranking is solid, THEN explore Turkish or Indonesian BOFU separately."

---

END OF WEIGHT MATRIX REFERENCE

---

## Upstream Data to Motion Fit Mapping

These mappings translate SC1-SC4 findings into motion-specific adjustments beyond the baseline bonuses.

### SC1 (Project Definition) Signals → Motion Fit

| SC1 Signal | Motion Impact | Reasoning |
|-----------|--------------|-----------|
| Niche = 3-level defined clearly | Signal Sniper +1, BOFU SEO +1 | Narrow niche enables precise targeting |
| Positioning = category creator | Authority Education +2, Build-in-Public +1 | Category creators need education-led GTM |
| Geography = MENA-first | Dream 100 +1, Waitlist +1, Value Trust +1 | MENA-native relationship motions |
| Geography = US/Global | BOFU SEO +1, Paid VSL +1, Build-in-Public +1 | Western-native motions work better |
| ACV > $10K | 7x4x11 +2, Dream 100 +1, Signal Sniper +1 | High-touch motions justified at high price |
| ACV < $500 | LTD +2, Build-in-Public +1, BOFU SEO +1 | Self-serve, high-volume motions only |
| Brand voice = contrarian | Build-in-Public +2, Authority Education +1 | Contrarian creators attract via transparency |
| Brand voice = educator | Authority Education +2, Value Trust +1 | Educators naturally position through teaching |

### SC2 (ICP Clarity) Signals → Motion Fit

| SC2 Signal | Motion Impact | Reasoning |
|-----------|--------------|-----------|
| ICP congregates on LinkedIn | Signal Sniper +1, Build-in-Public +1, Authority Education +1 | Reach audience where they gather |
| ICP congregates at events | 7x4x11 +1, Waitlist Heat +1, Value Trust +1 | Event-based relationship motions work |
| ICP congregates on Twitter/online communities | Build-in-Public +2, Wave Riding +1 | Online-first audiences respond to builders |
| ICP buying behavior = research-heavy | Authority Education +2, BOFU SEO +1 | Buyers research before committing — edu + SEO |
| ICP buying behavior = relationship-driven | Dream 100 +2, 7x4x11 +1 | Relationship trust is primary | signal |
| ICP buying behavior = impulse/trend-driven | Wave Riding +2, LTD +1, Paid VSL +1 | Trend followers and impulse buyers |
| ICP budget = low (<$1K annual) | LTD +1, Build-in-Public +1; Penalize Paid VSL -1 | Price-sensitive = high-volume motions |
| ICP budget = high (>$10K annual) | 7x4x11 +1, Signal Sniper +1, Dream 100 +1 | Premium buyers = high-touch motions |
| Top pain = urgent/deadline-driven | Signal Sniper +1, Outcome Demo +1 | Urgency enables outbound and demo |
| Top pain = latent/educatable | Authority Education +1, Value Trust +1 | Latent pain needs education first |

### SC3 (Market Attractiveness) Signals → Motion Viability

| SC3 Signal | Motion Impact | Reasoning |
|-----------|--------------|-----------|
| Pain reality = urgent, spreading | Signal Sniper +1, Outcome Demo +1 | Urgency enables direct outbound |
| Pain reality = latent, known to few | Authority Education +1, Build-in-Public +1 | Need education to surface pain |
| Market growth = expanding rapidly | Wave Riding +2, BOFU SEO +1 | Expanding markets have tailwinds |
| Market growth = flat | Authority Education +1, Signal Sniper +1 | Flat markets need differentiation |
| Market growth = contracting | Penalize all by -0.5 | Difficult environment overall |
| Competition = sparse/low | Authority Education +1, Build-in-Public +1 | Category creation without noise |
| Competition = moderate | Outcome Demo +1, BOFU SEO +1 | Need to differentiate clearly |
| Competition = high/intense | Hammering-Feature +1, BOFU SEO +1 | Differentiation critical |
| Purchasing power = strong | Paid VSL +1, 7x4x11 +1, Signal Sniper +1 | Budget-heavy motions work |
| Purchasing power = weak | LTD +1, Build-in-Public +1, Wave Riding +1 | Low-budget motions work |
| ICP accessibility = easy (easy to reach) | Build-in-Public +1, BOFU SEO +1, Wave Riding +1 | Easy-to-reach = broad distribution motions |
| ICP accessibility = hard (gatekept) | 7x4x11 +1, Dream 100 +1, Signal Sniper +1 | Hard-to-reach = relationship motions |

### SC4 (Strategy Selector) Archetype Affinity

| SC4 Archetype | PRIMARY Motions | SECONDARY Motions |
|---------------|-----------------|------------------|
| **The Domain Expert** (10+ years, known) | Authority Education (high), Dream 100 (high) | Value Trust (medium), Signal Sniper (medium) |
| **The Connector** (natural networker) | Dream 100 (high), 7x4x11 (high) | Waitlist Heat (medium), Outcome Demo (medium) |
| **The Builder** (ships fast, loves coding) | Hammering-Feature (high), Build-in-Public (high) | BOFU SEO (medium), Wave Riding (medium) |
| **The Operator** (processes, systems, execution) | Signal Sniper (high), 7x4x11 (high) | Outcome Demo (medium), BOFU SEO (medium) |
| **The Influencer** (large following, known) | Build-in-Public (high), Waitlist Heat (high) | Authority Education (medium), Dream 100 (medium) |
| **The Consultant** (sells advice, relationships) | Consulting-First SaaS path | Authority Education, Signal Sniper, Dream 100 |
| **The Hustler** (grinds, scrappy, resourceful) | Signal Sniper (high), 7x4x11 (high) | Outcome Demo (high), Wave Riding (medium) |
| **The Researcher** (data-driven, cautious) | BOFU SEO (high), Authority Education (high) | Outcome Demo (medium), Paid VSL (medium) |

---

## Motion Scoring Priority Model

Use this to understand which questions matter most for each motion's scoring, in priority order:

| Motion | Priority 1 | Priority 2 | Priority 3 | Notes |
|--------|-----------|-----------|-----------|-------|
| Waitlist | Q0 (list), Q11 (events) | Q2 (visibility), Q6 (network) | Q1 (content), Q5 (budget) | Needs audience + presentation |
| Build-Public | Q1 (content), Q2 (visibility) | Q8 (speed) | Everything else irrelevant | Content + visibility only |
| Authority Ed | Q1 (content), Q2 (visibility) | Q0 (list), Q11 (events) | Q9 (search) optional | Content frequency is critical |
| Wave Riding | Q8 (speed), Q9 (search) | Q1 (content) | Q3 (demo) | Speed + market timing key |
| LTD | Q3 (demo), Q8 (speed) | Q9 (search) | Nothing else matters | Just ship fast + clearly |
| Signal Sniper | Q4 (tools), Q10 (sales) | Q7 (deal size) | Q9 (search demand) | Infrastructure + conversations |
| Outcome Demo | Q3 (demo) | Q10 (sales capacity) | Q6 (network) | Clear outcome + sales time |
| Hammering | Q8 (speed), Q9 (search) | Q3 (demo) | Nothing else | Speed + market demand |
| BOFU SEO | Q9 (search), Q1 (content) | Q5 (budget) | Q8 (speed) | Search demand + content |
| Dream 100 | Q6 (network), Q2 (visibility) | Q10 (sales), Q11 (events) | Q7 (deal size) | Network + relationship skill |
| 7x4x11 | Q7 (deal size), Q10 (sales) | Q6 (network), Q11 (events) | Q4 (tools) | ACV + time required |
| Value Trust | Q0 (list), Q1 (content), Q11 (events) | Q2 (visibility), Q5 (budget) | Q10 (sales) optional | Give value at scale |
| Paid VSL | Q5 (budget), Q3 (demo) | Q9 (search) | Q7 (deal size) | Ad spend + clear offer |

---

**END OF WEIGHT MATRIX REFERENCE**

Use this when analyzing why certain motions score high/low for specific founders, and when understanding the logic behind bonus calculations.
