# Benchmarks, Gates, and Diagnosis Reference

Reference data for the campaign guide. Read specific sections as needed during
phase execution, not the entire file upfront.

---

## Table of Contents

1. Performance Benchmarks (Traffic Light)
2. Signal Decay Rules
3. Suppression Rules
4. Root Cause Diagnosis Tree
5. Human vs AI Comparison Matrix
6. Cost Metrics
7. Scoring Systems Quick Reference

---

## 1. Performance Benchmarks

### Cold Email Reply Rate

| Zone | Rate | Action |
|------|------|--------|
| RED | < 3% | Stop. Diagnose offer, data, or deliverability. |
| YELLOW | 3-5% | Investigate. Test new wedge or proof asset. |
| GREEN | 5-8% | Healthy. Optimize and scale. |
| ELITE | 8%+ | Scale aggressively. Document what works. |

Reference data: Instantly 2026 benchmark shows average reply rate 3.43%, top quartile
5.5%+, top 10% at 10%+. 58% of replies come from step 1, 42% from follow-ups.

### LinkedIn

No reliable universal benchmarks. Build internal benchmarks by ICP and region.
Starting guardrails:
- Connection acceptance < 20%: check account health and note quality
- Message reply rate: track separately from connection rate
- Any sender showing restrictions: pause immediately

### Key Guardrails

- Bounce rate: must stay < 3%. Above 5% = pause immediately.
- Spam complaint rate: < 0.3% (Google/Microsoft threshold).
- Positive reply rate (not total replies) is the metric that matters. Track separately.

---

## 2. Signal Decay Rules

Signals expire. Acting on stale signals poisons relevance.

| Signal Type | Valid Window | After Expiry |
|------------|-------------|--------------|
| Technology change | 90 days | Downgrade to monitor |
| Funding round | 60 days | Downgrade to monitor |
| New executive hired | 45 days | Downgrade to monitor |
| Job change (prospect moved) | 30 days | Exclude or re-score |
| Content download | 21 days | Downgrade to nurture |
| Competitor page visit | 14 days | Exclude unless stacked |
| Pricing page visit | 7 days | Exclude if no other signals |

---

## 3. Suppression Rules

| Condition | Action |
|-----------|--------|
| Touched in last 30 days by any channel | Suppress (prevent signal fatigue) |
| Negative reply in last 90 days | Suppress |
| Active customer | Suppress from outbound (route to account management) |
| Competitor employee | Suppress |
| Personal email (gmail, hotmail) | Suppress from B2B campaigns |
| Blacklisted domain | Suppress permanently |

---

## 4. Root Cause Diagnosis Tree

Use this when a campaign underperforms. Diagnose before changing anything.

| Symptom | Most Likely Root Cause | Fix |
|---------|----------------------|-----|
| High open, low reply | Message, offer, or CTA problem | Rewrite copy (asset-factory). Re-score offer. |
| Low deliverability, high bounce | Data or infrastructure problem | Check domain health (instantly). Clean list. Verify SPF/DKIM. |
| Strong reply, weak meetings | CTA or qualification problem | Simplify booking. Pre-qualify harder. |
| Strong meetings, weak opportunities | Targeting or handoff problem | Review ICP fit. Fix sales handoff process. |
| AI < Human on same audience | Prompt, routing, or proof packaging | Audit AI skill prompts. Check signal-to-message mapping. |
| High unsubscribe/spam | Targeting or frequency problem | Tighten ICP. Reduce volume. Check suppression. |
| High cost per meeting | Channel or scale mismatch | Shift to higher-performing channel. Cut low-signal batches. |
| Step 1 weak, follow-ups strong | Subject line or opening line issue | A/B test subject lines. Signal reference in first sentence. |
| LinkedIn low accept, email strong | LinkedIn note too salesy or generic | Shorten note, reference shared context, remove any pitch. |

---

## 5. Human vs AI Comparison Matrix

When running parallel campaigns (Variant A: Human, Variant B: AI):

### Control Variables (Must Be Identical)

Same ICP, geography, offer, wedge, list size, signal classes, proof assets, channels,
campaign window.

### Comparison Dimensions

| Category | Metrics |
|----------|---------|
| Performance | Reply rate, positive reply rate, meeting rate, opportunity rate |
| Speed | Signal-to-launch, signal-to-first-touch, signal-to-first-positive-reply |
| Economics | Labor hours, software cost, cost per meeting, cost per opportunity |
| Quality | Message quality score (copywriting-scorer), variance, routing accuracy, compliance |

### Comparison Rules

Always compare normalized, not raw:
- Per 100 leads
- Per $1,000 spent
- Per operator hour
- Per signal type

AI may win on speed and scale. Human may win on judgment for specific signal classes.

---

## 6. Cost Metrics

Track for every campaign cycle:

| Metric | Formula |
|--------|---------|
| Cost per lead contacted | (Data + enrichment + tool + labor) / leads contacted |
| Cost per reply | Total cost / total replies |
| Cost per positive reply | Total cost / positive replies |
| Cost per meeting | Total cost / meetings booked |
| Cost per opportunity | Total cost / opportunities created |

Break down by: motion, signal type, channel, and orchestration model (AI vs human).

---

## 7. Scoring Systems Quick Reference

The campaign guide invokes these existing scoring systems. Do not reinvent them.

### smorch-gtm-scoring Plugin (6 Systems)

| System | What It Scores | Criteria Count |
|--------|---------------|----------------|
| campaign-strategy-scorer | GTM blueprint before assets | 10 criteria |
| offer-positioning-scorer | Offer + positioning strength | 10 + Dunford check |
| copywriting-scorer | Channel-specific copy quality | 4 subsystems (email 9, VSL 8, LinkedIn 7, WhatsApp 8) |
| social-media-scorer | Organic social posts by funnel stage | 6 universal + stage-specific |
| linkedin-branding-scorer | Personal brand posts (2 tracks) | Track A: 9, Track B: 8 |
| youtube-scorer | Video content (4 subsystems) | Thumbnail 7, Title 6, Script 8, Description 5 |

### Orchestrator Composite Formula

Campaign Strategy (25%) + Offer/Positioning (20%) + Best Copywriting (25%) +
Social Media (15%) + YouTube/LinkedIn (15%)

### Hard Stops (Enforced by Orchestrator)

- Any single criterion < 5.0 = fix before ship
- Primary channel score < 6.0 = rewrite
- MENA context score must be > 6.0

### Invoking

- Score one thing: `smorch-gtm-scoring:score` (auto-routes to right scorer)
- Score everything: `smorch-gtm-scoring:score-all` (composite Campaign Health)
- Generate report: `smorch-gtm-scoring:score-report` (produces formatted docx)
