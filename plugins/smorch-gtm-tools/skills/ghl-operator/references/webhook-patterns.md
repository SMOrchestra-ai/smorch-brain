# Webhook Patterns Reference

> **v2 migration banner — 2026-04-26.** Bare tool names in this doc (e.g., `upsert_contact`, `add_contact_tags`) are now **operation names** under the new `mcp__salesmfast-ops__ghl-contacts-updater` router. Call shape: `{ selectSchema: { operation, params } }`. See `SKILL.md → MCP Tools Reference` or `salesmfast-ops-mcp/docs/MIGRATION.md` for the full mapping.

## Table of Contents
1. [GHL Webhook Events](#ghl-webhook-events)
2. [Signal Capture Configuration](#signal-capture-configuration)
3. [Webhook-to-n8n Patterns](#webhook-to-n8n-patterns)
4. [Event Processing Logic](#event-processing-logic)

---

## GHL Webhook Events

GHL supports 50+ webhook event types. These are the ones relevant to signal-based operations:

### Contact Events
| Event | Trigger | Signal Value | Action |
|-------|---------|-------------|--------|
| `ContactCreate` | New contact created | Low | Log source, apply initial tags |
| `ContactUpdate` | Contact fields updated | Varies | Check what changed, re-score if relevant |
| `ContactTagUpdate` | Tag added or removed | High | Route based on tag taxonomy |
| `ContactDndUpdate` | Do-not-disturb status changed | High | Stop/start messaging |
| `ContactDelete` | Contact deleted | N/A | Clean up related opportunities |

### Opportunity Events
| Event | Trigger | Signal Value | Action |
|-------|---------|-------------|--------|
| `OpportunityCreate` | New opportunity created | Medium | Log in reporting, notify if high value |
| `OpportunityStageUpdate` | Stage changed | High | Track velocity, trigger stage-specific actions |
| `OpportunityStatusUpdate` | Status changed (won/lost/open) | High | Update metrics, trigger win/loss workflow |
| `OpportunityMonetaryValueUpdate` | Deal value changed | Medium | Update pipeline value calculations |
| `OpportunityDelete` | Opportunity removed | Low | Clean up records |

### Conversation Events
| Event | Trigger | Signal Value | Action |
|-------|---------|-------------|--------|
| `ConversationUnreadUpdate` | New unread message | High | Potential reply — check source, score |
| `InboundMessage` | Contact sends message | Very High | Reply signal — escalate, update score |
| `OutboundMessage` | Message sent to contact | Low | Log communication, track sequence |

### Appointment Events
| Event | Trigger | Signal Value | Action |
|-------|---------|-------------|--------|
| `AppointmentCreate` | Meeting booked | Very High | Move to "Meeting Booked" stage |
| `AppointmentUpdate` | Meeting rescheduled | Medium | Update notes, adjust follow-up |
| `AppointmentDelete` | Meeting cancelled | High | Investigate — re-engage or archive |

### Form/Survey Events
| Event | Trigger | Signal Value | Action |
|-------|---------|-------------|--------|
| `FormSubmission` | Website form filled | High | Create/update contact, route by form type |
| `SurveySubmission` | Survey completed | Medium | Enrich contact data with responses |

### Task Events
| Event | Trigger | Signal Value | Action |
|-------|---------|-------------|--------|
| `TaskCreate` | Task assigned | Low | Track follow-up commitments |
| `TaskComplete` | Task completed | Low | Log completion, check next action |

---

## Signal Capture Configuration

### High-Value Signal Events
These events should always trigger immediate processing:

```
Priority 1 (Immediate — Slack alert + score update):
- InboundMessage (contact replied to any channel)
- AppointmentCreate (meeting booked)
- FormSubmission (website engagement)
- ContactTagUpdate where tag = signal:hot

Priority 2 (Within 1 hour — score update):
- OpportunityStageUpdate (pipeline movement)
- ConversationUnreadUpdate (new message in thread)
- AppointmentDelete (cancelled — requires attention)

Priority 3 (Daily batch — analytics only):
- ContactCreate (new lead logging)
- OpportunityCreate (pipeline tracking)
- OutboundMessage (communication logging)
- TaskComplete (activity tracking)
```

### Webhook Configuration Best Practices
1. **Filter by event type** — Don't subscribe to ALL events. Only subscribe to the ones you'll act on.
2. **Idempotency** — GHL may fire duplicate webhooks. Always check if the action was already taken before processing.
3. **Timeout handling** — Webhook endpoints must respond within 30 seconds. For heavy processing, acknowledge receipt immediately and process async via n8n queue.
4. **Retry policy** — GHL retries failed webhooks up to 3 times with exponential backoff. Design your endpoint to handle retries gracefully.

---

## Webhook-to-n8n Patterns

Webhooks from GHL feed into n8n workflows for processing. The standard pattern:

### Pattern 1: Direct Webhook
```
GHL Webhook → n8n Webhook Trigger → Process → Act

Setup:
1. Create n8n workflow with Webhook trigger node
2. Copy the n8n webhook URL
3. Configure GHL webhook to point to that URL
4. Select specific events to forward
```

### Pattern 2: Tag-Based Routing
```
GHL ContactTagUpdate webhook → n8n
  → Parse tag name
  → Switch node on tag category
    → signal:hot → Slack alert + pipeline update
    → signal:warm → Add to nurture sequence
    → source:* → Log source attribution
    → icp:* → Route to correct pipeline
```

### Pattern 3: Conversation Signal
```
GHL InboundMessage webhook → n8n
  → Extract message content
  → Claude API: Analyze sentiment & intent
  → Score update (Function node)
  → IF score >= 7 → Upgrade to hot + Slack alert
  → Update GHL contact with new score
```

---

## Event Processing Logic

### Contact Tag Update Processing
When a `ContactTagUpdate` event fires:

```python
# Pseudo-logic for tag event processing
event = webhook_payload

tag_name = event['tag']
contact_id = event['contactId']
action = event['action']  # 'added' or 'removed'

if action == 'added':
    if tag_name.startswith('signal:'):
        signal_level = tag_name.split(':')[1]
        if signal_level == 'hot':
            # 1. Create/update opportunity
            # 2. Move to "Qualified" or "Signal Detected"
            # 3. Send Slack alert
            # 4. Start hot lead follow-up sequence
        elif signal_level == 'warm':
            # 1. Ensure in nurture sequence
            # 2. Log for weekly report
        elif signal_level == 'cold':
            # 1. Remove from active sequences
            # 2. Log for monthly re-score batch

    elif tag_name.startswith('source:'):
        # Log source attribution for analytics
        # Don't trigger action — informational only

    elif tag_name.startswith('icp:'):
        icp = tag_name.split(':')[1]
        # Route to correct pipeline based on ICP
        # e.g., icp:mena_saas → MENA SaaS Pipeline
```

### Inbound Message Processing
When an `InboundMessage` event fires:

```python
event = webhook_payload

contact_id = event['contactId']
message = event['body']
channel = event['type']  # SMS, Email, WhatsApp, etc.

# 1. Update last_signal_date
update_contact(contact_id, {
    'customField': {
        'last_signal_date': datetime.now().isoformat(),
        'signal_source': f'{channel.lower()}_reply'
    }
})

# 2. Analyze message sentiment/intent (via Claude API in n8n)
analysis = analyze_message(message)

# 3. Update signal score
new_score = calculate_score(analysis.sentiment, analysis.intent)
update_contact(contact_id, {'customField': {'signal_score': str(new_score)}})

# 4. Route based on score
if new_score >= 7:
    add_tags(contact_id, ['signal:hot'])
    remove_tags(contact_id, ['signal:warm', 'signal:cold'])
    # Create opportunity if none exists
    # Send Slack alert

# 5. Log
create_note(contact_id, f"Inbound {channel} reply on {date}. "
            f"Sentiment: {analysis.sentiment}. Score: {new_score}.")
```

### Appointment Event Processing
When an `AppointmentCreate` event fires:

```python
event = webhook_payload

contact_id = event['contactId']
appointment_date = event['startTime']

# 1. Move opportunity to "Meeting Booked"
opportunities = search_opportunities(contact_id=contact_id)
if opportunities:
    for opp in opportunities:
        if opp['status'] == 'open':
            update_opportunity(opp['id'], {
                'pipelineStageId': meeting_booked_stage_id
            })

# 2. Update tags
add_tags(contact_id, ['status:meeting_booked'])

# 3. Set signal to hot if not already
add_tags(contact_id, ['signal:hot'])

# 4. Log
create_note(contact_id, f"Meeting booked for {appointment_date}. "
            f"Auto-moved to Meeting Booked stage.")

# 5. Slack notification
send_slack_alert(f"🗓️ Meeting booked with {contact_name} on {appointment_date}")
```

---

## Webhook Security

### Verification
- GHL webhooks don't include HMAC signatures by default
- Validate incoming requests by checking the source IP or using a webhook secret in the URL path
- n8n webhook nodes support path-based authentication: use a random string in the webhook path

### Rate Considerations
- GHL doesn't rate-limit outgoing webhooks, but high-volume events (like bulk contact updates) can flood your n8n instance
- Use a queue or buffer for high-volume webhook processing
- Consider filtering events at the GHL level rather than receiving everything and filtering in n8n
