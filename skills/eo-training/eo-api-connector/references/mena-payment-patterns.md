# MENA Payment & Messaging Integration Patterns

Production-ready code patterns for MENA-specific payment gateways and messaging. Copy directly into your lib/integrations/[service] directory.

---

## Tap Payments Integration (UAE, KSA, Kuwait, Bahrain, Qatar, Oman)

**Primary use**: All GCC markets, native MENA currency support, MADA in Saudi Arabia.

### Setup

```bash
npm install @tap-payments/tap-nodejs zod
```

### Environment Variables

```env
# .env.local
TAP_API_KEY=sk_test_...
TAP_SECRET_KEY=sk_...
TAP_WEBHOOK_SECRET=whsec_...
```

### Client Wrapper

```typescript
// lib/integrations/tap-payments/client.ts
import { z } from 'zod'

const TAP_API_URL = 'https://api.tap.company/v2'
const TAP_API_KEY = process.env.TAP_API_KEY
const TAP_SECRET_KEY = process.env.TAP_SECRET_KEY

// Input validation
const TapChargeSchema = z.object({
  amount: z.number().positive(),
  currency: z.enum(['AED', 'SAR', 'KWD', 'BHD', 'QAR', 'OMR']),
  customer_email: z.string().email(),
  customer_name: z.string().min(1),
  description: z.string().max(500),
  redirect_url: z.string().url(),
})

// Response validation
const TapChargeResponseSchema = z.object({
  id: z.string(),
  status: z.enum(['INITIATED', 'PROCESSING', 'CAPTURED', 'FAILED', 'DECLINED']),
  amount: z.number(),
  currency: z.string(),
  customer: z.object({
    id: z.string().optional(),
    email: z.string(),
    first_name: z.string(),
  }),
  redirect: z.object({
    url: z.string().url(),
  }),
  created_at: z.string().datetime(),
})

export type TapChargeInput = z.infer<typeof TapChargeSchema>
export type TapChargeResponse = z.infer<typeof TapChargeResponseSchema>

// Retry configuration
const RETRY_CONFIG = {
  maxRetries: 3,
  delay: 1000,
  multiplier: 2,
}

async function delay(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

async function fetchWithRetry(
  url: string,
  options: RequestInit,
  retries = RETRY_CONFIG.maxRetries
): Promise<Response> {
  try {
    const response = await fetch(url, options)
    if (response.ok || retries === 0) return response
    if ([408, 429, 502, 503, 504].includes(response.status)) {
      await delay(RETRY_CONFIG.delay * Math.pow(RETRY_CONFIG.multiplier, RETRY_CONFIG.maxRetries - retries))
      return fetchWithRetry(url, options, retries - 1)
    }
    return response
  } catch (error) {
    if (retries > 0 && (error instanceof TypeError || error instanceof Error)) {
      await delay(RETRY_CONFIG.delay * Math.pow(RETRY_CONFIG.multiplier, RETRY_CONFIG.maxRetries - retries))
      return fetchWithRetry(url, options, retries - 1)
    }
    throw error
  }
}

export class TapClient {
  private apiKey: string
  private secretKey: string

  constructor(apiKey: string = TAP_API_KEY!, secretKey: string = TAP_SECRET_KEY!) {
    this.apiKey = apiKey
    this.secretKey = secretKey
  }

  async createCharge(input: TapChargeInput): Promise<TapChargeResponse> {
    // Validate input
    const validated = TapChargeSchema.parse(input)

    // Tap expects amounts in major units (0.50 AED, not 50 fils)
    const amountInMajor = validated.amount

    const response = await fetchWithRetry(`${TAP_API_URL}/charges`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        amount: amountInMajor,
        currency: validated.currency,
        source: { id: 'src_all' }, // Accept all payment methods
        customer: {
          email: validated.customer_email,
          first_name: validated.customer_name,
        },
        redirect: {
          url: validated.redirect_url,
        },
        description: validated.description,
      }),
    })

    if (!response.ok) {
      const error = await response.json()
      throw new Error(`Tap API error: ${error.errors?.[0]?.description || response.statusText}`)
    }

    const data = await response.json()
    return TapChargeResponseSchema.parse(data)
  }

  async getCharge(chargeId: string): Promise<TapChargeResponse> {
    const response = await fetchWithRetry(`${TAP_API_URL}/charges/${chargeId}`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
      },
    })

    if (!response.ok) {
      throw new Error(`Failed to fetch charge: ${response.statusText}`)
    }

    const data = await response.json()
    return TapChargeResponseSchema.parse(data)
  }
}

export const tapClient = new TapClient()
```

### Webhook Handler

```typescript
// app/api/webhooks/tap/route.ts
import { NextResponse } from 'next/server'
import crypto from 'crypto'
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'

const TAP_WEBHOOK_SECRET = process.env.TAP_WEBHOOK_SECRET!

async function verifyTapSignature(body: string, signature: string): Promise<boolean> {
  const hash = crypto.createHmac('sha256', TAP_WEBHOOK_SECRET).update(body).digest('hex')
  return hash === signature
}

export async function POST(req: Request) {
  try {
    const body = await req.text()
    const signature = req.headers.get('x-tap-signature')

    if (!signature || !(await verifyTapSignature(body, signature))) {
      console.error('Invalid Tap signature')
      return NextResponse.json({ error: 'Invalid signature' }, { status: 401 })
    }

    const event = JSON.parse(body)
    const supabase = createRouteHandlerClient({ cookies })

    // Idempotency check: prevent processing the same event twice
    const { data: existing } = await supabase
      .from('webhook_events')
      .select('id')
      .eq('provider', 'tap')
      .eq('external_event_id', event.id)
      .single()

    if (existing) {
      return NextResponse.json({ received: true })
    }

    // Record the event
    await supabase.from('webhook_events').insert({
      provider: 'tap',
      external_event_id: event.id,
      event_type: event.type,
      data: event,
    })

    // Handle payment status changes
    if (event.type === 'charge.status_changed' && event.data.status === 'CAPTURED') {
      const chargeId = event.data.id

      // Update payment in database
      await supabase
        .from('payments')
        .update({
          status: 'completed',
          tap_charge_id: chargeId,
          completed_at: new Date().toISOString(),
        })
        .eq('tap_charge_id', chargeId)
    }

    if (event.type === 'charge.status_changed' && event.data.status === 'FAILED') {
      await supabase
        .from('payments')
        .update({ status: 'failed' })
        .eq('tap_charge_id', event.data.id)
    }

    return NextResponse.json({ received: true })
  } catch (error) {
    console.error('Webhook error:', error)
    return NextResponse.json({ error: 'Webhook processing failed' }, { status: 500 })
  }
}
```

### Usage in Payment Flow

```typescript
// app/api/payments/create/route.ts
import { NextResponse } from 'next/server'
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { tapClient } from '@/lib/integrations/tap-payments/client'
import { z } from 'zod'

const PaymentRequestSchema = z.object({
  amount: z.number().positive(),
  currency: z.enum(['AED', 'SAR', 'KWD', 'BHD', 'QAR', 'OMR']),
  description: z.string(),
})

export async function POST(req: Request) {
  try {
    const supabase = createRouteHandlerClient({ cookies })
    const { data: { session } } = await supabase.auth.getSession()

    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await req.json()
    const { amount, currency, description } = PaymentRequestSchema.parse(body)

    // Get user email
    const { data: user } = await supabase.auth.admin.getUserById(session.user.id)

    // Create Tap charge
    const charge = await tapClient.createCharge({
      amount,
      currency,
      customer_email: user?.email || '',
      customer_name: user?.user_metadata?.name || 'Customer',
      description,
      redirect_url: `${process.env.NEXT_PUBLIC_URL}/payments/confirm`,
    })

    // Store payment record in database
    await supabase.from('payments').insert({
      user_id: session.user.id,
      tap_charge_id: charge.id,
      amount,
      currency,
      status: 'pending',
      created_at: new Date().toISOString(),
    })

    return NextResponse.json({
      redirect_url: charge.redirect.url,
      charge_id: charge.id,
    })
  } catch (error) {
    console.error('Payment creation error:', error)
    const message = error instanceof Error ? error.message : 'Failed to create payment'
    return NextResponse.json({ error: message }, { status: 500 })
  }
}
```

---

## HyperPay Integration (Saudi Arabia)

**Primary use**: Saudi Arabia market, MADA cards, bank transfers.

### Environment Variables

```env
HYPERPAY_MERCHANT_ID=..
HYPERPAY_API_KEY=..
HYPERPAY_ACCESS_TOKEN=..
```

### Client Wrapper (Simplified)

```typescript
// lib/integrations/hyperpay/client.ts
import { z } from 'zod'

const HYPERPAY_API_URL = 'https://api.hyperpay.net/v2'

const HyperPayCheckoutSchema = z.object({
  amount: z.number().positive(),
  currency: z.literal('SAR'),
  order_id: z.string(),
  customer_email: z.string().email(),
  redirect_url: z.string().url(),
})

const HyperPayCheckoutResponseSchema = z.object({
  id: z.string(),
  checkout_url: z.string().url(),
  status: z.enum(['PENDING', 'PAID', 'FAILED']),
})

export type HyperPayCheckoutInput = z.infer<typeof HyperPayCheckoutSchema>

export class HyperPayClient {
  private merchantId: string
  private accessToken: string

  constructor(merchantId = process.env.HYPERPAY_MERCHANT_ID!, accessToken = process.env.HYPERPAY_ACCESS_TOKEN!) {
    this.merchantId = merchantId
    this.accessToken = accessToken
  }

  async createCheckout(input: HyperPayCheckoutInput) {
    const validated = HyperPayCheckoutSchema.parse(input)

    // HyperPay uses amount in halalahs (100 halalahs = 1 SAR)
    const amountInHalalahs = Math.round(validated.amount * 100)

    const response = await fetch(`${HYPERPAY_API_URL}/checkout`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        amount: amountInHalalahs,
        currency: 'SAR',
        merchantReferenceId: validated.order_id,
        redirectUrl: validated.redirect_url,
        customerEmail: validated.customer_email,
      }),
    })

    if (!response.ok) {
      throw new Error(`HyperPay error: ${response.statusText}`)
    }

    const data = await response.json()
    return HyperPayCheckoutResponseSchema.parse(data)
  }
}
```

---

## WhatsApp Business API Integration

**Primary use**: Customer notifications, order updates, payment confirmations in MENA.

### Environment Variables

```env
WHATSAPP_BUSINESS_ACCOUNT_ID=...
WHATSAPP_PHONE_NUMBER_ID=...
WHATSAPP_ACCESS_TOKEN=...
WHATSAPP_WEBHOOK_VERIFY_TOKEN=...
```

### Client Wrapper

```typescript
// lib/integrations/whatsapp/client.ts
import { z } from 'zod'

const WHATSAPP_API_URL = 'https://graph.instagram.com/v18.0'

const WhatsAppMessageSchema = z.object({
  to: z.string().regex(/^\+[1-9]\d{1,14}$/), // E.164 format
  template_name: z.string(),
  template_language: z.enum(['ar', 'en']),
  parameters: z.array(z.object({ type: z.literal('text'), text: z.string() })).optional(),
})

export type WhatsAppMessageInput = z.infer<typeof WhatsAppMessageSchema>

// MENA country codes
const MENA_COUNTRY_CODES = {
  UAE: '+971',
  SA: '+966',
  EG: '+20',
  JO: '+962',
  KW: '+965',
  QA: '+974',
  BH: '+973',
  OM: '+968',
} as const

export function formatWhatsAppNumber(phone: string, country: keyof typeof MENA_COUNTRY_CODES): string {
  const cleaned = phone.replace(/[\s\-\(\)]/g, '')
  const code = MENA_COUNTRY_CODES[country]

  if (cleaned.startsWith(code)) return cleaned
  if (cleaned.startsWith('0')) return `${code}${cleaned.slice(1)}`
  return `${code}${cleaned}`
}

export class WhatsAppClient {
  private businessAccountId: string
  private phoneNumberId: string
  private accessToken: string

  constructor(
    businessAccountId = process.env.WHATSAPP_BUSINESS_ACCOUNT_ID!,
    phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID!,
    accessToken = process.env.WHATSAPP_ACCESS_TOKEN!
  ) {
    this.businessAccountId = businessAccountId
    this.phoneNumberId = phoneNumberId
    this.accessToken = accessToken
  }

  async sendTemplateMessage(input: WhatsAppMessageInput) {
    const validated = WhatsAppMessageSchema.parse(input)

    const response = await fetch(
      `${WHATSAPP_API_URL}/${this.phoneNumberId}/messages`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.accessToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          messaging_product: 'whatsapp',
          recipient_type: 'individual',
          to: validated.to,
          type: 'template',
          template: {
            name: validated.template_name,
            language: {
              code: validated.template_language,
            },
            ...(validated.parameters && {
              components: [
                {
                  type: 'body',
                  parameters: validated.parameters,
                },
              ],
            }),
          },
        }),
      }
    )

    if (!response.ok) {
      const error = await response.json()
      throw new Error(`WhatsApp API error: ${error.error?.message || response.statusText}`)
    }

    return await response.json()
  }

  async sendTextMessage(to: string, message: string) {
    const response = await fetch(
      `${WHATSAPP_API_URL}/${this.phoneNumberId}/messages`,
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.accessToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          messaging_product: 'whatsapp',
          recipient_type: 'individual',
          to,
          type: 'text',
          text: { body: message },
        }),
      }
    )

    if (!response.ok) {
      throw new Error(`Failed to send WhatsApp message: ${response.statusText}`)
    }

    return await response.json()
  }
}

export const whatsappClient = new WhatsAppClient()
```

### Webhook Handler for Incoming Messages

```typescript
// app/api/webhooks/whatsapp/route.ts
import { NextResponse } from 'next/server'
import crypto from 'crypto'
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'

const VERIFY_TOKEN = process.env.WHATSAPP_WEBHOOK_VERIFY_TOKEN

// GET: Webhook verification from Meta
export async function GET(req: Request) {
  const url = new URL(req.url)
  const mode = url.searchParams.get('hub.mode')
  const token = url.searchParams.get('hub.verify_token')
  const challenge = url.searchParams.get('hub.challenge')

  if (mode === 'subscribe' && token === VERIFY_TOKEN) {
    return NextResponse.json(challenge, { status: 200 })
  }

  return NextResponse.json({ error: 'Verification failed' }, { status: 403 })
}

// POST: Incoming WhatsApp messages
export async function POST(req: Request) {
  try {
    const body = await req.json()

    // Extract message
    const message = body.entry?.[0]?.changes?.[0]?.value?.messages?.[0]
    if (!message) {
      return NextResponse.json({ received: true })
    }

    const from = message.from
    const textContent = message.text?.body || ''
    const messageId = message.id

    // Store incoming message in database
    const supabase = createRouteHandlerClient({ cookies })
    await supabase.from('whatsapp_messages').insert({
      from_number: from,
      text: textContent,
      message_id: messageId,
      type: 'incoming',
      created_at: new Date().toISOString(),
    })

    // TODO: Implement business logic (e.g., chatbot response, order lookup)
    // Example: if textContent includes 'ORDER', send order status via WhatsApp

    return NextResponse.json({ received: true })
  } catch (error) {
    console.error('WhatsApp webhook error:', error)
    return NextResponse.json({ error: 'Webhook processing failed' }, { status: 500 })
  }
}
```

---

## Stripe Integration (International + UAE Backup)

**Primary use**: Fallback for users outside MENA, subscription billing, handles AED, SAR, EGP.

### Environment Variables

```env
STRIPE_SECRET_KEY=sk_live_...
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

### Client Wrapper (Simplified)

```typescript
// lib/integrations/stripe/client.ts
import Stripe from 'stripe'
import { z } from 'zod'

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: '2023-10-16',
})

const StripeCheckoutSessionSchema = z.object({
  amount: z.number().positive(),
  currency: z.enum(['aed', 'sar', 'egp', 'jod', 'usd']),
  customer_email: z.string().email(),
  success_url: z.string().url(),
  cancel_url: z.string().url(),
})

export type StripeCheckoutInput = z.infer<typeof StripeCheckoutSessionSchema>

export class StripeClient {
  async createCheckoutSession(input: StripeCheckoutInput) {
    const validated = StripeCheckoutSessionSchema.parse(input)

    // Stripe amounts in cents
    const amountInCents = Math.round(validated.amount * 100)

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: validated.currency,
            product_data: {
              name: 'Purchase',
            },
            unit_amount: amountInCents,
          },
          quantity: 1,
        },
      ],
      mode: 'payment',
      success_url: validated.success_url,
      cancel_url: validated.cancel_url,
      customer_email: validated.customer_email,
    })

    return { session_id: session.id, url: session.url }
  }

  async createSubscription(customerId: string, priceId: string) {
    const subscription = await stripe.subscriptions.create({
      customer: customerId,
      items: [{ price: priceId }],
    })

    return subscription
  }
}

export const stripeClient = new StripeClient()
```

---

## Unifonic SMS Integration (MENA Native)

**Primary use**: SMS OTP, alerts, Saudi Arabia Sender ID registration.

### Environment Variables

```env
UNIFONIC_APP_SID=...
UNIFONIC_API_KEY=...
```

### Client Wrapper

```typescript
// lib/integrations/unifonic/client.ts
import { z } from 'zod'

const UNIFONIC_API_URL = 'https://api.unifonic.com/rest/sms/send'

const UnionicSMSSchema = z.object({
  to: z.string().regex(/^\+[1-9]\d{1,14}$/),
  message: z.string().max(160),
  sender_id: z.string().optional(),
})

export class UnionicClient {
  private appSid: string
  private apiKey: string

  constructor(appSid = process.env.UNIFONIC_APP_SID!, apiKey = process.env.UNIFONIC_API_KEY!) {
    this.appSid = appSid
    this.apiKey = apiKey
  }

  async sendSMS(input: z.infer<typeof UnionicSMSSchema>) {
    const validated = UnionicSMSSchema.parse(input)

    const params = new URLSearchParams({
      AppSid: this.appSid,
      ApiKey: this.apiKey,
      To: validated.to,
      Body: validated.message,
      Encoding: 'UTF8', // Support Arabic
      ...(validated.sender_id && { SenderID: validated.sender_id }),
    })

    const response = await fetch(UNIFONIC_API_URL, {
      method: 'POST',
      body: params,
    })

    if (!response.ok) {
      throw new Error(`Unifonic error: ${response.statusText}`)
    }

    return await response.json()
  }
}
```

---

## Currency Handling in MENA

Always handle currency explicitly in API calls:

```typescript
// lib/integrations/currency-utils.ts

export const MENA_CURRENCIES = {
  AED: { decimal_places: 2, country: 'UAE' },
  SAR: { decimal_places: 2, country: 'Saudi Arabia' },
  KWD: { decimal_places: 3, country: 'Kuwait' },
  BHD: { decimal_places: 3, country: 'Bahrain' },
  QAR: { decimal_places: 2, country: 'Qatar' },
  OMR: { decimal_places: 3, country: 'Oman' },
  JOD: { decimal_places: 3, country: 'Jordan' },
  EGP: { decimal_places: 2, country: 'Egypt' },
} as const

export function formatCurrency(amount: number, currency: keyof typeof MENA_CURRENCIES): string {
  const { decimal_places } = MENA_CURRENCIES[currency]
  return amount.toFixed(decimal_places)
}

// Usage
const saudiPrice = formatCurrency(19.95, 'SAR') // "19.95"
const kuwaitiPrice = formatCurrency(5.5, 'KWD') // "5.500"
```

---

## Testing Checklist

- [ ] Tap: Test charge creation, webhook signature verification, idempotency
- [ ] HyperPay: Test Saudi MADA card flow, halalahs conversion
- [ ] WhatsApp: Test template message sending, webhook verification, phone number formatting
- [ ] Stripe: Test multiple currencies (AED, SAR), subscription creation
- [ ] Unifonic: Test SMS with Arabic text (UTF-8 encoding)
- [ ] Currency: Verify decimal places for KWD, BHD (3), others (2)
