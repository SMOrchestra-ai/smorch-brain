# EO API Connector - MENA Integration Reference

Reference file for MENA-specific payment gateways, WhatsApp, SMS, OAuth, and currency considerations.

---

## Payment Gateways by Market

| Market | Primary Gateway | Notes |
|--------|----------------|-------|
| UAE | Stripe or Tap Payments | Both work well, Stripe has better docs |
| Saudi Arabia | Tap Payments or HyperPay | MADA debit required for Saudi market |
| Egypt | Paymob or Fawry | Cash-on-delivery still common |
| Jordan | Stripe (limited) or CliQ | Bank transfer integration may be needed |
| Kuwait/Qatar/Bahrain | Tap Payments | Regional coverage |
| Global | Stripe | Default for non-MENA users |

**MADA Integration (Saudi Arabia):**
- MADA is Saudi Arabia's debit card network
- Required for Saudi consumers (most don't have Visa/Mastercard)
- Tap Payments and HyperPay support MADA natively
- Test with MADA sandbox cards

---

## WhatsApp Business API

WhatsApp is the primary business communication channel in MENA.

Key requirements:
- Business verification through Meta
- Message templates must be pre-approved (24-72 hour review)
- Template languages: Arabic (ar) and English (en) at minimum
- Session messages (within 24h of user message) are free
- Template messages (outside 24h window) are paid
- Phone number format: E.164 with country code

```typescript
// MENA phone number formatting
const MENA_COUNTRY_CODES = {
  UAE: '+971',
  SA: '+966',
  EG: '+20',
  JO: '+962',
  KW: '+965',
  QA: '+974',
  BH: '+973',
  OM: '+968',
} as const;

function formatWhatsAppNumber(phone: string, country: keyof typeof MENA_COUNTRY_CODES): string {
  const cleaned = phone.replace(/[\s\-\(\)]/g, '');
  const code = MENA_COUNTRY_CODES[country];
  if (cleaned.startsWith(code)) return cleaned;
  if (cleaned.startsWith('0')) return `${code}${cleaned.slice(1)}`;
  return `${code}${cleaned}`;
}
```

---

## SMS Providers for MENA

| Provider | Arabic SMS | MENA Coverage | Notes |
|----------|-----------|---------------|-------|
| Twilio | Yes | Good | Expensive per-message in GCC |
| Unifonic | Yes | Excellent (MENA-native) | Better rates for regional |
| Vonage | Yes | Good | Decent API |

- Arabic SMS: ensure UTF-8 encoding (70 chars/segment for Arabic vs 160 for Latin)
- Sender ID registration required in Saudi Arabia and UAE
- OTP delivery: test actual delivery times (can be 5-30 seconds in some networks)

---

## OAuth Considerations

- Google OAuth: works globally, good default
- Apple Sign-In: required if iOS app planned, works in MENA
- Phone OTP: preferred auth method for SME users in MENA
  - Use Firebase Auth or Supabase Phone Auth
  - Support +971, +966, +20, +962 country codes in dropdown
  - Default country code based on user's locale/IP

---

## Currency and Localization in API Calls

- Always pass currency explicitly (don't assume USD)
- Stripe: supports AED, SAR, EGP, JOD, KWD, QAR, BHD, OMR
- Tap Payments: native MENA currency support
- Format amounts according to locale (Arabic numerals optional, decimal separator varies)
- KWD and BHD use 3 decimal places (not 2)
