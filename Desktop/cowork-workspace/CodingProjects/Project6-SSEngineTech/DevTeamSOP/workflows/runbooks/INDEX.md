# SSE V3 n8n Workflow Runbooks

**Last Updated:** 2026-04-14
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

All workflows run on smo-brain (100.89.148.62) via n8n at testflow.smorchestra.ai:5170.

---

## Workflow Index

| # | Workflow | Layer | Trigger | Schedule | Runbook |
|---|---------|-------|---------|----------|---------|
| 1 | Signal-Ingestion-Master | Signal Ingestion | Cron | Every 4 hours | [01-signal-ingestion-master.md](01-signal-ingestion-master.md) |
| 2 | Signal-Ingest-Clay | Signal Ingestion | Triggered by master / manual | On demand | [02-signal-ingest-clay.md](02-signal-ingest-clay.md) |
| 3 | Signal-Ingest-Instantly | Signal Ingestion | Triggered by master / webhook | On demand + webhook | [03-signal-ingest-instantly.md](03-signal-ingest-instantly.md) |
| 4 | Signal-Ingest-HeyReach | Signal Ingestion | Triggered by master / webhook | On demand + webhook | [04-signal-ingest-heyreach.md](04-signal-ingest-heyreach.md) |
| 5 | Signal-Ingest-News | Signal Ingestion | Cron | Every 4 hours | [05-signal-ingest-news.md](05-signal-ingest-news.md) |
| 6 | Signal-Ingest-Apify | Signal Ingestion | Cron / manual | Every 24 hours or on demand | [06-signal-ingest-apify.md](06-signal-ingest-apify.md) |
| 7 | Scoring-Master | Scoring | Webhook + cron | On new signal + daily 02:00 UTC | [07-scoring-master.md](07-scoring-master.md) |
| 8 | Scoring-Daily-Batch | Scoring | Cron | Daily 02:00 UTC | [08-scoring-daily-batch.md](08-scoring-daily-batch.md) |
| 9 | Routing-Master | Routing | Webhook (from Scoring-Master) | Event-driven | [09-routing-master.md](09-routing-master.md) |
| 10 | Outreach-Queue-Processor | Activation | Cron | Every 15 minutes | [10-outreach-queue-processor.md](10-outreach-queue-processor.md) |
| 11 | Channel-Sender-Instantly | Activation | Triggered by queue processor | Event-driven | [11-channel-sender-instantly.md](11-channel-sender-instantly.md) |
| 12 | Channel-Sender-HeyReach | Activation | Triggered by queue processor | Event-driven | [12-channel-sender-heyreach.md](12-channel-sender-heyreach.md) |
| 13 | Channel-Sender-GHL | Activation | Triggered by queue processor | Event-driven | [13-channel-sender-ghl.md](13-channel-sender-ghl.md) |
| 14 | Feedback-Loop-Monthly | Feedback | Cron | 1st Sunday of month, 02:00 UTC | [14-feedback-loop-monthly.md](14-feedback-loop-monthly.md) |
| 15 | Nurture-Email-Sequencer | Supporting | Cron | Daily | [15-nurture-email-sequencer.md](15-nurture-email-sequencer.md) |
| 16 | Competitor-Monitoring | Supporting | Cron | Weekly | [16-competitor-monitoring.md](16-competitor-monitoring.md) |

---

## Layer Summary

| Layer | Workflows | Purpose |
|-------|-----------|---------|
| Signal Ingestion | 1-6 | Collect buying signals from 15+ sources into `signals` table |
| Scoring | 7-8 | AI-powered intent scoring via Claude API, outputs to `lead_scores_history` |
| Routing | 9 | Maps score tiers to outreach strategies and channels |
| Activation | 10-13 | Executes multi-channel outreach (email, LinkedIn, WhatsApp/SMS) |
| Feedback | 14 | Monthly closed-deal analysis, signal weight optimization |
| Supporting | 15-16 | Nurture sequences and competitive intelligence |

---

## Quick Troubleshooting

**Workflow not firing on schedule:**
1. Check n8n UI at testflow.smorchestra.ai:5170 -- is the workflow active (toggle ON)?
2. Check n8n execution logs for the workflow -- any recent errors?
3. SSH to smo-brain, run `systemctl status n8n` to confirm the service is running.

**All workflows failing simultaneously:**
1. Check Supabase connectivity -- can n8n reach the database?
2. Check n8n credential store -- have any API keys expired?
3. Check smo-brain server health: `ssh 100.89.148.62` then `htop`, `df -h`, `systemctl status n8n`.

**Single workflow in error state:**
1. Open the workflow in n8n UI, check the last execution error.
2. Cross-reference with the specific runbook for that workflow.
3. Check Sentry for correlated exceptions.
4. Check Slack #sse-v3-alerts for related alerts.

---

## Database Table Reference (BRD to Actual)

Runbooks use BRD names for clarity. Actual table names in Supabase:

| BRD Name | Actual DB Table |
|----------|----------------|
| customers | `tenants` |
| accounts | `company_entities` |
| contacts | `individual_entities` |
| account_intent_scores | `lead_scores_history` |
| activation_outreach | `campaign_messages` |
| signals | `signals` |
| signal_sources | `signal_sources` |
| signal_weights | `signal_weights` |
| circuit_breaker_state | `circuit_breaker_state` |

See `DevTeamSOP/database/SCHEMA-MAPPING.md` for full mapping.
