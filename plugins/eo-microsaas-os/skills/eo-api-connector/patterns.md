# EO API Connector - Code Patterns

Reference file for client wrapper architecture, error handling, retry logic, and webhook processing patterns.

---

## Client Wrapper Architecture

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

## Error Handling Patterns

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

## Webhook Processing

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
