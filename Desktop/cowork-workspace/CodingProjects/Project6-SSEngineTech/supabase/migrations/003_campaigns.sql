-- Migration 003: Campaign Tables
-- campaigns, campaign_leads, campaign_messages, campaign_engagements,
-- campaign_analytics, campaign_triggers, campaign_status_log, campaign_error_log,
-- campaign_metrics, campaign_replies, ace_skills, ace_optimization_recommendations

CREATE TABLE IF NOT EXISTS public.campaigns (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name varchar(255) NOT NULL,
  description text,
  campaign_type varchar(50) NOT NULL,
  status varchar(50) DEFAULT 'draft',
  target_profile jsonb NOT NULL,
  target_count integer,
  offer_headline varchar(500),
  offer_description text,
  lead_magnet varchar(255),
  cta_text varchar(255),
  email_platform varchar(50) NOT NULL,
  email_account_id varchar(255),
  channels jsonb NOT NULL,
  message_templates jsonb,
  sequence jsonb NOT NULL,
  language varchar(10) DEFAULT 'ar',
  region varchar(50),
  scheduled_for timestamp,
  started_at timestamp,
  ended_at timestamp,
  created_by uuid REFERENCES users(id),
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  deleted_at timestamp,
  ghl_tag text,
  instantly_campaign_id uuid,
  is_ace_campaign boolean DEFAULT false,
  ace_status text,
  brd_hash text,
  brd_data jsonb,
  icp_id text,
  quarterly_theme jsonb,
  monthly_narrowing jsonb,
  weekly_wedges jsonb DEFAULT '[]'::jsonb,
  asset_manifest jsonb DEFAULT '{}'::jsonb,
  deployment_map jsonb DEFAULT '{}'::jsonb,
  metrics_snapshot jsonb DEFAULT '{}'::jsonb,
  positioning_canvas jsonb DEFAULT '{}'::jsonb,
  skill_chain_output jsonb DEFAULT '{}'::jsonb,
  auto_deploy_leads boolean DEFAULT false,
  PRIMARY KEY (id)
);

-- Add FK that couldn't be created in 002 (circular dep with campaigns)
ALTER TABLE public.lead_scores_history ADD CONSTRAINT lead_scores_history_campaign_id_fkey
  FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS public.campaign_leads (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  campaign_id uuid NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  lead_id uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  status varchar(50) DEFAULT 'pending',
  channel_status jsonb,
  email_sent_at timestamp,
  email_opened_at timestamp,
  email_clicked_at timestamp,
  first_reply_at timestamp,
  last_reply_at timestamp,
  reply_count integer DEFAULT 0,
  linkedin_connection_sent_at timestamp,
  linkedin_connection_accepted_at timestamp,
  linkedin_message_sent_at timestamp,
  linkedin_viewed_at timestamp,
  whatsapp_sent_at timestamp,
  whatsapp_delivered_at timestamp,
  whatsapp_read_at timestamp,
  engagement_score numeric DEFAULT 0,
  fit_score_at_add numeric,
  current_sequence_step integer DEFAULT 0,
  instantly_contact_id varchar(100),
  ghl_contact_id varchar(100),
  heyreach_lead_id varchar(100),
  reply_content text,
  reply_sentiment varchar(50),
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  lead_email text,
  PRIMARY KEY (id),
  UNIQUE (campaign_id, lead_id)
);

CREATE TABLE IF NOT EXISTS public.campaign_messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  campaign_lead_id uuid NOT NULL REFERENCES campaign_leads(id) ON DELETE CASCADE,
  channel varchar(50) NOT NULL,
  language varchar(10) NOT NULL,
  subject varchar(500),
  body text NOT NULL,
  generated_by varchar(50) NOT NULL,
  prompt_used text,
  tokens_used integer,
  generation_time_ms integer,
  status varchar(50) DEFAULT 'draft',
  sent_at timestamp,
  external_id varchar(255),
  error_message text,
  retry_count integer DEFAULT 0,
  last_retry_at timestamp,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  sequence_step integer,
  body_ar text,
  body_en text,
  day_offset integer,
  generation_time_sec double precision,
  generated_at timestamptz,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.campaign_engagements (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  campaign_lead_id uuid NOT NULL REFERENCES campaign_leads(id) ON DELETE CASCADE,
  event_type varchar(50) NOT NULL,
  event_data jsonb,
  source_tool varchar(50),
  external_event_id varchar(255),
  created_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.campaign_analytics (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  campaign_id uuid NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  leads_targeted integer DEFAULT 0,
  leads_sent integer DEFAULT 0,
  leads_opened integer DEFAULT 0,
  leads_clicked integer DEFAULT 0,
  leads_replied integer DEFAULT 0,
  leads_qualified integer DEFAULT 0,
  open_rate numeric,
  click_rate numeric,
  reply_rate numeric,
  qualification_rate numeric,
  avg_time_to_first_reply_hours integer,
  avg_time_to_qualification_hours integer,
  cost_per_lead numeric,
  cost_per_reply numeric,
  cost_per_qualified numeric,
  deals_created integer DEFAULT 0,
  revenue_attributed numeric DEFAULT 0,
  roi numeric,
  calculated_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (campaign_id)
);

CREATE TABLE IF NOT EXISTS public.campaign_triggers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  campaign_id uuid NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  name varchar(255) NOT NULL,
  description text,
  conditions jsonb NOT NULL,
  enabled boolean DEFAULT true,
  priority integer DEFAULT 0,
  created_by uuid REFERENCES users(id),
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.campaign_status_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id),
  campaign_id uuid NOT NULL REFERENCES campaigns(id),
  from_status text,
  to_status text NOT NULL,
  triggered_by text NOT NULL,
  reason text,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.campaign_error_log (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id),
  campaign_id uuid NOT NULL REFERENCES campaigns(id),
  error_type text NOT NULL,
  error_message text NOT NULL,
  error_details jsonb DEFAULT '{}'::jsonb,
  severity text DEFAULT 'error',
  resolved boolean DEFAULT false,
  resolved_at timestamptz,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.campaign_metrics (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id),
  campaign_id uuid NOT NULL REFERENCES campaigns(id),
  channel text NOT NULL,
  platform text NOT NULL,
  metric_type text NOT NULL,
  metric_value numeric NOT NULL,
  period_start timestamptz NOT NULL,
  period_end timestamptz NOT NULL,
  raw_data jsonb DEFAULT '{}'::jsonb,
  collected_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.campaign_replies (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id),
  campaign_id uuid REFERENCES campaigns(id),
  lead_id uuid REFERENCES leads(id),
  channel text NOT NULL,
  platform_message_id text,
  reply_text text,
  classification text,
  confidence numeric,
  suggested_action text,
  action_taken text,
  action_taken_by uuid,
  action_taken_at timestamptz,
  raw_data jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.ace_skills (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid REFERENCES tenants(id),
  skill_key text NOT NULL,
  skill_name text NOT NULL,
  description text,
  prompt_template text NOT NULL,
  version integer DEFAULT 1,
  is_active boolean DEFAULT true,
  metadata jsonb DEFAULT '{}'::jsonb,
  created_by uuid,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (tenant_id, skill_key, version)
);

CREATE TABLE IF NOT EXISTS public.ace_optimization_recommendations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id),
  campaign_id uuid NOT NULL REFERENCES campaigns(id),
  recommendation_type text NOT NULL,
  recommendation_text text NOT NULL,
  supporting_data jsonb DEFAULT '{}'::jsonb,
  status text DEFAULT 'pending',
  applied_by uuid,
  applied_at timestamptz,
  expires_at timestamptz,
  created_at timestamptz DEFAULT now(),
  PRIMARY KEY (id)
);
