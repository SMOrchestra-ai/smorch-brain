# Sub-Skill Orchestration Reference

Detailed orchestration sequences, dependencies, and input/output specifications for each execution mode.

Referenced from SKILL.md. This file contains the complete sub-skill call chains for all four modes.

---

## Mode A: New Monthly Campaign (Full Q->M->W->D)

```
1. campaign-strategist
   Input: Q2-Q4 answers (ICP, Quarterly feature, Monthly narrowing, Weekly strategy)
   Output: Campaign brief with Q->M->W->D alignment

2. signal-detector
   Input: Q5 answer (signal collection), ICP Fit criteria
   Output: Validated prospect list (Fit PASS only), signal taxonomy

3. wedge-generator
   Input: Q6 answer (weekly strategy), signal data, monthly theme
   Output: 3 weekly wedges (one-sentence each)

4. asset-factory
   Input: 3 weekly wedges, Q9 (channel mix), campaign brief
   Output: 6 emails, 4 LinkedIn, 3 WhatsApp, 3 social posts

5. lead-magnet-builder (if Q7 != None)
   Input: Q7 (lead magnet type), monthly wedge, silence type
   Output: Interactive lead magnet (HTML/React artifact)

6. dsi-calculator
   Input: Landing page content, objection patterns
   Output: DSI score (0-100), Q&A section for objection silence

7. landing-page-architect
   Input: Q8 (VSL strategy), monthly wedge, 3 weekly wedges, lead magnet
   Output: Master VSL landing page with UTM variants

8. culture-adapter (if Q10 = multi-market)
   Input: All assets, geographic markets
   Output: Culturally adapted message variants

9. integration-orchestrator (if Q11 = B or C)
   Input: All assets, tech stack selection
   Output: GHL workflows, Instantly campaigns, HeyReach sequences

10. performance-analyzer (if Q12 = A)
    Input: Campaign setup
    Output: Tracking dashboard setup, baseline metrics
```

---

## Mode B: Weekly Asset Generation

```
1. performance-analyzer
   Input: Last week's metrics
   Output: Winning wedge, performance insights

2. wedge-generator
   Input: Winning wedge, A/B variant request
   Output: Refined wedge + variants

3. asset-factory
   Input: This week's wedge, channel mix
   Output: Weekly asset bundle

4. culture-adapter
   Input: Assets, geographic market
   Output: Adapted variants

5. integration-orchestrator (if Q11 = B or C)
   Input: Weekly assets
   Output: Updated campaign deployments
```

---

## Mode C: Performance Analysis

```
1. performance-analyzer
   Input: Campaign metrics (reply rate, meeting rate, objections)
   Output: Performance report with insights

2. campaign-strategist
   Input: Performance insights
   Output: Pivot recommendation (double down, shift wedge, new signal)

3. wedge-generator (if pivot = new wedge)
   Input: New signal direction
   Output: Alternative wedge options
```

---

## Mode D: One-Off Tasks

Route directly to specific sub-skill:
- "Validate signals" -> signal-detector
- "Generate wedge" -> wedge-generator
- "Calculate DSI" -> dsi-calculator
- "Build lead magnet" -> lead-magnet-builder
- "Adapt for MENA" -> culture-adapter
- "Deploy to GHL" -> integration-orchestrator

---

## Self-Improvement Loop

If Question 12 = "Yes, track performance", the skill evolves over time:

### Week 1 -> Week 2: Template Refinement
**performance-analyzer** tracks:
- Which subject lines got highest open rates
- Which P.S. lines got most replies
- Which wedge variants won
- Common objection patterns

**Outputs**:
- Updated battle cards with winning patterns
- Refined wedge variants for Week 2
- Objection handling additions

### Monthly -> Quarterly: Signal Discovery
**performance-analyzer** identifies:
- New signals mentioned by 5+ responders
- Geographic patterns (e.g., "West Coast prospects respond better")
- Industry sub-segments (e.g., "Healthcare SaaS different from FinTech SaaS")

**Outputs**:
- Suggested new signal types for signal-hierarchy.md
- ICP refinement recommendations
- New wedge templates for wedge-sentence-map.md

### Quarterly -> Annual: Framework Expansion
**campaign-strategist** analyzes:
- Which silence types converted best by ICP
- Which lead magnet types drove most bookings
- Channel mix optimization (email vs LinkedIn vs WhatsApp ratios)
- Geographic market performance

**Outputs**:
- Updated 7-silence-types.md with new subcategories
- New ICP additions to framework
- Culture Map refinements based on real data

---

## Integration Points

The skill integrates with your full tech stack:

### GoHighLevel (GHL)
**What we export:**
- Workflow JSONs (email/SMS sequences)
- Custom field definitions (signal_type, wedge_variant, etc.)
- Tag-based triggers
- Form configurations
- Chat widget scripts

**How to deploy:**
1. Import workflow JSON via GHL dashboard
2. Map custom fields to contact records
3. Upload prospect list with tags
4. Activate workflows

### Instantly
**What we export:**
- Campaign configs (JSON)
- Sequence steps (CSV)
- Personalization variables

**How to deploy:**
1. Create new campaign in Instantly
2. Import sequence CSV
3. Map merge fields
4. Launch campaign

### HeyReach / LinkedHelper
**What we export:**
- Connection request templates
- Follow-up sequences
- InMail templates
- CSV prospect lists with LinkedIn URLs

**How to deploy:**
1. Import CSV into HeyReach
2. Set up sequence templates
3. Configure daily limits
4. Start campaign

### Apify / Relevance
**What we use:**
- LinkedIn profile scraping
- Company data enrichment
- Signal detection (hiring posts, tech stack changes, etc.)

**Integration mode:**
- Manual: "Here are the Apify actors to run"
- Automated: Skill generates Apify task configs

### SMooR (n8n + Claude)
**What we can generate:**
- n8n workflow JSONs for signal orchestration
- Claude agent prompts for custom logic
- Webhook endpoints for real-time signal capture
