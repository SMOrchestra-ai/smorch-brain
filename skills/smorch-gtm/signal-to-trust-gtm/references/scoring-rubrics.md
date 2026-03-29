<!-- IP:START - Signal-to-Trust scoring rubrics and quality gates -->
# Scoring Rubrics & Quality Gates

Detailed validation logic, scoring criteria, and quality gates for the Signal-to-Trust GTM framework.

Referenced from SKILL.md. This file contains the enforcement details for hard stop rules, DSI scoring, campaign metrics, and quality gates.

---

## Hard Stop Rules — Detailed Validation Logic

### Rule 1: Fit = FAIL -> No Outreach
If prospect fails ICP Fit criteria, **STOP immediately**. Do not generate assets.

**Validation:**
```
signal-detector checks:
- Company size in range?
- Geography match?
- Industry/vertical match?
- Revenue band match?

If ANY = NO -> Exclude from campaign
```

### Rule 2: Signal Age > 90 Days -> Exclude
Signals older than 90 days are stale. Skip them.

**Validation:**
```
signal-detector checks signal timestamp
If (today - signal_date) > 90 days -> Flag as STALE
```

### Rule 3: Cannot Name Signal in One Sentence -> Skip
If you can't articulate the signal clearly in one sentence, it's not actionable.

**Validation:**
```
wedge-generator attempts one-sentence wedge
If wedge requires 2+ sentences or hedging -> REJECT signal
```

### Rule 4: Intent > Trust (Priority Rule)
When both Trust AND Intent signals present, **Intent takes priority**.

**Logic:**
```
if has_intent_signal AND has_trust_signal:
    use_intent_signal()
```

**Example:**
- Trust signal: "Posted about hiring challenges" (Trust: Community)
- Intent signal: "Posted job listing for SDR" (Intent: Hiring)
- **Use Intent signal** -> Higher buying intent

---

## DSI (Digital Silence Index) Scoring

The DSI calculator scores landing pages and campaign assets on a 0-100 scale across the 7 silence types.

Each silence type contributes to the total score. A score below 70 indicates the campaign has unaddressed silence gaps.

**Scoring dimensions (mapped from 7-silence-types.md):**

| Silence Type | What It Measures | Weight |
|---|---|---|
| Positioning Silence | Clarity of what you solve | 20% |
| Proof Silence | Evidence of delivery capability | 20% |
| Objection Silence | Addressed concerns / Q&A coverage | 15% |
| Channel Silence | Right platform for the message | 10% |
| Step Silence | Process clarity and simplicity | 10% |
| Response Silence | Response time and follow-up speed | 10% |
| Friction Silence | Barriers to action (forms, steps, complexity) | 15% |

**Quality gates:**
- Score 80-100: Campaign-ready. Deploy.
- Score 60-79: Needs improvement in flagged silence types before launch.
- Score below 60: Major gaps. Rework required.

---

## Campaign Performance Metrics

### Benchmarks by ICP

| ICP | Reply Rate Benchmark | Meeting Rate Benchmark | Objection Rate (acceptable) |
|---|---|---|---|
| MENA SaaS Founders | 6.2% | 0.8% | < 30% |
| US Real Estate Brokers | 4.8% | 0.6% | < 25% |
| MENA Beauty Clinics | 5.5% | 0.7% | < 35% |
| US eCommerce | 3.9% | 0.5% | < 20% |

### Performance Thresholds

**Green (performing):**
- Reply rate >= 1.5x benchmark
- Meeting rate >= 1.2x benchmark

**Yellow (monitor):**
- Reply rate between 0.8x and 1.5x benchmark
- Meeting rate between 0.8x and 1.2x benchmark

**Red (pivot required):**
- Reply rate < 0.8x benchmark for 2+ weeks
- Meeting rate < 0.5x benchmark
- Objection rate exceeds acceptable threshold

### Wedge Performance Evaluation

When comparing weekly wedges:
- **Winner**: Highest reply rate with meeting rate above benchmark
- **Double down**: Winner has >= 2x the reply rate of other wedges
- **Pivot**: All wedges below 0.8x benchmark for 2+ consecutive weeks
- **Hybrid**: Winner performing but new signal pattern emerging (5+ mentions)

---

## Wedge Quality Gates

Before a wedge is approved for asset generation:

1. **One-sentence test**: Can be expressed in exactly one sentence (no hedging, no "and also")
2. **Signal specificity**: References a specific observed signal, not a generic pain point
3. **Outcome quantification**: Includes a specific number or metric when possible (e.g., "8x", "21x", "50x")
4. **ICP relevance**: Matches the target ICP's language and context
5. **Silence type alignment**: Addresses the campaign's target silence type

**Pass criteria**: All 5 gates must pass. If any fail, revise the wedge before proceeding to asset-factory.

---

## Asset Quality Gates

Before assets are deployed:

1. **Pattern interrupt**: First line of every email/message must break pattern (no "I hope this finds you well")
2. **Single CTA**: Each message has exactly one low-friction call to action
3. **Signal reference**: Every outreach message references the specific signal that triggered it
4. **Cultural alignment**: Messages pass culture-adapter validation for target geography
5. **Channel fit**: Message length and tone match channel norms (email vs LinkedIn vs WhatsApp)
6. **A/B differentiation**: Variants must differ in psychology/angle, not just word swaps

**Pass criteria**: All 6 gates must pass. Failed assets are flagged for revision before deployment.

---

## Integration Quality Gates

Before campaign is deployed to tools:

1. **GHL**: Custom fields mapped, tags created, workflow triggers tested
2. **Instantly**: Merge fields validated, sending account warmed, daily limits set
3. **HeyReach**: LinkedIn URLs verified, connection request limits configured, sequence timing set
4. **Cross-channel**: No prospect receives simultaneous outreach on 3+ channels on the same day

**Pass criteria**: All applicable integration gates must pass before launch.

<!-- IP:END -->
