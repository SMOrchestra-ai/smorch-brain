# Error Handling Patterns

Every production n8n workflow needs error handling. Silent failures in signal pipelines mean lost leads, duplicate actions, or broken sequences. This reference covers the patterns that prevent those failures.

## Table of Contents
1. [Error Trigger Pattern (Mandatory)](#error-trigger-pattern)
2. [Retry Patterns](#retry-patterns)
3. [Idempotency Guards](#idempotency-guards)
4. [Data Validation](#data-validation)
5. [Rate Limit Handling](#rate-limit-handling)
6. [Dead Letter Queue](#dead-letter-queue)

---

## Error Trigger Pattern

**This is non-negotiable.** Every workflow gets an Error Trigger node connected to a Slack notification. The cost of adding it is 2 nodes. The cost of not adding it is missed failures that silently corrupt your pipeline for days before anyone notices.

### Standard Error Handler

```json
{
  "nodes": [
    {
      "parameters": {},
      "name": "Error Trigger",
      "type": "n8n-nodes-base.errorTrigger",
      "typeVersion": 1,
      "position": [250, 600]
    },
    {
      "parameters": {
        "functionCode": "const error = $input.first().json;\nconst errorInfo = {\n  workflow_name: error.workflow?.name || 'Unknown',\n  workflow_id: error.workflow?.id || 'Unknown',\n  node_name: error.execution?.lastNodeExecuted || 'Unknown',\n  error_message: error.execution?.error?.message || 'No error message',\n  error_type: error.execution?.error?.name || 'Unknown',\n  timestamp: new Date().toISOString(),\n  execution_id: error.execution?.id || 'Unknown',\n  execution_url: error.execution?.url || ''\n};\nreturn [{ json: errorInfo }];"
      },
      "name": "Format - Error Details",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [450, 600]
    },
    {
      "parameters": {
        "resource": "message",
        "operation": "post",
        "channel": {
          "__rl": true,
          "value": "#n8n-errors",
          "mode": "name"
        },
        "text": "={{ '⚠️ *Workflow Error*\\n\\n*Workflow:* ' + $json.workflow_name + '\\n*Node:* ' + $json.node_name + '\\n*Error:* ' + $json.error_message + '\\n*Time:* ' + $json.timestamp + '\\n*Execution:* ' + $json.execution_url }}",
        "otherOptions": {}
      },
      "name": "Alert - Error to Slack",
      "type": "n8n-nodes-base.slack",
      "typeVersion": 2.2,
      "position": [650, 600],
      "credentials": {
        "slackApi": {
          "id": "CREDENTIAL_ID_PLACEHOLDER",
          "name": "Slack API"
        }
      }
    }
  ],
  "connections": {
    "Error Trigger": {
      "main": [
        [{ "node": "Format - Error Details", "type": "main", "index": 0 }]
      ]
    },
    "Format - Error Details": {
      "main": [
        [{ "node": "Alert - Error to Slack", "type": "main", "index": 0 }]
      ]
    }
  }
}
```

### Enhanced Error Handler (with Google Sheet Logging)

For workflows where you need an error audit trail (high-volume signal processing):

Add a Google Sheets append after the Slack alert:
```json
{
  "name": "Log - Error to Sheet",
  "type": "n8n-nodes-base.googleSheets",
  "parameters": {
    "operation": "append",
    "sheetId": { "value": "ERROR_LOG_SHEET_ID", "mode": "id" },
    "sheetName": { "value": "errors", "mode": "name" },
    "columns": {
      "workflow": "={{ $json.workflow_name }}",
      "node": "={{ $json.node_name }}",
      "error": "={{ $json.error_message }}",
      "timestamp": "={{ $json.timestamp }}",
      "execution_id": "={{ $json.execution_id }}",
      "resolved": "FALSE"
    }
  }
}
```

---

## Retry Patterns

### Simple Retry (Node-Level)
n8n supports built-in retry on individual nodes. Use for transient errors (network timeouts, temporary 500s).

Set in node settings:
```json
{
  "retryOnFail": true,
  "maxTries": 3,
  "waitBetweenTries": 2000
}
```

Best for: HTTP Request nodes calling external APIs (GHL, Instantly, Clay)

### Exponential Backoff Pattern
For APIs that return 429 (rate limit) — retry with increasing delays.

```javascript
// Function node — calculate retry delay
const attempt = $json.retry_attempt || 0;
const maxAttempts = 5;
const baseDelay = 2; // seconds

if (attempt >= maxAttempts) {
  // Give up — route to error handler
  return [{ json: { ...item.json, retry_exhausted: true } }];
}

const delay = baseDelay * Math.pow(2, attempt); // 2, 4, 8, 16, 32 seconds
return [{ json: { ...item.json, retry_attempt: attempt + 1, retry_delay: delay } }];
```

Follow this Function node with a Wait node using `={{ $json.retry_delay }}` seconds, then loop back to the HTTP Request node.

---

## Idempotency Guards

Webhook events are frequently duplicated. Platform retries, network issues, and user actions can send the same event multiple times. Without idempotency guards, your workflow will create duplicate contacts, send duplicate messages, and tag contacts multiple times.

### GHL Tag Check
Before adding a tag, check if contact already has it:

```javascript
// Function node — check existing tags
const existingTags = $json.ghl_contact?.tags || [];
const newTag = 'hot-lead';
const alreadyTagged = existingTags.includes(newTag);
return [{ json: { ...item.json, already_tagged: alreadyTagged } }];
```

→ IF node: `already_tagged === false` → proceed with tag

### Instantly Campaign Check
Before enrolling a lead, check if they're already in the campaign:

```javascript
// After calling Instantly's lead/get endpoint
const leadExists = $json.status === 200 && $json.data?.email;
return [{ json: { ...item.json, already_in_campaign: !!leadExists } }];
```

→ IF node: `already_in_campaign === false` → proceed with enrollment

### Deduplication by Event ID
If the webhook payload includes an event ID, store processed IDs and skip duplicates:

```javascript
// Function node — check if event already processed
// Uses workflow static data (persists across executions)
const eventId = $json.event_id || $json.id;
if (!eventId) return [{ json: { ...item.json, is_duplicate: false } }];

const staticData = $getWorkflowStaticData('global');
const processedEvents = staticData.processedEvents || [];

if (processedEvents.includes(eventId)) {
  return [{ json: { ...item.json, is_duplicate: true } }];
}

// Add to processed list (keep last 1000 to prevent memory bloat)
processedEvents.push(eventId);
if (processedEvents.length > 1000) processedEvents.shift();
staticData.processedEvents = processedEvents;

return [{ json: { ...item.json, is_duplicate: false } }];
```

→ IF node: `is_duplicate === false` → proceed

---

## Data Validation

### Required Fields Check
Before processing, validate that required fields exist:

```javascript
// Function node — validate required fields
const required = ['contact_email', 'signal_type', 'source_platform'];
const missing = required.filter(field => !$json[field] || $json[field] === '');

if (missing.length > 0) {
  return [{
    json: {
      ...item.json,
      validation_passed: false,
      validation_error: `Missing required fields: ${missing.join(', ')}`
    }
  }];
}

// Email format check
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
if (!emailRegex.test($json.contact_email)) {
  return [{
    json: {
      ...item.json,
      validation_passed: false,
      validation_error: `Invalid email format: ${$json.contact_email}`
    }
  }];
}

return [{ json: { ...item.json, validation_passed: true } }];
```

→ IF node: `validation_passed === true` → proceed, ELSE → log invalid data + skip

### Signal Age Validation
Enforce the 90-day signal freshness rule:

```javascript
// Function node — check signal age
const signalDate = new Date($json.timestamp);
const now = new Date();
const daysSince = Math.floor((now - signalDate) / (1000 * 60 * 60 * 24));
const isStale = daysSince > 90;

return [{
  json: {
    ...item.json,
    signal_age_days: daysSince,
    is_stale: isStale
  }
}];
```

→ IF node: `is_stale === false` → proceed, ELSE → NoOp (skip stale signals)

---

## Rate Limit Handling

### Batch Processing Pattern
For any operation touching >20 items:

```
SplitInBatches (batchSize: 10)
  → Process batch (HTTP Request / API call)
  → Wait (2 seconds)
  → Loop back to SplitInBatches
```

**GHL specifics:** 100 req/min = ~1.6 req/sec → batch of 10 + 7s wait
**Instantly specifics:** 10 req/sec → batch of 10 + 2s wait
**HeyReach specifics:** 5 req/sec → batch of 5 + 2s wait

### Throttle Pattern for High-Volume Webhooks
If your webhook receives >100 events/minute, add a queue:

```
Webhook → Google Sheets (append to queue) → End
Schedule Trigger (every 5 min) → Read Sheet (next 50 rows) → Process → Mark as processed
```

This decouples ingestion from processing, preventing rate limit cascades.

---

## Dead Letter Queue

For critical workflows where losing data is unacceptable (signal scoring, lead enrollment):

### Pattern
When a node fails after all retries:
1. Capture the failed item's data
2. Write to a "dead_letter" Google Sheet with the error details
3. Send Slack alert with count of items in dead letter queue
4. A scheduled workflow processes the dead letter queue daily (retry or manual review)

```javascript
// Function node — prepare dead letter entry
return [{
  json: {
    original_data: JSON.stringify($json),
    error_node: $json._error_node || 'unknown',
    error_message: $json._error_message || 'unknown',
    timestamp: new Date().toISOString(),
    retry_count: 0,
    status: 'pending_review'
  }
}];
```

### Dead Letter Processor (Separate Workflow)
```
Schedule (daily 8 AM) → Read dead_letter sheet (status=pending_review)
  → For each: attempt reprocess
  → IF success → update status to "resolved"
  → IF fail again → update retry_count, alert if retry_count > 3
```
