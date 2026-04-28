## Signal Classification Logic

### Trust vs Intent Decision Tree

```
Signal observed → Analyze behavior type

├─ Active problem indication?
│  ├─ YES → Intent Signal (Subtype: Active Problem)
│  └─ NO → Continue
│
├─ Solution research behavior?
│  ├─ YES → Intent Signal (Subtype: Solution Research)
│  └─ NO → Continue
│
├─ Procurement signal?
│  ├─ YES → Intent Signal (Subtype: Procurement)
│  └─ NO → Continue
│
├─ Urgency indicator?
│  ├─ YES → Intent Signal (Subtype: Urgency)
│  └─ NO → Continue
│
├─ Community engagement?
│  ├─ YES → Trust Signal (Subtype: Community Engagement)
│  └─ NO → Continue
│
├─ Authority building?
│  ├─ YES → Trust Signal (Subtype: Authority Building)
│  └─ NO → Continue
│
└─ Visibility action?
   ├─ YES → Trust Signal (Subtype: Visibility)
   └─ NO → No signal detected
```

### Intent Signal Patterns (Keyword Matching)

#### Active Problem Indication
**Keywords**: "our [system] is a mess", "can't see", "losing", "scattered", "too slow", "broken", "frustrated with"

**Examples**:
- "Our sales data lives in 7 different tools" → Intent: Fragmentation Pain
- "Can't see full pipeline" → Intent: Visibility Loss
- "Losing leads to faster competitors" → Intent: Speed Issues
- "98% say I'll think about it" → Intent: Leakage

#### Solution Research
**Keywords**: "looking for", "recommendations for", "evaluating", "comparing", "need solution for"

**Examples**:
- "Looking for CRM alternatives" → Intent: Solution Research
- "Evaluating automation tools" → Intent: Solution Research
- "Need better lead capture" → Intent: Solution Research

#### Procurement
**Keywords**: "RFP", "RFQ", "budget allocated", "Q4 purchase", "contract ending"

**Examples**:
- "Issuing RFP for sales automation" → Intent: Procurement
- "Current contract ends Q2" → Intent: Procurement
- "Budget approved for CRM upgrade" → Intent: Procurement

#### Urgency
**Keywords**: "need by", "urgent", "ASAP", "this quarter", "losing deals", "costing us"

**Examples**:
- "Need solution by Q4" → Intent: Urgency
- "This is costing us deals daily" → Intent: Urgency
- "Can't wait any longer" → Intent: Urgency

### Trust Signal Patterns

#### Community Engagement
**Keywords**: "posted about", "commented on", "shared", "discussed", "asked peers"

**Examples**:
- "Posted about sales team alignment challenges" → Trust: Community
- "Asked for recommendations in LinkedIn group" → Trust: Community
- "Shared article about GTM challenges" → Trust: Community

#### Authority Building
**Keywords**: "published", "speaking at", "webinar host", "wrote article", "podcast guest"

**Examples**:
- "Published blog post on B2B sales trends" → Trust: Authority
- "Speaking at SaaStr conference" → Trust: Authority
- "Hosting webinar on lead generation" → Trust: Authority

#### Visibility
**Keywords**: "updated profile", "new role", "company milestone", "expansion announced"

**Examples**:
- "Updated LinkedIn: now Head of Sales" → Trust: Visibility
- "Company announced Series A" → Trust: Visibility (also Trigger)
- "Opened new office in Dubai" → Trust: Visibility (also Trigger)

