# n8n Node Patterns Reference

Common node configurations and JSON snippets for the SMOrchestra stack. Copy these into workflows and modify parameters as needed.

## Table of Contents
1. [Triggers](#triggers)
2. [Data Transformation](#data-transformation)
3. [Flow Control](#flow-control)
4. [HTTP Requests](#http-requests)
5. [Notifications](#notifications)
6. [Utilities](#utilities)

---

## Triggers

### Webhook Trigger (Production)
Receives incoming HTTP requests. Used for signal capture from platforms.

```json
{
  "parameters": {
    "path": "signal-intake",
    "responseMode": "onReceived",
    "options": {
      "rawBody": false
    }
  },
  "name": "Webhook - Signal Intake",
  "type": "n8n-nodes-base.webhook",
  "typeVersion": 2,
  "position": [250, 300]
}
```

**Key settings:**
- `responseMode: "onReceived"` → responds immediately (webhook source doesn't time out)
- `responseMode: "lastNode"` → responds with workflow output (use for sync APIs)
- `path` → becomes part of the webhook URL: `https://your-n8n.com/webhook/signal-intake`

### Schedule Trigger (Cron)
For recurring tasks like daily reports or periodic data pulls.

```json
{
  "parameters": {
    "rule": {
      "interval": [
        {
          "field": "cronExpression",
          "expression": "0 9 * * 1-5"
        }
      ]
    }
  },
  "name": "Schedule - Daily 9AM Weekdays",
  "type": "n8n-nodes-base.scheduleTrigger",
  "typeVersion": 1.2,
  "position": [250, 300]
}
```

**Common cron expressions:**
- `0 9 * * 1-5` → 9 AM weekdays (UAE time, set in n8n settings)
- `0 */4 * * *` → every 4 hours
- `0 8 * * 1` → Monday 8 AM (weekly report)
- `0 0 1 * *` → first of month midnight

### Error Trigger
Catches errors from any node in the workflow. Every production workflow needs this.

```json
{
  "parameters": {},
  "name": "Error Trigger",
  "type": "n8n-nodes-base.errorTrigger",
  "typeVersion": 1,
  "position": [250, 600]
}
```

---

## Data Transformation

### Function Node (Data Normalization)
Transforms raw platform data into standard signal schema.

```json
{
  "parameters": {
    "functionCode": "const items = $input.all();\nconst results = [];\n\nfor (const item of items) {\n  const data = item.json;\n  results.push({\n    json: {\n      signal_type: data.event_type || 'unknown',\n      source_platform: 'instantly',\n      contact_email: data.email || data.lead_email || '',\n      contact_name: data.name || data.first_name || '',\n      company: data.company_name || '',\n      signal_strength: calculateStrength(data),\n      timestamp: new Date().toISOString(),\n      metadata: {\n        campaign_id: data.campaign_id,\n        raw_event: data.event_type\n      }\n    }\n  });\n}\n\nfunction calculateStrength(data) {\n  if (data.event_type === 'reply') return 9;\n  if (data.event_type === 'link_click') return 7;\n  if (data.event_type === 'email_open') return 4;\n  return 3;\n}\n\nreturn results;"
  },
  "name": "Normalize - Signal Schema",
  "type": "n8n-nodes-base.function",
  "typeVersion": 1,
  "position": [450, 300]
}
```

### Set Node (Clean Data)
Extract specific fields for downstream processing. Use this between stages to prevent raw API response leakage.

```json
{
  "parameters": {
    "mode": "manual",
    "duplicateItem": false,
    "assignments": {
      "assignments": [
        {
          "id": "email",
          "name": "email",
          "value": "={{ $json.contact_email }}",
          "type": "string"
        },
        {
          "id": "score",
          "name": "score",
          "value": "={{ $json.signal_strength }}",
          "type": "number"
        },
        {
          "id": "source",
          "name": "source",
          "value": "={{ $json.source_platform }}",
          "type": "string"
        }
      ]
    },
    "options": {
      "includeBinary": false
    }
  },
  "name": "Set - Clean for Routing",
  "type": "n8n-nodes-base.set",
  "typeVersion": 3.4,
  "position": [650, 300]
}
```

### Function Node (Scoring Logic)
Applies weighted scoring. Weights can be hardcoded or pulled from a Google Sheet for runtime configurability.

```json
{
  "parameters": {
    "functionCode": "const items = $input.all();\nconst results = [];\n\n// Scoring weights — move to Google Sheet for runtime config\nconst weights = {\n  reply: 10,\n  link_click: 7,\n  form_submit: 8,\n  email_open: 3,\n  linkedin_view: 4,\n  website_visit: 5\n};\n\n// Recency decay: signals lose 1 point per 7 days\nconst DECAY_DAYS = 7;\n\nfor (const item of items) {\n  const d = item.json;\n  const baseScore = weights[d.signal_type] || 3;\n  const daysSince = Math.floor((Date.now() - new Date(d.timestamp).getTime()) / (1000*60*60*24));\n  const decay = Math.floor(daysSince / DECAY_DAYS);\n  const finalScore = Math.max(1, baseScore - decay);\n  \n  results.push({\n    json: {\n      ...d,\n      base_score: baseScore,\n      recency_decay: decay,\n      final_score: finalScore,\n      tier: finalScore >= 8 ? 'hot' : finalScore >= 5 ? 'warm' : 'cold'\n    }\n  });\n}\n\nreturn results;"
  },
  "name": "Score - Apply Weights",
  "type": "n8n-nodes-base.function",
  "typeVersion": 1,
  "position": [650, 300]
}
```

---

## Flow Control

### IF Node (Score Threshold)
Route based on conditions. Most common: score threshold routing.

```json
{
  "parameters": {
    "conditions": {
      "options": {
        "caseSensitive": true,
        "leftValue": "",
        "typeValidation": "strict"
      },
      "conditions": [
        {
          "id": "hot-check",
          "leftValue": "={{ $json.final_score }}",
          "rightValue": 7,
          "operator": {
            "type": "number",
            "operation": "gte"
          }
        }
      ],
      "combinator": "and"
    },
    "options": {}
  },
  "name": "Route - Hot Lead Check",
  "type": "n8n-nodes-base.if",
  "typeVersion": 2,
  "position": [850, 300]
}
```

### Switch Node (Multi-Path Routing)
For routing to multiple destinations based on tier or signal type.

```json
{
  "parameters": {
    "dataType": "string",
    "value1": "={{ $json.tier }}",
    "rules": {
      "rules": [
        {
          "value2": "hot",
          "output": 0
        },
        {
          "value2": "warm",
          "output": 1
        },
        {
          "value2": "cold",
          "output": 2
        }
      ]
    },
    "fallbackOutput": 2
  },
  "name": "Route - By Tier",
  "type": "n8n-nodes-base.switch",
  "typeVersion": 3,
  "position": [850, 300]
}
```

### SplitInBatches
Process large datasets without hitting rate limits. Pair with a Wait node.

```json
{
  "parameters": {
    "batchSize": 10,
    "options": {}
  },
  "name": "Batch - Process 10 at a Time",
  "type": "n8n-nodes-base.splitInBatches",
  "typeVersion": 3,
  "position": [450, 300]
}
```

### Wait Node (Rate Limit Buffer)
Add between batch iterations to respect API rate limits.

```json
{
  "parameters": {
    "amount": 2,
    "unit": "seconds"
  },
  "name": "Wait - 2s Rate Limit",
  "type": "n8n-nodes-base.wait",
  "typeVersion": 1.1,
  "position": [850, 300]
}
```

### Merge Node
Combine data from parallel branches.

```json
{
  "parameters": {
    "mode": "combine",
    "mergeByFields": {
      "values": [
        {
          "field1": "email",
          "field2": "email"
        }
      ]
    },
    "options": {}
  },
  "name": "Merge - Combine Enriched Data",
  "type": "n8n-nodes-base.merge",
  "typeVersion": 3,
  "position": [1050, 300]
}
```

---

## HTTP Requests

### Generic HTTP Request (GET)
For APIs without native n8n nodes.

```json
{
  "parameters": {
    "method": "GET",
    "url": "https://api.example.com/v1/contacts",
    "authentication": "genericCredentialType",
    "genericAuthType": "httpHeaderAuth",
    "sendHeaders": true,
    "headerParameters": {
      "parameters": [
        {
          "name": "Content-Type",
          "value": "application/json"
        }
      ]
    },
    "options": {
      "response": {
        "response": {
          "responseFormat": "json"
        }
      },
      "timeout": 30000
    }
  },
  "name": "API - Fetch Contacts",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [450, 300],
  "credentials": {
    "httpHeaderAuth": {
      "id": "CREDENTIAL_ID_PLACEHOLDER",
      "name": "API Auth - ServiceName"
    }
  }
}
```

### HTTP Request (POST with Body)

```json
{
  "parameters": {
    "method": "POST",
    "url": "https://api.example.com/v1/contacts",
    "authentication": "genericCredentialType",
    "genericAuthType": "httpHeaderAuth",
    "sendBody": true,
    "specifyBody": "json",
    "jsonBody": "={{ JSON.stringify({ email: $json.contact_email, tags: [$json.tier], custom_fields: { signal_type: $json.signal_type, signal_score: $json.final_score } }) }}",
    "options": {
      "timeout": 30000
    }
  },
  "name": "API - Create Contact",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [650, 300],
  "credentials": {
    "httpHeaderAuth": {
      "id": "CREDENTIAL_ID_PLACEHOLDER",
      "name": "API Auth - ServiceName"
    }
  }
}
```

---

## Notifications

### Slack Message
Standard notification pattern. Used in error handlers and hot lead alerts.

```json
{
  "parameters": {
    "resource": "message",
    "operation": "post",
    "channel": {
      "__rl": true,
      "value": "#sales-alerts",
      "mode": "name"
    },
    "text": "={{ '🔥 Hot Lead Alert\\n\\nContact: ' + $json.contact_name + ' (' + $json.contact_email + ')\\nCompany: ' + $json.company + '\\nSignal: ' + $json.signal_type + '\\nScore: ' + $json.final_score + '/10\\nSource: ' + $json.source_platform }}",
    "otherOptions": {}
  },
  "name": "Notify - Slack Hot Lead",
  "type": "n8n-nodes-base.slack",
  "typeVersion": 2.2,
  "position": [1050, 200],
  "credentials": {
    "slackApi": {
      "id": "CREDENTIAL_ID_PLACEHOLDER",
      "name": "Slack API"
    }
  }
}
```

### Slack Error Alert
Used in error handler branch. Always include workflow name, node name, and error message.

```json
{
  "parameters": {
    "resource": "message",
    "operation": "post",
    "channel": {
      "__rl": true,
      "value": "#n8n-errors",
      "mode": "name"
    },
    "text": "={{ '⚠️ Workflow Error\\n\\nWorkflow: ' + $json.workflow.name + '\\nNode: ' + $json.execution.lastNodeExecuted + '\\nError: ' + $json.execution.error.message + '\\nTime: ' + new Date().toISOString() }}",
    "otherOptions": {}
  },
  "name": "Alert - Error to Slack",
  "type": "n8n-nodes-base.slack",
  "typeVersion": 2.2,
  "position": [450, 600],
  "credentials": {
    "slackApi": {
      "id": "CREDENTIAL_ID_PLACEHOLDER",
      "name": "Slack API"
    }
  }
}
```

---

## Utilities

### Google Sheets (Read Config)
Pull configuration data (scoring weights, routing rules) from a Google Sheet for runtime changes without editing the workflow.

```json
{
  "parameters": {
    "operation": "read",
    "sheetId": {
      "__rl": true,
      "value": "SHEET_ID_PLACEHOLDER",
      "mode": "id"
    },
    "sheetName": {
      "__rl": true,
      "value": "scoring_weights",
      "mode": "name"
    },
    "options": {}
  },
  "name": "Config - Read Scoring Weights",
  "type": "n8n-nodes-base.googleSheets",
  "typeVersion": 4.5,
  "position": [450, 300],
  "credentials": {
    "googleSheetsOAuth2Api": {
      "id": "CREDENTIAL_ID_PLACEHOLDER",
      "name": "Google Sheets"
    }
  }
}
```

### Execute Sub-Workflow
Call another workflow for modular design.

```json
{
  "parameters": {
    "source": "database",
    "workflowId": "WORKFLOW_ID_PLACEHOLDER",
    "options": {}
  },
  "name": "Sub - Enrich Contact",
  "type": "n8n-nodes-base.executeWorkflow",
  "typeVersion": 1,
  "position": [650, 300]
}
```

### No Operation (NoOp)
Explicit dead-end for branches where no action is needed. Better than leaving connections dangling — makes the workflow's intent clear.

```json
{
  "parameters": {},
  "name": "NoOp - Cold Lead (No Action)",
  "type": "n8n-nodes-base.noOp",
  "typeVersion": 1,
  "position": [1050, 500]
}
```

---

## Connection Pattern

Connections in n8n JSON use this structure:

```json
{
  "connections": {
    "Webhook - Signal Intake": {
      "main": [
        [
          {
            "node": "Normalize - Signal Schema",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Route - Hot Lead Check": {
      "main": [
        [
          {
            "node": "Notify - Slack Hot Lead",
            "type": "main",
            "index": 0
          }
        ],
        [
          {
            "node": "NoOp - Not Hot (Continue)",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  }
}
```

- `main[0]` = true/first output of IF/Switch
- `main[1]` = false/second output
- Multiple nodes in one array = parallel execution from that output

## Position Guidelines

Lay out nodes in a readable left-to-right flow:
- X-axis: increment by 200 per step
- Y-axis: parallel branches offset by 200
- Error handler branch: Y offset of +300 from main flow
- Start position: [250, 300]
