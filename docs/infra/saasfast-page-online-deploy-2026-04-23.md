# SaaSfast-Page-Online Deploy Evidence — 2026-04-23

## Correct mapping (supersedes earlier wrong assertion)

| Repo | Purpose | Host | Path | DB | Domain |
|---|---|---|---|---|---|
| `smorchestraai-code/SaaSfast-Page-Online` | Buy page (customer purchase) | **eo-prod** (89.117.62.131) | `/opt/apps/saasfast-page-online` | MongoDB (docker) | `saasfast.entrepreneursoasis.me` |
| `smorchestraai-code/SaaSfast-ar` | Distributable bundle customers download after purchase | N/A (not a server app) | — | — | — |
| `SMOrchestra-ai/SaaSFast` | Internal v2 advanced gating layer for SMO + EO microsaas | TBD | — | — | — |

## What's done

- ✅ Rsync'd repo to `/opt/apps/saasfast-page-online` on eo-prod (HEAD `8e37afc`)
- ✅ MongoDB 7 running in docker (`mongo-saasfast` container, persistent volume, bound to 127.0.0.1:27017, auth enabled with auto-generated root password)
- ✅ `.env.local` written (600 perms) with MONGODB_URI populated + NEXTAUTH_SECRET auto-generated
- ✅ `npm install` + `npm run build` completed clean
- ✅ `ecosystem.config.js` written (port 3400)
- ✅ pm2 app `saasfast-page-online` online — `curl 127.0.0.1:3400 → 200` ✅
- ✅ `pm2 save` persisted (auto-restart on reboot)
- ✅ nginx vhost template at `/etc/nginx/sites-available/saasfast-page-online` (NOT yet enabled)
- ✅ `SaaSfast-ar` repo un-archived on GitHub (it's a distributable, not a dead repo)
- ✅ `.env.example` committed at `/opt/apps/saasfast-page-online/.env.example` documenting all required vars

## What's remaining (needs CEO action)

### 1. DNS update — REQUIRED
`saasfast.entrepreneursoasis.me` currently resolves to `62.171.165.57` (smo-dev). Change A-record to **89.117.62.131** (eo-prod) via your DNS provider (Cloudflare / wherever entrepreneursoasis.me is registered).

### 2. Populate real env creds in `.env.local`
11 placeholders. Retrieve from 1Password vault `SMOrchestra Infrastructure`:
```
GOOGLE_ID=
GOOGLE_SECRET=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
EMAIL_SERVER=
MAILGUN_API_KEY=
MAILGUN_DOMAIN_NAME=
MAILGUN_FROM_NO_REPLY=
MAILGUN_SIGNING_KEY=
# OR (pick one email provider)
RESEND_API_KEY=
```

After populating: `ssh root@100.89.148.62 'pm2 restart saasfast-page-online --update-env'`

### 3. Enable nginx vhost + provision SSL cert
After DNS propagates (~5-30 min):
```
ssh root@100.89.148.62
ln -s /etc/nginx/sites-available/saasfast-page-online /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
certbot --nginx -d saasfast.entrepreneursoasis.me --non-interactive --agree-tos -m mamoun@smorchestra.ai
```

Certbot auto-rewrites the vhost to listen on 443 with the cert + redirect 80→443.

### 4. Stripe webhook endpoint configuration
After #3, configure Stripe webhook in Stripe dashboard:
- Endpoint: `https://saasfast.entrepreneursoasis.me/api/webhooks/stripe`
- Events: `checkout.session.completed`, `customer.subscription.updated`, `customer.subscription.deleted`, `invoice.paid`, `invoice.payment_failed`
- Copy webhook signing secret → `STRIPE_WEBHOOK_SECRET` in `.env.local`

### 5. Post-deploy sanity check
```
curl -sI https://saasfast.entrepreneursoasis.me → expect 200
curl -sI https://saasfast.entrepreneursoasis.me/api/auth/session → expect 200 JSON
```

## MongoDB operational info

Retrieve root password any time:
```
ssh root@100.89.148.62 'docker inspect mongo-saasfast --format "{{range .Config.Env}}{{println .}}{{end}}" | grep MONGO_INITDB_ROOT_PASSWORD'
```

Backup: add to the server's `/opt/scripts/backup-mongo.sh` (Phase H.2 equivalent — TODO):
```
docker exec mongo-saasfast mongodump --authenticationDatabase admin -u saasfast -p <pw> --archive=/backup/saasfast-$(date +%F).archive
```

## DNS (current misconfig)

Other MENA subdomains also wrongly point to smo-dev per Phase 3 audit:
- `sse.smorchestra.ai` → points to smo-dev, should be smo-prod once Signal-Sales-Engine deployed
- `app.smorchestra.ai/contentengine` → points to smo-dev, should be smo-prod once content-automation deployed

These can be batched in one DNS provider session.
