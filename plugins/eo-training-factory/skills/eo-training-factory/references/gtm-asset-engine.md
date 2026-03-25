# GTM Asset Engine — EO Training Factory
## Production Guide for Sales & Marketing Asset Generation

**Version:** 1.0
**Last Updated:** 2026-03-03
**Scope:** Handles ALL GTM/sales asset production for EO training launches
**Owner:** EO Training Factory

---

## Quick Reference: Asset Production Order

The correct build sequence ensures messaging coherence across all channels:

1. **YouTube Video Preps** (messaging foundation — see youtube-prep-engine)
2. **LinkedIn Post Series** (derives from YouTube messaging)
3. **VSL Scripts** (distills YouTube + LinkedIn positioning)
4. **VSL Landing Page** (built around VSL scripts)
5. **Outbound Sequences** (requires all messaging crystallized first)
6. **Signal Outbound Playbook** (triggers sequences with precision targeting)
7. **One-Pagers** (summary of everything else)

**Why this order matters:** Each asset builds on the messaging clarity of previous ones. Out-of-order production causes inconsistent positioning and weak conversion chains.

---

## Asset 1: EO-LinkedIn-Post-Series.docx

**File Size:** ~20KB | **Format:** Microsoft Word (.docx)
**Naming Convention:** `EO-LinkedIn-Post-Series-[COHORT_NAME]-[LAUNCH_DATE].docx`

### Structure

- **5 series** × **24 posts total** (typically 4–5 posts per series, some series longer)
- Each post lives in a **single-cell table** (prevents formatting drift when copied)
- **Metadata included:** Character count, estimated engagement rate, series number, post order

### Content Specifications

**Character limits (CRITICAL):**
- Primary platform: LinkedIn (1,300 character truncation at "...more")
- **Golden rule:** First line must complete a thought and stop the scroll
- If you can't make your point in 3 lines, your post is too weak

**Tone & positioning:**
- Contrarian-signal-rich (not vanilla advice)
- Anchor messaging:
  - "Relationship-based selling is a tax on growth"
  - "Signal-based trust engineering is the replacement"
  - "You don't need 47 coffee meetings to close enterprise deals in the Gulf"

**Proof points (MENA-specific):**
- Named personas with real context:
  - **Ahmed:** Dubai beauty clinic owner (high-touch, Instagram-first decision-makers)
  - **Sara:** Riyadh HR director (government procurement familiarity, risk-averse)
  - **Omar:** Cairo accountant (WhatsApp-native, signal-responsive)
  - **Layla:** Amman real estate developer (relationship-based but data-driven)
  - **Khalid:** Abu Dhabi telecoms manager (enterprise procurement, B2B comfort)

**Hashtag strategy:**
- Maximum 3 hashtags per post (no spam)
- Examples: #SignalSelling #EnterpriseSales #MiddleEastBusiness
- No generic hashtags (#sales, #marketing, #business)

**Content mix:**
- 40% contrarian takes on sales methodology
- 30% MENA-specific GTM insights (WhatsApp trends, Arabic LinkedIn growth, government tenders)
- 20% proof points / case studies (Ahmed's clinic, Sara's HR ops, etc.)
- 10% direct offers/CTAs (link to landing page, VSL)

**Language strategy (natural mixing):**
- Post primarily in English (LinkedIn's largest professional audience in MENA)
- Sprinkle Arabic terms naturally: "Wasta" (connections), "Wakala" (agency), "Shurah" (consultation)
- Never force bilingual posts; if content is Arabic-primary, use separate post
- Use Arabic in replies/comments if audience initiates in Arabic

### Formatting in .docx

```
Style: NAVY (RGB 17, 52, 96) text on white background
Accent: TEAL (RGB 0, 128, 120) for key phrases
Gold: RGB (212, 175, 55) for call-out numbers/stats

Font: Calibri, 11pt body text
Table cell padding: 0.15"
Line spacing: 1.5 (for readability in LinkedIn preview)
```

### Quality Checklist

- [ ] Each post < 1,300 characters
- [ ] First sentence completes a thought (can stand alone)
- [ ] No more than 3 hashtags
- [ ] MENA persona used ≥ 1x per series
- [ ] Contrarian angle present (not generic advice)
- [ ] Links/CTAs use short URLs (bit.ly format)
- [ ] Character count displayed in table metadata
- [ ] All names spelled consistently across series

---

## Asset 2: EO-Outbound-Sequences.docx

**File Size:** ~17KB | **Format:** Microsoft Word (.docx)
**Naming Convention:** `EO-Outbound-Sequences-[SEQUENCE_NAME]-[VERSION].docx`

### Structure

- **3 core sequences** (typically; may extend to 5 depending on campaign)
- Standard sequences:
  1. **Side Hustle Track** (for freelancers/consultants looking to build scalable offer)
  2. **Extract Expertise Track** (for experts/professionals monetizing knowledge)
  3. **AI Co-Founder Track** (for founders/operators building AI-native businesses)
- Each sequence: **7-row table** (7 touchpoints over 14–21 days)

### Touchpoint Sequence Pattern

**Row structure:**
- Day (1, 3, 5, 7, 10, 14, 18 or similar stagger)
- Channel (Email / LinkedIn / Email / LinkedIn / WhatsApp / Email / LinkedIn)
- Subject line / Headline (if applicable)
- Body copy (short)
- Personalization tokens (embedded in template)
- Follow-up note (timing, if no response)

**Typical sequence:**
1. Day 1: Email (research-backed cold open)
2. Day 3: LinkedIn (3rd-degree connection angle or direct if low-cost)
3. Day 5: Email (proof point / case study from their industry)
4. Day 7: WhatsApp (if number available from signal research)
5. Day 10: LinkedIn (final social touch before reframe)
6. Day 14: Email (reframe: "I think I've been approaching this wrong")
7. Day 18: End sequence or move to nurture list

### Personalization Tokens

All sequences use these exact tokens (no variations):

```
{{first_name}}          — recipient's first name
{{company}}             — company name
{{industry}}            — industry vertical
{{title}}               — job title
{{signal_type}}         — the trigger signal (e.g., "LinkedIn post about hiring")
{{our_cohort_stage}}    — which EO cohort (Founding, Accelerator, etc.)
```

**Example:**
```
Hi {{first_name}},

I noticed {{company}} just posted about expanding {{industry}} operations.
That's exactly what we're building signal-based GTM for.

Ahmed did something similar at his Dubai clinic—went from 12 to 47
qualified leads/month with zero email campaigns.

Worth 20 min?
```

### Email Subject Lines (CRITICAL)

**Rules:**
- **Maximum 50 characters** (mobile preview cutoff)
- No clickbait
- First email: mention the signal ("I saw your LinkedIn post about...")
- Personalization token must appear: `{{first_name}}` or `{{company}}`

**Examples:**
- `{{first_name}}, I saw your post about AI hiring` ✓
- `Quick question about {{company}}'s GTM strategy` ✓
- `Why {{industry}} teams are ditching email outreach` ✓

**Bad examples:**
- `🚀 URGENT: You won't believe what we found` ✗
- `Hi {{first_name}}, let me tell you why our solution is amazing` ✗

### First Sentence Rule

**Non-negotiable:** The first sentence is NEVER about the sender.

BAD:
```
We're a GTM agency and we help companies scale sales.
```

GOOD:
```
I noticed your team just posted about expanding into MENA markets.
```

**Why:** Receiver-first positioning = 3–5x higher open rates.

### Formatting in .docx

```
Color scheme: NAVY headers, TEAL row accents, GOLD highlights
Font: Calibri, 10pt for tables
Table: 7 rows × 5 columns (Day | Channel | Subject | Body | Token Notes)
Row height: 0.5" (compact but readable)
```

### Quality Checklist

- [ ] Subject lines ≤ 50 characters
- [ ] First sentence receiver-focused (not sender)
- [ ] Personalization tokens consistent across all sequences
- [ ] Proof points match sequence theme (Side Hustle ≠ AI Co-Founder messaging)
- [ ] WhatsApp copy is conversational (not email-like)
- [ ] No sales jargon; speak like a peer
- [ ] Sequences stagger across 14–21 days (not bunched)
- [ ] Follow-up notes are specific (e.g., "If no response by Day 12, move to nurture")

---

## Asset 3: EO-VSL-Scripts.docx

**File Size:** ~15KB | **Format:** Microsoft Word (.docx)
**Naming Convention:** `EO-VSL-Scripts-[COHORT_NAME]-[DURATION].docx`

### Structure

- **2 scripts** (standard)
  1. **1-minute VSL** (high-traffic landing page, YouTube ads, WhatsApp preview)
  2. **5-minute VSL** (email click-through, dedicated landing page, webinar pre-roll)
- Each script: **Table format** with sections and timing

### 1-Minute Script Sections

| Section | Duration | Copy Guidelines |
|---------|----------|-----------------|
| **Hook** | 3 sec | One-liner that stops the scroll. Not a question—a statement. Example: "Signal-based selling converts 3x faster than relationship-based in MENA markets." |
| **Problem** | 15 sec | Paint the pain. "You're spending 4+ hours/day on outreach with <2% response rates." Mention friction, not the product. |
| **Agitate** | 15 sec | Amplify the cost of inaction. "Every month without fixing this is $12K in lost pipeline." Use specific numbers; avoid vagueness. |
| **Solution** | 15 sec | Single sentence. "We built a signal detection + personalized outreach system that cuts your prospecting time to 30 min/day." |
| **CTA** | 12 sec | One ask. "Click the link below—watch the full breakdown (5 min)." Or: "Reply with your main selling challenge; I'll send you our playbook." |

**Total: 60 seconds**

### 5-Minute Script Sections

| Section | Duration | Copy Guidelines |
|---------|----------|-----------------|
| **Hook** | 15 sec | Same as 1-min but with 1 expansion sentence. Show the possibility, not the problem yet. |
| **Credibility** | 30 sec | Anchor your authority. "We've worked with 47 founders in the Gulf, UAE, Egypt, and Lebanon. They've generated $8.2M in new revenue using this exact system." Name-drop: Ahmed (beauty clinics), Sara (HR ops), Khalid (enterprise sales). |
| **Problem** | 60 sec | Deep dive into the pain. 3–4 specific friction points. Use language they use: "Your inbox is a black hole." "Prospects ghost you after one email." "You don't know which signal to chase first." |
| **Failed Solutions** | 45 sec | Acknowledge what they've tried and why it didn't work. "You bought the software (Instantly, HubSpot, Outreach). It collected dust. Why? No signal framework." This builds credibility by validating their past choices. |
| **Breakthrough** | 45 sec | The "aha moment" for your system. "Here's what changed everything: Instead of generic personalization, we started with signal intelligence—what the prospect actually cares about today. Only then do we personalize." Show the sequence, not the tool. |
| **What They Get** | 60 sec | Outcomes, not features. "You'll cut prospecting time to 30 min/day. You'll hit 8%+ response rates (vs. 2% industry avg). Most importantly, you'll close deals with buyers who actually want what you're selling." List 3–4 tangible outcomes. |
| **Social Proof** | 30 sec | Specific case studies with permission. "Omar, a Cairo accountant, went from 2 qualified leads/month to 21 using the playbook. He's now charging 3x per service." Use exact names and numbers. |
| **CTA** | 15 sec | Match the VSL placement. YouTube pre-roll: "Subscribe for the full method." Email: "Reply with 'PLAYBOOK' and I'll send the 8-step framework." Webinar: "Register for the live walkthrough (link in description)." |

**Total: 300 seconds (5 minutes)**

### Production Notes (Meta Section)

Include a separate section in the .docx with production instructions:

```
PRODUCTION NOTES

1-Minute VSL Production:
- Voiceover: 120–150 wpm (clear, not rushed)
- Visual pacing: Scene every 5–8 seconds
- No music under (too distracting for WhatsApp in-app viewing)
- Captions mandatory (MENA audiences often watch muted)

5-Minute VSL Production:
- Voiceover: 130–150 wpm
- Visual pacing: Every 8–12 seconds (slower = deeper credibility building)
- B-roll: Mix of data visuals, case study screenshots, customer testimonials
- Music: Subtle background (don't compete with voiceover)
- Captions: Hard-coded, high contrast (white with black outline)
- Length: 4:45–5:15 (YouTube metadata should say "5 min")

Test environment:
- WhatsApp in-app browser (Android + iOS)
- YouTube mobile (landscape + portrait)
- LinkedIn video player (auto-play, no audio)

Quality gates before publishing:
- [ ] Captions synchronized within 0.2 sec of speech
- [ ] Audio levels: -3dB peak (don't clip)
- [ ] No visual transitions > 0.5 sec (jarring)
- [ ] Proof points (names, numbers) validated with client
- [ ] CTA matches landing page / email where it links to
```

### Formatting in .docx

```
Font: Calibri, 11pt
Table structure: 2 columns (Section | Copy)
Section headers: TEAL (bold, 12pt)
Duration timings: GOLD (right-aligned)
Production notes: Grey box, italicized, 9pt
```

### Quality Checklist

- [ ] Hook is a statement, not a question
- [ ] Problem section uses specific friction (not generic)
- [ ] Failed Solutions section validates past attempts (builds credibility)
- [ ] Social proof names are real with permission
- [ ] Numbers are verified (don't claim "3x" without data)
- [ ] CTA is one ask (not multiple)
- [ ] Total script reads naturally aloud (read it aloud yourself)
- [ ] MENA personas appear ≥ 1x in 5-min script
- [ ] No jargon (if you wouldn't say it in conversation, remove it)

---

## Asset 4: EO-VSL-Landing-Page.html

**File Size:** ~19KB | **Format:** Single-file HTML with inline CSS
**Naming Convention:** `EO-VSL-Landing-Page-[COHORT_NAME]-[VERSION].html`

### Architecture: Single-File HTML Requirement

**Why single file?**
- No external dependencies (works in WhatsApp in-app browser)
- No server-side rendering (instant load)
- CSS variables for theme management
- Mobile-first, fully responsive

**Structure:**

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EO Training — [Cohort Name]</title>
    <style>
        :root {
            --navy: #113460;
            --teal: #008078;
            --gold: #d4af37;
            --light-gray: #f5f5f5;
            --dark-gray: #333;
        }
        /* Inline CSS here */
    </style>
</head>
<body>
    <!-- Sections below -->
</body>
</html>
```

### Page Sections (in order)

#### 1. Navigation (Fixed, Top)
```html
<nav>
    Logo | About | Curriculum | Pricing | FAQ | Get Started
</nav>
```
- Sticky to top on scroll
- Background: White with light shadow
- Links: NAVY text, TEAL hover

#### 2. Hero Section
```html
<section class="hero">
    <h1>[Main value prop]</h1>
    <p>[Sub-headline—one sentence]</p>
    <div id="vsl-placeholder">
        <!-- Video embed code for VSL (YouTube embed or self-hosted video tag) -->
        <video controls poster="thumbnail.jpg">
            <source src="vsl-1min.mp4" type="video/mp4">
        </video>
    </div>
    <button class="cta-primary">Watch Now</button>
</section>
```

**Hero copy examples:**
- H1: "Build a $50K/month expertise business in 90 days"
- H1: "Stop cold-pitching. Start signal-selling."
- Sub: "The exact system used by 47+ founders to close enterprise deals in MENA"

#### 3. Problem Cards
```html
<section class="problems">
    <h2>The Problem</h2>
    <div class="card-grid">
        <div class="card">
            <h3>🔴 Problem 1</h3>
            <p>Description of friction</p>
        </div>
        <div class="card">...</div>
        <div class="card">...</div>
    </div>
</section>
```

**Standard 3 problems:**
1. You're spending 4+ hours/day on outreach with <2% response
2. Your "relationships" aren't closing—they're ghosting
3. You don't know which signal to chase first (too much noise)

#### 4. Modules Overview
```html
<section class="curriculum">
    <h2>What You'll Learn</h2>
    <div class="modules">
        <div class="module">
            <h3>Module 1: Signal Architecture</h3>
            <p>Identify the 13 highest-converting signals for your market...</p>
        </div>
        <!-- 4–6 modules total -->
    </div>
</section>
```

**Typical modules:**
1. Signal Architecture (what signals to monitor)
2. Audience Intelligence (finding the right buyers)
3. Message Crafting (signal-aware copy)
4. Sequence Engineering (7-touch GTM flow)
5. WhatsApp Mastery (MENA-specific channel optimization)
6. Metrics & Optimization (what to measure, daily workflow)

#### 5. Proof Stats
```html
<section class="social-proof">
    <div class="stat">
        <h3>47+</h3>
        <p>Founders & experts trained</p>
    </div>
    <div class="stat">
        <h3>$8.2M</h3>
        <p>New revenue generated by students</p>
    </div>
    <div class="stat">
        <h3>8%+</h3>
        <p>Average response rate (vs. 2% industry avg)</p>
    </div>
    <div class="stat">
        <h3>30 min/day</h3>
        <p>Average time to run outreach (down from 4+ hours)</p>
    </div>
</section>
```

#### 6. Credentials / About Section
```html
<section class="credentials">
    <h2>Who's Teaching This</h2>
    <div class="instructor">
        <img src="instructor.jpg" alt="Instructor name">
        <h3>Instructor Name</h3>
        <p>3+ years building GTM systems. Worked with founders
        in Dubai, Riyadh, Cairo, Amman, Abu Dhabi. Previously
        [relevant experience].</p>
    </div>
</section>
```

#### 7. Pricing Section (2 Tiers)
```html
<section class="pricing">
    <h2>Choose Your Track</h2>
    <div class="pricing-grid">
        <div class="tier founding">
            <h3>Founding Track</h3>
            <p class="price">$97</p>
            <p class="period">(Founding cohort only, 48-hour offer)</p>
            <ul>
                <li>✓ 6 core modules</li>
                <li>✓ Email templates & sequences</li>
                <li>✓ Signal playbook</li>
                <li>✗ Group coaching</li>
            </ul>
            <button class="cta-secondary">Join Founding</button>
        </div>
        <div class="tier standard">
            <h3>Standard Track</h3>
            <p class="price">$497</p>
            <p class="period">(Ongoing, full access)</p>
            <ul>
                <li>✓ 6 core modules</li>
                <li>✓ Email templates & sequences</li>
                <li>✓ Signal playbook</li>
                <li>✓ Weekly group coaching</li>
                <li>✓ Private community</li>
            </ul>
            <button class="cta-primary">Get Started</button>
        </div>
    </div>
</section>
```

**Pricing psychology:**
- Founding tier: Scarcity + urgency (48-hour window, limited spots)
- Standard tier: Highlighted as "Recommended" (subtle visual emphasis)
- Price difference: 5x ($97 to $497) signals value gap (coaching + community)

#### 8. FAQ Section
```html
<section class="faq">
    <h2>Frequently Asked Questions</h2>
    <div class="faq-item">
        <h4>Do I need a product to start?</h4>
        <p>No. This is for consultants, freelancers, and experts
        looking to build their first business or scale an existing one.</p>
    </div>
    <!-- 5 items total -->
</section>
```

**Standard 5 FAQ items:**
1. Do I need a product to start?
2. How much time does this take per day?
3. Is this for MENA markets only?
4. Do you offer a refund if I'm not satisfied?
5. Can I apply this to my existing business/product?

#### 9. Final CTA Section
```html
<section class="final-cta">
    <h2>Ready to stop cold-pitching?</h2>
    <p>Join 47+ founders building signal-based GTM in MENA.</p>
    <button class="cta-primary">Get Started Now</button>
    <p class="subtext">48-hour founding cohort window closes: [DATE/TIME]</p>
</section>
```

#### 10. Footer
```html
<footer>
    <p>&copy; 2026 EO Training. All rights reserved.</p>
    <p>
        <a href="#privacy">Privacy</a> |
        <a href="#terms">Terms</a> |
        <a href="mailto:support@eotraining.io">Contact</a>
    </p>
</footer>
```

### CSS Specifications

**Mobile-first approach:**
```css
/* Base: Mobile (320px+) */
body {
    font-size: 16px;
    line-height: 1.6;
    color: var(--dark-gray);
}

/* Tablet and up (768px+) */
@media (min-width: 768px) {
    body { font-size: 18px; }
    .pricing-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; }
}

/* Desktop and up (1200px+) */
@media (min-width: 1200px) {
    .container { max-width: 1200px; margin: 0 auto; }
}
```

**WhatsApp in-app browser compatibility:**
- No viewport scaling issues (viewport meta tag set)
- Button sizing: min 44px height/width (touch targets)
- Colors: High contrast (NAVY on white, not gray on white)
- No fixed sidebars (breaks mobile views)
- Video embed: Use `<video>` tag or YouTube iframe (both work in WhatsApp)

### Quality Checklist

- [ ] Single HTML file, no external CSS imports
- [ ] CSS variables for all colors (--navy, --teal, --gold, etc.)
- [ ] Mobile viewport meta tag present
- [ ] Video embed works in WhatsApp in-app browser (tested)
- [ ] All buttons have min 44px touch targets
- [ ] No horizontal scroll on mobile
- [ ] Color contrast meets WCAG AA (4.5:1 for text)
- [ ] Page loads < 3 seconds (no heavy images)
- [ ] VSL embed placeholder is clear (video tag or iframe ready)
- [ ] Pricing clearly differentiates tiers (visual weight + copy)
- [ ] Footer has contact + privacy links
- [ ] Hero CTA button color: TEAL (primary action)
- [ ] Secondary buttons: NAVY outline (secondary action)

---

## Asset 5: EO-Signal-Outbound-Playbook.docx

**File Size:** ~19KB | **Format:** Microsoft Word (.docx)
**Naming Convention:** `EO-Signal-Outbound-Playbook-[VERSION].docx`

**NOTE:** This is an OPERATIONS document, not marketing copy. It's internal—never shared directly with prospects.

### Structure

#### Section 1: Signal Inventory (Ranked by Strength)

Table: Signal Name | Strength Score (1–10) | Detection Method | Response Rate (%) | Platform | Notes

**Example signal inventory (13 total):**

| Signal | Strength | Detection Method | Avg Response Rate | Platform | Notes |
|--------|----------|------------------|-------------------|----------|-------|
| LinkedIn job post (hiring eng/sales) | 9 | LinkedIn search + RSS feed | 8.2% | LinkedIn + Email | Strongest signal; high buyer intent |
| LinkedIn post about MENA expansion | 8 | LinkedIn native search + keyword alerts | 7.1% | LinkedIn | Industry-specific subtext |
| Raised funding (Series A/B) | 8 | Crunchbase + Twitter/LinkedIn | 6.9% | Email (personalized) | Expanding teams = scaling pain |
| Product launch announcement | 7 | Product Hunt + Twitter + LinkedIn | 5.3% | LinkedIn | Timing window: 48–72 hours post-launch |
| Company rebranding | 7 | LinkedIn company updates + news | 4.8% | Email | Strategic shift = process change |
| Executive changed title | 7 | LinkedIn profile updates | 5.1% | LinkedIn | New role = higher openmindedness |
| Company opened new office | 8 | LinkedIn + Google News | 6.7% | WhatsApp (if GCC) | Local market entry = hiring/systems |
| Became LinkedIn Creator | 6 | LinkedIn creator badge + post frequency | 3.2% | LinkedIn comment | Thought leader positioning |
| Speaking at industry event | 7 | LinkedIn + Eventbrite + Twitter | 4.9% | Email (1 week before) | Authority + openness |
| Government tender activity (GCC) | 8 | TAMAMM + UAE Contracts + local news | 7.4% | Email (WhatsApp if applicable) | Enterprise procurement signal |
| Posted hiring ad on Facebook | 5 | Facebook job ads + LinkedIn crosspost | 2.1% | Facebook + LinkedIn | Lower intent than LinkedIn posting |
| Competitor lost major client | 6 | LinkedIn layoff trends + news | 3.7% | Email (soft approach) | Window of vulnerability |
| Published webinar or training | 6 | LinkedIn + YouTube + email archives | 4.1% | Email | Expert positioning; outbound window: 2 weeks |

**Scoring logic:**
- 9–10: Immediate outreach within 24–48 hours; 70%+ response likelihood
- 7–8: Outreach within 1 week; strong intent signal
- 5–6: Nurture list or secondary sequence
- < 5: Skip or use only for brand awareness

#### Section 2: Platform Stack (11 Tools)

Table: Tool Name | Category | Primary Use | Integration | Cost | Notes

| Tool | Category | Use | Integration | Cost | Notes |
|------|----------|-----|-------------|------|-------|
| LinkedIn | Prospecting | Research + direct outreach | Manual + Instantly.ai automation | Free + $100/mo | Best platform for MENA B2B |
| Email (GMail / Outlook) | Outreach | Cold sequences | Instantly.ai | Free + $25/mo Instantly | Deliverability critical in GCC |
| HeyReach | Outreach | Email + LinkedIn automation at scale | API integration | $79–199/mo | Saves 4+ hours/week on personalization |
| Instantly.ai | Outreach | Multi-channel (email + LinkedIn) + follow-up | Zapier | $29–99/mo | Best email warmup; works in region |
| WhatsApp Business | Outreach | Direct messages + templates (MENA-first) | Manual + Meta API | Free + $0.055/msg | Converts better than email in GCC/Levant |
| Perplexity / ChatGPT | Content | Signal research, copy generation | Manual (copy-paste) | Free / $20/mo | Speed up research and first-draft sequences |
| Google Alerts | Monitoring | Signal detection (job posts, news, raises) | Email | Free | Set up 15+ alerts for ICP keywords |
| Twitter / X | Monitoring | Executive movements, company announcements | Manual + TweetDeck | Free | MENA tech/startup early signals |
| Crunchbase | Monitoring | Funding rounds, hiring, company changes | Manual + API | Free (limited) / $299/mo | Best for B2B signal verification |
| Calendly / Stripe | Logistics | Meeting scheduling + payment collection | API | $12–20/mo | Embed in email CTAs |
| Airtable / Notion | Tracking | Pipeline + signal inventory management | Zapier | Free / $10–20/mo | Store all prospect data + signals |

**Integration notes:**
- Instantly.ai automates email + LinkedIn touches (reduces manual work from 4 hrs/day to 30 min/day)
- HeyReach personalizes at scale (uses AI to customize each email)
- WhatsApp should be manual for high-intent targets (more effective than template-blasted emails)

#### Section 3: Signal → Sequence Mapping

Table: Signal | Sequence Track | First Touchpoint | Timing | Notes

| Signal | Sequence | Touchpoint | Timing | Notes |
|--------|----------|------------|--------|-------|
| LinkedIn job post | Side Hustle / Extract Expertise | Email (research-backed) | Within 24 hrs | Reference specific role in subject line |
| Raised funding | Outbound Playbook sequences | Email (proof point) | Within 2 days | Emphasize hiring/growth pain |
| MENA expansion | Email (localized) | Email + WhatsApp | Immediate | Show MENA case study proof |
| Product launch | Proof-point sequence | LinkedIn comment (not DM) | 48–72 hrs | Build in-feed credibility first |
| Executive title change | Relationship sequence | LinkedIn message | 3–5 days | Acknowledge transition, no hard sell |
| Tender activity (GCC) | Government playbook (separate) | Email (formal tone) | Immediately upon discovery | Different copy; procurement mindset |
| Speaking event | Expert positioning | Email (1 week before) | 5–7 days prior | "Would love to catch up at [event]" |
| Became LinkedIn Creator | Comment sequence | LinkedIn comment on post | Immediate | Engage 2–3 posts before DM |

**Key rule:** Don't force all signals into one sequence. Customize the first touchpoint based on signal strength and audience receptiveness.

#### Section 4: WhatsApp Rules (CRITICAL for MENA)

**8 Golden Rules:**

1. **Permission first.** Never add someone to WhatsApp without email / LinkedIn touchpoint first. Exception: Government/enterprise contexts where phone number is public.

2. **One message per day max.** WhatsApp is intimate; back-to-back messages feel like spam. Space out 24+ hours between touches.

3. **Profile picture = professional.** Must be headshot or company logo. Anything else kills credibility in enterprise contexts.

4. **Verify locale before sending.** UAE / KSA residents expect different tone/timing than Egypt/Lebanon. Adjust copy accordingly.

5. **No voice notes to cold prospects.** Text only for first 2–3 messages. Voice notes are for warm relationships only.

6. **Time zone aware.** GCC business hours (8am–5pm GST) peak on Tue–Thu. Avoid Friday–Sunday and Maghreb. Send Egypt/Lebanon messages 9am–12pm, 3pm–7pm local time.

7. **Link sparingly.** One link per message max. If you're sending a landing page or asset, send the text first, get engagement, then follow with the link 1–2 messages later.

8. **Switch to email if they ask.** If they say "send me an email," honor it immediately. Don't push WhatsApp. Respect their preference.

**4 Standard Templates:**

**Template 1: Cold Open (Day 1 Email)**
```
Hi {{first_name}},

Saw your recent post about [{{signal_type}}].

I help {{industry}} teams 10x their outbound response rates without hiring a sales team.

Ahmed's beauty clinic went from 2 to 18 qualified leads/week using the same playbook.

Worth 20 min on a call?

[Calendly link]
```

**Template 2: Proof Point (Day 5 Email)**
```
{{first_name}},

No response yet—totally get it, inboxes are brutal.

Quick context: Just helped {{company}} in {{industry}} systemize their outreach.

Main win: Cut their prospecting time from 4 hrs/day to 30 min.

Not a fit right now? No problem. I'll stay top of mind.

[Link to playbook PDF]
```

**Template 3: WhatsApp Warm Message (Day 7, if number available)**
```
Hi {{first_name}} 👋

I'm following up on the email I sent about [signal].

I work specifically with {{industry}} teams in the region who want to scale their outbound without hiring.

Quick question: What's your biggest bottleneck right now—finding the right buyers, crafting messages, or follow-up consistency?
```

**Template 4: Reframe / Final (Day 14)**
```
Hi {{first_name}},

I think I've been approaching this wrong.

Instead of another sales pitch, let me ask: What would a 10x improvement in your outbound response rate be worth to {{company}}?

That's the specific outcome we deliver. If it's not relevant, I'll stop bothering you 😊

[CTA: "Reply with PLAYBOOK" or "Schedule 20-min call"]
```

#### Section 5: Scoring Model

**Lead scoring for prioritization (decides sequence assignment):**

```
Score = (Signal Strength × 0.5) + (ICP Match × 0.3) + (Engagement History × 0.2)

Signal Strength (0–10):
  9–10 = Immediate outreach (hire/funding/tender)
  7–8 = Standard 7-touch sequence
  5–6 = Nurture list (2-touch/month)
  < 5 = Brand awareness only

ICP Match (0–10):
  10 = Perfect fit (title, company size, industry, location all match)
  8 = Good fit (4/5 criteria match)
  6 = Possible fit (3/5 criteria match)
  4 = Loose fit (2/5 criteria match)
  < 4 = Low match; skip

Engagement History (0–5):
  5 = Replied to previous email / engaged on LinkedIn
  3 = Viewed landing page / opened email
  1 = No prior engagement
  0 = Bounced email / blocked

Example:
  Prospect = strong job post signal (9) + perfect ICP (10) + prior engagement (4)
  Score = (9 × 0.5) + (10 × 0.3) + (4 × 0.2) = 4.5 + 3 + 0.8 = 8.3/10
  Action: Immediate outreach (within 24 hrs)
```

#### Section 6: Daily Workflow (30 min/day)

**Breakdown:**
- 5 min: Review overnight replies + signals (Google Alerts, Twitter, Crunchbase)
- 10 min: Identify highest-scoring signals (score > 7.5)
- 8 min: Draft 3–5 personalized first emails using HeyReach
- 4 min: Send via Instantly.ai (with warmup rules applied)
- 2 min: Update Airtable pipeline
- 1 min: Schedule follow-ups for existing sequences

**Tools used:**
- Instantly.ai (sends emails, logs engagement)
- HeyReach (personalizes at scale)
- Google Sheets / Airtable (tracks scores + responses)
- WhatsApp (warm follow-ups only, manual)

**Outcome:** 20–30 new prospects added to sequences daily without working more than 30 min.

#### Section 7: Tools Integration Architecture

Diagram (text-based):

```
Signal Discovery Layer:
  LinkedIn searches → Google Alerts → Twitter → Crunchbase
  └─→ Notion database (centralized signal inventory)

Personalization Layer:
  Lead data + signal trigger → HeyReach AI → Custom email
  └─→ Instantly.ai queue

Execution Layer:
  Instantly.ai → Email delivery (warmup rules applied)
  └─→ Recipient inbox (tracked by Instantly)
           ├─→ Opens
           ├─→ Clicks
           └─→ Replies (auto-logged in Airtable)

Relationship Layer:
  High-intent prospects (replies) → WhatsApp (manual)
  Low-intent prospects → Nurture sequence (2x/month)

Measurement:
  Airtable → Google Sheets (pivot) → Weekly report
  Metrics tracked: # sent, open rate, click rate, reply rate, meeting rate
```

### Quality Checklist

- [ ] All 13 signals have detection methods (not vague)
- [ ] Platform stack tools are integrated (not siloed)
- [ ] Signal → Sequence mapping covers all major signals
- [ ] WhatsApp rules are enforced (e.g., permission first, one msg/day)
- [ ] Scoring model is quantifiable (not subjective)
- [ ] Daily workflow is < 30 min (includes buffer)
- [ ] Templates use exact personalization tokens (no manual inserts)
- [ ] MENA-specific rules are included (time zones, platforms, locales)
- [ ] Tools are affordable/accessible for solo founder
- [ ] Each signal has a specific response rate baseline
- [ ] Government tender signals are flagged (different sequence)

---

## Asset 6: EO-Training-One-Pagers (EN + AR)

**File Size:** ~4KB each | **Format:** PDF
**Naming Convention:**
- `EO-Training-One-Pager-EN-[COHORT_NAME].pdf`
- `EO-Training-One-Pager-AR-[COHORT_NAME].pdf`

### Purpose

One-page summary for quick sharing via email, WhatsApp, or in-person. Not a sales document—a reference.

### Structure (English)

**Header (top 1"):**
```
EO TRAINING — [Cohort Name]
Signal-Based GTM for Founders in MENA
[Logo]
```

**Body (middle 3.5"):**
```
WHAT YOU'LL LEARN (6 modules):
• Module 1: Signal architecture
• Module 2: Audience intelligence
• Module 3: Message crafting
• Module 4: Sequence engineering
• Module 5: WhatsApp mastery
• Module 6: Metrics & optimization

PROOF:
✓ 47+ founders trained
✓ $8.2M new revenue generated
✓ 8%+ response rates (vs. 2% industry avg)
✓ 30 min/day to manage outreach

PRICING:
$97 founding cohort (48-hour window)
$497 standard ongoing cohort

SIGN UP: [URL] or [QR code]
```

**Footer (bottom 1"):**
```
Questions? contact@eotraining.io
Next cohort starts: [DATE]
Only for founders / experts building GTM in MENA
```

### Arabic Version

**Key translations:**
- "Signal-Based GTM" → "نظام التسويق الموجه بالإشارات"
- "Response Rate" → "معدل الرد"
- "Founding Cohort" → "فئة التأسيس"

**Layout note:** Arabic reads right-to-left; mirror the layout.

### Quality Checklist

- [ ] Fits on one page (11×8.5" or A4)
- [ ] QR code links to correct landing page
- [ ] Logo and colors match EO brand
- [ ] Arabic version is professionally translated (not Google Translate)
- [ ] Arabic version is right-aligned with proper typography
- [ ] Proof stats are accurate and verified
- [ ] Contact email is correct
- [ ] Pricing matches VSL landing page
- [ ] Cohort start date is current

---

## Asset 7: Supporting Context Files

### EO-Cohort-ICP.md

**File Size:** ~11KB | **Format:** Markdown
**Naming Convention:** `EO-Cohort-ICP-[COHORT_NAME].md`

**Contains:**
- ICP (Ideal Customer Profile) definition with MENA specificity
- Job titles and industries
- Company size ranges
- Decision-making dynamics (who says yes, who says no)
- Pain points (specific to MENA market)
- Budget expectations
- Timeline to purchase
- Common objections + rebuttals

**Example ICP profile:**
```markdown
# EO Training ICP — Founding Cohort

## Persona: Ahmed (Dubai Beauty Clinic Owner)
- Title: Founder / Owner
- Company size: 2–10 employees
- Industry: Beauty, healthcare, professional services
- Region: UAE, KSA, Egypt, Lebanon
- Pain: Spending 4+ hrs/day on outreach, <2% response
- Budget: $200–500/month for GTM tools
- Timeline: Immediate (wants to close deals this quarter)
- Decides: Solo (founder is decision-maker)
```

### EO-Pricing-Strategy.md

**File Size:** ~12KB | **Format:** Markdown
**Naming Convention:** `EO-Pricing-Strategy-[VERSION].md`

**Contains:**
- Pricing tier rationale ($97 vs. $497)
- Founding window strategy (48-hour scarcity)
- Payment terms (one-time, no recurring)
- Refund policy
- Upsell / cross-sell strategy
- Lifetime value expectations
- Competitive landscape (what else costs $97–$500)

**Example snippet:**
```markdown
# EO Training Pricing Strategy

## Tier 1: Founding Cohort ($97, 48-hour window)
Rationale:
- Low barrier to entry (validates market demand)
- Scarcity drives urgency (48-hour deadline)
- Attracts early adopters (less price-sensitive)
- Builds social proof (more signups = more testimonials)

Students per founding cohort: 100–200 (cap)
Founding cohort runs: 2–3x per year
After cutoff: Tier shifts to $497 (standard)

## Tier 2: Standard Cohort ($497, ongoing)
Rationale:
- Includes weekly group coaching (adds value)
- Community access (cohort bonding, referrals)
- Lifetime access to materials (no expiration)
- Justifies higher price vs. founding
```

---

## Build Dependency Chart

```
Start: YouTube Video Preps (foundation messaging)
  ↓
LinkedIn Post Series (distill YouTube into posts)
  ├─→ VSL Scripts (condense messaging to video form)
  │   └─→ VSL Landing Page (build around VSL scripts)
  │       └─→ Outbound Sequences (craft all messaging to drive landing page)
  │           └─→ Signal Outbound Playbook (define triggers for sequences)
  │
  └─→ One-Pagers (summary of landing page + messaging)

Supporting context (run in parallel):
  - ICP definition
  - Pricing strategy

Timeline:
- Day 1–3: YouTube preps + LinkedIn series (2–3 days)
- Day 4–5: VSL scripts (1 day)
- Day 6–7: VSL landing page (1 day, can parallelize with scripts)
- Day 8–9: Outbound sequences (1 day)
- Day 10–11: Signal playbook (1 day)
- Day 12: One-pagers (0.5 day)

Total: 11–12 days from brief to full asset suite
```

---

## Production Standards & Quality Gates

### Color Scheme (EO Brand)

```
Primary: NAVY RGB(17, 52, 96) / HEX #113460
Secondary: TEAL RGB(0, 128, 120) / HEX #008078
Accent: GOLD RGB(212, 175, 55) / HEX #d4af37
Neutral: Light Gray RGB(245, 245, 245) / HEX #f5f5f5
Text: Dark Gray RGB(51, 51, 51) / HEX #333333
```

### Typography

```
Headlines (H1, H2): Montserrat Bold or similar sans-serif
Body text: Calibri, 11pt (web: 16–18px)
Line height: 1.6 (body text), 1.2 (headlines)
```

### File Naming Convention

```
[ASSET_TYPE]-[COHORT_NAME]-[VERSION/DATE].ext

Examples:
EO-LinkedIn-Post-Series-Founding-20260303.docx
EO-Outbound-Sequences-Side-Hustle-v2.docx
EO-VSL-Scripts-Accelerator-Final.docx
EO-VSL-Landing-Page-Founding-v3.html
EO-Signal-Outbound-Playbook-v2.docx
EO-Training-One-Pager-EN-Founding-20260303.pdf
```

### Quality Gate Checklist (Pre-Launch)

**All assets:**
- [ ] Proofread for typos + grammatical errors (US English spelling)
- [ ] MENA persona names consistent across all assets
- [ ] Color scheme applied consistently (NAVY/TEAL/GOLD)
- [ ] Links tested (landing page URLs, Calendly, etc.)
- [ ] Proof stats verified (names, numbers, outcomes)
- [ ] File names follow naming convention

**LinkedIn posts:**
- [ ] All posts < 1,300 characters
- [ ] No more than 3 hashtags per post
- [ ] First line stands alone (makes sense without rest of post)

**Outbound sequences:**
- [ ] Subject lines ≤ 50 characters
- [ ] First sentence is receiver-focused
- [ ] Personalization tokens are consistent
- [ ] No jargon; reads like peer-to-peer

**VSL scripts:**
- [ ] Total 1-min script = 60 seconds read aloud
- [ ] Total 5-min script = 300 seconds read aloud
- [ ] Hook is statement, not question
- [ ] Social proof names have permission

**Landing page:**
- [ ] Single HTML file (no external dependencies)
- [ ] Responsive on mobile (test 320px width)
- [ ] Works in WhatsApp in-app browser
- [ ] All buttons have min 44px touch targets
- [ ] Video embed placeholder is clear

**Playbook:**
- [ ] All 13 signals have response rate baselines
- [ ] Platform stack tools are affordable (< $500/mo total)
- [ ] Daily workflow is realistic (30 min max)
- [ ] WhatsApp rules are enforced

**One-pagers:**
- [ ] Fits on one page
- [ ] QR code tested and links correctly
- [ ] Arabic version is professionally translated
- [ ] Proof stats match landing page

---

## Version Control & Updates

When updating existing assets, increment version number and document changes:

```markdown
## Changelog

### v2.1 (2026-03-15)
- Added "government tender activity" signal (strength 8)
- Updated Ahmed's proof point (18 leads/week, was 12)
- Revised WhatsApp template 3 (tone softened for lower-intent)
- Fixed VSL script 5-min timing (was running 5:30, now 5:00)

### v2.0 (2026-03-01)
- First production version
- 3 core sequences, 13 signals
- Complete asset suite
```

---

## Handoff Documentation

When handing off assets to GTM lead / operations:

**Package includes:**
1. All 7 primary assets (docx, html, pdf)
2. Supporting context files (markdown)
3. This reference guide (gtm-asset-engine.md)
4. Changelog (versions used in launch)
5. Asset mapping sheet (which asset for which campaign)

**Example asset mapping:**
```
Campaign: LinkedIn Outreach
  Primary asset: EO-Outbound-Sequences-Extract-Expertise-v2.docx
  Supporting: EO-Signal-Outbound-Playbook-v2.docx
  Landing page: EO-VSL-Landing-Page-Founding-v3.html
  One-pager: EO-Training-One-Pager-EN-Founding.pdf

Campaign: Email Nurture (Non-Responders)
  Primary asset: EO-Outbound-Sequences-Side-Hustle-v2.docx (Day 14+ only)
  Supporting: EO-Signal-Outbound-Playbook-v2.docx
```

---

## Troubleshooting & Common Issues

**Issue: LinkedIn posts are getting low engagement (< 5 reactions)**
- Check: Is the first line compelling enough to stop the scroll?
- Fix: Rewrite first line with stronger contrarian angle or specific MENA proof point
- Example weak: "Building a GTM system is hard"
- Example strong: "Relationship-based selling cost Ahmed $48K in lost revenue last year"

**Issue: Email open rates are low (< 20%)**
- Check: Are subject lines ≤ 50 characters?
- Check: Is the first line receiver-focused (not about sender)?
- Fix: A/B test subject line angle (signal-based vs. social proof vs. curiosity)

**Issue: VSL scripts feel rushed when read aloud**
- Check: Are you reading at 130–150 wpm?
- Fix: Add pauses after key statements (write them as "..." in script)
- Example: "You're spending 4+ hours/day on outreach. ... With <2% response rates."

**Issue: Landing page breaks on WhatsApp mobile browser**
- Check: Are you testing with 320px viewport width?
- Fix: Remove any fixed-width elements; use max-width: 100% on all containers
- Test: Manually open the HTML file in WhatsApp on iPhone + Android

**Issue: Outbound sequences have low reply rates (< 3%)**
- Check: Are you using the right signal → sequence mapping?
- Fix: Verify the prospect's signal strength (job post, funding, etc.)
- Example: If signal strength < 7, don't expect 8%+ response; nurture instead

---

## Success Metrics & KPIs

**Per asset:**

| Asset | KPI | Target | Notes |
|-------|-----|--------|-------|
| LinkedIn Posts | Engagement rate | 2–4% (reactions + replies) | MENA avg is 0.8%; this is 3–5x higher |
| Outbound Sequences | Reply rate | 5–8% | 2–3x industry avg |
| VSL Scripts | Click-through rate (to landing) | 8–12% (email), 15–20% (YouTube) | CTA must match channel |
| Landing Page | Conversion to signup | 8–12% (traffic → paid signup) | Founding cohort usually higher |
| Signal Playbook | Outreach velocity | 20–30 new prospects/day in 30 min | Measure time spent vs. output |

**Campaign-level:**

| Metric | Founding Cohort Target | Standard Cohort Target |
|--------|----------------------|----------------------|
| # signups | 100–200 | 30–50 per cohort |
| Revenue (cohort) | $9,700–19,400 | $14,910–24,850 |
| Customer acquisition cost | $50–100 | $200–300 |
| 30-day retention | 85%+ | 75%+ |
| NPS (Net Promoter Score) | 60+ | 50+ |

---

## Recap: What This Engine Produces

This GTM Asset Engine is responsible for creating and maintaining:

1. **LinkedIn Post Series** — 24 contrarian, MENA-focused posts
2. **Outbound Sequences** — 3 templates with 7 touches each, personalized
3. **VSL Scripts** — 1-min and 5-min versions, production-ready
4. **VSL Landing Page** — Single HTML file, mobile-optimized, WhatsApp-compatible
5. **Signal Outbound Playbook** — Operations guide with 13 signals, 11 tools, daily workflow
6. **One-Pagers** — English + Arabic PDFs for quick sharing
7. **Supporting context** — ICP + pricing strategy

**All assets are linked:** LinkedIn → VSL → Landing → Outbound → Signal Playbook → One-Pagers.
**All assets use:** NAVY/TEAL/GOLD color scheme, MENA personas (Ahmed, Sara, Omar, Layla, Khalid), exact personalization tokens, verified proof stats.

This engine is the production backbone for every EO training launch. Update it when messaging shifts; use it as the reference for every new campaign.

---

**End of GTM Asset Engine Reference**
