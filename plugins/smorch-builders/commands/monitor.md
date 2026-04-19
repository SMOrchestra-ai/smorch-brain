---
description: Run a health check on SMOrchestra infrastructure
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, WebFetch
argument-hint: '[quick|full]'
---

Run an observability and monitoring check across SMOrchestra infrastructure. Used by the DevOps agent and VP Eng to catch issues before they cascade.

If `$ARGUMENTS` is "full", run a deep check (all 9 categories below). Default ("quick" or no argument) runs categories 1-4 only.

## Usage

```
/monitor              # Quick health check (services, servers, resources, n8n)
/monitor quick        # Same as above
/monitor full         # Deep check — adds GitHub, model APIs, DB, SSL, error logs
```

## How It Works

Execute the following checks in order. For each check, run the appropriate bash/curl command and collect results. If a command times out (5s for quick, 15s for full), mark that check as TIMEOUT.

### 1. Service Health

Check HTTP endpoints are responding:

| Service          | Endpoint                          |
|------------------|-----------------------------------|
| Paperclip        | `http://localhost:3100/health`    |
| OpenClaw Sulaiman| `http://localhost:18789/health`   |
| OpenClaw al-Jazari| `http://localhost:18790/health`  |
| n8n smo-brain    | `http://100.89.148.62:5678/healthz` |
| n8n smo-dev      | `http://100.117.35.19:5678/healthz` |

For each, run `curl -s -o /dev/null -w "%{http_code} %{time_total}s" --max-time 5 <endpoint>`. Record HTTP status and latency.

### 2. Server Connectivity

Ping both Tailscale nodes:

- **smo-brain**: `ping -c 2 -W 3 100.89.148.62`
- **smo-dev**: `ping -c 2 -W 3 100.117.35.19`

### 3. Disk / Memory / CPU

SSH into each server and collect resource usage:

```bash
ssh 100.89.148.62 "echo '--- CPU ---' && top -bn1 | head -5 && echo '--- MEM ---' && free -h && echo '--- DISK ---' && df -h / /data 2>/dev/null || df -h /"
```

Repeat for `100.117.35.19`. Flag if: CPU > 85%, Memory > 90%, Disk > 85%.

### 4. n8n Workflow Status

Use the n8n MCP tools (smo-brain and smo-dev) to list workflows. Count:
- Total workflows
- Active workflows
- Errored workflows (check recent executions for failures)

### 5. GitHub API Rate Limits (full only)

```bash
curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/rate_limit | jq '.rate | {limit, remaining, reset: (.reset | todate)}'
```

### 6. Model API Health (full only)

- **Claude**: `curl -s -o /dev/null -w "%{http_code}" -H "x-api-key: $ANTHROPIC_API_KEY" -H "anthropic-version: 2023-06-01" https://api.anthropic.com/v1/messages -d '{"model":"claude-sonnet-4-20250514","max_tokens":1,"messages":[{"role":"user","content":"ping"}]}'`
- **OpenAI**: `curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $OPENAI_API_KEY" https://api.openai.com/v1/models`

Report status code only. Do not send real prompts.

### 7. Database Connectivity (full only)

Check Supabase connection using the project's connection string or REST API:

```bash
curl -s -o /dev/null -w "%{http_code}" -H "apikey: $SUPABASE_ANON_KEY" "$SUPABASE_URL/rest/v1/" --max-time 5
```

### 8. SSL / Cert Expiry Warnings (full only)

For any public-facing domains, check cert expiry:

```bash
echo | openssl s_client -servername <domain> -connect <domain>:443 2>/dev/null | openssl x509 -noout -enddate
```

Flag if expiry is within 14 days.

### 9. Recent Error Logs (full only)

SSH into both servers and pull the last 30 minutes of critical/error-level journal entries:

```bash
ssh 100.89.148.62 "journalctl --priority=err --since '30 min ago' --no-pager | tail -30"
```

Repeat for `100.117.35.19`.

## Output Format

Present all results in this structure:

```markdown
## System Health Report -- [YYYY-MM-DD HH:MM UTC]

### Services
| Service | Endpoint | Status | Latency |
|---------|----------|--------|---------|
| Paperclip | :3100 | UP 200 | 0.023s |
| ... | ... | ... | ... |

### Infrastructure
| Server | CPU | Memory | Disk | Uptime |
|--------|-----|--------|------|--------|
| smo-brain | 34% | 62% | 48% | 14d |
| smo-dev | 21% | 45% | 33% | 7d |

### n8n Workflows
| Instance | Total | Active | Recent Errors |
|----------|-------|--------|---------------|
| smo-brain | 14 | 12 | 0 |
| smo-dev | 22 | 20 | 1 |

### Alerts
- [OK] All services responding
- [WARNING] smo-brain disk at 87% -- consider cleanup
- [CRITICAL] OpenClaw al-Jazari not responding (timeout)

### Recommendations
- Run `ssh 100.89.148.62 "docker system prune -f"` to reclaim disk
- Investigate al-Jazari gateway -- check `docker logs openclaw-al-jazari`
```

## Alert Thresholds

| Metric | OK | WARNING | CRITICAL |
|--------|----|---------|----------|
| CPU | < 70% | 70-85% | > 85% |
| Memory | < 75% | 75-90% | > 90% |
| Disk | < 70% | 70-85% | > 85% |
| Latency | < 1s | 1-3s | > 3s or timeout |
| Cert expiry | > 30d | 14-30d | < 14d |
| n8n errors | 0 in 1h | 1-3 in 1h | > 3 in 1h |
