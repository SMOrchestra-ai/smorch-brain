# Composite Scoring & Improvement Priority Matrix

## When to Use Composite Scoring

Composite scoring applies when a campaign or initiative spans multiple deliverable types. A signal-based outbound campaign typically involves: campaign strategy, offer/positioning, email copy, LinkedIn messages, and possibly social posts or YouTube content.

Individual scores tell you how good each piece is in isolation. The composite score tells you whether the campaign as a whole will perform.

## Campaign Health Formula

```
Campaign Health = (Campaign Strategy x 0.25) +
                  (Offer/Positioning x 0.20) +
                  (Best Copywriting Subsystem x 0.25) +
                  (Social Media x 0.15) +
                  (YouTube OR LinkedIn x 0.15)
```

### Weight Rationale

Campaign Strategy gets 25% because even perfect copy fails with wrong targeting, wrong channels, or wrong timing. Strategy is the foundation.

Copywriting gets 25% because it's the direct interface with the prospect. The words they read determine whether they respond. Highest-scoring subsystem is used because campaigns typically lean on one primary channel.

Offer/Positioning gets 20% because a weak offer can't be saved by strong copy. The value equation has to work before the words matter.

Social Media and YouTube/LinkedIn each get 15% because they amplify the primary campaign but rarely carry it alone. They build the authority layer that makes outbound convert higher.

### Applying the Formula

If only some systems are scored (not every campaign has YouTube), normalize the weights:

```
Adjusted Weight = Original Weight / Sum of Applicable Weights
```

Example: Campaign with Strategy (0.25), Offer (0.20), Email Copy (0.25), LinkedIn Posts (0.15) = total applicable weight 0.85. Normalized: Strategy = 0.294, Offer = 0.235, Copy = 0.294, LinkedIn = 0.176.

## 7-Level Improvement Priority Matrix

After scoring, improvements should be prioritized by impact. Not all criteria are equal, and not all gaps are equally urgent.

### Priority Levels

| Priority | Condition | Action | Timeline |
|----------|-----------|--------|----------|
| P0: EMERGENCY | Hard stop triggered (any criterion < 5.0) | Stop deployment. Fix this criterion immediately. | Same day |
| P1: CRITICAL | Overall score < 6.0 | Full rework of weakest system. Do not ship. | 24-48 hours |
| P2: HIGH | Highest-weighted criterion below 7.0 | Targeted fix on this criterion first. | 48-72 hours |
| P3: MEDIUM | 2+ criteria below 7.0 in same system | Systematic improvement across weak criteria. | This week |
| P4: LOW | Overall 7.0-7.5, all criteria above 5.0 | Polish. Optimize for performance. | This sprint |
| P5: OPTIMIZATION | Overall 7.5-8.5, looking for edge | A/B test variations. Benchmark against top performers. | Ongoing |
| P6: MAINTENANCE | Overall 8.5+, performing well | Monitor metrics. Re-score monthly with live data. | Monthly review |

### Priority Selection Logic

```
IF any criterion < 5.0:
  → P0 (fix that criterion, block deployment)
ELIF overall < 6.0:
  → P1 (full rework)
ELIF highest-weighted criterion < 7.0:
  → P2 (fix the big lever first)
ELIF count(criteria < 7.0) >= 2:
  → P3 (systematic pass)
ELIF overall < 7.5:
  → P4 (polish)
ELIF overall < 8.5:
  → P5 (optimize)
ELSE:
  → P6 (maintain)
```

## Cross-System Dependencies

Some improvements cascade across systems. When one system scores low, check whether the root cause is upstream:

| Weak System | Likely Upstream Cause | Check First |
|-------------|----------------------|-------------|
| Copywriting scores low on personalization | Campaign Strategy: Signal Clarity is weak | Score Campaign Strategy C1 |
| Social media scores low on authority signal | LinkedIn Branding: Authority Signal is weak | Score LinkedIn 6A-C2 |
| Email reply rate below benchmark | Offer: Dream Outcome Clarity is vague | Score Offer C1 |
| YouTube retention drops at mechanism section | Offer: Unique Mechanism undefined | Score Offer C5 |
| LinkedIn posts not triggering client action | Offer: ICP-Offer Alignment is off | Score Offer C9 |

## Score History Tracking

Track scores over time per system. The scoring-orchestrator saves results as JSON fragments that enable trending:

```json
{
  "history": [
    {
      "date": "2026-03-26",
      "system": "copywriting",
      "subsystem": "email",
      "overall": 7.8,
      "campaign_id": "Q2-MENA-SaaS"
    },
    {
      "date": "2026-04-02",
      "system": "copywriting",
      "subsystem": "email",
      "overall": 8.3,
      "campaign_id": "Q2-MENA-SaaS"
    }
  ]
}
```

Pattern to watch: if a system consistently scores below 7.0 across 3+ scoring sessions, the problem is structural (skill gap, missing data, wrong framework), not execution. Escalate to strategy review.

## Monthly Calibration Protocol

Every 4 weeks:
1. Select 3 shipped deliverables per scoring system
2. Re-score with hindsight (actual performance data vs predicted score)
3. Calculate prediction accuracy: |predicted score correlation with actual metrics|
4. Adjust criterion weights if specific criteria consistently over/under-predict quality
5. Update benchmarks if market data has shifted
