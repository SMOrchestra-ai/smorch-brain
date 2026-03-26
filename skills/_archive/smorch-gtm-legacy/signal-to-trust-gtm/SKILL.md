---
name: signal-to-trust-gtm
description: Signal-to-Trust GTM orchestrator for complete outbound campaign management. Use whenever the user wants to create signal-based outreach campaigns, generate multi-channel assets (email/LinkedIn/WhatsApp/VSL), analyze campaign performance, calculate Digital Silence Index, build lead magnets, adapt messaging for geographic markets (MENA/US/EU), or deploy to GHL/Instantly/HeyReach. Triggers include "launch campaign", "generate weekly assets", "analyze performance", "signal-based outreach", "wedge generation", "silence type", "DSI calculator", or any mention of the Signal-to-Trust framework. This skill orchestrates 10 specialized sub-skills to handle the complete Q→M→W→D campaign hierarchy.
---

# Signal-to-Trust GTM Orchestrator

## Overview

This is the master orchestrator for the complete Signal-to-Trust GTM framework. It manages the hierarchical campaign flow from **Quarterly → Monthly → Weekly → Daily** and coordinates 10 specialized sub-skills to produce complete multi-channel outbound campaigns.

**Core Philosophy**: "Your funnel is not broken. It is silent."

Every campaign is built on observed signals (not assumptions), wedges derived from those signals (not generic value props), and assets optimized for specific silence types.

## When to Use This Skill

This skill orchestrates EVERYTHING in the Signal-to-Trust framework:

1. **New Campaign Launch**: "Start monthly campaign for MENA SaaS founders targeting Proof Silence"
2. **Weekly Asset Generation**: "Generate this week's sequences for Week 2"
3. **Performance Analysis**: "Analyze last week's results and recommend pivot"
4. **Signal Detection**: "Validate these 200 prospects against Fit criteria"
5. **Wedge Generation**: "Create wedges for Intent signal: hiring sales team"
6. **DSI Calculation**: "Calculate Digital Silence Index for this landing page"
7. **Lead Magnet Creation**: "Build Signal Audit scorecard for real estate brokers"
8. **Geographic Adaptation**: "Adapt this message for MENA vs US markets"
9. **Integration Deployment**: "Deploy to GHL and Instantly"

## Strategic Questionnaire

Before executing ANY campaign work, run this questionnaire to determine execution path. Present as **multiple-choice** with context-aware defaults.

### Question 1: Invocation Mode
**What are you trying to do?**
- A) Launch new monthly campaign (full Q→M→W→D alignment)
- B) Generate this week's assets (existing campaign continuation)
- C) Analyze performance and recommend pivot
- D) One-off task (signal validation, wedge generation, DSI calc, etc.)

**Execution Logic:**
- A → Questions 2-12, then full orchestration
- B → Questions 2, 6-8, 11, then asset-factory + culture-adapter
- C → Load campaign context, call performance-analyzer
- D → Route to specific sub-skill based on task type

---

### Question 2: ICP Selection
**Which ICP are we targeting?**
- A) MENA SaaS Founders (B2B tech, 5-50 employees)
- B) US Real Estate Brokers (residential, 10-100 agents)
- C) MENA Beauty Clinics (derma/aesthetics, 2-20 staff)
- D) US eCommerce (DTC brands, $500k-$5M revenue)
- E) Other (describe: _________)

**This determines:**
- Fit criteria enforcement (ICP-specific hard stops)
- Wedge templates from wedge-sentence-map.md
- Culture Map application (MENA vs US messaging)
- Channel mix (WhatsApp for MENA, email/LinkedIn for US)

---

### Question 3: Quarterly Feature (Hammering Theme)
**What quarterly outcome/feature are we hammering?**
- A) Use existing quarterly theme: [display if campaign exists]
- B) Define new quarterly feature (one-sentence outcome)

**Examples:**
- "Capture 8x more revenue per contact than social followers"
- "Respond within 5 minutes for 21x higher conversion"
- "Nurture backend leads for 50x improvement in close rate"
- "Consolidate scattered sales data into unified dashboard"

**This becomes the North Star** for all downstream (M→W→D) derivation.

---

### Question 4: Monthly Narrowing Strategy
**How should we narrow from Quarterly → Monthly?**
- A) By ICP segment (e.g., MENA SaaS → vertical focus)
- B) By feature breakdown (e.g., Capture 8x → 3 sub-wedges)
- C) By silence type (e.g., Proof Silence all month)
- D) Let skill decide based on signal density

**Examples:**
- Quarterly: "Capture 8x ROI" → Monthly: "Instagram Follower Leakage" (ICP segment)
- Quarterly: "Capture 8x ROI" → Monthly: "8x Capture" + "20x Response" + "50x Nurture" (feature breakdown)
- Quarterly: "Capture 8x ROI" → Monthly: "Proof Silence" (silence type focus)

---

### Question 5: Signal Collection Status
**Do you have signals collected, or should we gather them?**
- A) Signals already collected (provide CSV/list)
- B) Need to scrape signals (use Apify/Relevance)
- C) Manual signal observation (I'll provide examples)

**If B selected:**
- Call signal-detector with scraping mode
- Tools: Apify (LinkedIn/web scraping), Relevance (enrichment)
- Output: CSV with Fit/Trigger/Signal Type/Subtype/Raw Data

---

### Question 6: Weekly Wedge Strategy
**How should we derive 3 weekly wedges from monthly theme?**
- A) Different angles on same monthly wedge (default)
- B) Sequential story (Week 1→2→3 builds narrative)
- C) A/B/C test variants (same core message, different psychology)

**Critical Rule**: Weekly wedges are DIFFERENT (not A/B test variants), but derivative from monthly theme.

**Example (Monthly: "Instagram Follower Leakage"):**
- Week 1: "Rented Land Risk" (algorithm changes, account suspension)
- Week 2: "8x Revenue Gap" (owned contacts vs social followers)
- Week 3: "Capture Infrastructure" (funnel + AI solution)

---

### Question 7: Lead Magnet Selection
**What lead magnet should we create for this monthly campaign?**
- A) DSI Scorecard (interactive assessment)
- B) Signal Library (curated list of triggers)
- C) Wedge Calculator (outcome estimator)
- D) Case Study Library (proof-based stories)
- E) Battle Card (one-page framework)
- F) None (link directly to booking)

**Tied to silence types:**
- Positioning Silence → Battle Card
- Proof Silence → Case Study Library
- Objection Silence → DSI Scorecard with Q&A
- Channel Silence → Signal Library
- Step Silence → Wedge Calculator
- Response Silence → Battle Card
- Friction Silence → DSI Scorecard

---

### Question 8: VSL Strategy
**What VSL(s) should we create?**
- A) 5-minute monthly master VSL (Problem-Agitation-Solution-Proof-Offer)
- B) 1-2 minute weekly wedge-specific VSLs (3 total)
- C) Both monthly + weekly
- D) None (text-based campaign only)

**Default recommendation**: C (both) for first month, B (weekly only) for subsequent months.

---

### Question 9: Channel Mix
**Which channels should we use?**
- A) Email + LinkedIn (default for US/EU)
- B) Email + LinkedIn + WhatsApp (default for MENA)
- C) Email only (high-volume, low-touch)
- D) LinkedIn only (executive outreach)
- E) Custom (specify: _________)

**Weekly output volumes:**
- Email: 3 sequences × 2 variants = 6 emails
- LinkedIn: 2 sequences × 2 variants = 4 messages
- WhatsApp: 1 sequence × 3 variants = 3 messages
- Social posts: 3 posts (LinkedIn/Twitter)
- VSLs: 1-2 videos

---

### Question 10: Geographic Market
**Which geographic market(s)?**
- A) MENA (trust-first, high-context, relationship-driven)
- B) US (intent-first, direct, data-driven)
- C) Germany (data-first, structured, formal)
- D) Multi-market (specify regions)

**This triggers culture-adapter sub-skill** using Erin Meyer's Culture Map framework.

---

### Question 11: Integration Mode
**How should we deploy assets?**
- A) Manual (just give me the assets)
- B) Hybrid (assets + workflow triggers)
- C) Full automation (deploy to GHL/Instantly/HeyReach)

**If B or C selected:**
- Calls integration-orchestrator
- Outputs: GHL workflow JSONs, Instantly campaign configs, HeyReach sequences
- Tools: GHL API, Instantly API, HeyReach CSV exports

---

### Question 12: Performance Tracking
**Should we set up self-improvement loop?**
- A) Yes, track performance and suggest optimizations
- B) No, one-time campaign generation

**If A selected:**
- Calls performance-analyzer after Week 1
- Tracks: Reply rate, meeting rate, objection patterns, winning templates
- Suggests: Wedge pivots, new signal discovery, template evolution

---

## Sub-Skill Orchestration

Based on questionnaire answers, call sub-skills in this sequence:

### Mode A: New Monthly Campaign (Full Q→M→W→D)

```
1. campaign-strategist
   Input: Q2-Q4 answers (ICP, Quarterly feature, Monthly narrowing, Weekly strategy)
   Output: Campaign brief with Q→M→W→D alignment

2. signal-detector
   Input: Q5 answer (signal collection), ICP Fit criteria
   Output: Validated prospect list (Fit PASS only), signal taxonomy

3. wedge-generator
   Input: Q6 answer (weekly strategy), signal data, monthly theme
   Output: 3 weekly wedges (one-sentence each)

4. asset-factory
   Input: 3 weekly wedges, Q9 (channel mix), campaign brief
   Output: 6 emails, 4 LinkedIn, 3 WhatsApp, 3 social posts

5. lead-magnet-builder (if Q7 ≠ None)
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

### Mode B: Weekly Asset Generation

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

### Mode C: Performance Analysis

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

### Mode D: One-Off Tasks

Route directly to specific sub-skill:
- "Validate signals" → signal-detector
- "Generate wedge" → wedge-generator
- "Calculate DSI" → dsi-calculator
- "Build lead magnet" → lead-magnet-builder
- "Adapt for MENA" → culture-adapter
- "Deploy to GHL" → integration-orchestrator

---

## Hard Stop Rules Enforcement

**CRITICAL**: Before ANY execution, validate these non-negotiable rules:

### Rule 1: Fit = FAIL → No Outreach
If prospect fails ICP Fit criteria, **STOP immediately**. Do not generate assets.

**Validation:**
```
signal-detector checks:
- Company size in range?
- Geography match?
- Industry/vertical match?
- Revenue band match?

If ANY = NO → Exclude from campaign
```

### Rule 2: Signal Age > 90 Days → Exclude
Signals older than 90 days are stale. Skip them.

**Validation:**
```
signal-detector checks signal timestamp
If (today - signal_date) > 90 days → Flag as STALE
```

### Rule 3: Cannot Name Signal in One Sentence → Skip
If you can't articulate the signal clearly in one sentence, it's not actionable.

**Validation:**
```
wedge-generator attempts one-sentence wedge
If wedge requires 2+ sentences or hedging → REJECT signal
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
- **Use Intent signal** → Higher buying intent

---

## Output Formats

### For Mode A (New Campaign):

**1. Campaign Brief** (Markdown)
```markdown
# [ICP] - [Monthly Theme] Campaign

## Quarterly Alignment
**Feature**: [Quarterly hammering outcome]
**Monthly Focus**: [How we narrowed it]

## Signal Intelligence
- Total prospects: [N]
- Fit PASS: [N]
- Primary signal type: [Trust/Intent]
- Signal subtype: [specific subtype]

## Weekly Wedge Strategy
- **Week 1**: [Wedge sentence]
- **Week 2**: [Wedge sentence]
- **Week 3**: [Wedge sentence]

## Lead Magnet
**Type**: [DSI Scorecard / Signal Library / etc.]
**Silence addressed**: [Positioning / Proof / Objection / etc.]

## Channel Mix
- Email: [Y/N]
- LinkedIn: [Y/N]
- WhatsApp: [Y/N]

## Geographic Markets
- Primary: [MENA/US/EU]
- Adaptation: [Culture Map dimensions]

## Integration Status
- GHL: [Deployed/Pending/Manual]
- Instantly: [Deployed/Pending/Manual]
- HeyReach: [Deployed/Pending/Manual]
```

**2. Asset Folder Structure**
```
campaign-assets/
├── week-1/
│   ├── email-sequence-A.md (3 emails)
│   ├── email-sequence-B.md (3 emails)
│   ├── linkedin-sequence-A.md (2 messages)
│   ├── linkedin-sequence-B.md (2 messages)
│   ├── whatsapp-messages-ABC.md (3 variants)
│   ├── vsl-script-week1.md
│   └── social-posts.md (3 posts)
├── week-2/
│   └── [same structure]
├── week-3/
│   └── [same structure]
├── lead-magnet/
│   └── [interactive artifact or guide]
├── landing-page/
│   └── master-vsl-page.html (with UTM variants)
└── integration/
    ├── ghl-workflows.json
    ├── instantly-campaign-config.json
    └── heyreach-sequences.csv
```

**3. GHL Deployment Configs** (JSON)
```json
{
  "campaign_name": "[ICP] - [Monthly Theme]",
  "workflows": [
    {
      "name": "Week 1 Email Sequence A",
      "trigger": "Tag added: week1_sequence_a",
      "steps": [
        {
          "type": "email",
          "delay_days": 0,
          "subject": "{{custom_field.wedge_subject}}",
          "body": "...",
          "merge_fields": ["contact.first_name", "custom_field.signal_data"]
        }
      ]
    }
  ],
  "custom_fields": [
    {"name": "signal_type", "type": "text"},
    {"name": "wedge_variant", "type": "dropdown", "options": ["A", "B"]},
    {"name": "signal_data", "type": "text"}
  ]
}
```

### For Mode B (Weekly Assets):

**Weekly Asset Bundle** (Markdown + Files)
```markdown
# Week [N] Assets - [Campaign Name]

## Performance Context (from last week)
- Winning wedge: [Wedge 1/2/3]
- Reply rate: [X%]
- Meeting rate: [X%]
- Key insight: [pattern observed]

## This Week's Strategy
**Wedge**: [Refined wedge sentence]
**Variant strategy**: [A/B psychology difference]

## Assets
- [Links to email/LinkedIn/WhatsApp sequences]
- [Link to updated VSL script if applicable]
- [Link to social posts]

## Deployment Status
- GHL: [Updated/Pending]
- Instantly: [Updated/Pending]
- HeyReach: [Updated/Pending]
```

### For Mode C (Performance Analysis):

**Performance Report** (Markdown)
```markdown
# Campaign Performance Analysis
## Campaign: [Name]
## Period: [Date range]

## Metrics Summary
| Metric | Week 1 | Week 2 | Week 3 | Trend |
|--------|--------|--------|--------|-------|
| Reply Rate | X% | X% | X% | ↑/↓/→ |
| Meeting Rate | X% | X% | X% | ↑/↓/→ |
| Objection Rate | X% | X% | X% | ↑/↓/→ |

## Wedge Performance
- **Wedge 1**: [Reply X%, Meeting X%]
- **Wedge 2**: [Reply X%, Meeting X%] ← **WINNER**
- **Wedge 3**: [Reply X%, Meeting X%]

## Pattern Discovery
**New signals observed**:
1. "[8 responders mentioned 'sales team scattered']" → Potential new Intent signal
2. "[5 prospects asked about geographic coverage]" → Potential Friction silence

## Recommendations
### Option A: Double Down (Recommended)
- **Action**: Continue Wedge 2, create A/B variants
- **Rationale**: 13.7% reply rate is 2.1x benchmark
- **Assets needed**: 2 new email variants

### Option B: Pivot to New Signal
- **Action**: Test "geographic distribution" signal
- **New wedge**: "[One-sentence wedge for new signal]"
- **Risk**: Restart momentum

### Option C: Hybrid
- **Action**: 70% Wedge 2, 30% new signal test
- **Rationale**: Maintain performance while exploring

## Template Evolution
**Winning patterns**:
- Subject lines with "[specific data point]" → 1.8x open rate
- P.S. with "[micro-commitment]" → 2.3x reply rate

**Updated battle cards**:
- [Link to updated templates in battle-cards/ folder]
```

---

## Framework Knowledge Base

The meta skill references these knowledge files (located in `references/`):

### 1. signal-hierarchy.md
Complete taxonomy: **Fit → Trigger → Signal Type (Trust/Intent) → Signal Subtype → Wedge**

**Critical distinctions:**
- **Fit** = ICP criteria (company size, geography, industry) → NOT used for wedges
- **Trigger** = Timing/event (funding, hiring, expansion) → NOT used for wedges
- **Trust Signal** = Community, authority, visibility behaviors → CAN be used for wedges
- **Intent Signal** = Active buying behaviors → PRIORITIZED for wedges

### 2. 7-silence-types.md
From your PDF, the complete taxonomy:
1. **Positioning Silence**: They don't understand what you solve
2. **Proof Silence**: They don't believe you can deliver
3. **Objection Silence**: They have unaddressed concerns
4. **Channel Silence**: They're on wrong platform for your message
5. **Step Silence**: Your process is unclear/overwhelming
6. **Response Silence**: You're not responding fast enough
7. **Friction Silence**: Too many barriers to take action

Each silence type maps to specific DSI scoring dimensions and lead magnet types.

### 3. wedge-sentence-map.md
ICP-specific wedge templates with examples:

**Template**: "[Observed Signal] is costing you [Specific Outcome]. Here's the [One-Line Solution]."

**Examples by ICP:**
- MENA SaaS: "Your Instagram followers are generating $79 per 1000. Owned contacts generate $582. That's 8x ROI you're leaving on the table."
- Real Estate Brokers: "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."
- Beauty Clinics: "98% of your leads say 'I'll think about it.' 80% will book after 5-12 touchpoints. You're missing the backend 50x improvement."

### 4. hard-stop-rules.md
Non-negotiable enforcement:
- Fit = Fail → No outreach
- Signal > 90 days → Exclude
- Cannot name in one sentence → Skip
- Intent > Trust (priority rule)

### 5. culture-map-framework.md
Erin Meyer's 8 dimensions applied to GTM messaging:

**MENA Adaptation** (Trust-first):
- High-context (implied vs explicit)
- Relationship-before-task
- Indirect negative feedback
- Longer trust-building sequences

**US Adaptation** (Intent-first):
- Low-context (explicit, direct)
- Task-before-relationship
- Direct communication
- Shorter, data-driven sequences

**Germany Adaptation** (Data-first):
- Extremely low-context (hyper-explicit)
- Structured, formal
- Principle-based reasoning
- Longer, evidence-heavy sequences

### 6. battle-cards/ Folder
Proven templates from previous campaigns:
- `email-subject-lines-winners.md` (top-performing subject lines by ICP)
- `linkedin-opener-variants.md` (connection request + first message combos)
- `whatsapp-psychology-abc.md` (Pattern Interrupt / Problem Amplification / Peer Reference)
- `vsl-hooks-library.md` (tested opening hooks by silence type)
- `objection-handling-scripts.md` (responses to common objections by ICP)

---

## Self-Improvement Loop

If Question 12 = "Yes, track performance", the skill evolves over time:

### Week 1 → Week 2: Template Refinement
**performance-analyzer** tracks:
- Which subject lines got highest open rates
- Which P.S. lines got most replies
- Which wedge variants won
- Common objection patterns

**Outputs**:
- Updated battle cards with winning patterns
- Refined wedge variants for Week 2
- Objection handling additions

### Monthly → Quarterly: Signal Discovery
**performance-analyzer** identifies:
- New signals mentioned by 5+ responders
- Geographic patterns (e.g., "West Coast prospects respond better")
- Industry sub-segments (e.g., "Healthcare SaaS different from FinTech SaaS")

**Outputs**:
- Suggested new signal types for signal-hierarchy.md
- ICP refinement recommendations
- New wedge templates for wedge-sentence-map.md

### Quarterly → Annual: Framework Expansion
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

---

## Examples

### Example 1: Launch New Campaign for MENA SaaS

**User**: "Start new monthly campaign for MENA SaaS Founders targeting Proof Silence"

**Meta Skill Execution**:

1. **Runs questionnaire**:
   - Q1: A (New campaign)
   - Q2: A (MENA SaaS Founders)
   - Q3: B (Define new: "Consolidate scattered sales data into unified dashboard")
   - Q4: C (By silence type: Proof Silence)
   - Q5: C (Manual - user will provide examples)
   - Q6: A (Different angles on monthly wedge)
   - Q7: D (Case Study Library - proof-based)
   - Q8: C (Both monthly + weekly VSLs)
   - Q9: B (Email + LinkedIn + WhatsApp)
   - Q10: A (MENA)
   - Q11: C (Full automation - GHL/Instantly/HeyReach)
   - Q12: A (Yes, track performance)

2. **Calls campaign-strategist**:
   - Quarterly: "Consolidate scattered sales data"
   - Monthly: "Proof Silence - Data Fragmentation Crisis"
   - Weekly wedges:
     - Week 1: "Your sales data lives in 7 different tools. Decision paralysis is costing you deals."
     - Week 2: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."
     - Week 3: "Other founders closed 40% more deals after consolidating their sales stack."

3. **Calls signal-detector**:
   - User provides: "Founders posting about 'too many tools', 'can't see full pipeline', 'spreadsheet chaos'"
   - Validates 147 prospects meet Fit criteria
   - Tags signals as: Intent (frustrated with current state) > Trust (community discussion)
   - Output: CSV with signal_type, signal_data, prospect details

4. **Calls wedge-generator**:
   - Generates 3 one-sentence wedges (listed above)
   - Validates each can be stated in one sentence ✓

5. **Calls asset-factory**:
   - Produces:
     - 6 email sequences (3 weeks × 2 variants)
     - 4 LinkedIn sequences (2 weeks × 2 variants - Week 3 uses InMail)
     - 3 WhatsApp message sets (A/B/C psychology)
     - 3 social proof posts for LinkedIn
     - 3 VSL scripts (1 monthly master, 2 weekly wedge-specific)

6. **Calls lead-magnet-builder**:
   - Type: Case Study Library
   - Creates: Interactive artifact showing "Before/After: 5 SaaS Founders Who Unified Their Stack"
   - Includes: Data visualization of deals closed before vs after consolidation

7. **Calls dsi-calculator**:
   - Scores landing page: 67/100
   - Identifies objections: "Integration complexity" (Friction Silence)
   - Generates Q&A section addressing objection

8. **Calls landing-page-architect**:
   - Creates master VSL page with:
     - 5-minute monthly VSL (embedded HeyGen video)
     - CTA to Case Study Library
     - Embedded DSI calculator
     - 3 UTM variants (one per weekly wedge)

9. **Calls culture-adapter**:
   - MENA adaptation:
     - Adds relationship-building language
     - Uses "we" instead of "you" (collective vs individual)
     - Lengthens trust-building in email Day 1-3
     - Adds WhatsApp as primary channel

10. **Calls integration-orchestrator**:
    - Exports GHL workflows (3 email sequences, tag triggers, custom fields)
    - Exports Instantly campaign (147 prospects, 6 emails, merge fields)
    - Exports HeyReach CSV (LinkedIn URLs, 4-step sequence)

11. **Calls performance-analyzer**:
    - Sets up tracking: Reply rate, meeting rate, objection keywords
    - Creates baseline benchmark: MENA SaaS = 6.2% reply rate, 0.8% meeting rate
    - Schedules Week 1 check-in

**Output to User**:
```
✅ Campaign created: "MENA SaaS Founders - Proof Silence (Data Fragmentation)"

📁 Assets folder: /campaign-assets/
   - 18 emails (3 weeks × 2 variants × 3 emails each)
   - 12 LinkedIn messages (3 weeks × 2 variants × 2 messages each)
   - 9 WhatsApp messages (3 variants × 3 psychology types)
   - 3 VSL scripts
   - 3 social posts
   - 1 Case Study Library (interactive artifact)
   - 1 Master VSL landing page

🚀 Integration status:
   - GHL: Deployed (3 workflows active)
   - Instantly: Deployed (147 prospects loaded)
   - HeyReach: Ready (CSV exported, manual import needed)

📊 Performance tracking: ENABLED
   - Week 1 check-in scheduled
   - Baseline: 6.2% reply, 0.8% meeting (MENA SaaS benchmark)
   - Tracking: Reply rate, meeting rate, objection keywords

🎯 Next steps:
   1. Review assets in /campaign-assets/
   2. Import HeyReach CSV (147 prospects)
   3. Activate GHL workflows (currently paused)
   4. Launch Instantly campaign (scheduled for Monday 9am UAE time)

Want to review assets before launch? Or shall I activate everything?
```

---

### Example 2: Weekly Asset Generation (Existing Campaign)

**User**: "Generate Week 2 assets for MENA SaaS campaign"

**Meta Skill Execution**:

1. **Loads campaign context**:
   - Campaign: "MENA SaaS Founders - Proof Silence"
   - Week 1 complete
   - ICP: MENA SaaS Founders
   - Channels: Email + LinkedIn + WhatsApp

2. **Calls performance-analyzer**:
   - Week 1 metrics:
     - Wedge 1 reply rate: 8.3%
     - Wedge 2 reply rate: 13.7% ← **WINNER**
     - Wedge 3 reply rate: 5.1%
   - Pattern: "Unified dashboard" messaging (Wedge 2) resonated most
   - Objections: 3 asked about "implementation time"

3. **Calls wedge-generator**:
   - Refines Wedge 2 with A/B variants:
     - Variant A: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."
     - Variant B: "Pipeline visibility disappeared across 7 tools. One dashboard brought it back."

4. **Calls asset-factory**:
   - Produces Week 2 bundle:
     - 6 emails (2 variants × 3 emails)
     - 4 LinkedIn (2 variants × 2 messages)
     - 3 WhatsApp (A/B/C psychology)
     - 2 social posts

5. **Calls culture-adapter**:
   - Validates MENA tone maintained
   - Adds "implementation time" objection handling to email Day 3

6. **Calls integration-orchestrator**:
   - Updates GHL workflows (new email sequences)
   - Updates Instantly (variant B for top 50 engaged prospects)

**Output to User**:
```
✅ Week 2 assets ready

📊 Week 1 Performance:
   - Winner: Wedge 2 (13.7% reply rate - 2.2x benchmark)
   - Key insight: "Unified dashboard" messaging resonated
   - New objection: "Implementation time" (3 mentions)

📁 Week 2 Assets:
   - 6 emails (A/B variants, now includes "implementation time" handling)
   - 4 LinkedIn messages
   - 3 WhatsApp messages
   - 2 social posts

🚀 Deployment:
   - GHL: Updated (new sequences uploaded)
   - Instantly: Variant B deployed to top 50 engaged prospects

🎯 Recommendation: Double down on Wedge 2 for Week 3 as well.
   Reply rate is 2.2x benchmark—this is working.
```

---

### Example 3: Performance Analysis & Pivot

**User**: "Analyze last week's performance and recommend pivot"

**Meta Skill Execution**:

1. **Calls performance-analyzer**:
   - Loads: Reply rates, meeting rates, objection keywords, winning templates
   - Analysis:
     - Overall reply rate: 9.1% (1.5x benchmark)
     - Meeting rate: 1.2% (1.5x benchmark)
     - Wedge 2 still winning (14.3% reply)
     - **New pattern**: 8 responders mentioned "sales team scattered across regions"

2. **Calls campaign-strategist**:
   - Evaluates: New signal = "Geographic distribution" (Intent signal)
   - Options:
     - A) Double down on Wedge 2 (safe, proven)
     - B) Pivot to "Geographic distribution" signal (new opportunity)
     - C) Hybrid: 70% Wedge 2, 30% new signal test

3. **Calls wedge-generator** (for Option B):
   - New wedge: "Your sales team is scattered across Dubai, Riyadh, and Cairo. Your CRM isn't. Regional dashboards are the missing piece."

**Output to User**:
```
📊 Performance Analysis: MENA SaaS Campaign (Weeks 1-3)

✅ Strong Performance:
   - Reply rate: 9.1% (1.5x benchmark)
   - Meeting rate: 1.2% (1.5x benchmark)
   - Wedge 2 remains winner (14.3% reply)

🔍 New Signal Discovered:
   "8 responders mentioned 'sales team scattered across regions'"
   → Potential Intent signal: Geographic distribution pain

🎯 Recommendations:

**Option A: Double Down (Recommended)**
   - Continue Wedge 2, create 2 new A/B variants
   - Rationale: 14.3% reply is exceptional, don't break what's working
   - Risk: LOW

**Option B: Pivot to New Signal**
   - New wedge: "Regional sales teams need regional dashboards"
   - Rationale: Strong signal (8 mentions), specific pain
   - Risk: MEDIUM (restart momentum)

**Option C: Hybrid (70/30 Split)**
   - 70% continue Wedge 2
   - 30% test new "geographic distribution" wedge
   - Rationale: Maintain performance while exploring
   - Risk: LOW-MEDIUM

Which option should I execute?
```

---

## Conclusion

This meta skill is the orchestrator for your entire Signal-to-Trust GTM framework. It coordinates 10 specialized sub-skills to transform observed signals into complete multi-channel campaigns with performance tracking and continuous improvement.

**Key principles:**
1. **Always start with the questionnaire** (12 questions determine execution path)
2. **Enforce hard stop rules** (Fit=Fail, Signal>90d, one-sentence test, Intent>Trust)
3. **Derive hierarchically** (Q→M→W→D domino alignment)
4. **Track and evolve** (performance loop → template refinement → signal discovery)
5. **Adapt culturally** (MENA ≠ US ≠ Germany messaging)
6. **Integrate fully** (GHL/Instantly/HeyReach deployment-ready)

The framework is designed to be self-improving: every campaign generates data, every data point refines templates, every pattern discovered expands the signal library.

Let's build signal-based campaigns that actually convert.
