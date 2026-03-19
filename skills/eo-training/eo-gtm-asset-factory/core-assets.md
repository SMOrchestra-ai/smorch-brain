# Core Assets Specification

These assets are produced for EVERY customer regardless of which GTM motion they select.
All messaging assets are DOCX format (not HTML). Landing page is HTML. Deck is PPTX.

---

## 1. Warm Email Sequence (DOCX)

**File:** `core/warm-email-sequence.docx`
**Format:** 3 emails, each on its own page in the DOCX

### Email 1: The Announcement
**Subject line options (provide 3):**
- "[Venture Name] is live — built for [ICP one-line description]"
- "I built something for [ICP pain in their language]"
- "[Specific outcome] — here's how"

**Body structure:**
```
Hey [First Name],

[One sentence: what I built and why]

[Two sentences: the specific pain this solves, using ICP language from icp.md]

[One sentence: what makes this different — from positioning.md unique mechanism]

[Social proof if available: "X founders already [action]" or "Beta users seeing [result]"]

[CTA: ONE action — "See it in action: [link]" or "Book 15 min: [link]"]

[Signature]
```
**Rules:** Under 120 words. No "I hope this finds you well." First line must be the hook.

### Email 2: The Proof
**Subject:** "How [specific ICP persona] gets [specific outcome]"
**Body:** Show one concrete example or demo result. Screenshot description placeholder. End with same CTA.
**Rules:** Under 100 words. Lead with the result, not the feature.

### Email 3: The Soft Close
**Subject:** "Last thing on [venture/topic]"
**Body:** Brief recap + time-bound element ("launching publicly next week" or "first 50 spots"). No guilt. No desperation.
**Rules:** Under 80 words. If they haven't responded to 2 emails, respect that. This is a nudge, not a push.

---

## 2. LinkedIn Warm Outreach Sequence (DOCX)

**File:** `core/linkedin-warm-sequence.docx`
**Format:** 3 messages + optional connection note

### Connection Note (if not already connected)
```
[First Name] — saw your work on [specific thing]. Building something in the same space.
Would love to connect.
```
Max 50 characters for the note. No pitch.

### Message 1: Value Give
```
Hey [First Name],

Just launched [Venture Name] — [one sentence what it does].

Thought this might be relevant given your work in [their area].

Here's a [quick demo / resource / insight]: [link]

No ask — just sharing.
```
**Rules:** Under 60 words. No ask in first message. Pure value.

### Message 2: The Ask
```
Hey [First Name],

Quick question — would a [specific outcome from your product] be useful for [their context]?

Happy to show you in 15 min if interested. If not, no worries at all.
```
**Rules:** Under 50 words. One question. One CTA.

### Message 3: Breakup
```
Hey [First Name],

Last ping on this. If timing's not right, totally get it.

[Venture Name] will be here when it makes sense. Cheers.
```
**Rules:** Under 30 words. No guilt. Leave door open.

---

## 3. WhatsApp Warm Sequence (DOCX)

**File:** `core/whatsapp-warm-sequence.docx`
**Format:** 3 messages + voice note script

### Message 1: Casual Announcement
```
Hey [Name]! 👋

Quick heads up — just launched [Venture Name].

[One line: what it does for who]

Check it out: [link]
```
**Rules:** Under 30 words. Casual. Emoji OK (one max). Like texting a friend.

### Voice Note Script (30 seconds)
```
"Hey [Name], it's [Founder]. Quick update — I just launched [Venture Name].
Basically it [one sentence outcome]. Already seeing [proof point].
If you know anyone who [ICP description], would love an intro.
Or check it out yourself at [URL]. Talk soon."
```
**Rules:** Conversational. Under 30 seconds when spoken. No corporate speak.

### Message 2: Social Proof
```
[Name] — just got this from [beta user/early customer]:

"[One-line testimonial or result]"

Thought you'd find it interesting. [Link]
```

### Message 3: Direct CTA
```
[Name] — launching publicly [timeframe].

Want to get you in before that. Worth 15 min?

[Calendly/booking link]
```

**Arabic variant (if language = Arabic or Both):**
All WhatsApp messages should be in conversational Gulf Arabic. Not MSA. Example tone:
```
يا [Name]! عندي شي حلو أبي أشاركك فيه...
```

---

## 4. Landing Page (HTML)

**File:** `core/landing-page.html`
**Quality benchmark:** Match the production quality of smorchestra-home-ghl.html and the-engine-ghl.html

### Technical Requirements
- Single HTML file, self-contained (inline CSS, Google Fonts link only)
- CSS variables for ALL colors — customer changes 4 variables, entire page updates:
  ```css
  :root {
    --primary: [customer color 1];
    --primary-hover: [darker variant];
    --primary-glow: [rgba glow variant];
    --bg: [customer color 2 or #000000];
    --bg-alt: [slightly different bg];
    --text: [auto: white if dark bg, dark if light bg];
    --text-muted: [mid-tone gray];
    --accent: [customer color 3 if provided];
  }
  ```
- Mobile responsive (max-width breakpoints at 768px, 480px)
- If Arabic: `dir="rtl"`, Cairo + Tajawal fonts, RTL layout adjustments
- If English: Inter font, LTR layout

### Page Sections (in order)

**1. Navigation Bar**
- Logo text (venture name) with accent color
- 3-4 nav links: How It Works, Features/Benefits, Pricing, CTA button
- Sticky, blur backdrop, border-bottom subtle

**2. Hero Section**
- Full viewport height
- Badge/pill: category or trust signal (e.g., "BUILT FOR MENA FOUNDERS")
- H1: Headline from positioning.md (bold, large, accent color on key word)
- Subtitle: 1-2 sentences expanding the headline
- Primary CTA button + ghost/secondary CTA
- Trust bar: "Trusted by X founders" or "X products launched"
- Subtle dot-grid or gradient background pattern

**3. Problem Section**
- Light/contrasting background
- "THE PROBLEM" eyebrow text
- H2: Pain statement from ICP's top pain
- 3 pain cards with icons (pain 1, pain 2, pain 3 from icp.md)
- Each card: icon + title + 1-sentence description

**4. Solution Section**
- "THE SOLUTION" eyebrow
- H2: How [Venture Name] solves it
- 3-step process visualization (step 1 → step 2 → step 3)
- Each step: number + title + description
- Unique mechanism callout box

**5. Features/Benefits Section**
- Grid of 4-6 feature cards
- Each: icon placeholder + title + 2-line description
- Focus on outcomes not features ("Get X" not "Has X feature")

**6. Social Proof Section**
- Testimonial cards (2-3, with placeholder names/companies)
- Stats bar: 3-4 key numbers (users, outcomes, growth)
- Trust logos placeholder area

**7. Pricing Section (if applicable)**
- 2-3 tier cards
- From companyprofile.md pricing tiers
- Highlight recommended tier
- CTA per tier

**8. Final CTA Section**
- Dark/accent background
- Strong headline: "Ready to [outcome]?"
- Subtitle: urgency or scarcity element
- Large CTA button
- Supporting text: "No credit card required" or similar friction reducer

**9. Footer**
- Venture name + one-liner
- Contact: email
- Social links placeholders
- Copyright

### CSS Quality Standards (from SMO benchmark)
- Smooth transitions (0.3s ease) on all interactive elements
- Box shadows with accent glow on primary buttons
- Clamp() for responsive typography: `clamp(2rem, 5vw, 3.5rem)`
- Consistent spacing rhythm (2rem, 3rem, 5rem sections)
- Card hover effects (translateY, shadow increase)
- Gradient overlays on hero
- Eyebrow text: uppercase, letter-spacing 0.15em, font-weight 700

---

## 5. LinkedIn Launch Posts (DOCX)

**File:** `core/linkedin-launch-post-1.docx` and `core/linkedin-launch-post-2.docx`

### Post 1: Story-Driven Launch
```
[Hook line — pattern interrupt, personal, specific]

[2-3 sentences: the backstory — why I built this]

[The problem I kept seeing — use ICP pain language]

[What I built — one sentence, specific]

[Early result or validation — specific number if possible]

[CTA: "Check it out: [link]" or "DM me 'launch' and I'll send you access"]

[1-3 relevant hashtags max]
```
**Rules:** 150-250 words. First line must stop the scroll. No "Excited to announce." No corporate tone. Write like you're telling a friend.

### Post 2: Value-Driven Launch (post 3 days after Post 1)
```
[Hook: specific outcome or contrarian take]

[3 specific things your product enables:]
→ [Outcome 1 — specific, measurable]
→ [Outcome 2 — specific, measurable]
→ [Outcome 3 — specific, measurable]

[One line: who this is for]

[CTA: link or DM trigger]
```
**Rules:** 120-200 words. Lead with outcomes, not features. Arrow format for scanability.

---

## 6. Company 1-Pager (DOCX)

**File:** `core/company-one-pager.docx`
**Format:** Single page, clean layout, brand colors applied

### Structure
```
[HEADER]
[Venture Name]                    [Logo placeholder]
[One-liner from companyprofile.md]

[PROBLEM]  (2-3 sentences)
[ICP pain description using their actual language]

[SOLUTION]  (2-3 sentences)
[What the product does + unique mechanism from positioning.md]

[FOR WHO]  (1 sentence)
[ICP description: title, company size, location, situation]

[WHY NOW]  (2-3 bullet points)
• [Market timing signal 1 from market-analysis.md]
• [Market timing signal 2]
• [Growth data point]

[TRACTION]  (2-3 bullet points)
• [Validation evidence]
• [Beta users/waitlist/revenue if available]
• [Partnerships or integrations]

[PRICING]
[Tier overview from companyprofile.md — keep to 1-2 lines per tier]

[CTA]
[Low-friction next step: "Book 15 min: [link]" or "Start free: [link]"]
[Contact: email, LinkedIn, website]
```

**Rules:**
- Max 400 words total
- At least one specific number (market size, users, growth %)
- CTA must be low-friction
- Brand colors: colored header bar, accent on section headers
- Clean sans-serif font (Inter or equivalent in DOCX)

---

## 7. 10-Slide Pitch Deck (PPTX)

**File:** `core/pitch-deck-10slides.pptx`
**Format:** 16:9 slides, customer brand colors throughout

### Slide Master Config
- Background: customer's bg color (or white)
- Title font: Bold, customer's primary color for emphasis
- Body font: Regular weight, dark gray or white depending on bg
- Accent elements: primary color bars, dividers, highlights
- Footer: venture name + slide number (small, bottom right)

### Slide-by-Slide Spec

**Slide 1: Title**
- Venture name (large, centered or left-aligned)
- One-liner subtitle
- Logo placeholder area
- Tagline or positioning statement
- Website URL

**Slide 2: The Problem**
- H2: "The Problem"
- 3 pain points from icp.md (Pain 1, 2, 3)
- Each: bold title + 1-sentence description
- Optional: supporting stat from market-analysis.md

**Slide 3: The Solution**
- H2: "[Venture Name]: [One-liner]"
- What it does in 2-3 bullet points
- Unique mechanism from positioning.md highlighted
- Screenshot/demo placeholder box

**Slide 4: How It Works**
- H2: "How It Works"
- 3-step visual flow: Step 1 → Step 2 → Step 3
- Each step: icon placeholder + title + 1-line description
- Arrow or connector between steps

**Slide 5: Market Opportunity**
- H2: "Market Opportunity"
- TAM / SAM / SOM from market-analysis.md
- 2-3 growth signals (data points with sources)
- MENA-specific market context

**Slide 6: Traction**
- H2: "Traction"
- Key metrics: users, revenue, waitlist, beta feedback
- Timeline of milestones (if any)
- Testimonial quote (if available)
- If pre-launch: validation evidence, design partner commitments

**Slide 7: Business Model**
- H2: "Business Model"
- Pricing tiers from companyprofile.md
- Unit economics (if available)
- Revenue model diagram or table

**Slide 8: GTM Strategy**
- H2: "Go-To-Market"
- The selected GTM motion explained in 3-4 bullets
- Why this motion fits (1 sentence from SC5 reasoning)
- 90-day launch timeline overview

**Slide 9: Team**
- H2: "Team"
- Founder: name, title, 2-line bio from founderprofile.md
- Credibility signals: years of experience, relevant companies, domain expertise
- Advisor/partner placeholder slots

**Slide 10: The Ask / CTA**
- H2: "Let's Talk" or "Next Steps"
- What you're asking for (partnership, investment, pilot, etc.)
- Contact info: email, LinkedIn, website, phone
- QR code placeholder for booking link
- Closing line: one-sentence vision statement

### PPTX Quality Standards
- Consistent margins: 0.5" all sides
- Title text: 28-36pt
- Body text: 18-22pt
- Bullet text: 16-18pt
- Max 6 lines of text per slide
- No walls of text — if it needs that many words, split the slide
- Brand color accent bar on each slide (top or side)
- Slide numbers in footer
