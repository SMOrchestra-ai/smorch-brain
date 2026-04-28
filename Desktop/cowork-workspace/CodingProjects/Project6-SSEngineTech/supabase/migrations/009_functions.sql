-- Migration 009: Database Functions
-- get_current_tenant_id(), update_signal_updated_at(), validate_campaign_lead_tenant()

-- Helper function for tenant isolation via JWT claims.
-- Checks request.jwt.claims.tenant_id first, then app_metadata.tenant_id.
CREATE OR REPLACE FUNCTION public.get_current_tenant_id()
RETURNS uuid
LANGUAGE plpgsql
STABLE SECURITY DEFINER
AS $$
DECLARE
  tid UUID;
BEGIN
  BEGIN
    tid := (current_setting('request.jwt.claims', true)::json->>'tenant_id')::UUID;
    RETURN tid;
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        tid := (current_setting('request.jwt.claims', true)::json->'app_metadata'->>'tenant_id')::UUID;
        RETURN tid;
      EXCEPTION
        WHEN OTHERS THEN
          RETURN NULL;
      END;
  END;
END;
$$;

-- Trigger function: auto-update updated_at on signal-related tables.
CREATE OR REPLACE FUNCTION public.update_signal_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;

-- Trigger function: validate that campaign_lead tenant matches lead and campaign tenants.
CREATE OR REPLACE FUNCTION public.validate_campaign_lead_tenant()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF (SELECT tenant_id FROM leads WHERE id = NEW.lead_id) != NEW.tenant_id THEN
    RAISE EXCEPTION 'Lead tenant mismatch';
  END IF;
  IF (SELECT tenant_id FROM campaigns WHERE id = NEW.campaign_id) != NEW.tenant_id THEN
    RAISE EXCEPTION 'Campaign tenant mismatch';
  END IF;
  RETURN NEW;
END;
$$;
