# Output Templates & Examples

Complete output templates and worked examples for the Signal-to-Trust GTM orchestrator.

Referenced from SKILL.md. This file contains the full template structures and end-to-end execution examples.

---

## Mode A Output Templates (New Campaign)

### 1. Campaign Brief (Markdown)

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

### 2. Asset Folder Structure

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

### 3. GHL Deployment Configs (JSON)

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

---

## Mode B Output Templates (Weekly Assets)

### Weekly Asset Bundle (Markdown + Files)

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

---

## Mode C Output Templates (Performance Analysis)

### Performance Report (Markdown)

```markdown
# Campaign Performance Analysis
## Campaign: [Name]
## Period: [Date range]

## Metrics Summary
| Metric | Week 1 | Week 2 | Week 3 | Trend |
|--------|--------|--------|--------|-------|
| Reply Rate | X% | X% | X% | up/down/flat |
| Meeting Rate | X% | X% | X% | up/down/flat |
| Objection Rate | X% | X% | X% | up/down/flat |

## Wedge Performance
- **Wedge 1**: [Reply X%, Meeting X%]
- **Wedge 2**: [Reply X%, Meeting X%] <-- **WINNER**
- **Wedge 3**: [Reply X%, Meeting X%]

## Pattern Discovery
**New signals observed**:
1. "[8 responders mentioned 'sales team scattered']" -> Potential new Intent signal
2. "[5 prospects asked about geographic coverage]" -> Potential Friction silence

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
- Subject lines with "[specific data point]" -> 1.8x open rate
- P.S. with "[micro-commitment]" -> 2.3x reply rate

**Updated battle cards**:
- [Link to updated templates in battle-cards/ folder]
```

---

## Wedge Sentence Templates by ICP

**Template**: "[Observed Signal] is costing you [Specific Outcome]. Here's the [One-Line Solution]."

**Examples by ICP:**
- MENA SaaS: "Your Instagram followers are generating $79 per 1000. Owned contacts generate $582. That's 8x ROI you're leaving on the table."
- Real Estate Brokers: "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."
- Beauty Clinics: "98% of your leads say 'I'll think about it.' 80% will book after 5-12 touchpoints. You're missing the backend 50x improvement."

---

## Culture Map Adaptation Reference

### MENA Adaptation (Trust-first):
- High-context (implied vs explicit)
- Relationship-before-task
- Indirect negative feedback
- Longer trust-building sequences

### US Adaptation (Intent-first):
- Low-context (explicit, direct)
- Task-before-relationship
- Direct communication
- Shorter, data-driven sequences

### Germany Adaptation (Data-first):
- Extremely low-context (hyper-explicit)
- Structured, formal
- Principle-based reasoning
- Longer, evidence-heavy sequences

---

## Worked Examples

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
   - Validates each can be stated in one sentence

5. **Calls asset-factory**:
   - Produces:
     - 6 email sequences (3 weeks x 2 variants)
     - 4 LinkedIn sequences (2 weeks x 2 variants - Week 3 uses InMail)
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
Campaign created: "MENA SaaS Founders - Proof Silence (Data Fragmentation)"

Assets folder: /campaign-assets/
   - 18 emails (3 weeks x 2 variants x 3 emails each)
   - 12 LinkedIn messages (3 weeks x 2 variants x 2 messages each)
   - 9 WhatsApp messages (3 variants x 3 psychology types)
   - 3 VSL scripts
   - 3 social posts
   - 1 Case Study Library (interactive artifact)
   - 1 Master VSL landing page

Integration status:
   - GHL: Deployed (3 workflows active)
   - Instantly: Deployed (147 prospects loaded)
   - HeyReach: Ready (CSV exported, manual import needed)

Performance tracking: ENABLED
   - Week 1 check-in scheduled
   - Baseline: 6.2% reply, 0.8% meeting (MENA SaaS benchmark)
   - Tracking: Reply rate, meeting rate, objection keywords

Next steps:
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
     - Wedge 2 reply rate: 13.7% <-- **WINNER**
     - Wedge 3 reply rate: 5.1%
   - Pattern: "Unified dashboard" messaging (Wedge 2) resonated most
   - Objections: 3 asked about "implementation time"

3. **Calls wedge-generator**:
   - Refines Wedge 2 with A/B variants:
     - Variant A: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."
     - Variant B: "Pipeline visibility disappeared across 7 tools. One dashboard brought it back."

4. **Calls asset-factory**:
   - Produces Week 2 bundle:
     - 6 emails (2 variants x 3 emails)
     - 4 LinkedIn (2 variants x 2 messages)
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
Week 2 assets ready

Week 1 Performance:
   - Winner: Wedge 2 (13.7% reply rate - 2.2x benchmark)
   - Key insight: "Unified dashboard" messaging resonated
   - New objection: "Implementation time" (3 mentions)

Week 2 Assets:
   - 6 emails (A/B variants, now includes "implementation time" handling)
   - 4 LinkedIn messages
   - 3 WhatsApp messages
   - 2 social posts

Deployment:
   - GHL: Updated (new sequences uploaded)
   - Instantly: Variant B deployed to top 50 engaged prospects

Recommendation: Double down on Wedge 2 for Week 3 as well.
   Reply rate is 2.2x benchmark -- this is working.
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
Performance Analysis: MENA SaaS Campaign (Weeks 1-3)

Strong Performance:
   - Reply rate: 9.1% (1.5x benchmark)
   - Meeting rate: 1.2% (1.5x benchmark)
   - Wedge 2 remains winner (14.3% reply)

New Signal Discovered:
   "8 responders mentioned 'sales team scattered across regions'"
   -> Potential Intent signal: Geographic distribution pain

Recommendations:

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
