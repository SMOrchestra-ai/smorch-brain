# Market-Specific Playbooks

Channel preferences, timing, and cultural rules by market.

## Table of Contents
1. MENA Playbook (UAE, Saudi, Qatar, Kuwait, Bahrain, Oman)
2. US Playbook
3. EU Playbook
4. Market Detection Logic
5. Language & Content Rules
6. Cross-Market Campaigns

---

## MENA Playbook

### Channel Priority
1. **LinkedIn** (primary) — Professional network of choice for Gulf business
2. **WhatsApp** (secondary, after signal) — Ubiquitous in MENA business, feels personal
3. **Email** (tertiary) — Lower open rates than US/EU, but still effective for follow-up
4. **SMS** (rarely) — Mostly for appointment reminders, not cold outreach

### Why This Order
MENA business culture values relationship and trust over efficiency. LinkedIn creates
a visible professional identity (credibility check). WhatsApp is where real business
conversations happen in the Gulf. Email is seen as more formal/transactional.

### Timing Rules
| Parameter | Value | Notes |
|-----------|-------|-------|
| Work days | Sunday — Thursday | Friday-Saturday is weekend |
| Business hours | 08:00 — 17:00 Gulf Time (UTC+4) | Avoid lunch 12:30-13:30 |
| Best email send time | 09:00-10:30 or 14:00-15:00 | Morning slot outperforms |
| Best LinkedIn time | 08:00-09:00 or 16:00-17:00 | Start/end of day browsing |
| WhatsApp hours | 09:00-16:00 ONLY | NEVER evening/weekend |
| Ramadan adjustment | Reduce volume 50%, shift hours to 10:00-14:00 | Respect shorter work days |
| Summer adjustment | Jun-Aug: many execs travel, reduce volume 30% | Low response rates |

### Recommended Patterns
- **Primary:** Pattern C (Signal-Triggered Multi-Touch) — maximizes WhatsApp escalation
- **Secondary:** Pattern B (LinkedIn-First) — for LinkedIn-only campaigns
- **Enterprise:** Pattern D with CEO on WhatsApp channel

### Cultural Notes for Content
- Formal but warm greeting: "Dear [FirstName]" in email, casual on LinkedIn/WhatsApp
- Reference shared geography: "fellow [Dubai/Riyadh/Doha]-based" creates instant rapport
- Mutual connections are GOLD — mention them prominently
- Arabic name detection → consider Arabic WhatsApp message variant
- Avoid aggressive "you're losing money" fear-based copy — Gulf professionals respond better to aspiration/growth framing
- Case studies from Gulf companies >2x more effective than US case studies
- Friday is sacred — never send anything on Friday

### MENA Sub-Markets
| Market | Notes |
|--------|-------|
| UAE | Most digitally mature, English + Arabic, WhatsApp dominant |
| Saudi Arabia | Rapidly growing, Arabic-first, Vision 2030 signals are strong |
| Qatar | Small market, relationship-heavy, reference mutual connections |
| Kuwait | Conservative, Arabic-first, slower decision cycles |
| Bahrain | Finance hub, English common, FinTech signals strong |
| Oman | Smaller market, government-heavy, slower cycles |
| Jordan/Egypt/Lebanon | Levant different from Gulf — more price-sensitive, email works better |

---

## US Playbook

### Channel Priority
1. **Email** (primary) — Highest volume, fastest deployment, most measurable
2. **LinkedIn** (secondary) — Professional credibility, connection building
3. **SMS** (tertiary, after engagement) — Only for warm leads who've engaged
4. **WhatsApp** (rarely) — US professionals don't use WhatsApp for business

### Why This Order
US B2B culture values efficiency and data over relationship ceremony. Cold email is
accepted and expected. LinkedIn is the professional layer. SMS feels invasive unless
there's an existing relationship.

### Timing Rules
| Parameter | Value | Notes |
|-----------|-------|-------|
| Work days | Monday — Friday | Saturday-Sunday is weekend |
| Business hours | 09:00 — 17:00 local timezone | Use lead's timezone, not yours |
| Best email send time | 07:00-09:00 or 13:00-14:00 local | Tuesday-Thursday outperform |
| Best LinkedIn time | 07:00-08:00 or 17:00-18:00 local | Commute/wrap-up browsing |
| SMS hours | 10:00-16:00 local ONLY | TCPA compliance considerations |
| Holiday blackouts | Thanksgiving week, Dec 24-Jan 2, July 4 week | Very low response |

### US Timezone Handling
| Lead Location | Timezone | UTC Offset |
|--------------|----------|------------|
| East Coast (NY, Boston, DC) | America/New_York | UTC-5 |
| Central (Chicago, Dallas, Houston) | America/Chicago | UTC-6 |
| Mountain (Denver, Phoenix) | America/Denver | UTC-7 |
| West Coast (LA, SF, Seattle) | America/Los_Angeles | UTC-8 |

When timezone unknown, default to America/Chicago (Central) — it's the safest middle ground.

### Recommended Patterns
- **Primary:** Pattern A (Email-First → LinkedIn Follow) — volume efficient
- **Enterprise:** Pattern D with CEO on LinkedIn (not WhatsApp)
- **Tech/Startup:** Pattern A compressed (5-day sprint) — faster pace accepted

### Cultural Notes for Content
- Direct and specific — US professionals respect brevity
- Lead with data/metrics: "Companies like X see Y% improvement"
- Pattern interrupt in subject line: question, stat, or contrarian take
- "Cold" is fine — US professionals expect and accept outbound
- Avoid: flowery language, excessive politeness, long preambles
- CTA: Direct ask — "15 minutes this week?" beats "would you be open to..."
- Reference their company's recent news/funding/product launch

---

## EU Playbook

### Channel Priority
1. **LinkedIn** (primary) — Professional standard across EU
2. **Email** (secondary) — GDPR considerations, but effective with legitimate interest
3. **SMS** (rarely) — Strict GDPR, consent required
4. **WhatsApp** (Germany/DACH only) — Common in Germany, rare elsewhere

### GDPR Considerations
- **Legitimate interest** basis for B2B outbound (not consent)
- Must include opt-out mechanism in every email
- Must have clear data processing basis documented
- No email to personal addresses — only business emails
- Right to be forgotten — if they ask for removal, comply within 72hrs

### Timing Rules
| Parameter | Value | Notes |
|-----------|-------|-------|
| Work days | Monday — Friday | Varies by country |
| Business hours | 09:00 — 17:30 local | EU has longer lunch breaks in Southern Europe |
| Best email send time | 09:00-10:00 or 14:00-15:00 local | Tuesday-Thursday |
| UK | GMT/BST | Most similar to US patterns |
| Germany/DACH | CET/CEST | LinkedIn + Email, formal tone |
| France | CET/CEST | LinkedIn-first, email formal, longer sales cycles |
| Nordics | CET/EET | Direct like US, shorter emails, LinkedIn active |

### Recommended Patterns
- **Primary:** Pattern B (LinkedIn-First) — trust-building approach suits EU
- **UK:** Pattern A (Email-First) — closer to US style
- **DACH (Germany/Austria/Swiss):** Pattern B with WhatsApp option for warm leads

---

## Market Detection Logic

When the orchestrator receives a lead list, detect market automatically:

```
FUNCTION: detect_market(lead)

1. Check location field:
   - Contains UAE/Dubai/Abu Dhabi/Saudi/Riyadh/Jeddah/Qatar/Doha/Kuwait/Bahrain/Oman → MENA
   - Contains US state/city OR United States → US
   - Contains UK/Germany/France/etc → EU

2. Check phone prefix:
   - +971 → UAE | +966 → Saudi | +974 → Qatar | +965 → Kuwait → MENA
   - +1 → US
   - +44 → UK | +49 → Germany | +33 → France → EU

3. Check email domain:
   - .ae, .sa, .qa, .kw → MENA
   - .co.uk, .de, .fr → EU
   - .com → ambiguous, check other signals

4. Check company info:
   - Known MENA companies/industries → MENA
   - Known US/EU companies → respective market

5. Fallback: If unable to detect → ask user
```

### Mixed-Market Lists

If a lead list contains leads from multiple markets:
1. Segment by market FIRST
2. Apply market-specific patterns to each segment
3. Create separate channel campaigns per market (different timing/hours)
4. Track performance per market in GHL tags: geo:mena, geo:us, geo:eu

---

## Language & Content Rules

### Arabic Content (MENA)

| Channel | Language | Style |
|---------|----------|-------|
| LinkedIn connection note | English or Arabic | Depends on lead's LinkedIn language |
| LinkedIn message | English (default) | Arabic if lead's profile is Arabic |
| Email | English (default) | Arabic variant for Arabic-dominant markets |
| WhatsApp | Arabic (Gulf dialect) | Mix English tech terms naturally |

**Arabic Style Guidelines:**
- Gulf Arabic conversational tone, NOT Modern Standard Arabic (MSA)
- Don't over-formalize — Gulf WhatsApp is casual
- English tech terms stay in English: "CRM", "ROI", "SaaS", "pipeline"
- Use local greetings: "السلام عليكم" for opening, not just "مرحبا"

### Arabic Name Detection Heuristic

For automated language selection in WhatsApp templates:

```
Common Arabic first names (sample):
Ahmed, Mohammed, Ali, Hassan, Khalid, Omar, Saeed, Faisal, Abdulrahman,
Nasser, Sultan, Rashid, Ibrahim, Yousef, Hamad, Tariq, Saleh, Majid,
Fatima, Aisha, Maryam, Noura, Hessa, Latifa, Reem, Sara (Arabic spelling)

IF first_name matches Arabic name patterns
  AND (location is MENA OR phone starts with MENA prefix)
  THEN → Arabic WhatsApp template
  ELSE → English WhatsApp template
```

### English Content (US/EU/Global)

Standard English, direct tone. Adjust formality:
- US: Casual, direct, data-driven
- UK: Slightly more formal, less aggressive
- DACH: More formal, reference credentials/certifications
- Nordic: Direct and brief, similar to US

---

## Cross-Market Campaigns

When running a global campaign that spans markets:

1. **Never mix timezones in one campaign** — Create separate channel campaigns per timezone region
2. **Unified messaging, localized execution** — Same wedge, different channel priority
3. **GHL as central hub** — All leads in same pipeline, tagged by market
4. **Separate analytics** — Compare performance WITHIN markets, not across (MENA benchmarks ≠ US benchmarks)
5. **Stagger launches** — Start MENA Sunday, US Monday, EU Tuesday. Avoids overwhelming response capacity.
