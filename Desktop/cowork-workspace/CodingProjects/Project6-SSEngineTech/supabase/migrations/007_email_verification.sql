-- Migration 007: Email Verification Tables
-- email_verifications, verification_queue, bounce_signals,
-- domain_intelligence, disposable_domains, arabic_name_mappings

CREATE TABLE IF NOT EXISTS public.email_verifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  email text NOT NULL,
  lead_id uuid,
  l1_syntax_valid boolean,
  l1_format_score numeric,
  l2_domain_exists boolean,
  l2_mx_records jsonb DEFAULT '[]'::jsonb,
  l2_is_catch_all boolean,
  l2_is_disposable boolean,
  l2_domain_age_days integer,
  l3_mailbox_exists boolean,
  l3_smtp_code integer,
  l3_smtp_message text,
  l3_is_role_account boolean,
  l4_data_confidence numeric,
  l4_historical_bounces integer DEFAULT 0,
  l4_last_seen_active timestamptz,
  l4_engagement_score numeric,
  verdict text NOT NULL DEFAULT 'unknown',
  risk_score numeric,
  verification_provider text,
  verified_at timestamptz,
  expires_at timestamptz,
  raw_response jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (tenant_id, email)
);

CREATE TABLE IF NOT EXISTS public.verification_queue (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  email text NOT NULL,
  lead_id uuid,
  priority integer NOT NULL DEFAULT 5,
  status text NOT NULL DEFAULT 'pending',
  attempts integer NOT NULL DEFAULT 0,
  max_attempts integer NOT NULL DEFAULT 3,
  last_error text,
  scheduled_at timestamptz NOT NULL DEFAULT now(),
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.bounce_signals (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  email text NOT NULL,
  email_verification_id uuid REFERENCES email_verifications(id) ON DELETE SET NULL,
  bounce_type text NOT NULL,
  bounce_code text,
  bounce_reason text,
  source_platform text,
  source_campaign_id uuid,
  sending_account_age_days integer,
  is_warmup_period boolean DEFAULT false,
  bounce_weight numeric DEFAULT 1.00,
  bounced_at timestamptz NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.domain_intelligence (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  domain text NOT NULL,
  mx_records jsonb DEFAULT '[]'::jsonb,
  mx_provider text,
  has_spf boolean,
  has_dkim boolean,
  has_dmarc boolean,
  dmarc_policy text,
  is_catch_all boolean,
  is_disposable boolean,
  is_government boolean DEFAULT false,
  domain_age_days integer,
  registrar text,
  country_code text,
  is_mena_gov boolean DEFAULT false,
  gov_tld_pattern text,
  last_checked_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  dns_expires_at timestamptz,
  PRIMARY KEY (id),
  UNIQUE (tenant_id, domain)
);

CREATE TABLE IF NOT EXISTS public.disposable_domains (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  domain text NOT NULL,
  source text DEFAULT 'seed',
  added_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (domain)
);

CREATE TABLE IF NOT EXISTS public.arabic_name_mappings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  arabic_name text NOT NULL,
  romanized_variants text[] NOT NULL,
  gender text,
  frequency_rank integer,
  region text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (arabic_name)
);
