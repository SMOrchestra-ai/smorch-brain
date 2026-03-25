# Connectors — SMOrch GTM Engine

## How Tool References Work

This plugin's skills reference specific MCP tool prefixes to interact with execution platforms. The skills are designed to work with specific tools but degrade gracefully when connections are unavailable.

## Required MCP Connections

Connect these MCP servers in your Cowork session for full functionality. Core skills (strategy, signals, wedges, asset production) work without any MCP connections. Deployment, metrics, and workflow automation require the connections below.

| Category | Platform | MCP Server | Required For | How to Connect |
|----------|----------|------------|-------------|----------------|
| Workflow Engine | n8n | n8n MCP (bundled) | Workflow creation, deployment automation, scheduled tasks | Set `N8N_BASE_URL` and `N8N_API_KEY` environment variables |
| Cold Email | Instantly.ai | Instantly MCP | Email campaign deployment, deliverability monitoring, warmup | Connect via Cowork MCP settings → Add Instantly server |
| LinkedIn Outbound | HeyReach | HeyReach MCP | LinkedIn campaign deployment, sender rotation, analytics | Connect via Cowork MCP settings → Add HeyReach server |
| CRM / WhatsApp / Social | GoHighLevel | GHL MCP | Contact management, WhatsApp messaging, social scheduling, pipelines | Connect via Cowork MCP settings → Add GHL server |

## Environment Variables

Set these in your system environment or Cowork session:

| Variable | Description | Where to Get It |
|----------|------------|-----------------|
| `N8N_BASE_URL` | Your n8n instance URL (e.g., `https://n8n.yourdomain.com`) | Your n8n hosting dashboard |
| `N8N_API_KEY` | n8n API key for authentication | n8n Settings → API → Create API Key |

## MCP Tool Prefixes Used in Skills

The operator skills reference these MCP tool prefixes. These are set when you connect the MCP servers in Cowork:

| Platform | Tool Prefix Pattern | Example Tool |
|----------|-------------------|-------------|
| n8n | `mcp__n8n__*` | `mcp__n8n__n8n_list_workflows` |
| Instantly | `mcp__[instantly-server-id]__*` | Listed in instantly-operator skill |
| HeyReach | `mcp__[heyreach-server-id]__*` | Listed in heyreach-operator skill |
| GHL | `mcp__ghl-mcp__*` | `mcp__ghl-mcp__search_contacts` |

## Degraded Mode (Without MCP Connections)

Without MCP connections, the plugin still provides full access to:

- Campaign strategy and planning (signal-to-trust-gtm, campaign-strategist)
- Signal detection and classification (signal-detector)
- Wedge generation (wedge-generator)
- Business positioning analysis (positioning-engine)
- Asset production — 42 assets per campaign (asset-factory)
- Multi-channel coordination planning (outbound-orchestrator)
- Enrichment strategy and waterfall design (clay-operator)
- Scraping architecture planning (scraper-layer)

It cannot:

- Deploy campaigns directly to Instantly, HeyReach, or GHL
- Collect real-time metrics from platforms
- Create or modify n8n workflows programmatically
- Manage contacts in CRM automatically
- Schedule social posts

For these operations without MCP, the skills will generate the configuration and content, and you manually import/paste into each platform.
