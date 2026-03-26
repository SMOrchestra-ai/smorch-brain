---
description: Score a deliverable against expert-grade benchmarks. Routes to the right scoring system automatically.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(ls:*), Bash(wc:*), Bash(mkdir:*)
argument-hint: '[system] [content-or-filepath]'
---

# /score — Score a Single Deliverable

Entry point for all scoring. Routes to the correct scoring system based on argument or content analysis.

## Routing Logic

### If $ARGUMENTS specifies a system:

| Argument | Routes To |
|----------|-----------|
| campaign | campaign-strategy-scorer |
| offer, positioning | offer-positioning-scorer |
| copy, email | copywriting-scorer → 3A: Email |
| vsl, script | copywriting-scorer → 3B: VSL |
| linkedin-dm, dm | copywriting-scorer → 3C: LinkedIn DM |
| whatsapp, wa | copywriting-scorer → 3D: WhatsApp |
| social, post | social-media-scorer |
| youtube, yt, thumbnail, title | youtube-scorer |
| linkedin, brand | linkedin-branding-scorer |

### If $ARGUMENTS is empty or contains content:

Auto-detect from the content:
1. Look for file uploads or pasted text
2. Analyze content type:
   - Email structure (subject line, body, CTA) → copywriting-scorer 3A
   - Video script format (hook, sections, CTA) → copywriting-scorer 3B or youtube-scorer 5C
   - Short message (<300 chars with greeting) → copywriting-scorer 3C or 3D
   - Social post format (hook + body + engagement ask) → social-media-scorer or linkedin-branding-scorer
   - Campaign strategy document → campaign-strategy-scorer
   - Offer/proposal document → offer-positioning-scorer
3. If ambiguous, ask: "What are we scoring? (1) Campaign strategy, (2) Offer/positioning, (3) Email copy, (4) VSL script, (5) LinkedIn DM, (6) WhatsApp message, (7) Social post, (8) YouTube content, (9) LinkedIn brand post"

## Execution Flow

1. **Identify system** — route per above
2. **Load content** — from file, paste, or conversation context
3. **Establish context** — target market (MENA/US), ICP, business line
4. **Invoke scorer skill** — read the appropriate SKILL.md, apply all criteria
5. **Present score report** — use the format from scoring-orchestrator
6. **Save JSON** — if workspace has a `scores/` directory, save the result
7. **Offer fixes** — if below 8.0, offer to implement top fixes immediately

## Examples

```
/score email
→ "Paste your cold email or point me to the file."
→ Scores against 3A criteria, presents report

/score campaign
→ "Paste your campaign brief or point me to the strategy doc."
→ Scores against System 1 criteria

/score youtube thumbnail
→ "Share the thumbnail image."
→ Scores against 5A criteria

/score
→ (with content in conversation)
→ Auto-detects and routes
```

## After Scoring

If score is below 7.0:
- Highlight the hard stops and fix actions
- Offer: "Want me to fix the top 3 issues right now?"

If score is 7.0-8.5:
- Present score with improvement suggestions
- Offer: "Solid. Want me to push it toward 9+?"

If score is 8.5+:
- Confirm ship-readiness
- Note any minor optimizations for future iterations
