# EO Security Hardener - MENA Security Considerations

Reference file for MENA-specific security requirements and data privacy regulations.

---

## Data Privacy Regulations

### UAE
- Federal Decree-Law No. 45 of 2021 (Personal Data Protection Law)
- Consent required for data collection
- Right to access, rectify, delete personal data
- Data breach notification within "a reasonable time"

### Saudi Arabia
- Personal Data Protection Law (PDPL, effective Sept 2023)
- Stricter than UAE: explicit consent for data processing
- Data localization requirements for certain categories
- Heavy penalties for non-compliance

### Egypt
- Law No. 151 of 2020 (Personal Data Protection Law)
- Consent-based processing
- Cross-border data transfer restrictions

**Minimum compliance for MVP:**
- Privacy policy page (required)
- Cookie consent banner
- Data deletion capability (user can delete their account and data)
- Encrypted data in transit (HTTPS) and at rest (Supabase encryption)

---

## Phone Number Security

- Phone numbers are more sensitive in MENA (tied to national ID in some countries)
- Store in hashed form if only used for verification
- Never expose full phone numbers in API responses (mask: +971***1234)
- Phone OTP: use short expiry (5 minutes) and single-use tokens

---

## Arabic Content Security

- XSS payloads can use Arabic characters and RTL override characters
- Sanitize Arabic text input same as English (DOMPurify handles both)
- Watch for Unicode direction override characters (U+202E) in user input
- Bidirectional text can be used to disguise malicious URLs

---

## WhatsApp Security

- WhatsApp Business API tokens: treat as critical secrets
- Webhook payloads from WhatsApp: verify signature before processing
- Template messages: only use pre-approved templates (prevents injection)
- Message content: validate before displaying in product UI

---

## Payment Security for MENA Gateways

- PCI DSS compliance: use hosted payment pages (never handle raw card data)
- Tap Payments, HyperPay: use their hosted checkout (redirect model)
- Webhook verification: each gateway has its own signature method
- Refund authorization: require admin role, log all refund operations
- MADA transactions: follow mada-specific security requirements
