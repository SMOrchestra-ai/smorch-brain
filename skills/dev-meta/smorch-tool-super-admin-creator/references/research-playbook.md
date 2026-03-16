# Research Playbook: How to Build Genuine Tool Expertise

This playbook defines the systematic research process for building operator skills. The quality of research directly determines the quality of the skill. Shallow research = generic skill that's no better than reading the docs.

## Research Tiers

### Tier 1: Official Sources (MANDATORY)
These are non-negotiable. Every operator skill needs data from:

1. **Official Documentation**
   - API reference (endpoints, parameters, response shapes, error codes)
   - Getting started guides (reveals the tool's mental model)
   - Pricing page (tiers, credits, feature gates)
   - Status page / changelog (recent issues, deprecations)
   - Help center / knowledge base (common questions = common problems)

2. **Official Blog / Announcements**
   - New features (what's recently changed)
   - Best practices posts (vendor's recommended patterns)
   - Case studies (how power users actually use it)

### Tier 2: Practitioner Sources (HIGHLY RECOMMENDED)
Where real operational knowledge lives:

1. **Community Forums / Reddit**
   - Search: `r/[tool] problems`, `r/[tool] tips`, `r/saas [tool]`
   - Look for: recurring complaints (= real constraints), workarounds, power user tricks

2. **YouTube Tutorials (Advanced)**
   - Search: `[tool] advanced tutorial`, `[tool] masterclass`, `[tool] for agencies`
   - Look for: 30+ minute deep dives from practitioners (not vendor marketing)
   - Key channels for GTM tools: ColdIQ, Instantly tutorials, Clay University

3. **Agency Playbooks**
   - Search: `[tool] agency setup`, `[tool] at scale`, `[tool] for B2B`
   - Reference agencies: ColdIQ, FullFunnel.co, SalesCaptain, Clay Agency Partners

4. **Comparison Reviews**
   - Search: `[tool] vs [competitor] 2025 2026`, `[tool] review honest`
   - Look for: feature gaps, pricing gotchas, migration stories

### Tier 3: Integration & Technical (AS NEEDED)
For tools that connect to the existing stack:

1. **Integration Documentation**
   - Native integrations with tools in the stack
   - Webhook documentation (events, payloads, security)
   - Zapier/Make/n8n integration pages (reveal common automation patterns)

2. **API Libraries / SDKs**
   - npm/PyPI packages (reveals community adoption)
   - GitHub repos (issues reveal bugs, PRs reveal workarounds)

3. **MCP Ecosystem**
   - Check if MCP server exists for the tool
   - Review MCP tool capabilities vs native API coverage gaps

## Research Extraction Template

For each source, extract into this structure:

```
SOURCE: [URL]
TYPE: [official_docs | community | agency | comparison | integration]
DATE_ACCESSED: [YYYY-MM-DD]

CAPABILITIES DISCOVERED:
- [Operation]: [Details, parameters, limitations]

CONSTRAINTS DISCOVERED:
- [Limit type]: [Specific number/threshold]

COST DATA:
- [Tier/Operation]: [Price/credit cost]

INTEGRATION DATA:
- [Connected tool]: [Method, limitations]

MENA RELEVANCE:
- [Finding]: [Impact on Gulf/Arabic operations]

GOTCHAS / WARNINGS:
- [Issue]: [What goes wrong and when]

OPTIMIZATION OPPORTUNITIES:
- [Strategy]: [Expected savings/improvement]
```

## Research Quality Indicators

You know research is DEEP ENOUGH when you can answer:

1. "What happens when you hit the rate limit?" (not just "there is a rate limit")
2. "What's the cheapest way to do X for 10,000 records?" (specific cost math)
3. "What breaks when you use Arabic data?" (specific failure mode)
4. "What's the webhook payload for [event]?" (actual field names)
5. "What's the #1 mistake agencies make with this tool?" (operational wisdom)
6. "How does this tool handle [edge case relevant to MENA]?" (regional specifics)

You know research is TOO SHALLOW when:
- Constraints section just says "check the docs for limits"
- Pricing section just says "varies by plan"
- MENA section just says "may have limited coverage"
- Troubleshooting is generic HTTP error codes

## Research Time Budget

| Skill Depth | Research Time | Sources Required |
|-------------|--------------|-----------------|
| Quick Start (v0.1) | 15-20 minutes | Tier 1 only |
| Standard (v1.0) | 45-60 minutes | Tier 1 + Tier 2 |
| Battle-tested (v2.0) | 90+ minutes | All tiers + user SOPs + testing |

## Source Credibility Ranking

When sources conflict:
1. Official API documentation (ground truth for technical constraints)
2. Official pricing page (ground truth for costs)
3. Recent community reports (last 6 months)
4. Agency playbooks from known practitioners
5. Comparison reviews (often biased, verify claims)
6. Vendor marketing materials (treat as aspirational, not factual)

## MENA-Specific Research Queries

Always run these searches for any tool in the stack:

```
"[tool] Arabic support"
"[tool] RTL text"
"[tool] Middle East coverage"
"[tool] UAE OR Saudi Arabia OR Dubai"
"[tool] international OR global coverage gaps"
"[tool] phone format international"
"[tool] timezone support"
```

Most tools have zero official MENA documentation. The absence of results IS a finding: document it as "No official MENA support documentation. Expect: [predicted gaps based on similar tools]."

## Post-Research Validation

After research, validate key findings:

1. **Test 2-3 MCP operations** if tool is connected (verify docs match reality)
2. **Cross-reference pricing** between official page and community reports
3. **Verify rate limits** with a small test batch
4. **Check MENA coverage** with real Gulf data if possible (Arabic names, .ae/.sa domains, +971/+966 phones)
