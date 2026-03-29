<!-- IP:START - Hard Stop Rules enforcement logic -->
# Hard Stop Rules

Non-negotiable enforcement rules for the Signal-to-Trust GTM framework.

These rules exist to protect campaign quality, prevent wasted effort, and ensure signal-based precision. **They cannot be overridden**, even if the user requests it.

---

## Rule 1: Fit = FAIL → No Outreach

### Statement
**If a prospect fails ANY Fit criterion, STOP immediately. Do not generate assets. Do not add to campaign.**

### Rationale
Outreaching to prospects who don't meet ICP criteria wastes:
- Your time (creating personalized messages for wrong audience)
- Your sender reputation (low engagement damages deliverability)
- Your brand (annoying people who shouldn't be targeted)
- The prospect's time (irrelevant outreach = spam)

**Fit is binary**: Either they meet ALL criteria or they're excluded. There's no "mostly fits" or "close enough."

### Fit Criteria by ICP

#### MENA SaaS Founders
- **Company size**: 5-50 employees
- **Geography**: MENA region (UAE, Saudi Arabia, Egypt, Qatar, Bahrain, Kuwait, Oman, Jordan, Lebanon)
- **Industry**: B2B SaaS (not B2C, not services)
- **Revenue**: $200k-$5M ARR
- **Stage**: Post-revenue, pre-enterprise

**Validation**:
```
if employees < 5 OR employees > 50:
    EXCLUDE
if country NOT IN [UAE, Saudi, Egypt, Qatar, Bahrain, Kuwait, Oman, Jordan, Lebanon]:
    EXCLUDE
if industry != "B2B SaaS":
    EXCLUDE
if ARR < $200k OR ARR > $5M:
    EXCLUDE
```

#### US Real Estate Brokers
- **Company size**: 10-100 agents
- **Geography**: United States (excluding territories)
- **Industry**: Residential real estate brokerage
- **Revenue**: $2M-$50M annual commission volume
- **Tech stack**: Using at least one CRM (any platform)

**Validation**:
```
if agents < 10 OR agents > 100:
    EXCLUDE
if country != "United States":
    EXCLUDE
if vertical != "Residential Real Estate":
    EXCLUDE
if commission_volume < $2M OR commission_volume > $50M:
    EXCLUDE
if crm_present == False:
    EXCLUDE
```

#### MENA Beauty Clinics
- **Company size**: 2-20 staff (doctors, nurses, aestheticians)
- **Geography**: MENA region (focus: UAE, Saudi Arabia)
- **Industry**: Dermatology, medical aesthetics, beauty clinic
- **Revenue**: $300k-$3M annual
- **Services**: At least one of: Botox, fillers, laser treatments, skincare

**Validation**:
```
if staff < 2 OR staff > 20:
    EXCLUDE
if country NOT IN [UAE, Saudi]:
    EXCLUDE
if services NOT IN [Botox, fillers, laser, skincare]:
    EXCLUDE
if revenue < $300k OR revenue > $3M:
    EXCLUDE
```

#### US eCommerce (DTC)
- **Company size**: 3-50 employees
- **Geography**: United States
- **Industry**: Direct-to-consumer eCommerce
- **Revenue**: $500k-$10M annual
- **Platform**: Shopify, WooCommerce, Magento, or custom
- **Products**: Physical goods (not digital products, not services)

**Validation**:
```
if employees < 3 OR employees > 50:
    EXCLUDE
if country != "United States":
    EXCLUDE
if business_model != "DTC eCommerce":
    EXCLUDE
if revenue < $500k OR revenue > $10M:
    EXCLUDE
if product_type == "Digital" OR product_type == "Services":
    EXCLUDE
```

### Enforcement Protocol

When signal-detector is called:

1. **Load ICP-specific Fit criteria**
2. **Check EACH criterion** (company size, geography, industry, revenue, etc.)
3. **If ANY criterion fails**:
   - Flag prospect as `FIT_FAIL`
   - Log reason: `"Excluded: [criterion] out of range"`
   - **Do NOT pass to wedge-generator**
   - **Do NOT add to campaign**

4. **Output validation summary**:
```
Total prospects: 500
Fit PASS: 147
Fit FAIL: 353
  - Company size out of range: 127
  - Wrong geography: 89
  - Wrong industry: 76
  - Revenue out of range: 61
```

5. **Campaign proceeds ONLY with Fit PASS prospects** (147 in example above)

### User Override Protocol

**User**: "But I think this prospect is a good fit even though they're 60 employees."

**Response**:
"This prospect fails the Fit criterion (company size: 60 employees, range: 5-50). Rule 1 (Fit = FAIL) is non-negotiable to protect campaign quality.

If you believe the ICP definition should expand to 5-60 employees, we can update the Fit criteria for ALL future prospects. But we cannot override for individual prospects."

**Acceptable resolution**: Update ICP Fit criteria globally (requires user confirmation).

**Unacceptable resolution**: Override for one prospect (breaks framework integrity).

---

## Rule 2: Signal Age > 90 Days → Exclude

### Statement
**Signals older than 90 days are stale. Exclude them from wedge generation and campaign targeting.**

### Rationale
Signals decay rapidly. A LinkedIn post from 6 months ago about "hiring sales team" is no longer a valid Intent signal—they've likely already hired, or the pain has changed.

**90-day threshold** is based on:
- B2B buying cycles (30-90 days typical)
- Signal relevance decay (pain evolves)
- Competitive timing (someone else already reached out)

### Validation

When signal-detector processes signals:

```
signal_date = [date signal was observed]
today = [current date]
signal_age_days = today - signal_date

if signal_age_days > 90:
    FLAG as STALE
    LOG: "Signal too old: [signal_age_days] days (threshold: 90)"
    EXCLUDE from campaign
```

### Example

**Signal**: "Posted on LinkedIn: 'Our sales data is scattered across too many tools'"
**Date**: January 15, 2026
**Today**: May 20, 2026
**Age**: 125 days

**Validation**:
```
125 days > 90 days → STALE
Exclude from campaign
```

**Reasoning**: 4+ months later, they've either:
- Solved the problem (hired someone, bought a tool)
- Forgotten about it (pain not urgent)
- Changed focus (new priorities emerged)

### Enforcement Protocol

1. **Capture signal timestamp** when signal is detected/scraped
2. **Calculate age** on every campaign run
3. **If signal_age > 90 days**:
   - Flag as `STALE`
   - Exclude from prospect list
   - Log exclusion reason

4. **Output validation summary**:
```
Total signals collected: 500
Fresh signals (<90 days): 284
Stale signals (>90 days): 216
  - 91-180 days old: 127
  - 181-365 days old: 64
  - >365 days old: 25
```

### Edge Cases

**User**: "This signal is 95 days old but still very relevant."

**Response**:
"Signal age: 95 days (threshold: 90). Rule 2 (Signal >90 days = stale) is non-negotiable.

However, if the prospect has posted NEW signals on the same topic recently (within 90 days), we can use those instead. Should I search for fresh signals from this prospect?"

**Acceptable resolution**: Find fresh signals from same prospect.

**Unacceptable resolution**: Override 90-day rule.

---

## Rule 3: Cannot Name Signal in One Sentence → Skip

### Statement
**If you cannot articulate the signal clearly in one sentence, it's not actionable. Skip it.**

### Rationale
Complex, multi-faceted signals indicate:
- Ambiguity (unclear what the actual pain is)
- Multiple overlapping issues (need to narrow focus)
- Generic observations (not specific enough)

**One-sentence test** forces clarity. If the wedge requires hedging, caveats, or multiple sentences, the signal is too vague to convert.

### Validation

When wedge-generator creates wedges:

```
wedge = generate_wedge(signal)

# Test 1: Sentence count
sentence_count = count_sentences(wedge)
if sentence_count > 1:
    REJECT
    LOG: "Wedge requires multiple sentences. Signal not actionable."

# Test 2: Hedging language
if contains_hedging(wedge):  # "might," "could," "possibly," etc.
    REJECT
    LOG: "Wedge contains hedging. Signal lacks conviction."

# Test 3: Vague language
if contains_vague_terms(wedge):  # "better results," "improvement," "optimization"
    REJECT
    LOG: "Wedge uses vague language. Signal not specific."
```

### Examples

#### ❌ FAIL: Multiple Sentences
**Signal**: "Prospect posted about challenges with sales team alignment, data visibility issues, and needing better forecasting."

**Attempted wedge**: "Your sales team alignment challenges are connected to data visibility. This impacts forecasting. We solve all three."

**Why it fails**: 3 sentences. Signal is too broad—pick ONE specific pain.

**Resolution**: Narrow to Intent signal (data visibility) and ignore the rest.

**Revised wedge** (PASS): "Your scattered sales data is creating visibility gaps. Unified dashboard = accurate forecasting."

---

#### ❌ FAIL: Hedging Language
**Signal**: "Prospect mentioned possibly looking into CRM alternatives."

**Attempted wedge**: "You might be considering CRM alternatives. We could potentially help you evaluate options."

**Why it fails**: "Might," "could," "potentially" = weak signal, no conviction.

**Resolution**: This isn't a real Intent signal. It's speculative. Reject and wait for concrete signal ("Currently evaluating CRMs" = Intent).

---

#### ❌ FAIL: Vague Language
**Signal**: "Prospect posted about wanting better sales results."

**Attempted wedge**: "You want better sales results. We help companies optimize their sales process."

**Why it fails**: "Better results" and "optimize" are vague. What specific outcome?

**Resolution**: Probe for specific signal. "Better results" could mean:
- Higher close rate? → Proof Silence
- Faster deal cycles? → Speed Issues
- More pipeline visibility? → Visibility Loss

Wait for specific signal or ask clarifying question.

---

#### ✅ PASS: One Sentence, Specific, Clear
**Signal**: "Prospect posted: 'Our sales data lives in 7 different tools. Decision paralysis is real.'"

**Wedge**: "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."

**Why it passes**:
- One sentence ✓
- No hedging ✓
- Specific signal (7 tools, decision paralysis) ✓
- Clear outcome (predictable revenue) ✓

---

### Enforcement Protocol

1. **wedge-generator** attempts to create wedge from signal
2. **Run 3 validation tests**:
   - Sentence count = 1?
   - No hedging language?
   - No vague terms?

3. **If ANY test fails**:
   - Flag signal as `NOT_ACTIONABLE`
   - Log failure reason
   - **Do NOT use in campaign**

4. **Output validation summary**:
```
Total signals: 284
Actionable (passed one-sentence test): 147
Not actionable: 137
  - Multi-sentence required: 64
  - Hedging language: 41
  - Vague/generic: 32
```

### User Override Protocol

**User**: "This wedge needs two sentences to explain properly."

**Response**:
"If the wedge requires two sentences, the signal is too complex or vague. Rule 3 (one-sentence test) ensures clarity and actionability.

Options:
1. Narrow the signal to ONE specific pain point
2. Split into two separate signals (if truly two distinct issues)
3. Reject this signal and find a clearer one

Which would you prefer?"

**Acceptable resolution**: Narrow or split the signal.

**Unacceptable resolution**: Override one-sentence rule.

---

## Rule 4: Intent > Trust (Priority Rule)

### Statement
**When both Trust AND Intent signals are present, Intent takes priority.**

### Rationale
- **Intent signals** = Active buying behavior (high conversion probability)
- **Trust signals** = Passive community engagement (lower conversion probability)

**Intent indicates NOW**. Trust indicates "maybe someday."

If you have both, always prioritize the one that shows active pain or solution-seeking.

### Validation

When signal-detector identifies signals for a prospect:

```
signals = detect_signals(prospect)

intent_signals = [s for s in signals if s.type == "Intent"]
trust_signals = [s for s in signals if s.type == "Trust"]

if intent_signals AND trust_signals:
    use_signal = select_highest_priority(intent_signals)
    LOG: f"Both Intent and Trust present. Using Intent: {use_signal}"
    IGNORE trust_signals
elif intent_signals:
    use_signal = select_highest_priority(intent_signals)
elif trust_signals:
    use_signal = select_highest_priority(trust_signals)
else:
    LOG: "No signals present. Prospect excluded."
    EXCLUDE
```

### Examples

#### Example 1: Intent Overrides Trust

**Prospect**: MENA SaaS Founder

**Trust Signal** (observed 20 days ago):
"Posted article on LinkedIn: 'The Challenges of Scaling B2B Sales in MENA'"

**Intent Signal** (observed 5 days ago):
"Posted: 'Our sales data lives in HubSpot, Pipedrive, Notion, and 4 Google Sheets. Decision paralysis is real.'"

**Validation**:
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

#### Example 2: No Intent, Use Trust

**Prospect**: MENA SaaS Founder

**Trust Signal** (observed 10 days ago):
"Commented on LinkedIn post about sales team challenges: 'We're dealing with this too. Alignment is tough.'"

**Intent Signal**: None

**Validation**:
```
Only Trust signal present
→ Use Trust signal
→ Wedge: "I saw your comment about sales team alignment. Most founders we work with discover the root cause is data fragmentation."
```

**Why**: No Intent signal available. Trust signal is better than no outreach.

---

#### Example 3: Multiple Intent Signals

**Prospect**: US Real Estate Broker

**Intent Signal 1** (observed 3 days ago):
"Posted job listing: Sales Operations Manager"

**Intent Signal 2** (observed 1 day ago):
"Posted: 'Losing leads because we're too slow to respond. Need automation.'"

**Validation**:
```
Multiple Intent signals present
Signal 2 is newer (1 day vs 3 days)
Signal 2 is more specific (active pain vs hiring trigger)

→ Use Signal 2
→ Wedge: "Slow response is costing you leads. Automation captures them in the Golden Window (<5 min)."
```

**Why**: Signal 2 is fresher AND more specific to immediate pain.

---

### Enforcement Protocol

1. **signal-detector** identifies ALL signals for a prospect
2. **Classify each** as Trust or Intent
3. **If both types present**:
   - **ALWAYS prioritize Intent**
   - Select highest-priority Intent signal (freshest, most specific)
   - Ignore all Trust signals

4. **If only Trust present**:
   - Use highest-priority Trust signal

5. **If neither present**:
   - Exclude prospect (no valid signal)

### User Override Protocol

**User**: "I want to use the Trust signal even though there's an Intent signal."

**Response**:
"Rule 4 (Intent > Trust) is non-negotiable. Intent signals indicate active buying behavior and convert at 3-5x higher rates than Trust signals.

If you believe the Trust signal is more compelling, please explain why. In most cases, this indicates the 'Intent' signal may be misclassified.

Options:
1. Use Intent signal (recommended)
2. Re-classify the 'Intent' signal as Trust (if misidentified)
3. Create TWO separate campaigns (one Intent-focused, one Trust-focused)

Which would you prefer?"

**Acceptable resolution**: Re-classify signal or run separate campaigns.

**Unacceptable resolution**: Override Intent > Trust rule.

---

## Summary Table

| Rule | Statement | Validation | Override? |
|------|-----------|------------|-----------|
| **1. Fit = FAIL** | Prospect fails ANY Fit criterion → No outreach | Check ALL ICP criteria | ❌ No (but can update ICP globally) |
| **2. Signal >90 days** | Signals older than 90 days → Exclude | Calculate signal_age_days | ❌ No (but can find fresh signals) |
| **3. One-sentence test** | Cannot name signal in one sentence → Skip | Count sentences, check hedging/vague language | ❌ No (but can narrow signal) |
| **4. Intent > Trust** | When both present, Intent takes priority | Classify signals, prioritize Intent | ❌ No (but can re-classify or split campaigns) |

---

## Enforcement Checklist

Before ANY campaign execution:

```
☐ Fit validation complete (all prospects meet ALL ICP criteria)
☐ Signal age check complete (all signals <90 days)
☐ One-sentence test passed (all wedges = 1 sentence, no hedging, specific)
☐ Intent > Trust prioritization applied (if both present, Intent used)

If ALL checked → ✅ Proceed to asset-factory
If ANY unchecked → ❌ STOP, resolve violations first
```

---

## Philosophy

These rules exist to protect:
1. **Campaign quality** (only target right-fit prospects with fresh signals)
2. **Conversion rates** (actionable wedges, prioritized Intent signals)
3. **Sender reputation** (no spray-and-pray, no irrelevant outreach)
4. **Framework integrity** (signal-based precision, not guesswork)

**Hard Stop = Non-Negotiable**. These are the guardrails that make the Signal-to-Trust framework work.

<!-- IP:END -->
