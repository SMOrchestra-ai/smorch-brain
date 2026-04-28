-- Migration 001: Core Tables
-- Core tables with no foreign key dependencies on other migration groups:
-- tenants, users, user_roles, customers, tenant_credits, credit_actions,
-- credit_transactions, industries, invitations, audit_logs

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.tenants (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  workspace_name varchar(255) NOT NULL,
  subscription_tier varchar(50) DEFAULT 'starter',
  monthly_limits jsonb,
  created_by uuid,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  deleted_at timestamp,
  PRIMARY KEY (id),
  UNIQUE (workspace_name)
);

CREATE TABLE IF NOT EXISTS public.users (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  email varchar(255) NOT NULL,
  password_hash varchar(255),
  first_name varchar(100),
  last_name varchar(100),
  role varchar(50) DEFAULT 'user',
  is_active boolean DEFAULT true,
  last_login timestamp,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  company text,
  PRIMARY KEY (id),
  UNIQUE (tenant_id, email)
);

CREATE TABLE IF NOT EXISTS public.user_roles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role varchar(50) NOT NULL,
  granted_at timestamp DEFAULT now(),
  granted_by uuid REFERENCES users(id),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.customers (
  id uuid NOT NULL DEFAULT uuid_generate_v4(),
  company_name text NOT NULL,
  plan_tier text NOT NULL,
  max_accounts integer NOT NULL DEFAULT 5,
  max_emails_per_day integer NOT NULL DEFAULT 100,
  max_linkedin_per_day integer NOT NULL DEFAULT 20,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.tenant_credits (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  balance integer DEFAULT 1000,
  last_updated timestamp DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (tenant_id)
);

CREATE TABLE IF NOT EXISTS public.credit_actions (
  id varchar(100) NOT NULL,
  name varchar(255) NOT NULL,
  description text,
  cost_per_action integer,
  active boolean DEFAULT true,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.credit_transactions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  action_id varchar(100),
  amount integer,
  context_type varchar(50),
  context_id varchar(255),
  reason text,
  created_by uuid REFERENCES users(id),
  created_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.industries (
  id integer NOT NULL,
  label text NOT NULL,
  hierarchy text NOT NULL,
  description text,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.invitations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  email varchar(255) NOT NULL,
  role varchar(50) NOT NULL DEFAULT 'client_operator',
  token varchar(128) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'pending',
  invited_by uuid REFERENCES users(id) ON DELETE SET NULL,
  expires_at timestamp NOT NULL,
  accepted_at timestamp,
  created_at timestamp NOT NULL DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (token)
);

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  action varchar(100) NOT NULL,
  resource_type varchar(50),
  resource_id varchar(255),
  old_values jsonb,
  new_values jsonb,
  changes_summary text,
  user_id uuid REFERENCES users(id),
  user_ip varchar(50),
  user_agent text,
  created_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);
