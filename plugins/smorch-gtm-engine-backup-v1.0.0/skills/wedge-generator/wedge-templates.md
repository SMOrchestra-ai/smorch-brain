# Wedge Generator - ICP Templates & Examples

Reference file for ICP-specific wedge templates, validation logic, geographic adaptation, and examples.

---

## ICP-Specific Templates

### MENA SaaS Founders (High-Context, Trust-First)

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
```

**Pattern 3: Peer Proof**
```
Template: "[X MENA founders] faced [signal]. After [solution], they [outcome]."

Examples:
- "5 MENA SaaS founders unified their scattered stack. They closed 40% more deals."
```

---

### US Real Estate Brokers (Low-Context, Task-First)

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
```

**Pattern 3: Listing Capture**
```
Template: "[X people] walked through your open house. [Y captured]. [$Z revenue] lost."

Examples:
- "150 people walked through your open house. 12 captured. $2.1M in potential commission lost."
```

---

### MENA Beauty Clinics (Visual-First, Trust-Driven)

**Pattern 1: Social Follower Leakage**
```
Template: "Instagram [followers/engagement] generate [low $]. [Owned contacts] generate [high $]. That's [X]x ROI."

Examples:
- "Instagram followers generate $79 per 1000. Owned contacts generate $582. That's 8x ROI you're leaving on the table."
```

**Pattern 2: Backend Nurture Gap**
```
Template: "[X]% of clients say '[objection].' [Y]% will book after [touchpoints]. You're missing the backend [outcome]."
```

**Pattern 3: Response Window**
```
Template: "Someone DMs about [treatment] at [time]. You respond at [later time]. They booked with [competitor] who replied in [minutes]."
```

---

### US eCommerce (DTC) (Data-Driven, Friction-Sensitive)

**Pattern 1: Checkout Friction**
```
Template: "[X]% abandon at [checkout step]. [Root cause] is the killer. [Solution] = [Y]% recovery."

Examples:
- "67% abandon at 'Create Account.' Guest checkout + email capture = 43% recovery."
```

**Pattern 2: Email List ROI**
```
Template: "[Paid channel] costs [$/acquisition]. [Owned list] costs [$]. That's [X]x difference in LTV."
```

**Pattern 3: Mobile Optimization**
```
Template: "[X]% of traffic is mobile. [Y]% convert. Desktop converts at [Z]%. Mobile friction = revenue leak."
```

---

## Hard Stop Rule 3: One-Sentence Test

### Validation Logic

```python
def validate_one_sentence(wedge_text):
    # Test 1: Count sentences
    sentence_count = wedge_text.count('.') + wedge_text.count('!') + wedge_text.count('?')
    if sentence_count > 1:
        return {'pass': False, 'reason': f'Multiple sentences detected ({sentence_count}).'}

    # Test 2: Check for hedging language
    hedging_words = ['might', 'could', 'possibly', 'perhaps', 'maybe', 'potentially']
    if any(word in wedge_text.lower() for word in hedging_words):
        return {'pass': False, 'reason': 'Hedging language detected.'}

    # Test 3: Check for vague language
    vague_terms = ['better results', 'improvement', 'optimization', 'more efficient', 'enhanced']
    if any(term in wedge_text.lower() for term in vague_terms):
        return {'pass': False, 'reason': 'Vague language detected.'}

    # Test 4: Check for specificity (numbers, metrics, tangible outcomes)
    has_specificity = any([
        any(char.isdigit() for char in wedge_text),
        '$' in wedge_text or '%' in wedge_text,
        'x' in wedge_text.lower()
    ])
    if not has_specificity:
        return {'pass': False, 'reason': 'No specific metrics. Add data (%, $, Xx).'}

    return {'pass': True, 'reason': 'Passes one-sentence test'}
```

### PASS vs FAIL Examples

**PASS**: "Your sales data across 7 tools is creating decision paralysis. Unified dashboard = predictable revenue."
**FAIL (Multiple Sentences)**: "Your sales data is scattered. This causes problems. We can help."
**FAIL (Hedging)**: "You might be considering CRM alternatives. We could potentially help."
**FAIL (Vague)**: "You want better sales results. We help companies optimize their sales process."

---

## Hard Stop Rule 4: Intent > Trust

```python
def apply_intent_priority(signals):
    intent_signals = [s for s in signals if s['type'] == 'Intent']
    trust_signals = [s for s in signals if s['type'] == 'Trust']

    if intent_signals and trust_signals:
        # Both present -> Use Intent (Hard Stop Rule 4)
        return select_highest_priority(intent_signals)
    elif intent_signals:
        return select_highest_priority(intent_signals)
    elif trust_signals:
        return select_highest_priority(trust_signals)
    else:
        raise ValueError("No signals available for wedge generation")
```

---

## Geographic Adaptation (Culture Map)

### MENA Adaptation
**Original (US-style)**: "Your sales data across 7 tools is costing you $47k in lost deals monthly."
**MENA-adapted**: "I noticed you're facing the same challenge Ahmed at [Company] mentioned -- sales data scattered across tools. After working with him to unify everything, his team closed 40% more deals."
Changes: Added relationship reference, softened directness, used "we" framing, implied outcome.

### US Adaptation
**Original (MENA-style)**: "Many founders we work with have found that unifying data sources creates meaningful improvements."
**US-adapted**: "Your sales data across 7 tools is costing you $47k monthly. Unified dashboard cuts that to zero."
Changes: Direct problem statement, specific data, clear outcome, no softening.

### Germany Adaptation
**Original (US-style)**: "Your sales data across 7 tools is costing you $47k monthly."
**Germany-adapted**: "Systematic analysis of data fragmentation across disparate sales systems reveals a mean efficiency loss of 34% (n=147, p<0.01)."
Changes: Formal language, specific data with statistical significance, principle-first.

---

## Weekly Wedge Strategy Execution

### Strategy A: Different Angles (Default)
Monthly: "Data Fragmentation Crisis"
- Week 1: Identify problem (scattered state)
- Week 2: Amplify cost (visibility loss)
- Week 3: Provide proof (peer validation)

### Strategy B: Sequential Story
Monthly: "Golden Window Response Speed"
- Week 1: The invisible loss (story opening)
- Week 2: The quantified gap (data reveal)
- Week 3: The solution (resolution)

### Strategy C: A/B/C Variants
Monthly: "Instagram Follower Leakage"
- Week 1: Variant A (data-driven), B (story-driven), C (peer-driven)
- Week 2: Winning variant refined
- Week 3: Optimized variant deployed

---

## Error Handling

### Error 1: Wedge Fails One-Sentence Test
**Fix**: Narrow signal focus, remove complexity

### Error 2: No Intent Signals Available
**Fix**: Use Trust signals, note lower priority in output

### Error 3: Wedge Too Generic
**Fix**: Add ICP context (geography, vertical, specific pain)

### Error 4: Weekly Wedges Not Related
**Fix**: Realign all 3 to monthly theme
