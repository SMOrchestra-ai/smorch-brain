<!-- IP:START - Hard stop validation logic and priority rules -->
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


<!-- IP:END -->
