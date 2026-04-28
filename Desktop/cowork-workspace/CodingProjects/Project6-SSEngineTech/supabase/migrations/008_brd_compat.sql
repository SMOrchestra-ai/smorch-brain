-- Migration 008: BRD Compatibility Tables
-- Original signal engine schema tables used by BRD documents.
-- These depend on the 'customers' table (not tenants).
-- accounts, contacts, signals, signal_sources, signal_weights,
-- account_intent_scores, activation_outreach, outreach_templates,
-- audit_log, deals

CREATE TABLE IF NOT EXISTS public.accounts (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  company_name text NOT NULL,
  domain text NOT NULL,
  industry text,
  company_size integer,
  hq_country text,
  icp_match_score numeric,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (customer_id, domain)
);

CREATE TABLE IF NOT EXISTS public.contacts (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  email text,
  job_title text,
  seniority text,
  is_decision_maker boolean DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.signals (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  signal_type text NOT NULL,
  signal_source text NOT NULL,
  signal_value integer NOT NULL DEFAULT 0,
  signal_data jsonb DEFAULT '{}'::jsonb,
  evidence_source_tool text,
  evidence_text text,
  dedup_key text,
  detected_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.signal_sources (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  source_name text NOT NULL,
  source_tool text NOT NULL,
  config jsonb DEFAULT '{}'::jsonb,
  is_active boolean DEFAULT true,
  refresh_interval_minutes integer DEFAULT 240,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.signal_weights (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  signal_type text NOT NULL,
  weight numeric NOT NULL DEFAULT 0,
  optimization_source text DEFAULT 'default',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (customer_id, signal_type)
);

CREATE TABLE IF NOT EXISTS public.account_intent_scores (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  intent_score numeric NOT NULL DEFAULT 0,
  calculated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (customer_id, account_id)
);

CREATE TABLE IF NOT EXISTS public.activation_outreach (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  contact_id uuid REFERENCES contacts(id) ON DELETE SET NULL,
  channel text NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  sent_at timestamptz,
  reply_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.outreach_templates (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  channel text NOT NULL,
  intent_tier text NOT NULL,
  template_name text NOT NULL,
  subject text,
  body text NOT NULL,
  language text DEFAULT 'en',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.audit_log (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  actor text NOT NULL,
  action text NOT NULL,
  entity_type text,
  entity_id uuid,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.deals (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  customer_id uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  account_id uuid NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
  deal_name text NOT NULL,
  stage text NOT NULL DEFAULT 'discovery',
  stage_changed_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);
