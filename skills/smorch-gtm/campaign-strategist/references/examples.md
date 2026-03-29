<!-- IP:START - Campaign strategist ICP examples and domino validation -->
# Campaign Strategist - Examples & ICP Reference

Reference file for ICP-specific considerations, campaign examples, and domino validation tests.

---

## ICP-Specific Considerations

### MENA SaaS Founders
**Quarterly themes that resonate**:
- Data consolidation (scattered tools pain)
- Regional distribution (Dubai, Riyadh, Cairo teams)
- Trust-building (proof before product)

**Monthly narrowing preference**: By ICP segment (vertical-specific)

**Weekly approach**: Different angles (high-context communication requires variety)

**Daily tone**: Relationship-first, "we" language, geographic name-dropping

---

### US Real Estate Brokers
**Quarterly themes that resonate**:
- Speed (Golden Window, 5-minute response)
- Lead leakage (backend nurture, follow-up automation)
- Listing capture (open house optimization)

**Monthly narrowing preference**: By silence type (speed-driven, direct)

**Weekly approach**: Sequential story (builds urgency)

**Daily tone**: Task-first, "you" language, data-driven

---

### MENA Beauty Clinics
**Quarterly themes that resonate**:
- Social follower leakage (Instagram -> owned contacts)
- Backend nurture (98% say "I'll think about it")
- Response speed (DM -> booking conversion)

**Monthly narrowing preference**: By feature breakdown (visual proof emphasis)

**Weekly approach**: Different angles (trust-building requires variety)

**Daily tone**: Visual-first, proof-heavy, WhatsApp-native

---

### US eCommerce (DTC)
**Quarterly themes that resonate**:
- Checkout friction (cart abandonment)
- Email list ROI (owned vs paid traffic)
- Mobile optimization (conversion gaps)

**Monthly narrowing preference**: By silence type (friction-focused)

**Weekly approach**: A/B/C variants (fast optimization)

**Daily tone**: Data-first, conversion-focused, mobile-optimized

---

## Example 1: MENA SaaS - Proof Silence

**Input**:
- ICP: MENA SaaS Founders
- Quarterly Feature: "Consolidate scattered sales data into unified dashboard"
- Monthly Narrowing: By silence type (Proof Silence)
- Weekly Strategy: Different angles

**Output**:
```markdown
# MENA SaaS Founders - Proof Silence (Data Fragmentation) Campaign

## Campaign ID
20260211-MENA-SAAS-PROOF-SILENCE

## Quarterly Alignment
**Feature**: Consolidate scattered sales data into unified dashboard
**Duration**: Q1 2026
**Rationale**: MENA SaaS founders scaling from 5-50 employees consistently face data fragmentation across HubSpot, Pipedrive, Notion, spreadsheets. Unified visibility = predictable revenue.

## Monthly Focus
**Theme**: Proof Silence - Data Fragmentation Crisis
**Narrowing Strategy**: By silence type (Proof)
**Duration**: February 2026
**Rationale**: They understand the problem (scattered data) but don't believe consolidation is achievable. Need proof from MENA peers to build trust.

## Weekly Wedge Strategy
**Approach**: Different angles on same monthly theme

### Week 1
**Theme**: "Your sales data lives in 7 different tools. Decision paralysis is costing you deals."
**Angle**: Identify the problem (scattered state)
**Signal Type Priority**: Intent (active pain)

### Week 2
**Theme**: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."
**Angle**: Amplify the cost (visibility loss)
**Signal Type Priority**: Intent (outcome focus)

### Week 3
**Theme**: "5 MENA SaaS founders unified their stack. They closed 40% more deals."
**Angle**: Provide proof (peer validation)
**Signal Type Priority**: Trust (community proof)

## Daily Messaging Focus
**Sequence Type**: Email + LinkedIn + WhatsApp (MENA multi-channel)
**Cadence**: Day 1, 3, 6 (relationship-building pace)
**Tone**: High-context, relationship-first, "we" language, geographic mentions (Dubai, Riyadh)

## Success Metrics
**Primary**: Reply rate >6.2% (MENA SaaS benchmark)
**Secondary**: Meeting rate >0.8%
**Benchmarks**: MENA SaaS average = 6.2% reply, 0.8% meeting

## Next Steps
- [ ] Call signal-detector to validate MENA SaaS Fit criteria
- [ ] Call wedge-generator to create 3 specific one-sentence wedges
- [ ] Call asset-factory to produce 42 assets (18 emails, 12 LinkedIn, 9 WhatsApp, 3 social)
```

**Domino Validation**:
- Monthly traces to Quarterly (consolidation -> proof of consolidation)
- Weekly traces to Monthly (all 3 wedges about data fragmentation)
- Specificity increases (Q: consolidation -> M: proof silence -> W: specific angles)
- ICP resonance (MENA language, trust-building, peer proof)

---

## Example 2: US Real Estate - Response Silence

**Input**:
- ICP: US Real Estate Brokers
- Quarterly Feature: "Respond within 5 minutes for 21x higher conversion"
- Monthly Narrowing: By silence type (Response Silence)
- Weekly Strategy: Sequential story

**Output**:
```markdown
# US Real Estate Brokers - Response Silence (Golden Window) Campaign

## Campaign ID
20260211-US-REALESTATE-RESPONSE-SILENCE

## Quarterly Alignment
**Feature**: Respond within 5 minutes for 21x higher conversion
**Duration**: Q1 2026
**Rationale**: US brokers with 10-100 agents lose deals to competitors who respond faster. Speed = competitive advantage in tight markets.

## Monthly Focus
**Theme**: Response Silence - Golden Window Lost
**Narrowing Strategy**: By silence type (Response)
**Duration**: February 2026
**Rationale**: They know they should respond fast but don't realize 21x conversion difference between <5 min vs >30 min. Need urgency.

## Weekly Wedge Strategy
**Approach**: Sequential story (Week 1->2->3 builds urgency)

### Week 1
**Theme**: "Your lead fills a form at 2pm. You reply at 5pm. They booked with someone else at 2:07pm."
**Angle**: The invisible loss (story opening)
**Signal Type Priority**: Intent (immediate pain)

### Week 2
**Theme**: "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."
**Angle**: The quantified gap (data reveal)
**Signal Type Priority**: Intent (outcome focus)

### Week 3
**Theme**: "Instant auto-reply + mobile notifications = never miss the Golden Window."
**Angle**: The solution (resolution)
**Signal Type Priority**: Intent (solution-seeking)

## Daily Messaging Focus
**Sequence Type**: Email + LinkedIn (US direct channels)
**Cadence**: Day 1, 3, 6 (fast-paced, urgency-driven)
**Tone**: Low-context, task-first, "you" language, data-driven

## Success Metrics
**Primary**: Reply rate >4.5% (US Real Estate benchmark)
**Secondary**: Meeting rate >1.2%
**Benchmarks**: US Real Estate average = 4.5% reply, 1.2% meeting

## Next Steps
- [ ] Call signal-detector to validate US Real Estate Fit criteria
- [ ] Call wedge-generator to create 3 specific one-sentence wedges
- [ ] Call asset-factory to produce 36 assets (18 emails, 12 LinkedIn, 3 social - no WhatsApp for US)
```

**Domino Validation**:
- Monthly traces to Quarterly (5-min response -> response silence)
- Weekly traces to Monthly (all 3 about response speed)
- Specificity increases (Q: speed -> M: response silence -> W: sequential story)
- ICP resonance (US language, urgency, data-driven)

---

## Error Handling

### Error 1: Quarterly Feature Too Vague
**Symptom**: Feature is generic ("improve sales results")
**Fix**: Prompt user for specific outcome with metric
**Example**: "Improve sales results" -> "Respond within 5 minutes for 21x higher conversion"

### Error 2: Monthly Too Similar to Quarterly
**Symptom**: Monthly = Quarterly (no narrowing occurred)
**Fix**: Force narrowing by applying strategy (ICP segment, feature breakdown, silence type)
**Example**: Q="Capture 8x ROI", M="Capture 8x ROI" -> M="Instagram Follower Leakage for Beauty Clinics"

### Error 3: Weekly Wedges Not Related
**Symptom**: 3 weekly wedges address different problems
**Fix**: Realign all 3 to monthly theme, just different angles
**Example**: Week 1="Data scattered", Week 2="Slow response", Week 3="No proof" -> All should focus on ONE monthly theme

### Error 4: ICP Mismatch
**Symptom**: Themes don't resonate with selected ICP
**Fix**: Replace with ICP-specific pain points and language
**Example**: MENA SaaS with US-style direct messaging -> Add relationship-building, trust-first tone

<!-- IP:END -->
