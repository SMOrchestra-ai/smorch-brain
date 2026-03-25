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

**Reference Files:**
- [patterns.md](patterns.md) - Client wrapper architecture, error handling, retry logic, webhook processing code patterns
- [mena-integrations.md](mena-integrations.md) - MENA payment gateways, WhatsApp API, SMS providers, OAuth, currency reference

---

## TABLE OF CONTENTS

1. [Role Definition](#role-definition)
2. [Input Requirements](#input-requirements)
3. [Integration Categories](#integration-categories)
4. [Output Files](#output-files)
5. [Execution Flow](#execution-flow)
6. [Quality Gates](#quality-gates)
7. [Cross-Skill Dependencies](#cross-skill-dependencies)

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

## INTEGRATION CATEGORIES

### Category 1: Payments (Complexity: HIGH)

**Services:** Stripe, Tap Payments, HyperPay, PayPal, MADA

Key patterns:
- Webhook-driven architecture (never rely on client-side confirmation)
- Idempotency keys on all mutation requests
- Currency handling with proper decimal precision
- Subscription lifecycle: create, upgrade, downgrade, cancel, pause
- Refund flow with partial refund support
- Receipt/invoice generation

**MVP-CRITICAL if:** Product has any paid tier

```typescript
// Payment client wrapper pattern
import { z } from 'zod';

const CreateCheckoutSchema = z.object({
  priceId: z.string(),
  customerId: z.string(),
  currency: z.enum(['USD', 'AED', 'SAR', 'JOD', 'EGP', 'KWD', 'QAR', 'BHD', 'OMR']),
  successUrl: z.string().url(),
  cancelUrl: z.string().url(),
});

const CheckoutResponseSchema = z.object({
  id: z.string(),
  url: z.string().url(),
  status: z.enum(['open', 'complete', 'expired']),
});

export async function createCheckoutSession(
  input: z.infer<typeof CreateCheckoutSchema>
): Promise<z.infer<typeof CheckoutResponseSchema>> {
  const validated = CreateCheckoutSchema.parse(input);

  const response = await paymentClient.post('/checkout/sessions', {
    body: validated,
    idempotencyKey: generateIdempotencyKey(validated),
  });

  return CheckoutResponseSchema.parse(response);
}
```

### Category 2: Messaging (Complexity: MEDIUM)

**Services:** WhatsApp Business API, Twilio, SendGrid

Key patterns:
- Template-based messaging (WhatsApp requires pre-approved templates)
- Rate limit awareness with queue-based sending
- Delivery status tracking via webhooks
- Opt-in/opt-out compliance
- Multi-language message templates

**MVP-CRITICAL if:** Product uses WhatsApp or email for notifications

### Category 3: Auth Providers (Complexity: MEDIUM)

**Services:** Google OAuth, Apple Sign-In, Phone OTP

Key patterns:
- Token management (access token, refresh token, expiry)
- Session handling with Supabase Auth
- Account linking (user signs up with email, later adds Google)
- Profile data extraction from provider
- Phone OTP with MENA country code support

**MVP-CRITICAL if:** Product requires user authentication (almost always yes)

### Category 4: Storage (Complexity: LOW-MEDIUM)

**Services:** Supabase Storage, S3, Cloudflare R2

Key patterns:
- Presigned upload URLs (never send files through the API server)
- File type and size validation (server-side, never trust client)
- Image resize/optimization on upload
- CDN URL generation for serving
- Bucket-level access control aligned with RLS

### Category 5: AI Services (Complexity: MEDIUM)

**Services:** Claude API, OpenAI, Gemini

Key patterns:
- Streaming responses for real-time UI
- Token counting and budget management
- Fallback chain (primary -> secondary -> cached response)
- Prompt template management
- Response validation (AI output is untrusted data)

### Category 6: Analytics (Complexity: LOW)

**Services:** PostHog, Mixpanel, Google Analytics

Key patterns:
- Event tracking wrapper (single function, multiple providers)
- User identification on login
- Property enrichment (plan, role, org)
- Server-side tracking for critical events (payments, signups)
- Client-side tracking for UX events (clicks, page views)

For detailed code patterns (base client, error handling, retry, circuit breaker, webhooks), see [patterns.md](patterns.md).
For MENA-specific gateway and messaging details, see [mena-integrations.md](mena-integrations.md).

---

## OUTPUT FILES

### Per Integration
```
src/lib/integrations/[service-name]/
  client.ts         # HTTP client with base URL, auth, timeout
  types.ts          # Zod schemas for all request/response shapes
  [service].ts      # Public methods (createCheckout, sendMessage, etc.)
  webhooks.ts       # Webhook verification and event handlers
  __tests__/
    [service].test.ts  # Tests with mocked responses
```

### Integration Summary
```markdown
# API Integration Summary

## Active Integrations
| Service | Category | Priority | Status | Docs |
|---------|----------|----------|--------|------|
| Stripe | Payments | MVP-CRITICAL | Connected | [link] |
| SendGrid | Messaging | LAUNCH-DAY | Connected | [link] |
| ...

## Environment Variables Required
| Variable | Service | Description |
|----------|---------|-------------|
| STRIPE_SECRET_KEY | Stripe | API secret key |
| STRIPE_WEBHOOK_SECRET | Stripe | Webhook signature secret |
| ...

## Webhook Endpoints
| Endpoint | Service | Events Handled |
|----------|---------|----------------|
| /api/webhooks/stripe | Stripe | checkout.session.completed, invoice.paid, ... |
| ...
```

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
