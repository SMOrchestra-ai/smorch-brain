<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
---
name: wedge-generator
description: Creates one-sentence wedges from validated signals using ICP-specific templates. Enforces Hard Stop Rules 3 and 4 (one-sentence test, Intent>Trust). Use when generating wedges from signals, creating weekly messaging themes, or refining wedges based on performance. Outputs 3 validated weekly wedges ready for asset production.
---

# Wedge Generator

## Purpose

This sub-skill transforms **validated signals** into **precise, one-sentence wedges** that form the foundation of all campaign messaging. It's the creative heart of the Signal-to-Trust framework.

**Core Philosophy**: Every wedge must be signal-specific, ICP-resonant, and passable in one sentence.

---

## When to Call This Skill

The meta skill `signal-to-trust-gtm` calls this sub-skill during:
- **Mode A (New Campaign)**: Third sub-skill called (after signal-detector)
- **Mode B (Weekly Assets)**: When refining wedges based on performance
- **Mode D (One-Off Task)**: When user requests "Generate wedge" or "Create messaging theme"

Directly invoke when user asks:
- "Create wedges from these signals"
- "Generate messaging for [signal]"
- "Refine this wedge with A/B variants"
- "Turn this LinkedIn post into a wedge"

---

## Inputs

### Required

1. **Validated Signal Data** (from signal-detector)
   - Signal Type (Trust / Intent)
   - Signal Subtype (e.g., Fragmentation Pain, Community Engagement)
   - Signal text (raw observed behavior)
   - Prospect ICP

2. **Monthly Theme** (from campaign-strategist)
   - One-line monthly wedge theme
   - Example: "Data Fragmentation Crisis"

3. **Weekly Wedge Strategy** (from campaign-strategist)
   - Different angles (A - default)
   - Sequential story (B)
   - A/B/C variants (C)

4. **ICP Context**
   - MENA SaaS Founders / US Real Estate Brokers / MENA Beauty Clinics / US eCommerce

### Optional

- **Performance data** (if Mode B - wedge refinement)
- **Existing wedges** (if creating A/B variants)
- **Geographic market** (for Culture Map adaptation)

---

## Outputs

### 3 Weekly Wedges (Validated)

```markdown
## Weekly Wedges - [Campaign Name]

### Week 1 Wedge
**Wedge**: "[One-sentence wedge]"
**Signal Source**: [Intent/Trust: Subtype]
**ICP**: [Target ICP]
**Angle**: [Identify problem / Amplify pain / Provide solution / etc.]
**Validation**:
  - One-sentence test: ✓ PASS
  - No hedging: ✓ PASS
  - Specific (not vague): ✓ PASS
  - ICP resonance: ✓ PASS

### Week 2 Wedge
**Wedge**: "[One-sentence wedge]"
**Signal Source**: [Intent/Trust: Subtype]
**ICP**: [Target ICP]
**Angle**: [Different from Week 1]
**Validation**:
  - One-sentence test: ✓ PASS
  - No hedging: ✓ PASS
  - Specific (not vague): ✓ PASS
  - ICP resonance: ✓ PASS

### Week 3 Wedge
**Wedge**: "[One-sentence wedge]"
**Signal Source**: [Intent/Trust: Subtype]
**ICP**: [Target ICP]
**Angle**: [Different from Week 1 and 2]
**Validation**:
  - One-sentence test: ✓ PASS
  - No hedging: ✓ PASS
  - Specific (not vague): ✓ PASS
  - ICP resonance: ✓ PASS

## Hard Stop Rules Applied
- Rule 3 (One-sentence test): ✓ All wedges pass
- Rule 4 (Intent > Trust): ✓ Applied where both present
```

---

## Wedge Creation Logic

### Core Formula (from wedge-sentence-map.md)

```
[Observed Signal] is costing you [Specific Outcome]. [One-Line Solution].
```

**Variations**:
- Problem-focused: "[Signal] is creating [Pain]. [Solution] is the fix."
- Outcome-focused: "[Current State] generates [Low Metric]. [Better State] generates [High Metric]. That's [X]x ROI."
- Proof-focused: "[X Peers] faced [Signal]. After [Solution], they achieved [Outcome]."

### ICP-Specific Templates

#### MENA SaaS Founders (High-Context, Trust-First)

**Pattern 1: Data Fragmentation**
```
Template: "Your [asset] across [X tools] is creating [pain]. [Solution] = [outcome]."

Examples:
- "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."
- "Pipeline visibility disappeared across HubSpot, Pipedrive, and 4 spreadsheets. One view brings it back."
```

**Pattern 2: Geographic Distribution**
```
Template: "Your [team/asset] is scattered across [cities]. Your [system] isn't. [Regional solution] is the missing piece."

Examples:
- "Your sales team is scattered across Dubai, Riyadh, and Cairo. Your CRM isn't. Regional dashboards are the missing piece."
- "Customers in 5 MENA markets. Support team in one. Regional response system closes the gap."
```

**Pattern 3: Peer Proof**
```
Template: "[X MENA founders] faced [signal]. After [solution], they [outcome]."

Examples:
- "5 MENA SaaS founders unified their scattered stack. They closed 40% more deals."
- "Dubai founders consolidated data across 7 tools. Predictable revenue became possible."
```

---

#### US Real Estate Brokers (Low-Context, Task-First)

**Pattern 1: Golden Window (Speed)**
```
Template: "Responding after [X time] costs you [Y]x in conversion. The first [golden window] is everything."

Examples:
- "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."
- "Your lead fills a form at 2pm. You reply at 5pm. They booked with someone else at 2:07pm."
```

**Pattern 2: Lead Leakage**
```
Template: "[X]% of your leads say '[objection].' [Y]% will [convert] after [touchpoints]. You're missing the [opportunity]."

Examples:
- "98% of your leads say 'I'll think about it.' 80% will book after 5-12 touchpoints. You're missing the backend 50x improvement."
- "Only 2% book immediately. The other 98% need 7 touches over 30 days. That's where the revenue is."
```

**Pattern 3: Listing Capture**
```
Template: "[X people] walked through your open house. [Y captured]. [$Z revenue] lost."

Examples:
- "150 people walked through your open house. 12 captured. $2.1M in potential commission lost."
- "Every showing without capture = invisible buyer. Capture system = warm pipeline."
```

---

#### MENA Beauty Clinics (Visual-First, Trust-Driven)

**Pattern 1: Social Follower Leakage**
```
Template: "Instagram [followers/engagement] generate [low $]. [Owned contacts] generate [high $]. That's [X]x ROI."

Examples:
- "Instagram followers generate $79 per 1000. Owned contacts generate $582. That's 8x ROI you're leaving on the table."
- "10k Instagram followers. 127 in your CRM. You own 1.2% of your audience."
```

**Pattern 2: Backend Nurture Gap**
```
Template: "[X]% of clients say '[objection].' [Y]% will book after [touchpoints]. You're missing the backend [outcome]."

Examples:
- "98% of your leads say 'I'll think about it.' 80% will book after 5-12 touchpoints. You're missing the backend 50x improvement."
- "Only 2% book laser treatment on first inquiry. The rest need proof, trust, timing. That's 98% revenue you're not nurturing."
```

**Pattern 3: Response Window**
```
Template: "Someone DMs about [treatment] at [time]. You respond at [later time]. They booked with [competitor] who replied in [minutes]."

Examples:
- "Someone DMs about Botox at 2pm. You respond at 5pm. They booked with a competitor who replied in 5 minutes."
- "WhatsApp inquiry comes in. You're with a patient. Auto-reply captures them. Manual-only loses them."
```

---

#### US eCommerce (DTC) (Data-Driven, Friction-Sensitive)

**Pattern 1: Checkout Friction**
```
Template: "[X]% abandon at [checkout step]. [Root cause] is the killer. [Solution] = [Y]% recovery."

Examples:
- "67% abandon at 'Create Account.' Guest checkout + email capture = 43% recovery."
- "Your checkout has 7 steps. Every step costs you 15%. That's 105% cumulative leakage."
```

**Pattern 2: Email List ROI**
```
Template: "[Paid channel] costs [$/acquisition]. [Owned list] costs [$]. That's [X]x difference in LTV."

Examples:
- "Facebook ads cost $47 per customer. Email list nurture costs $6. That's 8x ROI on owned audience."
- "Paid traffic without capture = rent. Email list = ownership. 10x LTV difference."
```

**Pattern 3: Mobile Optimization**
```
Template: "[X]% of traffic is mobile. [Y]% convert. Desktop converts at [Z]%. Mobile friction = revenue leak."

Examples:
- "68% of your traffic is mobile. 2.1% convert. Desktop converts at 8.3%. Mobile checkout friction is costing you $23k monthly."
- "Mobile users don't fill 14-field forms. They abandon. 3-field form = 4x mobile conversion."
```

---

## Hard Stop Rule 3: One-Sentence Test

### Validation Logic

```python
def validate_one_sentence(wedge_text):
    # Test 1: Count sentences
    sentence_count = wedge_text.count('.') + wedge_text.count('!') + wedge_text.count('?')

    if sentence_count > 1:
        return {
            'pass': False,
            'reason': f'Multiple sentences detected ({sentence_count}). Signal too complex.'
        }

    # Test 2: Check for hedging language
    hedging_words = ['might', 'could', 'possibly', 'perhaps', 'maybe', 'potentially']
    if any(word in wedge_text.lower() for word in hedging_words):
        return {
            'pass': False,
            'reason': 'Hedging language detected. Signal lacks conviction.'
        }

    # Test 3: Check for vague language
    vague_terms = ['better results', 'improvement', 'optimization', 'more efficient', 'enhanced']
    if any(term in wedge_text.lower() for term in vague_terms):
        return {
            'pass': False,
            'reason': 'Vague language detected. Signal not specific enough.'
        }

    # Test 4: Check for specificity (numbers, metrics, tangible outcomes)
    has_specificity = any([
        any(char.isdigit() for char in wedge_text),  # Contains numbers
        '$' in wedge_text or '%' in wedge_text,      # Contains metrics
        'x' in wedge_text.lower()                     # Contains multiplier (8x, 21x)
    ])

    if not has_specificity:
        return {
            'pass': False,
            'reason': 'No specific metrics or outcomes. Add data (%, $, Xx).'
        }

    return {
        'pass': True,
        'reason': 'Passes one-sentence test'
    }
```

### Examples: PASS vs FAIL

**✓ PASS**:
- "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."
  - One sentence ✓, No hedging ✓, Specific (7 tools) ✓

**✗ FAIL: Multiple Sentences**:
- "Your sales data is scattered. This causes problems. We can help."
  - Three sentences ✗

**✗ FAIL: Hedging**:
- "You might be considering CRM alternatives. We could potentially help."
  - Hedging (might, could, potentially) ✗

**✗ FAIL: Vague**:
- "You want better sales results. We help companies optimize their sales process."
  - Vague ("better results," "optimize") ✗

---

## Hard Stop Rule 4: Intent > Trust

### Priority Logic

```python
def apply_intent_priority(signals):
    intent_signals = [s for s in signals if s['type'] == 'Intent']
    trust_signals = [s for s in signals if s['type'] == 'Trust']

    if intent_signals and trust_signals:
        # Both present → Use Intent (Hard Stop Rule 4)
        selected_signal = select_highest_priority(intent_signals)
        log(f"Both Intent and Trust present. Using Intent: {selected_signal}")
        return selected_signal

    elif intent_signals:
        # Only Intent → Use it
        return select_highest_priority(intent_signals)

    elif trust_signals:
        # Only Trust → Use it
        return select_highest_priority(trust_signals)

    else:
        # No signals → Error
        raise ValueError("No signals available for wedge generation")
```

### Example: Intent Overrides Trust

**Prospect**: MENA SaaS Founder

**Trust Signal** (20 days ago):
"Posted article on LinkedIn: 'The Challenges of Scaling B2B Sales in MENA'"

**Intent Signal** (5 days ago):
"Posted: 'Our sales data lives in HubSpot, Pipedrive, Notion, and 4 Google Sheets. Decision paralysis is real.'"

**Application of Rule 4**:
```
Both signals present
Intent signal age: 5 days (fresh)
Trust signal age: 20 days (fresh)

Intent > Trust (Rule 4)
→ Use Intent signal
→ Wedge: "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."
```

**Why**: Intent signal shows ACTIVE PAIN (right now). Trust signal shows thought leadership (passive).

---

## Weekly Wedge Strategy Execution

### Strategy A: Different Angles (Default)

**Input**: Monthly Theme = "Data Fragmentation Crisis"

**Output**:
- **Week 1**: "Your sales data lives in 7 different tools. Decision paralysis is costing you deals."
  - Angle: Identify problem (scattered state)
- **Week 2**: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."
  - Angle: Amplify cost (visibility loss)
- **Week 3**: "5 MENA SaaS founders unified their stack. They closed 40% more deals."
  - Angle: Provide proof (peer validation)

**Validation**: All 3 relate to monthly theme ✓, Each is different angle ✓

---

### Strategy B: Sequential Story

**Input**: Monthly Theme = "Golden Window Response Speed"

**Output**:
- **Week 1**: "Your lead fills a form at 2pm. You reply at 5pm. They booked with someone else at 2:07pm."
  - Chapter: The invisible loss (story opening)
- **Week 2**: "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."
  - Chapter: The quantified gap (data reveal)
- **Week 3**: "Instant auto-reply + mobile notifications = never miss the Golden Window."
  - Chapter: The solution (resolution)

**Validation**: Builds narrative arc ✓, Each advances story ✓

---

### Strategy C: A/B/C Variants

**Input**: Monthly Theme = "Instagram Follower Leakage"

**Output** (Week 1):
- **Variant A (Data-driven)**: "Instagram followers generate $79 per 1000. Owned contacts generate $582. That's 8x ROI."
- **Variant B (Story-driven)**: "You built 10k Instagram followers. Then your account got suspended. All gone. Owned list survives platform risk."
- **Variant C (Peer-driven)**: "Dubai clinics with 5k+ Instagram followers captured <2%. Those who built owned lists own 40% of their audience."

**Validation**: Same core message ✓, Different psychology ✓

---

## Geographic Adaptation (Culture Map)

### MENA Adaptation

**Original (US-style)**:
"Your sales data across 7 tools is costing you $47k in lost deals monthly. Here's the ROI breakdown."

**MENA-adapted**:
"I noticed you're facing the same challenge Ahmed at [Company] mentioned—sales data scattered across tools. After working with him to unify everything, his team closed 40% more deals. Would love to share how."

**Changes**:
- Added relationship reference (Ahmed)
- Softened directness ("I noticed" vs "Your")
- Used "we" framing ("working with him")
- Implied outcome vs explicit claim

---

### US Adaptation

**Original (MENA-style)**:
"Many founders we work with have found that unifying data sources creates meaningful improvements."

**US-adapted**:
"Your sales data across 7 tools is costing you $47k monthly. Unified dashboard cuts that to zero."

**Changes**:
- Direct problem statement ("Your")
- Specific data ($47k)
- Clear outcome (cuts to zero)
- No softening or hedging

---

### Germany Adaptation

**Original (US-style)**:
"Your sales data across 7 tools is costing you $47k monthly. Unified dashboard = predictable revenue."

**Germany-adapted**:
"Systematic analysis of data fragmentation across disparate sales systems reveals a mean efficiency loss of 34% (n=147, p<0.01). Consolidation to a unified platform restores operational efficiency."

**Changes**:
- Formal language ("systematic analysis")
- Specific data (34%, n=147, p<0.01)
- Principle-first (efficiency loss → consolidation)
- Structured reasoning

---

## Examples

### Example 1: MENA SaaS - Intent Signal

**Input**:
- Signal Type: Intent
- Signal Subtype: Fragmentation Pain
- Signal Text: "Our sales data lives in 7 different tools. Decision paralysis is real."
- Monthly Theme: "Proof Silence - Data Fragmentation Crisis"
- Weekly Strategy: Different angles
- ICP: MENA SaaS Founders

**Processing**:

**Week 1 Wedge** (Identify problem):
```
Wedge: "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."

Validation:
- One-sentence test: ✓ PASS (1 sentence, no hedging)
- Specificity: ✓ PASS (7 tools, unified dashboard, predictable revenue)
- ICP resonance: ✓ PASS (MENA founders face this exact pain)
- Derived from monthly theme: ✓ PASS (data fragmentation)
```

**Week 2 Wedge** (Amplify cost):
```
Wedge: "Scattered data = invisible pipeline. Unified dashboard = predictable revenue."

Validation:
- One-sentence test: ✓ PASS
- Specificity: ✓ PASS (invisible pipeline = visibility loss)
- ICP resonance: ✓ PASS
- Derived from monthly theme: ✓ PASS
```

**Week 3 Wedge** (Provide proof):
```
Wedge: "5 MENA SaaS founders unified their scattered stack. They closed 40% more deals."

Validation:
- One-sentence test: ✓ PASS
- Specificity: ✓ PASS (5 founders, 40% more deals)
- ICP resonance: ✓ PASS (MENA peer proof)
- Derived from monthly theme: ✓ PASS (unified stack = data consolidation)
```

**Output**: 3 validated weekly wedges ready for asset-factory.

---

### Example 2: US Real Estate - Multiple Signals

**Input**:
- Prospect 1 Signal: Intent: Speed Issues - "Losing leads to faster brokers"
- Prospect 2 Signal: Intent: Speed Issues - "Form fills at 2pm, reply at 5pm"
- Prospect 3 Signal: Intent: Solution Research - "Need automation for follow-up"
- Monthly Theme: "Response Silence - Golden Window Lost"
- Weekly Strategy: Sequential story
- ICP: US Real Estate Brokers

**Processing** (select highest priority Intent signal):
- All 3 are Intent signals
- 2 are Speed Issues (higher priority for Response Silence)
- Select Prospect 2 signal (most specific)

**Week 1 Wedge** (Story opening):
```
Wedge: "Your lead fills a form at 2pm. You reply at 5pm. They booked with someone else at 2:07pm."

Validation:
- One-sentence test: ✓ PASS
- Specificity: ✓ PASS (specific times: 2pm, 5pm, 2:07pm)
- ICP resonance: ✓ PASS (US brokers live this pain)
- Derived from signal: ✓ PASS (directly from Prospect 2)
```

**Week 2 Wedge** (Data reveal):
```
Wedge: "Responding after 30 minutes costs you 21x in conversion. The first 5 minutes is everything."

Validation:
- One-sentence test: ✓ PASS
- Specificity: ✓ PASS (21x, 30 minutes, 5 minutes)
- ICP resonance: ✓ PASS
- Sequential story: ✓ PASS (builds on Week 1)
```

**Week 3 Wedge** (Resolution):
```
Wedge: "Instant auto-reply + mobile notifications = never miss the Golden Window."

Validation:
- One-sentence test: ✓ PASS
- Specificity: ✓ PASS (instant, mobile, Golden Window)
- ICP resonance: ✓ PASS
- Sequential story: ✓ PASS (completes arc)
```

**Output**: 3 validated weekly wedges in narrative sequence.

---

## Error Handling

### Error 1: Wedge Fails One-Sentence Test
**Symptom**: Generated wedge requires multiple sentences
**Fix**: Narrow signal focus, remove complexity
**Example**: "Your sales data is scattered. This causes problems. We solve it." → "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."

### Error 2: No Intent Signals Available
**Symptom**: Only Trust signals in validated prospect list
**Fix**: Use Trust signals, note lower priority in output
**Example**: "Week 1 uses Trust signal (Community Engagement) due to no Intent signals available."

### Error 3: Wedge Too Generic
**Symptom**: Wedge lacks ICP-specific language
**Fix**: Add ICP context (geography, vertical, specific pain)
**Example**: "Better sales results" → "MENA SaaS founders closed 40% more deals after unifying scattered data"

### Error 4: Weekly Wedges Not Related
**Symptom**: 3 wedges address different problems
**Fix**: Realign all 3 to monthly theme
**Example**: Week 1="Data scattered", Week 2="Slow response", Week 3="No proof" → All should focus on data fragmentation

---

## Integration with Other Sub-Skills

### Downstream Dependencies

After wedge-generator outputs 3 validated wedges:

**asset-factory** uses:
- 3 weekly wedges (exact text)
- ICP context
- Geographic market
- Channel mix
- To produce 42 assets (18 emails, 12 LinkedIn, 9 WhatsApp, 3 social)

### Upstream Dependencies

**Inputs from**:
1. **signal-detector**: Validated signals (Fit PASS, Fresh, Trust/Intent classified)
2. **campaign-strategist**: Monthly theme, weekly strategy, ICP context
3. **wedge-sentence-map.md**: ICP-specific templates

---

## Conclusion

The wedge-generator sub-skill ensures:
1. **Signal-specific wedges** (not generic value props)
2. **One-sentence clarity** (Hard Stop Rule 3)
3. **Intent prioritization** (Hard Stop Rule 4)
4. **ICP resonance** (templates + language)
5. **Weekly consistency** (all 3 relate to monthly theme)

**Output**: 3 validated, one-sentence wedges ready to power 42 multi-channel assets.

Next: Pass 3 wedges to asset-factory for email, LinkedIn, WhatsApp, and social production.
