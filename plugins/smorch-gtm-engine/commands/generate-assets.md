---
description: Generate weekly campaign assets from wedges
argument-hint: "[campaign-name] [week-number]"
allowed-tools: Read, Write, Edit, Glob, Task, AskUserQuestion
---

Generate campaign assets for a specific week using the asset-factory skill.

**Arguments:**
- `$1` — Campaign name (matches folder in `campaigns/`)
- `$2` — Week number (1, 2, or 3)

If arguments are missing, ask the user which campaign and week.

**Execution:**

1. **Load Campaign Context**
   - Read campaign config from `campaigns/$1/config.json`
   - Load positioning canvas, weekly wedge strategies
   - Identify the wedge for week $2

2. **Run Wedge Generator** (if wedge not yet created for this week)
   - Use the week's strategy + any new signals detected since last generation
   - Produce 3 wedge variants, select the strongest
   - Apply Hard Stop Rule 3: must pass one-sentence test
   - Apply Hard Stop Rule 4: Intent signals > Trust signals in sequence order

3. **Run Asset Factory**
   Produce for week $2:
   - **6 emails**: 3 sequence steps × 2 A/B variants each
     - Step 1: Initial outreach (pattern interrupt + wedge + low-friction CTA)
     - Step 2: Follow-up (different angle, same wedge, add proof element)
     - Step 3: Break-up / value-add (final touch, offer something useful)
   - **4 LinkedIn messages**: connection request + 3 follow-ups
     - Connection note: signal-referenced, under 300 chars
     - Follow-ups: value delivery, not "just checking in"
   - **3 WhatsApp variants**: initial + 2 follow-ups
     - Conversational Gulf Arabic for MENA, casual English for US
     - Include voice note scripts where appropriate
   - **1 social post**: LinkedIn/Twitter-ready
     - Contrarian angle mandatory
     - Tie to the weekly wedge theme
     - Include suggested image/graphic concept

4. **Apply Culture Adapter**
   - MENA: Gulf Arabic tone, relationship-aware language, Ramadan/holiday sensitivity
   - US: Direct, value-first, data-driven
   - Apply based on campaign ICP geography

5. **Save Assets**
   Save to `campaigns/$1/week-$2/`:
   - `emails/` — step-1-a.md, step-1-b.md, step-2-a.md, step-2-b.md, step-3-a.md, step-3-b.md
   - `linkedin/` — connection-request.md, followup-1.md, followup-2.md, followup-3.md
   - `whatsapp/` — initial.md, followup-1.md, followup-2.md
   - `social/` — post.md

Present all assets for review before marking as ready for deployment.
