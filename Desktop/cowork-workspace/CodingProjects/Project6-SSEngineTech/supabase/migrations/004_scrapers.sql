-- Migration 004: Scraper Tables
-- scraper_types, scraper_runs, scraper_jobs, runs

CREATE TABLE IF NOT EXISTS public.scraper_types (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name varchar(100) NOT NULL,
  description text,
  category varchar(50),
  platforms jsonb,
  entity_table varchar(100),
  created_at timestamp DEFAULT now(),
  PRIMARY KEY (id),
  UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.scraper_runs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  scraper_type_id uuid NOT NULL REFERENCES scraper_types(id),
  scraper_type varchar(50) NOT NULL,
  platform varchar(50) NOT NULL,
  status varchar(50) DEFAULT 'pending',
  search_params jsonb,
  target_count integer,
  leads_found integer DEFAULT 0,
  leads_enriched integer DEFAULT 0,
  leads_failed integer DEFAULT 0,
  leads_deduplicated integer DEFAULT 0,
  started_at timestamp,
  completed_at timestamp,
  apify_job_id varchar(100),
  apify_actor_id varchar(100),
  credits_used integer DEFAULT 0,
  estimated_credits integer,
  error_message text,
  error_details jsonb,
  created_by uuid REFERENCES users(id),
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.scraper_jobs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  scraper_run_id uuid NOT NULL REFERENCES scraper_runs(id) ON DELETE CASCADE,
  campaign_id uuid,
  entity_type varchar(50),
  platform varchar(50),
  status varchar(50) DEFAULT 'pending',
  apify_job_id varchar(100),
  apify_actor_id varchar(100),
  raw_leads_count integer DEFAULT 0,
  processed_leads_count integer DEFAULT 0,
  error_message text,
  started_at timestamp,
  completed_at timestamp,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.runs (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name varchar(255) NOT NULL,
  scraper_type varchar(50) NOT NULL,
  platform varchar(50) NOT NULL,
  search_query text,
  max_leads integer DEFAULT 100,
  country varchar(50),
  city varchar(100),
  category varchar(100),
  status varchar(20) DEFAULT 'queued',
  collected_count integer DEFAULT 0,
  duplicate_count integer DEFAULT 0,
  error_count integer DEFAULT 0,
  credits_used integer DEFAULT 0,
  started_at timestamptz,
  completed_at timestamptz,
  error_message text,
  created_by uuid NOT NULL REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  search_params jsonb DEFAULT '{}'::jsonb,
  current_job_titles text[],
  industry_ids text[],
  function_ids text[],
  company_headcount text[],
  seniority_level_ids text[],
  years_of_experience_ids text[],
  locations text[],
  pageNumber integer,
  totalElements bigint,
  PRIMARY KEY (id)
);

-- Add FK for tenant_leads.source_run_id (created in 002, depends on runs table)
ALTER TABLE public.tenant_leads ADD CONSTRAINT tenant_leads_source_run_id_fkey
  FOREIGN KEY (source_run_id) REFERENCES runs(id) ON DELETE SET NULL;
