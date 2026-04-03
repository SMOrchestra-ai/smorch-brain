# Slot Injection Examples - eo-production-renderer

Complete worked examples showing design-brief.json input, template with slot markers, and rendered output.

---

## Example 1: Cold Email Sequence (3-Step)

### Input (from design-brief.json)

```json
{
  "asset_type": "cold-email-3step",
  "icp_name": "Solo real estate brokers in Dubai",
  "pain_1": "Losing 40% of leads to WhatsApp chaos",
  "wedge_angle": "WhatsApp-native CRM that auto-follows up",
  "cta": "15-min demo",
  "founder_name": "Mamoun",
  "company_name": "SalesMfast",
  "product_name": "LeadFlow",
  "emails": [
    {
      "step": 1,
      "subject": "Your WhatsApp leads are going cold",
      "pain_hook": "Losing leads to WhatsApp chaos?",
      "pain_statement": "You're managing 20+ listings and every lead comes through WhatsApp. By day 3, half of them go cold because there's no follow-up system.",
      "mechanism": "We built a CRM that lives inside WhatsApp. Auto-captures every lead, auto-follows up based on lead age. Zero tool-switching.",
      "proof": "A broker in JLT recovered 12 lost leads in the first week."
    },
    {
      "step": 2,
      "subject": "The follow-up gap",
      "pain_hook": "What happens after the first message?",
      "pain_statement": "Most leads go quiet because you're busy showing properties. There's no system to re-engage them at the right time.",
      "mechanism": "LeadFlow auto-sequences messages based on lead behavior. New lead? Day-1 warmup. No response? Day-3 reminder. Engaged? Move to pipeline.",
      "proof": "Brokers using auto-sequences see 3x faster response rates."
    },
    {
      "step": 3,
      "subject": "Last chance: let me show you",
      "pain_hook": "You're losing money every day",
      "pain_statement": "If you're closing deals 20% slower than you could, that's 2-3 extra months per deal. That's a lot of lost commission.",
      "mechanism": "15-min screen share. I'll show you exactly how to set up auto-follow-up in WhatsApp. No credit card, no setup fees.",
      "proof": "Most brokers see leads converted to viewings within the first week."
    }
  ]
}
```

### Template (reference)

```html
<!-- COLD EMAIL SEQUENCE TEMPLATE -->
<div class="email-sequence">
  <div class="email-step">
    <h2>Step 1</h2>
    <div class="subject"><!-- {{SLOT:EMAIL_1_SUBJECT}} --><span class="subject-text">Subject placeholder</span></div>
    <div class="body">
      <!-- {{SLOT:EMAIL_1_BODY}} -->
      <p>{{FIRST_NAME}},</p>
      <p>Body placeholder</p>
      <p class="cta">CTA placeholder</p>
      <p class="signature">{{FOUNDER_NAME}}</p>
    </div>
  </div>

  <div class="email-step">
    <h2>Step 2 (3 days later)</h2>
    <div class="subject"><!-- {{SLOT:EMAIL_2_SUBJECT}} --><span class="subject-text">Subject placeholder</span></div>
    <div class="body">
      <!-- {{SLOT:EMAIL_2_BODY}} -->
      <p>{{FIRST_NAME}},</p>
      <p>Body placeholder</p>
      <p class="cta">CTA placeholder</p>
      <p class="signature">{{FOUNDER_NAME}}</p>
    </div>
  </div>

  <div class="email-step">
    <h2>Step 3 (5 days later)</h2>
    <div class="subject"><!-- {{SLOT:EMAIL_3_SUBJECT}} --><span class="subject-text">Subject placeholder</span></div>
    <div class="body">
      <!-- {{SLOT:EMAIL_3_BODY}} -->
      <p>{{FIRST_NAME}},</p>
      <p>Body placeholder</p>
      <p class="cta">CTA placeholder</p>
      <p class="signature">{{FOUNDER_NAME}}</p>
    </div>
  </div>
</div>
```

### Rendered Output

```html
<!-- COLD EMAIL SEQUENCE TEMPLATE -->
<div class="email-sequence">
  <div class="email-step">
    <h2>Step 1</h2>
    <div class="subject"><span class="subject-text">Your WhatsApp leads are going cold</span></div>
    <div class="body">
      <p>{{FIRST_NAME}},</p>
      <p>You're managing 20+ listings and every lead comes through WhatsApp. By day 3, half of them go cold because there's no follow-up system. We built a CRM that lives inside WhatsApp. Auto-captures every lead, auto-follows up based on lead age. Zero tool-switching. A broker in JLT recovered 12 lost leads in the first week.</p>
      <p class="cta">Worth a 15-min demo? Tuesday or Wednesday work?</p>
      <p class="signature">Mamoun</p>
    </div>
  </div>

  <div class="email-step">
    <h2>Step 2 (3 days later)</h2>
    <div class="subject"><span class="subject-text">The follow-up gap</span></div>
    <div class="body">
      <p>{{FIRST_NAME}},</p>
      <p>Most leads go quiet because you're busy showing properties. There's no system to re-engage them at the right time. LeadFlow auto-sequences messages based on lead behavior. New lead? Day-1 warmup. No response? Day-3 reminder. Engaged? Move to pipeline. Brokers using auto-sequences see 3x faster response rates.</p>
      <p class="cta">Let's set up your first auto-sequence. Thursday at 3pm?</p>
      <p class="signature">Mamoun</p>
    </div>
  </div>

  <div class="email-step">
    <h2>Step 3 (5 days later)</h2>
    <div class="subject"><span class="subject-text">Last chance: let me show you</span></div>
    <div class="body">
      <p>{{FIRST_NAME}},</p>
      <p>If you're closing deals 20% slower than you could, that's 2-3 extra months per deal. That's a lot of lost commission. 15-min screen share. I'll show you exactly how to set up auto-follow-up in WhatsApp. No credit card, no setup fees. Most brokers see leads converted to viewings within the first week.</p>
      <p class="cta">Let's do this. Book here: [link]</p>
      <p class="signature">Mamoun</p>
    </div>
  </div>
</div>
```

---

## Example 2: Company One-Pager

### Input (from design-brief.json)

```json
{
  "asset_type": "one-pager",
  "company_name": "SalesMfast",
  "tagline": "WhatsApp-first CRM for real estate teams",
  "problem": "Real estate brokers lose 40% of leads because there's no WhatsApp follow-up system. Leads go cold, deals slip away, commission is lost.",
  "solution_headline": "Auto-follow-up happens inside WhatsApp",
  "solution_detail": "No tool-switching. No complex workflows. Leads trigger automatic messages at the right moment. New lead gets welcomed day-1. No response gets a reminder day-3. Engaged prospects move to pipeline view.",
  "for_who": "Independent real estate brokers and small teams managing 50-500 active leads",
  "why_now": "WhatsApp is the primary communication channel in MENA. CRMs designed for email are obsolete.",
  "traction": "Brokers using SalesMfast recover 12-15 lost leads per month. Average deal cycles shortened by 20%.",
  "pricing": "Starter: AED 199/month. Professional: AED 499/month. Agency: Custom.",
  "cta_text": "Join 200+ brokers using SalesMfast",
  "cta_link": "https://salesmfast.ae/demo"
}
```

### Template (reference)

```html
<!DOCTYPE html>
<html>
<head><title>Company One-Pager</title></head>
<body>
  <div class="one-pager">
    <header>
      <h1><!-- {{SLOT:COMPANY_NAME}} --><span>Company Name</span></h1>
      <p class="tagline"><!-- {{SLOT:TAGLINE}} --><span>Tagline</span></p>
    </header>

    <section class="problem">
      <h2>The Problem</h2>
      <!-- {{SLOT:PROBLEM}} -->
      <p>Problem statement</p>
    </section>

    <section class="solution">
      <h2><!-- {{SLOT:SOLUTION_HEADLINE}} --><span>Solution</span></h2>
      <!-- {{SLOT:SOLUTION_DETAIL}} -->
      <p>Solution detail</p>
    </section>

    <section class="for-who">
      <h2>For Who</h2>
      <!-- {{SLOT:FOR_WHO}} --><p>Target audience</p>
    </section>

    <section class="why-now">
      <h2>Why Now</h2>
      <!-- {{SLOT:WHY_NOW}} --><p>Market timing</p>
    </section>

    <section class="traction">
      <h2>Traction</h2>
      <!-- {{SLOT:TRACTION}} --><p>Proof/validation</p>
    </section>

    <section class="pricing">
      <h2>Pricing</h2>
      <!-- {{SLOT:PRICING}} --><p>Pricing tiers</p>
    </section>

    <footer>
      <a href="#" class="cta-button"><!-- {{SLOT:CTA_TEXT}} --><span>CTA Text</span></a>
    </footer>
  </div>
</body>
</html>
```

### Rendered Output

```html
<!DOCTYPE html>
<html>
<head><title>Company One-Pager</title></head>
<body>
  <div class="one-pager">
    <header>
      <h1><span>SalesMfast</span></h1>
      <p class="tagline"><span>WhatsApp-first CRM for real estate teams</span></p>
    </header>

    <section class="problem">
      <h2>The Problem</h2>
      <p>Real estate brokers lose 40% of leads because there's no WhatsApp follow-up system. Leads go cold, deals slip away, commission is lost.</p>
    </section>

    <section class="solution">
      <h2><span>Auto-follow-up happens inside WhatsApp</span></h2>
      <p>No tool-switching. No complex workflows. Leads trigger automatic messages at the right moment. New lead gets welcomed day-1. No response gets a reminder day-3. Engaged prospects move to pipeline view.</p>
    </section>

    <section class="for-who">
      <h2>For Who</h2>
      <p>Independent real estate brokers and small teams managing 50-500 active leads</p>
    </section>

    <section class="why-now">
      <h2>Why Now</h2>
      <p>WhatsApp is the primary communication channel in MENA. CRMs designed for email are obsolete.</p>
    </section>

    <section class="traction">
      <h2>Traction</h2>
      <p>Brokers using SalesMfast recover 12-15 lost leads per month. Average deal cycles shortened by 20%.</p>
    </section>

    <section class="pricing">
      <h2>Pricing</h2>
      <p>Starter: AED 199/month. Professional: AED 499/month. Agency: Custom.</p>
    </section>

    <footer>
      <a href="https://salesmfast.ae/demo" class="cta-button"><span>Join 200+ brokers using SalesMfast</span></a>
    </footer>
  </div>
</body>
</html>
```

---

## Example 3: LinkedIn Connection Sequence

### Input (from design-brief.json)

```json
{
  "asset_type": "linkedin-sequence",
  "founder_name": "Mamoun Alamouri",
  "company_name": "SalesMfast",
  "connection_request": {
    "message": "Hey {{FIRST_NAME}} — building signal-based GTM engines for MENA SaaS teams. Saw your post on lead gen. Let's compare notes."
  },
  "followups": [
    {
      "step": 1,
      "timing": "5 days after connection",
      "message": "{{FIRST_NAME}}, quick question: what's your biggest friction point in lead follow-up? For most teams I talk to, it's the lag between lead capture and first touch."
    },
    {
      "step": 2,
      "timing": "7 days after step 1",
      "message": "Most {{VERTICAL}} teams I work with are losing 30-40% of leads to follow-up chaos. We built a tool that auto-sequences based on lead behavior. Cuts deal cycles in half."
    },
    {
      "step": 3,
      "timing": "5 days after step 2",
      "message": "Last thing: I'm doing 15-min audits of {{VERTICAL}} teams' lead workflows. See exactly where you're bleeding deals. No pitch, just analysis. Worth 15 min?"
    }
  ]
}
```

### Template (reference)

```html
<!-- LINKEDIN SEQUENCE TEMPLATE -->
<div class="linkedin-sequence">
  <section class="connection-request">
    <h2>Connection Request</h2>
    <div class="message">
      <!-- {{SLOT:CONNECTION_MESSAGE}} -->
      <p>Connection message placeholder</p>
    </div>
  </section>

  <section class="followup followup-1">
    <h2>Follow-up 1 (5 days after connection)</h2>
    <div class="message">
      <!-- {{SLOT:FOLLOWUP_1_MESSAGE}} -->
      <p>Follow-up 1 message placeholder</p>
    </div>
  </section>

  <section class="followup followup-2">
    <h2>Follow-up 2 (7 days after Follow-up 1)</h2>
    <div class="message">
      <!-- {{SLOT:FOLLOWUP_2_MESSAGE}} -->
      <p>Follow-up 2 message placeholder</p>
    </div>
  </section>

  <section class="followup followup-3">
    <h2>Follow-up 3 (5 days after Follow-up 2)</h2>
    <div class="message">
      <!-- {{SLOT:FOLLOWUP_3_MESSAGE}} -->
      <p>Follow-up 3 message placeholder</p>
    </div>
  </section>
</div>
```

### Rendered Output

```html
<!-- LINKEDIN SEQUENCE TEMPLATE -->
<div class="linkedin-sequence">
  <section class="connection-request">
    <h2>Connection Request</h2>
    <div class="message">
      <p>Hey {{FIRST_NAME}} — building signal-based GTM engines for MENA SaaS teams. Saw your post on lead gen. Let's compare notes.</p>
    </div>
  </section>

  <section class="followup followup-1">
    <h2>Follow-up 1 (5 days after connection)</h2>
    <div class="message">
      <p>{{FIRST_NAME}}, quick question: what's your biggest friction point in lead follow-up? For most teams I talk to, it's the lag between lead capture and first touch.</p>
    </div>
  </section>

  <section class="followup followup-2">
    <h2>Follow-up 2 (7 days after Follow-up 1)</h2>
    <div class="message">
      <p>Most {{VERTICAL}} teams I work with are losing 30-40% of leads to follow-up chaos. We built a tool that auto-sequences based on lead behavior. Cuts deal cycles in half.</p>
    </div>
  </section>

  <section class="followup followup-3">
    <h2>Follow-up 3 (5 days after Follow-up 2)</h2>
    <div class="message">
      <p>Last thing: I'm doing 15-min audits of {{VERTICAL}} teams' lead workflows. See exactly where you're bleeding deals. No pitch, just analysis. Worth 15 min?</p>
    </div>
  </section>
</div>
```

---

## Edge Cases

### Edge Case 1: Empty Slot Value (Uses Fallback)

**Input:**
```json
{
  "asset_type": "cold-email-3step",
  "company_name": "",  // Empty
  "founder_name": "Mamoun",
  "emails": [{ "step": 1, "body": "Placeholder" }]
}
```

**Template:**
```html
<p>Built by {{SLOT:FOUNDER_NAME}} at {{SLOT:COMPANY_NAME}}</p>
```

**Renderer Behavior:**
- Replaces `{{SLOT:FOUNDER_NAME}}` with "Mamoun"
- Detects empty value for `{{SLOT:COMPANY_NAME}}`
- Uses fallback: either removes the phrase or inserts placeholder text `[Your company name]`
- Output: `<p>Built by Mamoun at [Your company name]</p>` or `<p>Built by Mamoun</p>` depending on fallback strategy

**Recommended behavior:** Remove the empty segment and adjust grammar. Output: `<p>Built by Mamoun</p>`

---

### Edge Case 2: Slot Value Too Long (Truncates with Note)

**Input:**
```json
{
  "asset_type": "one-pager",
  "problem": "This is an extremely long problem statement that explains in excruciating detail every single pain point the ICP faces, including historical context, competitive landscape analysis, and market research findings that span multiple paragraphs and would render a landing page unreadable. The full text is 450 words when the slot expects max 100 words."
}
```

**Template:**
```html
<div class="problem-section" max-chars="100">
  <!-- {{SLOT:PROBLEM}} -->
  <p>Problem placeholder (max 100 chars)</p>
</div>
```

**Renderer Behavior:**
- Detects slot value exceeds max-chars attribute
- Truncates at word boundary near 100 characters
- Appends "[…]" to indicate truncation
- Logs warning in render-log.json: `"PROBLEM slot truncated from 450 to 98 chars"`
- Output: `<p>This is an extremely long problem statement that explains in excruciating detail every single pain point the ICP […]</p>`

**Recommended behavior:** Add `[Truncated - see design-brief.json for full text]` at truncation point.

---

### Edge Case 3: Arabic Content in Slots (RTL Marker)

**Input:**
```json
{
  "asset_type": "whatsapp-sequence",
  "language": "ar",
  "messages": [
    {
      "step": 1,
      "body": "السلام عليكم، شفنا انك تبحث عن حل لإدارة العملاء. عندنا نظام يسهل المتابعة على الواتس."
    }
  ]
}
```

**Template:**
```html
<!-- {{SLOT:MESSAGE_1}} -->
<div class="whatsapp-message" lang="ar" dir="rtl">Message placeholder</div>
```

**Rendered Output:**
```html
<div class="whatsapp-message" lang="ar" dir="rtl">السلام عليكم، شفنا انك تبحث عن حل لإدارة العملاء. عندنا نظام يسهل المتابعة على الواتس.</div>
```

**Renderer Behavior:**
- Detects slot value contains Arabic characters (Unicode range \u0600-\u06FF)
- Preserves `dir="rtl"` and `lang="ar"` attributes in template
- Does NOT strip vowel marks or diacritics
- Logs in render-log.json: `"MESSAGE_1 rendered as RTL Arabic (47 chars)"`

---

## Template Slot Naming Convention

All slot markers follow the pattern: `<!-- {{SLOT:SLOT_NAME}} -->`

**Naming rules:**
- All caps: `EMAIL_1_SUBJECT`, not `Email1Subject`
- Use underscores between words: `COLD_EMAIL_STEP`, not `COLDEMAILSTEP`
- Number first for sequenced content: `EMAIL_1`, `EMAIL_2`, not `FIRST_EMAIL`
- Descriptive suffix: `_BODY`, `_SUBJECT`, `_MESSAGE`, `_TEXT`

**Examples:**
- `{{SLOT:EMAIL_1_SUBJECT}}`
- `{{SLOT:FOLLOWUP_2_MESSAGE}}`
- `{{SLOT:PROBLEM}}`
- `{{SLOT:COMPANY_NAME}}`
- `{{SLOT:CONNECTION_MESSAGE}}`
