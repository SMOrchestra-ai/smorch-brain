# Runbook: Signal-Ingest-Clay

**Workflow ID:** TBD -- assign on n8n
**Trigger:** Triggered by Signal-Ingestion-Master / manual execution
**Layer:** Signal Ingestion
**Owner:** al-Jazari (Architecture)
**Escalation:** Mamoun Alamouri (Product)

---

## Purpose

Polls the Clay API for enrichment data (technographics, company growth indicators, employee count changes) and stores results as signals in the `signals` table. Clay is a primary source for firmographic and technographic intelligence.

---

## Expected Behavior (Happy Path)

1. Receives trigger from Signal-Ingestion-Master (or manual invocation).
2. Fetches all active Clay signal source configs from `signal_sources` table (where `source_type = 'clay'` and `is_active = true`).
3. For each config, extracts the Clay table ID and API key from `config` jsonb field.
4. Calls Clay API (`GET /v1/tables/{table_id}/rows`) to fetch enriched company data since last sync.
5. For each row returned:
   a. Maps company domain to an existing `accounts` record (via domain match).
   b. Generates `dedup_key` = `{signal_type}_{account_id}_{date}`.
   c. Inserts into `signals` table with:
      - `signal_type`: `technographics` or `company_growth` (based on Clay column mapping)
      - `source`: `clay`
      - `signal_value`: jsonb containing the enriched data fields
      - `confidence_score`: derived from Clay's data completeness (0-100)
6. Skips rows that match an existing `dedup_key` (no duplicates within same day).
7. Returns summary to master workflow: `{ signals_created: N, accounts_matched: N, accounts_unmatched: N }`.

**Expected Duration:** 1-3 minutes per Clay table.

---

## Input/Output Data Shapes

**Input:**
```json
{
  "source_type": "clay",
  "customer_id": "uuid",
  "config": {
    "clay_table_id": "tbl_xxx",
    "api_key": "encrypted_ref",
    "column_mapping": {
      "domain": "Company Domain",
      "tech_stack": "Technologies Used",
      "employee_count": "Headcount",
      "revenue": "Estimated Revenue"
    }
  }
}
```

**Output:**
- New rows in `signals` table:
```json
{
  "account_id": "uuid",
  "signal_type": "technographics",
  "source": "clay",
  "signal_value": {
    "tech_stack": ["Salesforce", "HubSpot", "Slack"],
    "employee_count": 250,
    "revenue_estimate": "$10M-$50M",
    "industry": "SaaS"
  },
  "confidence_score": 85,
  "dedup_key": "technographics_abc123_2026-04-14"
}
```

---

## Failure Modes & Recovery

| Failure | Symptom | Recovery |
|---------|---------|----------|
| Clay API 401 Unauthorized | HTTP 401 in execution log | API key expired or rotated. Update the credential in n8n credential store. Check Clay dashboard for key status. |
| Clay API 429 Rate Limited | HTTP 429, retry-after header | Respect the retry-after value. Clay allows ~100 requests/min. Reduce batch size or add delays between requests. |
| Clay API 500/502/503 | HTTP 5xx errors | Transient. Retry logic should handle (3x exponential backoff: 2s, 4s, 8s). If persistent >30 min, check Clay status page. |
| No accounts match Clay domains | `accounts_unmatched` count is high | Companies in Clay may not exist in SSE yet. Log unmatched domains for review. May need to import new accounts first. |
| Clay credits exhausted | API returns credit limit error | Check Clay dashboard. Alert Mamoun -- budget cap is $2K/month for Clay+Clearbit combined. |
| Dedup key collision | Postgres unique constraint error | Expected for same-day re-runs. The ON CONFLICT DO NOTHING clause handles this silently. |
| Circuit breaker open for Clay | `circuit_breaker_state` shows state=open for clay | Wait for cooldown period. Check if Clay API is actually down. If recovered, manually reset: `UPDATE circuit_breaker_state SET state='closed', failure_count=0 WHERE api_name='clay';` |

---

## Monitoring

- **Where to check:** n8n execution logs, Sentry, Slack #sse-v3-alerts
- **Key metrics:**
  - Signals created per run (expect 10-100 per Clay table)
  - Account match rate (target: >80% of Clay rows match existing accounts)
  - API response time (target: <5s per request)
  - Clay credit consumption (track monthly)
- **Alert thresholds:**
  - 0 signals created for 3+ consecutive runs -> investigate Clay config
  - Account match rate <50% -> review account data completeness
  - Clay credits >80% of monthly budget -> alert Mamoun

---

## Dependencies

- **APIs:** Clay API (https://api.clay.com/v1/)
- **Tables:**
  - `signal_sources` (read: fetch Clay configs)
  - `signals` (write: insert new signals)
  - `company_entities` / `accounts` view (read: match domains to accounts)
  - `circuit_breaker_state` (read/write: check and update Clay CB)
- **Other workflows:** Called by Signal-Ingestion-Master
- **Circuit breakers:** `circuit_breaker_state` entry for `clay` API. Opens after 5 consecutive failures, 1-hour cooldown.

---

## Manual Execution

```bash
# Trigger manually for a specific customer
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-clay \
  -H "Content-Type: application/json" \
  -d '{"customer_id": "uuid-here", "manual": true}'

# Trigger for all customers
curl -X POST https://testflow.smorchestra.ai:5170/webhook/signal-ingest-clay \
  -H "Content-Type: application/json" \
  -d '{"manual": true}'
```

---

## Cost Notes

- Clay API credits: ~0.5 credit per enrichment query (SSE credit system).
- Budget cap: $2K/month combined Clay + Clearbit.
- Only enrich accounts with recent activity or hot/warm intent scores to control costs.
- Track credit consumption in `audit_log` with action = `clay_enrichment`.
