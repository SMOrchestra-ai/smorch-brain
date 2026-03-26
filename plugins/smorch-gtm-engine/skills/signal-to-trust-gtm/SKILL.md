---
name: signal-to-trust-gtm
description: "Signal-to-Trust GTM orchestrator for complete outbound campaign management. Use whenever the user wants to create signal-based outreach campaigns, generate multi-channel assets (email/LinkedIn/WhatsApp/VSL), analyze campaign performance, calculate Digital Silence Index, build lead magnets, adapt messaging for geographic markets (MENA/US/EU), or deploy to GHL/Instantly/HeyReach. Triggers include \"launch campaign\", \"generate weekly assets\", \"analyze performance\", \"signal-based outreach\", \"wedge generation\", \"silence type\", \"DSI calculator\", or any mention of the Signal-to-Trust framework. This skill orchestrates 10 specialized sub-skills to handle the complete Q to M to W to D campaign hierarchy."
---

# Signal-to-Trust GTM Orchestrator

**Core Philosophy**: "Your funnel is not broken. It is silent."

Every campaign is built on observed signals (not assumptions), wedges derived from those signals (not generic value props), and assets optimized for specific silence types. This skill orchestrates the complete Q→M→W→D hierarchy across 10 sub-skills.

## Strategic Questionnaire

Before executing ANY campaign work, run this questionnaire to determine execution path. Present as multiple-choice with context-aware defaults.

**Q1: Invocation Mode** - What are you trying to do?
- A) Launch new monthly campaign (full Q→M→W→D) → Questions 2-12
- B) Generate this week's assets (existing campaign) → Questions 2, 6-8, 11
- C) Analyze performance and recommend pivot → Load context, call performance-analyzer
- D) One-off task → Route to specific sub-skill

**Q2: ICP Selection** - Which ICP? (MENA SaaS / US Real Estate / MENA Beauty Clinics / US eCommerce / Other)
Determines: Fit criteria, wedge templates, Culture Map, channel mix.

**Q3: Quarterly Feature** - What outcome are we hammering? (Existing theme or define new one-sentence outcome)
Examples: "Capture 8x more revenue per contact", "Respond within 5 minutes for 21x conversion"

**Q4: Monthly Narrowing** - How to narrow Q→M? (By ICP segment / feature breakdown / silence type / auto)

**Q5: Signal Collection** - Signals collected, need scraping, or manual observation?

**Q6: Weekly Wedge Strategy** - How to derive 3 wedges from monthly? (Different angles / sequential story / A/B/C test)
Critical: Weekly wedges are DIFFERENT, not A/B variants, but derivative from monthly theme.

**Q7: Lead Magnet** - Type? (DSI Scorecard / Signal Library / Wedge Calculator / Case Study Library / Battle Card / None)
Tied to silence types. Read `references/7-silence-types.md` for mapping.

**Q8: VSL Strategy** - 5-min monthly master / 1-2min weekly / both / none?

**Q9: Channel Mix** - Email+LinkedIn (US/EU default) / +WhatsApp (MENA default) / email only / LinkedIn only / custom?
Weekly volumes: 6 emails, 4 LinkedIn, 3 WhatsApp, 3 social posts, 1-2 VSLs.

**Q10: Geographic Market** - MENA (trust-first) / US (intent-first) / Germany (data-first) / multi-market?
Triggers culture-adapter. Read `references/culture-map-framework.md` for dimensions.

**Q11: Integration Mode** - Manual / hybrid / full automation (GHL/Instantly/HeyReach)?

**Q12: Performance Tracking** - Track and suggest optimizations, or one-time generation?

## Sub-Skill Orchestration

### Mode A: New Monthly Campaign
```
1. campaign-strategist   → Campaign brief with Q→M→W→D alignment
2. signal-detector       → Validated prospect list (Fit PASS only)
3. wedge-generator       → 3 weekly wedges (one-sentence each)
4. asset-factory         → 6 emails, 4 LinkedIn, 3 WhatsApp, 3 social posts
5. lead-magnet-builder   → Interactive lead magnet (if Q7 ≠ None)
6. dsi-calculator        → DSI score, Q&A for objection silence
7. landing-page-architect → Master VSL page with UTM variants
8. culture-adapter       → Culturally adapted variants (if multi-market)
9. integration-orchestrator → GHL/Instantly/HeyReach deployment (if Q11=B/C)
10. performance-analyzer → Tracking setup and baselines (if Q12=A)
```

### Mode B: Weekly Asset Generation
```
1. performance-analyzer → Last week's metrics and insights
2. wedge-generator      → Refined wedge + A/B variants
3. asset-factory        → Weekly asset bundle
4. culture-adapter      → Adapted variants
5. integration-orchestrator → Updated deployments (if Q11=B/C)
```

### Mode C: Performance Analysis
```
1. performance-analyzer → Report with insights
2. campaign-strategist  → Pivot recommendation (double down / shift / hybrid)
3. wedge-generator      → Alternative wedge options (if pivoting)
```

### Mode D: One-Off Tasks
Route directly: signals → signal-detector, wedge → wedge-generator, DSI → dsi-calculator, lead magnet → lead-magnet-builder, adapt → culture-adapter, deploy → integration-orchestrator.

## Hard Stop Rules

**Non-negotiable. Enforce before ANY execution.** Read `references/hard-stop-rules.md` for full detail.

1. **Fit = FAIL → No Outreach.** If prospect fails ICP Fit criteria, exclude immediately.
2. **Signal > 90 Days → Exclude.** Stale signals are not actionable.
3. **Cannot Name in One Sentence → Skip.** If you can't articulate the signal in one sentence, reject it.
4. **Intent > Trust.** When both signal types present, Intent takes priority (higher buying intent).

## Reference Files

Read these as needed during execution:

| File | When to read |
|------|-------------|
| `references/signal-hierarchy.md` | Signal classification (Fit → Trigger → Trust/Intent → Subtype → Wedge) |
| `references/7-silence-types.md` | Mapping silence types to lead magnets and DSI dimensions |
| `references/wedge-sentence-map.md` | ICP-specific wedge templates and examples |
| `references/hard-stop-rules.md` | Full hard stop enforcement details |
| `references/culture-map-framework.md` | Erin Meyer's 8 dimensions for MENA/US/Germany adaptation |
| `references/output-formats.md` | Output templates for Mode A/B/C deliverables |
| `references/integration-guide.md` | GHL/Instantly/HeyReach/Apify deployment steps |
| `references/self-improvement-loop.md` | How campaigns evolve (weekly→monthly→quarterly) |
| `references/campaign-examples.md` | 3 worked examples (new campaign, weekly gen, pivot) |

## Key Principles

1. Always start with the questionnaire (12 questions determine execution path)
2. Enforce hard stop rules before any asset generation
3. Derive hierarchically: Q→M→W→D domino alignment
4. Track and evolve: performance loop → template refinement → signal discovery
5. Adapt culturally: MENA ≠ US ≠ Germany
6. Integrate fully: deployment-ready for GHL/Instantly/HeyReach
