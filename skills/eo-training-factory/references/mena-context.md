# MENA Context for EO Training

Signal types, market specifics, and cultural patterns that must be embedded in every EO training asset.

## Core Thesis

Signal-based scoring IS available in MENA. The signals are different from Western markets, not absent. This framing is non-negotiable across all content.

## MENA-Specific Buyer Signals

| Signal | Where It Shows | Strength | How to Detect |
|--------|---------------|----------|---------------|
| WhatsApp engagement patterns | Message open rates, response velocity, group participation | High | WhatsApp Business analytics, manual tracking |
| Exhibition attendance | GITEX, LEAP, regional industry events | High | Attendee lists, badge scans, LinkedIn check-ins |
| Government tender activity | Procurement portals, pre-qualification announcements | Very High | Tender boards, e-procurement platforms |
| LinkedIn Arabic-language content | Posts, comments, shares in Arabic | Medium | Sales Navigator alerts, manual monitoring |
| Regional platform activity | Noon, Talabat ecosystem, Careem network effects | Medium | Platform APIs where available |
| Relationship referral chains | Warm introductions | Very High (10x weight) | CRM tracking, WhatsApp intro messages |
| Payment method adoption | Apple Pay, STCPay, tabby | Low-Medium | Proxy for digital readiness, not direct buying signal |

## MENA Market Realities

**Things that work differently:**
- Cold email open rates are lower than Western benchmarks. WhatsApp outreach converts better.
- LinkedIn in Arabic is growing fast but still underutilized. Early movers have outsized reach.
- Enterprise sales cycles involve more stakeholders. But once trust is established, deals close faster.
- Government and semi-government are massive buyers. Tender-based procurement is a legitimate GTM channel.
- Payment processing varies by country. UAE (easy), Saudi (improving), Egypt (challenging), Jordan (limited).

**Things that are the same:**
- Pain-driven buying works everywhere
- Proof of competence beats relationship when the stakes are high enough
- Content marketing compounds (just needs to be in the right language)
- Price sensitivity follows value perception, not absolute numbers

## Currency & Pricing Context

When discussing pricing in training:
- UAE: AED (1 USD ≈ 3.67 AED)
- Saudi Arabia: SAR (1 USD ≈ 3.75 SAR)
- Egypt: EGP (volatile — always use current rate)
- Jordan: JOD (1 USD ≈ 0.71 JOD)

Gulf pricing (UAE/KSA) should reflect premium positioning. Egyptian pricing may need separate tier.

## Example Personas (Reusable)

These can be adapted for any training:

1. **Ahmed, 35, Dubai** — Runs 3 beauty clinics in JLT. Knows exactly what salon software needs but has never shipped code. Currently uses spreadsheets and WhatsApp groups to manage bookings.

2. **Sara, 42, Riyadh** — HR manager at a mid-size company. Sees the gap in Arabic employee onboarding tools. Has manually solved a workflow that 10,000 similar firms also struggle with.

3. **Omar, 38, Cairo** — Independent accountant serving 50+ small businesses. Does the same reconciliation process manually for every client. Knows exactly what an automation tool should do.

4. **Layla, 29, Amman** — Real estate consultant with 8 years experience. Understands broker pain points better than any developer. Tried hiring a developer once — the app never shipped.

5. **Khalid, 45, Abu Dhabi** — Former telecoms executive (15 years). Deep Rolodex in government procurement. Sees how every tender requires the same document prep that could be automated.

## Cultural Content Notes

- Never use alcohol, gambling, or pork references in examples
- Family and community values resonate. "Build something your children will be proud of" works.
- Respect for elders and expertise is strong. Mamoun's 20-year track record is a feature, not a liability.
- "Wasta" (connections) is real but shouldn't be glorified. EO's thesis is that signal-based trust engineering replaces it.
- Arabic humor is different from English. When writing scripts, keep humor observational, not sarcastic.
- Ramadan timing matters for launches. Avoid major pushes during Ramadan unless specifically designed for it.

## Arabic Content Adaptation Rules

When Arabizing content:
1. Build in English first (always). This ensures logical clarity.
2. Arabize with a native speaker's sensibility, not Google Translate. Use hand-written translation dicts, never machine translation.
3. Technical terms can stay in English when Arabic equivalent is awkward (e.g., "SaaS", "MCP", "API").
4. Headlines and hooks must work in Arabic first, they're the first thing the audience sees.
5. Numbers and pricing stay in Western Arabic numerals (1, 2, 3), not Eastern Arabic (١, ٢, ٣) for digital content.
6. Gulf Arabic dialect (Khaleeji), not MSA. Think Dubai WhatsApp group, not Al Jazeera newsroom.
7. Sentence restructuring required: Arabic sentences flow differently. Don't do word-for-word translation.

## V3 Arabization Production Rules

Patterns proven across 16 Arabic file deliveries (5 PPTX, 8 DOCX, 2 XLSX, 1 HTML):

### Translation Dict Approach (Not Machine Translation)
- Extract all unique text from source file programmatically
- Build hand-written Gulf Arabic translation dict
- Sort dict keys by length descending (specific/long FIRST, generic/short LAST)
- Apply programmatically to preserve formatting

### Complex Script Font Requirement
- Office apps use complex script font tags for Arabic rendering
- PPTX: `<a:cs>` element required alongside standard font
- DOCX: `<w:cs>` element required alongside standard font
- Setting only `run.font.name` causes Arabic to render in wrong font
- Default Arabic font: Arial (works across all Office formats)

### ZIP Repair for PPTX
- Source PPTX files may have duplicate ZIP entries
- Run `repair_pptx_zip()` BEFORE loading AND AFTER saving
- Without this: PowerPoint shows "save as recovered" prompt

### RTL Implementation
- PPTX: paragraph-level via `pPr.set('rtl', '1')` and `pPr.set('algn', 'r')`
- DOCX: paragraph-level via `<w:bidi>` and `<w:jc right>`
- XLSX: cell-level via `Alignment(horizontal='right', rtl=True)`
- HTML: document-level via `<html lang="ar" dir="rtl">` plus CSS directional flip

See `references/arabization-engine.md` for complete code and templates.

## Arabic Adaptation for Slide Decks (V3 Production Patterns)

Patterns discovered during WARP RECAP and CONCEPT slide production:

### Brand Terms Stay English
- "W A R P  R E C A P" label: keep in English (it's a brand term, not translatable)
- "CLAUDE CONCEPT" label: keep in English
- Product names, framework names, and branded terminology stay English even in Arabic decks

### Font Handling
- Georgia font (used for WARP RECAP main text) has poor Arabic support
- Switch main text to "Arial" or "Calibri" for Arabic text boxes
- Calibri works for both Arabic and English in the same slide
- Keep font sizing the same as English versions

### RTL Layout Rules
- Center-aligned text (`algn="ctr"` in XML, `WD_ALIGN_PARAGRAPH.CENTER` in python-docx) handles both LTR and RTL identically
- For full RTL layout, use `algn="r"` (right-align) instead of `algn="l"`
- Mixed Arabic/English text in the same text box: let the rendering engine handle bidi; do not force direction

### Step Labels
- "STEP N COMPLETE" can be translated to Arabic ("الخطوة N مكتملة") or kept in English depending on audience
- For bilingual decks: keep the step label in English, add Arabic subtitle below
- "WHAT CARRIES FORWARD" translates to "ما ينتقل للخطوة التالية" or similar

### Slide XML Adaptation
When adapting WARP RECAP XML templates for Arabic:
- Keep all coordinate positions identical (x, y, cx, cy values stay the same)
- Keep color values identical (#0F172A bg, #94A3B8 label, #FF6600 step label)
- Only change: font typeface attribute from `typeface="Georgia"` to `typeface="Arial"` for Arabic text boxes
- Add `lang="ar-SA"` attribute to `<a:rPr>` elements for Arabic text runs
