# Runbook: Signal-Ingest-News

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Cron (every 4 hours, aligned with master schedule)
**Layer:** Signal Ingestion
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Polls news APIs (NewsData.io, MENA-specific sources) for company mentions related to funding events, hiring announcements, expansion news, and other buying signals. Particularly important for MENA market intelligence where traditional data providers have gaps.

---

## Expected Behavior (Happy Path)

1. Triggered by Signal-Ingestion-Master on 4-hour cycle.
2. Fetches active news monitoring configs from `signal_sources` (where `source_type = 'news_api'`).
3. For each config, builds search queries from:
   - Customer's ICP company names (from `accounts` table)
   - Signal keywords: "funding", "raised", "Series A/B/C", "hiring", "expansion", "new office", "partnership"
   - MENA-specific keywords: "Dubai", "Saudi", "NEOM", "Riyadh", "Abu Dhabi", "Qatar"
4. Calls NewsData API with filters for articles published since `last_sync_at`.
5. For each relevant article:
   a. Extracts company name, event type, amounts (if funding), source URL.
   b. Matches company to existing `accounts` by company name or domain (fuzzy match).
   c. Classifies signal_type: `funding_event`, `hiring_signal`, `expansion_news`, `partnership_announcement`, `news_mention`.
   d. Generates `dedup_key` and inserts into `signals` table.
6. Returns summary to master workflow.

**Expected Duration:** 2-5 minutes depending on query volume and news volume.

---

## Input/Output Data Shapes

**Input:**
- News API config from `signal_sources`:
```json
{
  "source_type": "news_api",
  "config": {
    "api_key": "encrypted_ref",
    "provider": "newsdata",
    "keywords": ["funding", "expansion", "hiring"],
    "regions": ["ae", "sa", "qa", "kw"],
    "languages": ["en", "ar"]
  }
}
```

**Output:**
- Row in `signals` table:
```json
{
  "account_id": "uuid",
  "signal_type": "funding_event",
  "source": "news_api",
  "signal_value": {
    "headline": "TechCorp Dubai raises $15M Series B",
    "source_url": "https://news.example.com/article/123",
    "published_at": "2026-04-14T08:00:00Z",
    "amount": "$15M",
    "round": "Series B",
    "investors": ["VC Fund X", "MENA Capital"]
  },
  "confidence_score": 80,
  "dedup_key": "funding_event_abc123_2026-04-14"
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| NewsData API 401 | Unauthorized error | API key expired or plan downgraded. Update key in n8n credentials. |
| NewsData API 429 | Rate limited, retry-after header | Free tier: 200 requests/day. Paid tier: higher. Reduce query frequency or batch queries. |
| No articles returned | 0 signals for multiple cycles | Check if search keywords are too narrow. Expand keyword list. Verify API quota not exhausted. |
| False positive matches | Signals created for wrong companies | Improve company name matching -- use domain-first, then fuzzy name match with >80% similarity threshold. |
| Arabic article parsing issues | Signal value contains garbled text | Ensure UTF-8 encoding throughout. NewsData returns UTF-8 by default. Check n8n node encoding settings. |
| Duplicate articles from multiple sources | Same news event creates multiple signals | Dedup key uses signal_type + account_id + date. If the same funding event appears from different news sources on the same day, only the first is stored. |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Articles processed per cycle (expect 5-50)
  - Signals created per cycle (expect 2-20 after filtering)
  - Company match rate (target: >60% -- news mentions may include companies not in SSE)
  - Signal type distribution (funding events are highest value)
- **Alert thresholds:**
  - 0 signals for 24+ hours -> check API connectivity and keyword config
  - API quota >80% consumed -> consider upgrading plan or reducing query frequency
  - Match rate <30% -> keywords may be too broad, generating irrelevant results

---

## Dependencies

- **APIs:** NewsData.io API (https://newsdata.io/api/1/), MENA news aggregator APIs (configured per customer)
- **Tables:**
  - `signals` (write: insert news signals)
  - `signal_sources` (read: news API configs)
  - `company_entities` / `accounts` view (read: company name/domain matching)
  - `circuit_breaker_state` (read/write: news API CB)
- **Other workflows:** Called by Signal-Ingestion-Master. Triggers Scoring-Master on signal insert.
- **Circuit breakers:** `circuit_breaker_state` entry for `news_api`.

---

## Manual Execution

```bash
# Trigger news ingestion manually
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-news \
  -H "Content-Type: application/json" \
  -d '{"manual": true}'

# Trigger for specific keywords (override)
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-news \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "keywords": ["NEOM", "Saudi Vision 2030"], "since": "2026-04-13T00:00:00Z"}'
```

---

## MENA-Specific Notes

- Arabic news sources are critical for early signal detection in Saudi, UAE, Qatar, Kuwait.
- Many MENA funding events are reported in Arabic first, English 12-48 hours later.
- Include Arabic keywords alongside English: "تمويل" (funding), "توسع" (expansion), "توظيف" (hiring).
- Government mega-projects (NEOM, Expo, QatarEnergy) generate significant B2B signals.
- Friday/Saturday are weekend in MENA -- news volume drops. Adjust expectations for weekend cycles.
