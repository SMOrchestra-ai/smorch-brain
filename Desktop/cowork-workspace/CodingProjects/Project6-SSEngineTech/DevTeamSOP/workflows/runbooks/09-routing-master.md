# Runbook: Routing-Master

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Webhook (from Scoring-Master after new score)
**Layer:** Routing
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Maps intent score tiers to outreach strategies. When Scoring-Master produces a new score, Routing-Master determines what outreach actions to take, on which channels, and when. It creates pending outreach records in the `activation_outreach` table for the Outreach-Queue-Processor to execute.

---

## Expected Behavior (Happy Path)

1. Receives webhook from Scoring-Master with `account_id`, `intent_score`, `intent_tier`, `recommended_channel`.
2. Fetches account details and contacts from `accounts` and `contacts` tables.
3. Checks anti-spam rules:
   - No duplicate touches within 24 hours (query `activation_outreach` for recent sends).
   - Max 3 touches per 14-day window per contact (fatigue prevention).
   - Contact is not on DNL (`do_not_contact != true`).
   - Not in customer's suppress list.
4. Applies routing rules based on intent tier:

   | Score Tier | Day 0 | Day 2 | Day 4 | Day 7 | Day 14 |
   |-----------|-------|-------|-------|-------|--------|
   | Hot (80+) | Warm Email | LinkedIn | WhatsApp | Phone Call | - |
   | Warm (60-79) | Email | - | - | LinkedIn | Nurture |
   | Cool (40-59) | - | - | - | - | Weekly Nurture |
   | Cold (<40) | - | - | - | - | Quarterly Re-score |

5. For each scheduled action:
   a. Selects the best contact (decision_maker = true, preferred_channel match).
   b. Calculates `scheduled_at` based on day offset + timezone-aware scheduling (9am-5pm local, Sun-Thu for MENA).
   c. Checks credit balance: `customer.credit_balance >= action_cost`. If insufficient, logs warning and skips.
   d. Creates a row in `activation_outreach` (actual: `campaign_messages`) with status = `pending`.
6. Returns summary of actions scheduled.

**Expected Duration:** <2 seconds per account.

---

## Input/Output Data Shapes

**Input (Webhook from Scoring-Master):**
```json
{
  "account_id": "uuid",
  "customer_id": "uuid",
  "intent_score": 82,
  "intent_tier": "hot",
  "recommended_channel": "email",
  "next_action_signal": "Send case study about their funding round"
}
```

**Output:**
- Rows in `campaign_messages` (BRD: `activation_outreach`):
```json
[
  {
    "contact_id": "uuid",
    "account_id": "uuid",
    "channel": "email",
    "status": "pending",
    "scheduled_at": "2026-04-14T09:00:00+04:00",
    "credits_spent": 0
  },
  {
    "contact_id": "uuid",
    "account_id": "uuid",
    "channel": "linkedin",
    "status": "pending",
    "scheduled_at": "2026-04-16T10:00:00+04:00",
    "credits_spent": 0
  }
]
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| No contacts found for account | Warning in execution log, 0 actions scheduled | Account may need contact enrichment. Log for review. Do not create outreach without a valid contact. |
| All contacts on DNL | 0 actions scheduled despite hot score | Correct behavior. Log and move on. Customer may need to expand their contact list. |
| Insufficient credits | Warning logged, actions skipped | Alert the customer via dashboard notification. Do not proceed with sends that can't be billed. |
| Anti-spam check blocks all actions | 0 actions scheduled for warm/hot account | Check recent outreach history. If the contact was already touched within 24h, this is expected. If the 14-day window is full, the contact is being over-engaged -- review cadence. |
| Timezone calculation error | Outreach scheduled at wrong local time | Verify timezone data in `accounts` or `contacts` table. Default to UTC+4 (Dubai) for MENA if timezone missing. |
| Score arrives for deleted account | FK violation or null pointer | Check if account exists before processing. If deleted, discard the score event. |
| Duplicate routing for same score | Multiple outreach records for one scoring event | Add idempotency check: if an outreach already exists for this account + channel + day, skip. |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Routing events per hour (should correlate with scoring events)
  - Actions scheduled per routing event (avg: 1-3 for hot, 1 for warm, 0 for cool/cold)
  - Anti-spam block rate (target: <20% of routing events blocked)
  - Credit-insufficient rate (target: <5%)
- **Alert thresholds:**
  - Anti-spam block rate >50% -> cadence may be too aggressive, review routing rules
  - Credit-insufficient rate >20% -> customers running low, alert sales team
  - 0 routing events for 1+ hour during scoring activity -> workflow may be disconnected from Scoring-Master

---

## Dependencies

- **APIs:** None (internal routing logic only)
- **Tables:**
  - `lead_scores_history` / `account_intent_scores` view (read: score details)
  - `company_entities` / `accounts` view (read: account details, timezone)
  - `individual_entities` / `contacts` view (read: select best contact)
  - `campaign_messages` / `activation_outreach` view (read: check recent outreach; write: create pending records)
  - `tenants` / `customers` view (read: check credit_balance)
- **Other workflows:**
  - Receives from: Scoring-Master
  - Feeds into: Outreach-Queue-Processor (via pending records in DB)
- **Circuit breakers:** None (no external API calls).

---

## Manual Execution

```bash
# Route a specific account (simulate a scoring event)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/routing-master \
  -H "Content-Type: application/json" \
  -d '{
    "account_id": "uuid-here",
    "customer_id": "uuid-here",
    "intent_score": 85,
    "intent_tier": "hot",
    "recommended_channel": "email"
  }'

# Dry run (see what would be scheduled without creating records)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/routing-master \
  -H "Content-Type: application/json" \
  -d '{
    "account_id": "uuid-here",
    "intent_score": 85,
    "intent_tier": "hot",
    "dry_run": true
  }'
```

---

## Routing Rules Maintenance

- Routing rules (tier -> action matrix) are configured in the workflow, not in the database.
- Changes to routing rules require Mamoun's approval (product impact on customer outreach).
- When modifying rules, update this runbook and `/DevTeamSOP/ADRs/ADR-001-Signal-Nervous-System.md`.
- MENA weekend awareness: Friday/Saturday are off. Never schedule outreach for Fri/Sat. Sunday is the first workday.
- Ramadan awareness: during Ramadan, shift business hours to 10am-3pm local time for MENA prospects.
