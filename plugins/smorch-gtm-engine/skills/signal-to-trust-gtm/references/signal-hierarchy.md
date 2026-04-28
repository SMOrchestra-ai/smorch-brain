<!-- IP:START - Signal hierarchy taxonomy -->
# Signal Hierarchy Framework

Complete taxonomy for the Signal-to-Trust GTM system.

## Core Structure

```
Fit → Trigger → Signal Type → Signal Subtype → Wedge
```

Each level has a specific purpose and rules about whether it can be used for wedge generation.

---

## Level 1: Fit (ICP Criteria)

**Purpose**: Determine if prospect qualifies for outreach at all.

**Categories**:
- Company size (employees, revenue)
- Geography (MENA, US, EU, specific countries)
- Industry/vertical (SaaS, Real Estate, Beauty, eCommerce)
- Tech stack (for technical products)
- Maturity stage (startup, growth, enterprise)

**Hard Stop Rule**: **Fit = FAIL → No Outreach**

If prospect fails ANY Fit criterion, they are excluded from campaign entirely.

**Wedge Usage**: ❌ **NEVER** use Fit for wedges

**Why**: Fit is about qualification, not persuasion. You don't create wedges like "You're a SaaS company, so..." — that's not a signal, it's a category.

**Examples**:
- PASS: SaaS company, 10-50 employees, MENA region, $500k-$5M ARR
- FAIL: SaaS company, 2 employees (too small)
- FAIL: SaaS company, 500 employees (too large for SME focus)
- FAIL: Manufacturing company (wrong vertical)

---

## Level 2: Trigger (Timing/Event)

**Purpose**: Identify when to reach out (optimal timing based on events).

**Categories**:
- **Funding**: Series A/B/C raised, seed funding announced
- **Hiring**: Job postings for sales/marketing/RevOps roles
- **Expansion**: New office opening, geographic expansion
- **Tech Changes**: Switching CRM, adopting new tools
- **Leadership Changes**: New CMO, VP Sales, CRO hired
- **Product Launch**: New feature, new product line
- **M&A Activity**: Acquisition, merger, spin-off
- **Seasonal**: Q4 budget planning, fiscal year start

**Wedge Usage**: ❌ **NEVER** use Trigger alone for wedges

**Why**: Triggers are timing signals, not pain points. You don't create wedges like "You just raised Series A, so..." without connecting to actual pain.

**Note**: Triggers are often **combined** with Signal Types to create wedges.

**Examples**:
- Trigger alone: "Posted job listing for SDR" (timing signal)
- Trigger + Signal Type: "Posted job listing for SDR" (Trigger) + "Current sales data is scattered across tools" (Intent Signal) → **Valid wedge**

---

## Level 3: Signal Type (Trust vs Intent)

**Purpose**: Categorize the observed behavior by buying stage.

### Two Types Only:

#### 3A. Trust Signals
**Definition**: Community, authority, and visibility behaviors that build trust but don't indicate immediate buying intent.

**Subcategories**:
1. **Community Engagement**:
   - Posting about industry challenges (not specific to your solution)
   - Participating in LinkedIn discussions
   - Commenting on thought leader content
   - Sharing industry reports

2. **Authority Building**:
   - Publishing blog posts/articles
   - Speaking at conferences
   - Running webinars
   - Building personal brand

3. **Visibility Actions**:
   - Updating LinkedIn profile
   - Company announcements (non-buying)
   - Thought leadership content
   - Educational posts

**Wedge Usage**: ✅ **CAN** be used for wedges (but Intent takes priority)

**When to Use**: When no Intent signal exists, Trust signals can create "soft wedges" that build rapport.

**Example Wedge**:
- Trust Signal: "Posted about 'sales team alignment challenges'"
- Wedge: "I saw your post about sales team alignment. Most founders we work with discover the root cause is scattered data across 7 tools..."

#### 3B. Intent Signals
**Definition**: Active buying behaviors that indicate current pain or active solution-seeking.

**Subcategories**:
1. **Active Problem Indication**:
   - "Our CRM is a mess"
   - "Can't see full sales pipeline"
   - "Losing leads in spreadsheets"
   - Complaining about current tools

2. **Solution Research**:
   - Visiting competitor websites
   - Downloading comparison guides
   - Attending product demos
   - Reading reviews/case studies

3. **Procurement Signals**:
   - Posting RFP/RFQ
   - "Looking for recommendations for..."
   - Budget allocated announcements
   - Evaluating vendors publicly

4. **Urgency Indicators**:
   - "Need solution by Q4"
   - "Current contract ending soon"
   - "This is costing us deals"
   - Time-bound pain statements

**Wedge Usage**: ✅ **PRIORITIZED** for wedges

**Priority Rule**: **Intent > Trust** (if both present, use Intent)

**Example Wedge**:
- Intent Signal: "Posted: 'Our sales data lives in 7 different tools. Decision paralysis is real.'"
- Wedge: "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."

---

## Level 4: Signal Subtype (Specific Behavior)

**Purpose**: Granular categorization for precision targeting.

### Trust Signal Subtypes:

#### Community Engagement Subtypes:
- Industry pain discussion (broad)
- Best practices sharing
- Peer recommendations seeking
- Problem validation (not solution-seeking)

#### Authority Building Subtypes:
- Educational content creation
- Conference speaking/attending
- Certification/credential acquisition
- Thought leadership positioning

#### Visibility Subtypes:
- Profile optimization
- Company milestone announcements
- Team expansion signals
- Geographic presence updates

### Intent Signal Subtypes:

#### Active Problem Subtypes:
- **Fragmentation Pain**: Data/tools/processes scattered
- **Visibility Loss**: Can't see pipeline/metrics/performance
- **Speed Issues**: Slow response times, manual work
- **Leakage**: Losing leads, deals, opportunities
- **Compliance Gaps**: Regulatory, security, governance issues
- **Scalability Blocks**: Outgrowing current solution
- **Integration Hell**: Systems don't talk to each other

#### Solution Research Subtypes:
- Competitor comparison
- Feature requirement listing
- Vendor evaluation criteria
- Demo requests/attendance

#### Procurement Subtypes:
- RFP/RFQ publishing
- Budget confirmation
- Timeline establishment
- Stakeholder mapping

#### Urgency Subtypes:
- Contract expiration
- Deadline-driven (Q4, fiscal year, etc.)
- Crisis response (system failure, breach, etc.)
- Competitive pressure

**Wedge Usage**: ✅ Subtypes define the **specific angle** of the wedge

**Example**:
- Signal Type: Intent
- Signal Subtype: Fragmentation Pain
- Wedge: "Your sales data lives in 7 different tools. Decision paralysis is costing you deals. Unified dashboard = predictable revenue."

---

## Level 5: Wedge (One-Sentence Message)

**Purpose**: The actual one-line positioning statement derived from the signal.

**Rules**:
1. **Must be one sentence** (Hard Stop Rule: If requires 2+ sentences, reject signal)
2. **Derived from Trust OR Intent** (never from Fit or Trigger alone)
3. **Intent > Trust** (if both present, use Intent)
4. **Signal age < 90 days** (Hard Stop Rule: Signals >90 days excluded)

**Wedge Formula**:
```
[Observed Signal] is costing you [Specific Outcome]. [One-Line Solution].
```

**Examples by Signal Type**:

### Intent-Based Wedges:
1. **Fragmentation Pain**:
   - Signal: "Posted about data across 7 tools"
   - Wedge: "Your sales data lives in 7 different tools. Decision paralysis is costing you deals. Unified dashboard brings it back."

2. **Visibility Loss**:
   - Signal: "Can't see full pipeline"
   - Wedge: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."

3. **Speed Issues**:
   - Signal: "Responding to leads too slowly"
   - Wedge: "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."

4. **Leakage**:
   - Signal: "Losing Instagram followers who show interest"
   - Wedge: "Instagram followers generate $79 per 1000. Owned contacts generate $582. That's 8x ROI you're leaving on the table."

### Trust-Based Wedges (when no Intent signal):
1. **Community Engagement**:
   - Signal: "Posted about sales team alignment challenges"
   - Wedge: "I saw your post about sales alignment. Most founders we work with discover the root cause is data fragmentation across tools."

2. **Authority Building**:
   - Signal: "Wrote article on B2B sales trends"
   - Wedge: "Your article on sales trends resonated. We're seeing the pattern you described—and built a solution for the data visibility gap."

---

## Signal Hierarchy Decision Tree

Use this to determine if a signal is valid and which type it is:

```
START
  ↓
Does prospect meet ALL Fit criteria?
  NO → STOP (Hard Stop: Fit = FAIL)
  YES → Continue
  ↓
Is there a Trigger (timing/event)?
  YES → Note it (use for timing, not wedge alone)
  NO → Continue
  ↓
Observed behavior = ?
  ├─ Community/Authority/Visibility → Trust Signal
  └─ Active problem/Research/Procurement/Urgency → Intent Signal
  ↓
Are BOTH Trust AND Intent present?
  YES → Use Intent (Intent > Trust priority rule)
  NO → Use whichever is present
  ↓
Is signal < 90 days old?
  NO → STOP (Hard Stop: Signal too stale)
  YES → Continue
  ↓
Can you state the wedge in ONE sentence?
  NO → STOP (Hard Stop: Signal not actionable)
  YES → ✅ Valid wedge
```

---

## Practical Example: Complete Hierarchy

**Scenario**: MENA SaaS Founder

### Level 1: Fit
- Company: B2B SaaS, 15 employees
- Geography: Dubai, UAE (MENA)
- Revenue: $800k ARR
- Tech stack: HubSpot, Pipedrive, Slack, Notion
- **Result**: ✅ PASS (meets all Fit criteria)

### Level 2: Trigger
- Event: Posted job listing for "Sales Operations Manager"
- Timing: 5 days ago
- **Result**: ✓ Valid trigger (indicates scaling intent)

### Level 3: Signal Type
- **Trust Signal**: Posted article "Challenges of scaling B2B sales in MENA"
- **Intent Signal**: LinkedIn post: "Our sales data lives in HubSpot, Pipedrive, Notion, and 4 Google Sheets. Decision paralysis is real."
- **Result**: Intent Signal takes priority (Intent > Trust)

### Level 4: Signal Subtype
- Intent Subtype: **Fragmentation Pain**
- Specific complaint: Data across multiple tools, causing decision paralysis

### Level 5: Wedge
**Generated Wedge**:
"Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."

**One-sentence test**: ✅ PASS
**Signal age**: 5 days ✅ PASS
**Derived from**: Intent Signal ✅ PASS

---

## Common Mistakes to Avoid

### ❌ Mistake 1: Using Fit for Wedges
**Wrong**: "You're a SaaS company in MENA, so you need our solution."
**Why**: Fit is qualification, not persuasion.

### ❌ Mistake 2: Using Trigger Alone
**Wrong**: "You just raised Series A, so here's our pitch."
**Why**: Triggers are timing, not pain points.

### ❌ Mistake 3: Ignoring Intent > Trust Priority
**Wrong**: Using Trust signal "Posted about sales challenges" when Intent signal "Can't see pipeline across tools" also present.
**Why**: Intent indicates active buying behavior, Trust is passive.

### ❌ Mistake 4: Multi-Sentence Wedges
**Wrong**: "Your sales data is scattered. This causes problems. You need a solution. We can help."
**Why**: Violates one-sentence rule. Signal not actionable.

### ❌ Mistake 5: Stale Signals
**Wrong**: Using a LinkedIn post from 6 months ago.
**Why**: Violates 90-day freshness rule. Likely no longer relevant.

---

## Integration with 7 Silence Types

Each Signal Type often correlates with specific Silence Types:

| Signal Type | Common Silence Type | Wedge Focus |
|-------------|---------------------|-------------|
| Intent: Fragmentation Pain | Positioning Silence | "Here's what we actually solve" |
| Intent: Visibility Loss | Proof Silence | "Here's the evidence it works" |
| Intent: Speed Issues | Response Silence | "Here's how we respond in 5 min" |
| Intent: Leakage | Friction Silence | "Here's how we reduce barriers" |
| Trust: Community Engagement | Channel Silence | "Here's where to find us" |
| Trust: Authority Building | Objection Silence | "Here's how we address concerns" |

This mapping helps determine lead magnet type and DSI scoring dimensions.

---

## Summary

**Fit** → Qualification (Hard Stop if FAIL)
**Trigger** → Timing (Never wedge alone)
**Signal Type** → Trust or Intent (Intent > Trust)
**Signal Subtype** → Specific behavior
**Wedge** → One-sentence message (derived from Trust/Intent only)

**Hard Stop Rules**:
1. Fit = FAIL → No outreach
2. Signal > 90 days → Exclude
3. Cannot name in one sentence → Skip
4. Intent > Trust → Priority rule

Use this hierarchy to systematically convert observed behaviors into precise, signal-based wedges.

<!-- IP:END -->
