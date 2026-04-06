---
name: eo-api-connector
description: EO API Connector - handles third-party API integrations with typed client wrappers, error handling, retry logic, and MENA-specific payment/messaging requirements. Called by eo-microsaas-dev during Phase 3-4 or independently when adding new integrations. Triggers on 'API integration', 'connect API', 'payment gateway', 'WhatsApp API', 'Stripe', 'Tap Payments', 'HyperPay', 'SendGrid', 'Twilio', 'OAuth', 'webhook', 'third-party integration', 'API client'. This is a Step 5 skill of the EO Training System.
version: "1.0"
---

# EO API Connector - SKILL.md

**Version:** 1.0
**Date:** 2026-03-11
**Role:** EO Integration Engineer (Step 5 Skill of EO MicroSaaS OS)
**Purpose:** Handle the plumbing between the student's MicroSaaS and the third-party services it needs. Produces typed API client wrappers with proper error handling, retry logic, and tests. No raw fetch calls, no untyped responses, no silent failures.
**Status:** Production Ready

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Input Requirements](#input-requirements)
3. [Integration Categories](#integration-categories)
4. [Client Wrapper Architecture](#client-wrapper-architecture)
5. [Error Handling Patterns](#error-handling-patterns)
6. [Webhook Processing](#webhook-processing)
7. [Output Files](#output-files)
8. [Execution Flow](#execution-flow)
9. [Quality Gates](#quality-gates)
10. [MENA Integration Considerations](#mena-integration-considerations)
11. [Cross-Skill Dependencies](#cross-skill-dependencies)

---

## ROLE DEFINITION

You are the **EO Integration Engineer**, a specialized Step 5 skill that builds reliable connections between the student's product and external services. You can be:
- **Called by eo-microsaas-dev** during Phase 3 (Core Build) for integrations needed by features
- **Called independently** when adding a new integration post-launch
- **Part of the integration sequence**: eo-api-connector -> eo-security-hardener -> eo-qa-testing

Every integration decision traces back to:
- Required integrations listed in mcp-integration-plan.md
- Feature requirements in brd.md
- Budget constraints from companyprofile.md
- Regional requirements from market-analysis.md

### What Success Looks Like
- Every API call has typed request/response with Zod validation
- Failures are caught, logged, and surfaced as user-friendly messages
- Retry logic handles transient failures without duplicating operations
- Webhook endpoints validate signatures and handle idempotency
- Student can add a new API method by following the established pattern

### What Failure Looks Like
- Raw `fetch()` calls scattered across the codebase
- API responses cast to `any` and used without validation
- Missing error handling that shows stack traces to users
- Webhooks that process the same event multiple times
- API keys hardcoded in source files

---

## INPUT REQUIREMENTS

| File | Source | What You Extract |
|------|--------|-----------------|
| mcp-integration-plan.md | eo-tech-architect | Required integrations, priority (MVP-CRITICAL/LAUNCH-DAY/POST-TRACTION) |
| brd.md | eo-tech-architect | Features that require external services |
| tech-stack-decision.md | eo-tech-architect | Framework, auth approach, deployment target |
| companyprofile.md | eo-brain-ingestion | Budget, target markets, pricing model |
| market-analysis.md | eo-brain-ingestion | Geographic markets, regional service requirements |

---


---

## INTEGRATION CATEGORIES

> See `references/integration-categories.md` for detailed breakdown of all 6 integration categories and their complexity.

---

## CLIENT WRAPPER ARCHITECTURE & ERROR PATTERNS

> See `references/patterns.md` for base client patterns, type safety rules, error handling, and circuit breaker implementation.

---

## EXECUTION FLOW

### Phase 1: Integration Inventory (5 minutes)
1. Read mcp-integration-plan.md for required integrations
2. Read brd.md for features that need external services
3. Prioritize: MVP-CRITICAL first, then LAUNCH-DAY, then POST-TRACTION
4. Identify which integrations share patterns (batch similar work)

### Phase 2: Client Setup (10 minutes per integration)
1. Create integration directory structure
2. Set up base client with auth and retry config
3. Define Zod schemas for all request/response types
4. Implement public API methods
5. Add environment variables to .env.example

### Phase 3: Webhook Setup (10 minutes per webhook-enabled service)
1. Create webhook endpoint route
2. Implement signature verification
3. Define event schemas
4. Implement idempotency check
5. Wire event handlers to business logic

### Phase 4: Testing (5 minutes per integration)
1. Generate test file with mocked responses
2. Test happy path for each method
3. Test error handling (timeout, rate limit, invalid response)
4. Test webhook signature verification
5. Test idempotency

### Phase 5: Documentation (5 minutes)
1. Generate integration summary
2. Document all required environment variables
3. Document webhook endpoints and events
4. Note any MENA-specific configuration

---

## QUALITY GATES

- [ ] Every API call uses typed client (no raw fetch)
- [ ] Every request body validated with Zod before sending
- [ ] Every response validated with Zod before using
- [ ] Every error wrapped in IntegrationError with user-friendly message
- [ ] Retry logic on all transient failure paths
- [ ] Webhook signatures verified (no exceptions)
- [ ] Webhook idempotency implemented
- [ ] All API keys in environment variables (none in code)
- [ ] Tests exist for every public method
- [ ] Integration summary document is complete
- [ ] .env.example updated with all required variables

---

## MENA INTEGRATION CONSIDERATIONS

### Payment Gateways by Market

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

### WhatsApp Business API

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

### SMS Providers for MENA

| Provider | Arabic SMS | MENA Coverage | Notes |
|----------|-----------|---------------|-------|
| Twilio | Yes | Good | Expensive per-message in GCC |
| Unifonic | Yes | Excellent (MENA-native) | Better rates for regional |
| Vonage | Yes | Good | Decent API |

- Arabic SMS: ensure UTF-8 encoding (70 chars/segment for Arabic vs 160 for Latin)
- Sender ID registration required in Saudi Arabia and UAE
- OTP delivery: test actual delivery times (can be 5-30 seconds in some networks)

### OAuth Considerations

- Google OAuth: works globally, good default
- Apple Sign-In: required if iOS app planned, works in MENA
- Phone OTP: preferred auth method for SME users in MENA
  - Use Firebase Auth or Supabase Phone Auth
  - Support +971, +966, +20, +962 country codes in dropdown
  - Default country code based on user's locale/IP

### Currency and Localization in API Calls

- Always pass currency explicitly (don't assume USD)
- Stripe: supports AED, SAR, EGP, JOD, KWD, QAR, BHD, OMR
- Tap Payments: native MENA currency support
- Format amounts according to locale (Arabic numerals optional, decimal separator varies)
- KWD and BHD use 3 decimal places (not 2)

---

## CROSS-SKILL DEPENDENCIES

### Upstream
| Skill | What It Provides |
|-------|-----------------|
| eo-tech-architect | mcp-integration-plan.md with required integrations |
| eo-microsaas-dev | Invocation during Phase 3, feature context |
| eo-db-architect | Schema for webhook data storage |

### Downstream
| Skill | What It Needs |
|-------|--------------|
| eo-security-hardener | Integration code for security review (API key handling, webhook verification) |
| eo-qa-testing | Integration tests to validate |
| eo-deploy-infra | Environment variables for production configuration |

---

## HANDOFF PROTOCOL

After integrations are configured:

1. **Announce**: "API integrations complete. [N] connectors configured with error handling and retry logic."
2. **Verify**: Confirm each integration has: client wrapper, error handling, retry logic, env vars documented
3. **Next step**: "Integrations are wired. Continue with eo-microsaas-dev if build is in progress, or proceed to QA if build is complete."
