# n8n API & MCP Reference

Accurate reference for n8n REST API, MCP tools, and workflow JSON structure. Sourced from official n8n documentation and community-validated patterns.

## Table of Contents
1. [REST API Authentication](#rest-api-authentication)
2. [REST API Endpoints](#rest-api-endpoints)
3. [MCP Tool Reference](#mcp-tool-reference)
4. [Workflow JSON Structure](#workflow-json-structure)
5. [Core Node Type Registry](#core-node-type-registry)
6. [Built-in Code Variables](#built-in-code-variables)

---

## REST API Authentication

n8n uses API keys passed via the `X-N8N-API-KEY` header.

**Generate a key:** n8n Settings → API → Create API Key

**Example request:**
```bash
# Self-hosted instance
curl -X 'GET' \
  'https://ai.mamounalamouri.smorchestra.com/api/v1/workflows?active=true' \
  -H 'accept: application/json' \
  -H 'X-N8N-API-KEY: <your-api-key>'
```

**Key points:**
- Header name is exactly `X-N8N-API-KEY` (case-sensitive)
- Enterprise instances support scoped keys (limit which resources/actions a key can access)
- API is not available during free trial on n8n Cloud
- For self-hosted: base URL is `<N8N_HOST>:<N8N_PORT>/api/v1/`

---

## REST API Endpoints

### Workflows

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/workflows` | List all workflows. Query params: `active=true/false`, `limit`, `cursor` |
| POST | `/api/v1/workflows` | Create a new workflow. Body: workflow JSON |
| GET | `/api/v1/workflows/{id}` | Get a specific workflow by ID |
| PUT | `/api/v1/workflows/{id}` | Update a workflow |
| DELETE | `/api/v1/workflows/{id}` | Delete a workflow |
| POST | `/api/v1/workflows/{id}/activate` | Activate a workflow |
| POST | `/api/v1/workflows/{id}/deactivate` | Deactivate a workflow |

### Executions

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/executions` | List executions. Query params: `workflowId`, `status`, `limit` |
| GET | `/api/v1/executions/{id}` | Get execution details |
| DELETE | `/api/v1/executions/{id}` | Delete an execution |

### Tags

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/tags` | List all tags |
| POST | `/api/v1/tags` | Create a tag |
| PUT | `/api/v1/tags/{id}` | Update a tag |
| DELETE | `/api/v1/tags/{id}` | Delete a tag |

### Create Workflow Request Body
```json
{
  "name": "Workflow Name",
  "nodes": [...],
  "connections": {...},
  "settings": {
    "executionOrder": "v1",
    "saveManualExecutions": true,
    "saveDataErrorExecution": "all",
    "saveDataSuccessExecution": "all",
    "timezone": "Asia/Dubai"
  }
}
```

**Critical:** The `connections` object must be keyed by source node **name** (not ID). An empty workflow with no connections should have `"connections": {}`.

---

## MCP Tool Reference

Mamoun's n8n instance uses MCP for direct workflow management from Claude. The following tool names may vary depending on which MCP server is installed (there are several popular ones).

### Common MCP Tool Names

**From `czlonkowski/n8n-mcp` (most comprehensive, 525+ node documentation):**
- `n8n_create_workflow` — Create a new workflow
- `n8n_get_workflow` — Get workflow by ID
- `n8n_get_workflow_details` — Get detailed workflow info
- `n8n_get_workflow_structure` — Get workflow structure
- `n8n_update_full_workflow` — Full workflow update
- `n8n_update_partial_workflow` — Partial update
- `n8n_delete_workflow` — Delete workflow
- `n8n_list_workflows` — List all workflows
- `n8n_validate_workflow` — Validate workflow JSON before deploy
- `n8n_trigger_webhook_workflow` — Trigger via webhook
- `n8n_get_execution` — Get execution details
- `n8n_list_executions` — List executions
- `list_nodes` — List available node types
- `get_node_info` — Get node configuration details
- `search_nodes` — Search for nodes by keyword
- `validate_workflow` — Pre-deploy validation
- `validate_workflow_connections` — Check connection integrity
- `validate_workflow_expressions` — Check expression syntax
- `get_templates_for_task` — Get workflow templates

**From `leonardsellem/n8n-mcp-server`:**
- `workflow_list`, `workflow_get`, `workflow_create`, `workflow_update`
- `workflow_delete`, `workflow_activate`, `workflow_deactivate`
- `execution_run`, `execution_get`, `execution_list`
- `run_webhook` — Execute via webhook with Basic Auth

**From `ry-ops/n8n-mcp-server`:**
- `list_workflows`, `get_workflow`, `create_workflow`, `update_workflow`
- `delete_workflow`, `activate_workflow`, `deactivate_workflow`
- `execute_workflow`, `list_executions`, `get_execution`

### MCP Environment Variables
```
N8N_HOST=https://ai.mamounalamouri.smorchestra.com/api/v1
N8N_API_KEY=<your-api-key>
```

### Using MCP Tools in Workflows

When MCP tools are available, prefer them over generating JSON for manual import:

1. **Before creating:** Use `list_available_nodes` or `list_nodes` to verify node types exist
2. **Create:** Use `n8n_create_workflow` or `create_workflow` with the full JSON body
3. **Validate:** Use `validate_workflow` to check before deploying
4. **Activate:** Use `activate_workflow` after successful creation
5. **Debug:** Use `list_executions` + `get_execution` to analyze failures

---

## Workflow JSON Structure

### Top-Level Fields

```json
{
  "name": "string (required)",
  "nodes": "array (required) — list of node objects",
  "connections": "object (required) — node connection map",
  "settings": "object — workflow settings",
  "active": "boolean — whether workflow is active",
  "tags": "array — workflow tags",
  "pinData": "object — pinned test data",
  "staticData": "object — persistent data across executions"
}
```

### Node Object Structure

```json
{
  "id": "string (UUID) — unique node identifier",
  "name": "string (required) — display name, MUST be unique within workflow",
  "type": "string (required) — node type identifier (e.g., n8n-nodes-base.webhook)",
  "typeVersion": "number (required) — version of node type",
  "position": "[x, y] array (required) — canvas position in pixels",
  "parameters": "object (required) — node-specific configuration",
  "credentials": "object — credential references",
  "disabled": "boolean — whether node is disabled",
  "notesInFlow": "boolean — show notes on canvas",
  "notes": "string — node notes",
  "webhookId": "string — for webhook nodes"
}
```

**Important notes on node IDs:**
- The `id` field should be a UUID (e.g., `0f5532f9-36ba-4bef-86c7-30d607400b15`)
- If omitted, n8n generates one on import
- Node `name` must be unique within the workflow — this is what connections reference

### Connections Object Structure

Connections are keyed by **source node name**. Each source maps to output type (`main`), which contains an array of arrays. Each inner array contains connection targets for that output index.

```json
{
  "connections": {
    "Source Node Name": {
      "main": [
        [
          {
            "node": "Target Node Name",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "IF Node Name": {
      "main": [
        [{"node": "True Branch Node", "type": "main", "index": 0}],
        [{"node": "False Branch Node", "type": "main", "index": 0}]
      ]
    }
  }
}
```

**Connection rules:**
- `main[0]` = first output (TRUE for IF, first case for Switch)
- `main[1]` = second output (FALSE for IF, second case for Switch)
- Multiple objects in one inner array = parallel connections from that output
- A node with no connections FROM it simply has no entry in the connections object
- **Never create connection entries for nodes that have no outputs** (trigger-only, NoOp)
- **Single-node workflows:** Use `"connections": {}` (empty object, not an array)

### Settings Object

```json
{
  "settings": {
    "executionOrder": "v1",
    "saveManualExecutions": true,
    "saveDataErrorExecution": "all",
    "saveDataSuccessExecution": "all",
    "executionTimeout": 3600,
    "timezone": "Asia/Dubai",
    "errorWorkflow": "ERROR_WORKFLOW_ID",
    "callerPolicy": "workflowsFromSameOwner"
  }
}
```

- `executionOrder: "v1"` — always include this for modern n8n
- `timezone: "Asia/Dubai"` — Mamoun's default timezone
- `errorWorkflow` — ID of a dedicated error-handling workflow (optional)
- `callerPolicy` — who can call this as a sub-workflow

### Credential References

Credentials are never stored in workflow JSON. Only references:
```json
{
  "credentials": {
    "slackApi": {
      "id": "CREDENTIAL_ID",
      "name": "Slack API"
    }
  }
}
```

The `id` must match an existing credential in the n8n instance. When generating workflows, use placeholder IDs and document which credentials need mapping.

---

## Core Node Type Registry

Exact type identifiers for commonly used nodes:

### Triggers
| Display Name | Type | Notes |
|-------------|------|-------|
| Webhook | `n8n-nodes-base.webhook` | HTTP endpoint trigger |
| Schedule Trigger | `n8n-nodes-base.scheduleTrigger` | Cron/interval trigger |
| Error Trigger | `n8n-nodes-base.errorTrigger` | Catches workflow errors |
| Manual Trigger | `n8n-nodes-base.manualTrigger` | Manual execution |
| Email Trigger (IMAP) | `n8n-nodes-base.emailReadImap` | Email inbox monitor |
| Chat Trigger | `n8n-nodes-langchain.chatTrigger` | Chat/AI trigger |
| MCP Server Trigger | `n8n-nodes-langchain.mcpTrigger` | MCP server endpoint |

### Data Transformation
| Display Name | Type | Notes |
|-------------|------|-------|
| Edit Fields (Set) | `n8n-nodes-base.set` | Set/modify fields |
| Code | `n8n-nodes-base.code` | JavaScript/Python execution |
| Function | `n8n-nodes-base.function` | Legacy JS function (still works, more debuggable) |
| Aggregate | `n8n-nodes-base.aggregate` | Aggregate multiple items |
| Convert to File | `n8n-nodes-base.convertToFile` | Data to file conversion |
| Date & Time | `n8n-nodes-base.dateTime` | Date manipulation |
| Crypto | `n8n-nodes-base.crypto` | Hash/encrypt operations |
| AI Transform | `n8n-nodes-base.aiTransform` | AI-based data transform |
| Filter | `n8n-nodes-base.filter` | Filter items by condition |
| Compare Datasets | `n8n-nodes-base.compareDatasets` | Compare two data sets |

### Flow Control
| Display Name | Type | Notes |
|-------------|------|-------|
| IF | `n8n-nodes-base.if` | Conditional branching (2 outputs) |
| Switch | `n8n-nodes-base.switch` | Multi-path routing |
| Merge | `n8n-nodes-base.merge` | Combine branches |
| Split In Batches | `n8n-nodes-base.splitInBatches` | Process items in batches |
| Wait | `n8n-nodes-base.wait` | Pause execution |
| Execute Sub-workflow | `n8n-nodes-base.executeWorkflow` | Call another workflow |
| No Operation | `n8n-nodes-base.noOp` | Explicit dead-end |
| Execute Command | `n8n-nodes-base.executeCommand` | Run system commands |

### Communication
| Display Name | Type | Notes |
|-------------|------|-------|
| HTTP Request | `n8n-nodes-base.httpRequest` | Generic API calls |
| Slack | `n8n-nodes-base.slack` | Slack messaging |
| Google Sheets | `n8n-nodes-base.googleSheets` | Spreadsheet operations |
| Gmail | `n8n-nodes-base.gmail` | Email sending/reading |

### AI / LLM Nodes
| Display Name | Type | Notes |
|-------------|------|-------|
| AI Agent | `n8n-nodes-langchain.agent` | LLM agent with tools |
| LLM Chain | `@n8n/n8n-nodes-langchain.chainLlm` | Simple LLM call |
| MCP Client Tool | `n8n-nodes-langchain.mcpClientTool` | Connect to MCP servers |

---

## Built-in Code Variables

Available in Code and Function nodes:

### Data Access
- `$input.all()` — Get all input items as array
- `$input.first()` — Get first input item
- `$input.last()` — Get last input item
- `$input.item` — Current item (in "Run Once for Each Item" mode)
- `$json` — Shorthand for current item's JSON data (expression context)
- `$binary` — Access binary data on current item

### Workflow Metadata
- `$workflow.id` — Current workflow ID
- `$workflow.name` — Current workflow name
- `$workflow.active` — Whether workflow is active
- `$execution.id` — Current execution ID
- `$execution.mode` — Execution mode (manual, trigger, webhook)
- `$execution.resumeUrl` — URL to resume a waiting execution

### Environment & Static Data
- `$env.VARIABLE_NAME` — Access environment variables
- `$getWorkflowStaticData('global')` — Persistent data that survives across executions (great for dedup caches, counters)
- `$getWorkflowStaticData('node')` — Static data scoped to current node

### Node References
- `$('Node Name').all()` — Get all items from a named node
- `$('Node Name').first()` — Get first item from a named node
- `$prevNode` — Previous node reference
- `$runIndex` — Current run index (for loops)

### Expressions (in node parameters, not Code nodes)
- `{{ $json.fieldName }}` — Access field from previous node
- `{{ $('Node Name').item.json.field }}` — Access specific node's data
- `{{ DateTime.now().toISO() }}` — Luxon date functions
- `{{ $if($json.score > 7, 'hot', 'cold') }}` — Conditional expression

### Important Differences: Code vs Function Nodes
- **Code node** (`n8n-nodes-base.code`): Modern, supports JavaScript and Python, has "Run Once for All Items" and "Run Once for Each Item" modes
- **Function node** (`n8n-nodes-base.function`): Legacy, JavaScript only, returns array of items. Still works and is often more debuggable in execution logs because you can see the return value directly.

Both have access to the same built-in variables. For new workflows, either works. The skill prefers Function nodes for transparency in execution debugging, but Code nodes are fine for complex logic.
