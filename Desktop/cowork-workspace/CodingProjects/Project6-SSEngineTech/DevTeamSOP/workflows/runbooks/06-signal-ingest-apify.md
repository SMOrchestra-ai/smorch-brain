# Runbook: Signal-Ingest-Apify

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Cron (every 24 hours) / on-demand manual trigger
**Layer:** Signal Ingestion
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Triggers Apify actors for web scraping tasks: LinkedIn profile enrichment, Google Maps business data, YouTube channel intelligence. Runs less frequently than other sources (24-hour cycle) due to higher cost and longer execution times. On-demand triggers available for priority accounts.

---

## Expected Behavior (Happy Path)

1. Triggered by Signal-Ingestion-Master (only if `last_sync_at` > 24 hours ago) or manual invocation.
2. Fetches active Apify configs from `signal_sources` (where `source_type = 'apify'`).
3. For each config, identifies the actor type and target list:
   - **LinkedIn Profile Scraper:** enriches contact profiles (job title changes, company changes)
   - **Google Maps Scraper:** business expansion signals (new locations, reviews)
   - **YouTube Channel Scraper:** content activity signals (new videos, subscriber growth)
4. Calls Apify API to start actor runs with the configured input.
5. Polls for actor completion (Apify runs are async, may take 1-10 minutes).
6. Fetches results from the Apify dataset.
7. For each result:
   a. Maps to existing account/contact by domain, LinkedIn URL, or business name.
   b. Classifies signal_type: `job_change`, `company_expansion`, `content_activity`.
   c. Generates `dedup_key` and inserts into `signals` table.
8. Returns summary to master workflow.

**Expected Duration:** 5-15 minutes (depends on actor run time and dataset size).

---

## Input/Output Data Shapes

**Input:**
- Apify config from `signal_sources`:
```json
{
  "source_type": "apify",
  "config": {
    "api_token": "encrypted_ref",
    "actors": [
      {
        "actor_id": "apify/linkedin-profile-scraper",
        "input": {
          "profileUrls": ["from_contacts_table"],
          "maxItems": 100
        }
      },
      {
        "actor_id": "apify/google-maps-scraper",
        "input": {
          "searchQueries": ["from_accounts_table"],
          "maxItems": 50
        }
      }
    ]
  }
}
```

**Output:**
- Row in `signals` table:
```json
{
  "account_id": "uuid",
  "signal_type": "job_change",
  "source": "apify",
  "signal_value": {
    "linkedin_url": "https://linkedin.com/in/contact-name",
    "previous_title": "VP Sales",
    "new_title": "CRO",
    "previous_company": "Old Corp",
    "new_company": "Target Corp",
    "change_detected_at": "2026-04-14"
  },
  "confidence_score": 90,
  "dedup_key": "job_change_abc123_2026-04-14"
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Apify actor timeout | Run status stuck in "RUNNING" for >15 min | Abort the run via Apify API. Check actor input size -- may be too large. Reduce `maxItems`. |
| Apify API 401 | Token invalid | Update API token in n8n credentials. Check Apify dashboard for account status. |
| Apify credits exhausted | Run fails with quota error | Alert Mamoun. Monthly budget is $1K. Prioritize LinkedIn scraper (highest value). Pause Google Maps/YouTube until next billing cycle. |
| LinkedIn rate limiting detected | Apify actor returns partial results with rate limit warnings | Reduce scraping frequency. LinkedIn aggressively rate-limits scrapers. Use residential proxies in Apify actor config. |
| Actor version deprecated | Apify returns "actor version not found" | Update the `actor_id` to the latest version in `signal_sources.config`. Check Apify marketplace for updated actors. |
| No match for scraped profiles | Scraped data doesn't map to existing contacts/accounts | Log unmatched results for manual review. May indicate stale contact data in SSE. |

---

## Monitoring

- **Where to check:** n8n execution logs, Apify dashboard (apify.com), Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Actor run success rate (target: >90%)
  - Results per run (varies by actor type)
  - Signals created per run (expect 5-50)
  - Apify credit consumption (track monthly against $1K budget)
  - Run duration (target: <10 min per actor)
- **Alert thresholds:**
  - Actor run failure 3+ times consecutively -> check actor config
  - Apify credits >70% consumed mid-month -> alert Mamoun
  - Run duration >20 min -> investigate input size

---

## Dependencies

- **APIs:** Apify API (https://api.apify.com/v2/)
- **Tables:**
  - `signals` (write: insert scraped signals)
  - `signal_sources` (read: Apify configs)
  - `individual_entities` / `contacts` view (read: get LinkedIn URLs for scraping)
  - `company_entities` / `accounts` view (read: get business names for Google Maps)
  - `circuit_breaker_state` (read/write: Apify CB)
- **Other workflows:** Called by Signal-Ingestion-Master. Triggers Scoring-Master on signal insert.
- **Circuit breakers:** `circuit_breaker_state` entry for `apify`.

---

## Manual Execution

```bash
# Trigger full Apify ingestion
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-apify \
  -H "Content-Type: application/json" \
  -d '{"manual": true}'

# Trigger specific actor only
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-apify \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "actor_type": "linkedin-profile-scraper"}'

# Trigger for specific contacts
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-apify \
  -H "Content-Type: application/json" \
  -d '{"manual": true, "actor_type": "linkedin-profile-scraper", "linkedin_urls": ["https://linkedin.com/in/target"]}'
```

---

## Cost Control

- Apify budget: $1K/month max. Track consumption weekly.
- Priority order when budget is tight: (1) LinkedIn Profile Scraper, (2) Google Maps, (3) YouTube.
- Run LinkedIn scrapers on-demand for hot/warm accounts only -- never continuous scraping.
- Google Maps scraping is useful for detecting business expansion (new office openings) in MENA.
- YouTube scraping lowest priority unless customer's ICP includes content creators.
