# MENA Deep Overlay

> Injectable MENA contextualization layer. NOT enforced globally.
> Activated per-project via `CLAUDE.md` toggle (`mena_overlay: true`) or Linear tag `mena-context`.

---

## When to Activate

- Client deliverable targets UAE, Saudi, Qatar, or Kuwait
- Product has Arabic UI, RTL content, or Gulf-market users
- Campaign targets MENA prospects (email, LinkedIn, WhatsApp)
- Pricing involves AED, SAR, QAR, or KWD
- Feature involves Arabic text input, search, sort, or PDF export

## When NOT to Activate

- Pure infrastructure / DevOps work with no user-facing component
- Internal tooling used only by the dev team
- Global SaaS features with no MENA-specific logic
- English-only content targeting US/EU markets

---

## Language Rules

| Rule | Detail |
|------|--------|
| Arabic dialect | Gulf conversational Arabic. NOT Modern Standard Arabic (MSA). |
| Tech terms | Stay in English (API, CRM, webhook, deployment) |
| Numbers | Western Arabic numerals (1, 2, 3) not Eastern Arabic |
| Mixed content | Arabic body text, English technical terms inline |
| Tone | Professional but warm. Relationship-first language. |

---

## Currency

Always show local currency with USD equivalent:

| Market | Primary | Format Example |
|--------|---------|---------------|
| UAE | AED | AED 5,000 (~USD 1,360) |
| Saudi | SAR | SAR 7,500 (~USD 2,000) |
| Qatar | QAR | QAR 3,640 (~USD 1,000) |
| Kuwait | KWD | KWD 310 (~USD 1,010) |

---

## Code Review Additions

When MENA overlay is active, add these to every code review checklist:

- [ ] RTL text rendering correct (CSS `direction: rtl`, `text-align` overrides)
- [ ] Mixed LTR/RTL content displays correctly (bidirectional isolation)
- [ ] WhatsApp template message within 1024 character limit
- [ ] Date format: DD/MM/YYYY (Gulf standard)
- [ ] Phone numbers in E.164 format (+971, +966, +974, +965)
- [ ] Arabic form validation (right-to-left input, Arabic character ranges)
- [ ] Arabic PDF rendering tested (font embedding, RTL layout)
- [ ] Search handles Arabic text (diacritics, Hamza variants, Alef normalization)

---

## Stakeholder Communication

| Audience | Language | Style |
|----------|----------|-------|
| Executive / C-suite | English with Arabic business terms | Formal, ROI-focused, numbers first |
| Client-facing | Gulf Arabic | Warm, relationship-acknowledging, concise |
| Status updates | English | Green / Yellow / Red with Arabic labels |

Status label mapping:
- Green = ممتاز (Excellent)
- Yellow = يحتاج متابعة (Needs follow-up)
- Red = عاجل (Urgent)

---

## Timing and Calendar

| Item | Detail |
|------|--------|
| Gulf weekends | Friday - Saturday |
| Working week | Sunday - Thursday |
| Time zones | Dubai UTC+4, Amman UTC+3, Riyadh UTC+3 |
| Ramadan | Reduced working hours (~6hrs), no cold outreach during fasting hours |
| Eid al-Fitr | 3-5 day holiday, no deploys or launches |
| Eid al-Adha | 3-5 day holiday, no deploys or launches |
| UAE National Day | December 2-3, reduced availability |

---

## Competitive Landscape (MENA Players)

| Category | Players | Notes |
|----------|---------|-------|
| WhatsApp Business | Rasayel, Respond.io | WhatsApp is primary business channel in Gulf |
| HR / Payroll | Bayzat, ZenHR | UAE/Saudi focused |
| CRM | Zoho ME, Freshworks ME | Local presence matters |
| Pricing | Higher tolerance for premium pricing | Relationship + trust > lowest price |
| Outreach | WhatsApp > Email > LinkedIn | Email open rates lower in MENA; WhatsApp dominates |

---

## Sprint Planning Adjustments

- Account for Ramadan (reduced capacity ~30%)
- Block deploys during Eid holidays
- UAE National Day (Dec 2-3): no releases
- Sun-Thu working week: align sprint boundaries accordingly
- Friday standup = skip or async

---

## User Research Context

| Behavior | Implication |
|----------|------------|
| Relationship-based buying | Demos + in-person meetings before purchase decisions |
| Slower then faster trust cycle | Initial evaluation is long; once trust is earned, decisions are fast |
| In-person preference | Video call < in-person. Budget for travel. |
| WhatsApp primary | All nurture sequences should have WhatsApp variant |
| Group decision-making | Multiple stakeholders; provide shareable assets |

---

## Feature Spec Requirements

When MENA overlay is active, every feature spec must include:

- [ ] Arabic RTL test cases (input, display, export)
- [ ] "Gulf business owner" persona in user stories
- [ ] Arabic search, sort, and filter behavior specified
- [ ] Arabic PDF export tested
- [ ] WhatsApp delivery as a channel option (not just email/SMS)
- [ ] Date/time format: DD/MM/YYYY, 12-hour clock with AM/PM

---

## MENA Benchmarks

| Channel | Expected Rate | Notes |
|---------|--------------|-------|
| Email open rate | 25-35% | Lower than US/EU; subject line in English performs better for B2B |
| LinkedIn connection accept | 30-40% | Higher with Arabic greeting + English body |
| WhatsApp response rate | 45-60% | Dominant channel; best for warm + re-engagement |
| Sales cycle (B2B) | 4-8 weeks | Faster with referral; slower cold |
| Meeting show rate | 60-70% | Higher with WhatsApp reminder 1hr before |
