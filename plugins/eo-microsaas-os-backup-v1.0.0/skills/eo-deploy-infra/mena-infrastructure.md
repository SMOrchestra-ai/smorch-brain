# EO Deploy Infra - MENA Infrastructure Considerations

Reference file for MENA-specific server location, payment webhooks, WhatsApp hosting, DNS, and compliance.

---

## Server Location for Latency

- **Serving GCC users**: Choose Frankfurt or Amsterdam server (best latency to Gulf via submarine cables)
- **Serving Egypt/North Africa**: Choose Frankfurt or Paris
- **Serving global**: Frankfurt is the best compromise
- Cloudflare CDN handles static asset caching regardless of server location
- Test latency from Dubai, Riyadh, Cairo to confirm < 200ms TTFB

---

## Regional Payment Webhook Reliability

- MENA payment gateways (Tap, HyperPay) can have higher webhook latency
- Implement webhook retry logic (don't assume first delivery succeeds)
- Log all webhook payloads for debugging
- Set webhook timeout to 30 seconds (not the default 10)

---

## WhatsApp Business API Hosting

- If the product uses WhatsApp Business API:
  - Consider Meta's Cloud API (no self-hosting needed)
  - If self-hosting: dedicated container for the WhatsApp client
  - Webhook endpoint must be HTTPS with valid SSL

---

## DNS and Domain Considerations

- `.com` domains work everywhere
- `.ae` or `.sa` ccTLDs add local credibility but have registration requirements
- Arabic domain names (IDN) are supported but add complexity
- Recommendation: use `.com` for MVP, add ccTLD later if needed

---

## Compliance Notes

- UAE: No specific data localization requirements for most SaaS
- Saudi Arabia: NDMO data localization rules may apply for government-adjacent data
- Egypt: Some data localization requirements for financial data
- Default: host in EU (Frankfurt) for GDPR-adjacent protection, move to region-specific hosting only if legally required
