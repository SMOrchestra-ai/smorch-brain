-- Migration 006: Integration Tables
-- integration_credentials, ghl_integrations, instantly_integrations,
-- heyreach_integrations, integrations_audit

CREATE TABLE IF NOT EXISTS public.integration_credentials (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  provider varchar(50) NOT NULL,
  credentials_encrypted text NOT NULL,
  workspace_id varchar(255),
  account_email varchar(255),
  is_active boolean DEFAULT true,
  last_validated_at timestamptz,
  validation_status varchar(20) DEFAULT 'pending',
  metadata jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamptz DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE (tenant_id, provider)
);

CREATE TABLE IF NOT EXISTS public.instantly_integrations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  instantly_api_key text NOT NULL,
  instantly_account_id varchar(100),
  is_active boolean DEFAULT true,
  daily_limit integer DEFAULT 50,
  last_campaign_at timestamp,
  webhook_url varchar(500),
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  deleted_at timestamp,
  PRIMARY KEY (id),
  UNIQUE (tenant_id)
);

CREATE TABLE IF NOT EXISTS public.heyreach_integrations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  heyreach_api_key text NOT NULL,
  heyreach_account_id varchar(100),
  is_active boolean DEFAULT true,
  daily_limit integer DEFAULT 50,
  last_campaign_at timestamp,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  deleted_at timestamp,
  PRIMARY KEY (id),
  UNIQUE (tenant_id)
);

CREATE TABLE IF NOT EXISTS public.ghl_integrations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  ghl_workspace_id varchar(100) NOT NULL,
  ghl_location_id varchar(100) NOT NULL,
  ghl_access_token text NOT NULL,
  ghl_refresh_token text,
  token_expires_at timestamp,
  is_active boolean DEFAULT true,
  last_sync_at timestamp,
  webhook_url varchar(500),
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  deleted_at timestamp,
  PRIMARY KEY (id),
  UNIQUE (tenant_id)
);

CREATE TABLE IF NOT EXISTS public.integrations_audit (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  action varchar(100),
  integration_type varchar(50),
  details jsonb,
  status varchar(50),
  error_message text,
  created_by uuid REFERENCES users(id),
  created_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);
