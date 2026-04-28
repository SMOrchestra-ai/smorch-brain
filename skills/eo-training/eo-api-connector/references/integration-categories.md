# Integration Categories - eo-api-connector

Detailed breakdown of payment, messaging, auth, storage, AI, and analytics integrations.

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

