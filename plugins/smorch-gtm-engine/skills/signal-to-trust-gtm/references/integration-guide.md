# Integration Guide

## GoHighLevel (GHL)
**What we export:**
- Workflow JSONs (email/SMS sequences)
- Custom field definitions (signal_type, wedge_variant, etc.)
- Tag-based triggers
- Form configurations
- Chat widget scripts

**How to deploy:**
1. Import workflow JSON via GHL dashboard
2. Map custom fields to contact records
3. Upload prospect list with tags
4. Activate workflows

## Instantly
**What we export:**
- Campaign configs (JSON)
- Sequence steps (CSV)
- Personalization variables

**How to deploy:**
1. Create new campaign in Instantly
2. Import sequence CSV
3. Map merge fields
4. Launch campaign

## HeyReach / LinkedHelper
**What we export:**
- Connection request templates
- Follow-up sequences
- InMail templates
- CSV prospect lists with LinkedIn URLs

**How to deploy:**
1. Import CSV into HeyReach
2. Set up sequence templates
3. Configure daily limits
4. Start campaign

## Apify / Relevance
**What we use:**
- LinkedIn profile scraping
- Company data enrichment
- Signal detection (hiring posts, tech stack changes, etc.)

**Integration mode:**
- Manual: "Here are the Apify actors to run"
- Automated: Skill generates Apify task configs

## SMooR (n8n + Claude)
**What we can generate:**
- n8n workflow JSONs for signal orchestration
- Claude agent prompts for custom logic
- Webhook endpoints for real-time signal capture
