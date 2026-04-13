# Runbook: Competitor-Monitoring

**Workflow ID:** TBD — assign on n8n
**Trigger:** Weekly cron (Sunday 03:00 UTC)
**Layer:** Supporting
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Expected Behavior (Happy Path)

1. Cron triggers weekly at Sunday 03:00 UTC
2. Fetches competitor company list from `signal_sources` config (type = 'competitor')
3. Scrapes competitor websites for updates (pricing changes, new features, hiring)
4. Queries news APIs for competitor mentions in MENA market
5. Compares against previous week's snapshot (stored in workflow static data)
6. If changes detected, formats summary with change type and significance
7. Sends Slack alert to #sse-v3-product with competitor activity summary
8. Stores snapshot for next week's comparison

## Input/Output Data Shapes

**Input:**
- Competitor list from `signal_sources` table (source_type = 'competitor')
- Previous week's snapshot from n8n static data

**Output:**
- Slack message to #sse-v3-product (if changes detected)
- Updated snapshot in n8n static data

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| News API rate limit | 429 response | Retry with backoff, skip news if all retries fail |
| Competitor site down | Timeout/5xx | Skip that competitor, note in summary |
| Slack webhook failure | Message not delivered | Retry 3x, log to n8n execution log |
| No changes detected | Empty diff | No alert sent (expected behavior) |

## Monitoring

- **Where to check:** n8n execution logs (weekly), Slack #sse-v3-product
- **Key metrics:** Execution time (<5 min), competitor coverage (all competitors scraped)
- **Alert threshold:** 3 consecutive weeks with no execution = investigate

## Dependencies

- **APIs:** News APIs, competitor website scraping
- **Tables:** `signal_sources` (competitor config)
- **Other workflows:** None (standalone)
- **Circuit breakers:** None (standalone, non-critical)

## Manual Execution

```bash
# Trigger manually via n8n UI
# Navigate to Competitor-Monitoring workflow -> Execute Workflow
```
