# Output Formats by Mode

## Mode A: New Campaign

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

### 3. GHL Deployment Config (JSON)
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

## Mode B: Weekly Assets

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

## Mode C: Performance Analysis

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
- **Action**: Continue winning wedge, create A/B variants
- **Rationale**: [X]% reply rate is [X]x benchmark
- **Assets needed**: 2 new email variants

### Option B: Pivot to New Signal
- **Action**: Test new signal
- **New wedge**: "[One-sentence wedge for new signal]"
- **Risk**: Restart momentum

### Option C: Hybrid
- **Action**: 70% winning wedge, 30% new signal test

## Template Evolution
**Winning patterns**:
- Subject lines with "[specific data point]" → [X]x open rate
- P.S. with "[micro-commitment]" → [X]x reply rate
```
