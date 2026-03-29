<!-- Copyright SMOrchestra.ai. All rights reserved. Proprietary and confidential. -->
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

```typescript
// Messaging client pattern
export async function sendWhatsAppMessage(
  input: WhatsAppMessageInput
): Promise<MessageResult> {
  // Validate template exists and is approved
  const template = await getApprovedTemplate(input.templateName, input.language);
  if (!template) {
    throw new IntegrationError('TEMPLATE_NOT_APPROVED', {
      template: input.templateName,
      language: input.language,
    });
  }

  // Send with retry for rate limits
  return withRetry(
    () => whatsappClient.post('/messages', {
      to: formatE164(input.phoneNumber),
      type: 'template',
      template: {
        name: template.name,
        language: { code: input.language },
        components: input.parameters,
      },
    }),
    { maxRetries: 3, backoff: 'exponential', retryOn: [429] }
  );
}
```

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

```typescript
// AI service client pattern with fallback
export async function generateContent(
  prompt: string,
  options: AIOptions = {}
): Promise<AIResponse> {
  const providers = [
    () => callClaude(prompt, options),
    () => callOpenAI(prompt, options),    // fallback
    () => getCachedResponse(prompt),       // last resort
  ];

  for (const provider of providers) {
    try {
      const result = await withTimeout(provider(), options.timeout ?? 30000);
      return AIResponseSchema.parse(result);
    } catch (error) {
      if (error instanceof TimeoutError || error instanceof RateLimitError) {
        continue; // try next provider
      }
      throw error; // unexpected error, don't retry
    }
  }

  throw new IntegrationError('ALL_AI_PROVIDERS_FAILED');
}
```

### Category 6: Analytics (Complexity: LOW)

**Services:** PostHog, Mixpanel, Google Analytics

Key patterns:
- Event tracking wrapper (single function, multiple providers)
- User identification on login
- Property enrichment (plan, role, org)
- Server-side tracking for critical events (payments, signups)
- Client-side tracking for UX events (clicks, page views)

---

## CLIENT WRAPPER ARCHITECTURE

Every integration follows this structure:

```
src/lib/integrations/
  [service-name]/
    client.ts         # Configured HTTP client with auth
    types.ts          # Zod schemas for request/response
    [service].ts      # Public API methods
    webhooks.ts       # Webhook handlers (if applicable)
    __tests__/
      [service].test.ts
```

### Base Client Pattern

```typescript
// src/lib/integrations/base-client.ts
import { z } from 'zod';

interface ClientConfig {
  baseUrl: string;
  apiKey: string;
  timeout?: number;
  retryConfig?: RetryConfig;
}

interface RetryConfig {
  maxRetries: number;
  backoff: 'linear' | 'exponential';
  retryOn: number[];  // HTTP status codes to retry
}

export function createApiClient(config: ClientConfig) {
  return {
    async get<T>(path: string, schema: z.ZodSchema<T>): Promise<T> {
      const response = await fetchWithRetry(
        `${config.baseUrl}${path}`,
        { headers: { Authorization: `Bearer ${config.apiKey}` } },
        config.retryConfig
      );
      return schema.parse(response);
    },

    async post<T>(path: string, body: unknown, schema: z.ZodSchema<T>): Promise<T> {
      const response = await fetchWithRetry(
        `${config.baseUrl}${path}`,
        {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${config.apiKey}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(body),
        },
        config.retryConfig
      );
      return schema.parse(response);
    },
    // ... put, patch, delete
  };
}
```

### Type Safety Rules

1. **Every request body** validated with Zod schema before sending
2. **Every response** validated with Zod schema before using
3. **Every error** caught and wrapped in `IntegrationError` class
4. **No `any` types** anywhere in integration code
5. **No optional chaining (`?.`) on API responses** without explicit null handling

---

## ERROR HANDLING PATTERNS

### IntegrationError Class

```typescript
export class IntegrationError extends Error {
  constructor(
    public code: string,
    public details: Record<string, unknown> = {},
    public retryable: boolean = false,
    public statusCode?: number,
  ) {
    super(`Integration error: ${code}`);
    this.name = 'IntegrationError';
  }
}

// Error codes per category
export const PaymentErrors = {
  CARD_DECLINED: { retryable: false, userMessage: 'Payment declined. Please try a different card.' },
  INSUFFICIENT_FUNDS: { retryable: false, userMessage: 'Insufficient funds. Please try a different payment method.' },
  GATEWAY_TIMEOUT: { retryable: true, userMessage: 'Payment processing delayed. We will confirm shortly.' },
  DUPLICATE_CHARGE: { retryable: false, userMessage: 'This payment was already processed.' },
} as const;
```

### Retry Logic

```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  config: RetryConfig
): Promise<T> {
  let lastError: Error | undefined;

  for (let attempt = 0; attempt <= config.maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;

      if (error instanceof IntegrationError && !error.retryable) {
        throw error; // Don't retry non-retryable errors
      }

      if (attempt < config.maxRetries) {
        const delay = config.backoff === 'exponential'
          ? Math.min(1000 * Math.pow(2, attempt), 30000)
          : 1000 * (attempt + 1);
        await sleep(delay);
      }
    }
  }

  throw lastError;
}
```

### Circuit Breaker (for critical integrations)

```typescript
// If a service fails 5 times in 60 seconds, stop calling it for 30 seconds
const circuitBreaker = createCircuitBreaker({
  failureThreshold: 5,
  resetTimeout: 30000,
  monitorWindow: 60000,
});

export async function callExternalService() {
  return circuitBreaker.execute(() => externalClient.get('/endpoint'));
}
```

---

## WEBHOOK PROCESSING

### Webhook Handler Pattern

```typescript
// src/app/api/webhooks/[service]/route.ts
export async function POST(request: Request) {
  const body = await request.text();
  const signature = request.headers.get('x-webhook-signature');

  // 1. Verify signature (NEVER skip this)
  if (!verifyWebhookSignature(body, signature, WEBHOOK_SECRET)) {
    return new Response('Invalid signature', { status: 401 });
  }

  // 2. Parse and validate payload
  const event = WebhookEventSchema.parse(JSON.parse(body));

  // 3. Idempotency check (prevent double processing)
  const processed = await checkIdempotency(event.id);
  if (processed) {
    return new Response('Already processed', { status: 200 });
  }

  // 4. Process event
  try {
    await processWebhookEvent(event);
    await markProcessed(event.id);
    return new Response('OK', { status: 200 });
  } catch (error) {
    // Log but return 200 to prevent retry storm
    // Queue for manual retry instead
    await queueFailedWebhook(event, error);
    return new Response('Queued for retry', { status: 200 });
  }
}
```

### Webhook Security Rules
1. Always verify webhook signatures
2. Use HTTPS endpoints only
3. Implement idempotency (webhooks can be delivered multiple times)
4. Return 200 quickly, process asynchronously if needed
5. Log all webhook payloads for debugging
6. Never trust webhook data without server-side verification

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
