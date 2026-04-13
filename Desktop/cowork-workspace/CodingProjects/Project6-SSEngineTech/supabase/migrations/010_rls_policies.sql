-- Migration 010: Row Level Security Policies
-- Enable RLS on all tables with policies + create 44 RLS policies.

-- ============================================================
-- Enable RLS on all secured tables
-- ============================================================

-- BRD compat tables (customer-scoped)
ALTER TABLE public.account_intent_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activation_outreach ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.outreach_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signal_sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signal_weights ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signals ENABLE ROW LEVEL SECURITY;

-- Signal platform tables (tenant-scoped)
ALTER TABLE public.signal_audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signal_campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signal_clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signal_credit_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signal_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.signal_templates ENABLE ROW LEVEL SECURITY;

-- Integration tables
ALTER TABLE public.integration_credentials ENABLE ROW LEVEL SECURITY;

-- Email verification tables
ALTER TABLE public.bounce_signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.domain_intelligence ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.verification_queue ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- Service role policies (full access for backend/admin)
-- ============================================================
CREATE POLICY service_role_all_intent_scores ON public.account_intent_scores FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_accounts ON public.accounts FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_activation ON public.activation_outreach FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_audit ON public.audit_log FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_contacts ON public.contacts FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_customers ON public.customers FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_deals ON public.deals FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_sources ON public.signal_sources FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_templates ON public.outreach_templates FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_weights ON public.signal_weights FOR ALL TO service_role USING (true) WITH CHECK (true);
CREATE POLICY service_role_all_signals ON public.signals FOR ALL TO service_role USING (true) WITH CHECK (true);

-- ============================================================
-- Signal platform tenant isolation policies
-- ============================================================
CREATE POLICY signal_audit_service_role ON public.signal_audit_log FOR ALL TO service_role USING (true);
CREATE POLICY signal_audit_tenant_isolation ON public.signal_audit_log FOR ALL TO public USING (tenant_id = get_current_tenant_id());

CREATE POLICY signal_campaigns_service_role ON public.signal_campaigns FOR ALL TO service_role USING (true);
CREATE POLICY signal_campaigns_tenant_isolation ON public.signal_campaigns FOR ALL TO public USING (tenant_id = get_current_tenant_id());

CREATE POLICY signal_clients_service_role ON public.signal_clients FOR ALL TO service_role USING (true);
CREATE POLICY signal_clients_tenant_isolation ON public.signal_clients FOR ALL TO public USING (tenant_id = get_current_tenant_id());

CREATE POLICY signal_credit_service_role ON public.signal_credit_usage FOR ALL TO service_role USING (true);
CREATE POLICY signal_credit_tenant_isolation ON public.signal_credit_usage FOR ALL TO public USING (tenant_id = get_current_tenant_id());

CREATE POLICY signal_events_service_role ON public.signal_events FOR ALL TO service_role USING (true);
CREATE POLICY signal_events_tenant_isolation ON public.signal_events FOR ALL TO public USING (tenant_id = get_current_tenant_id());

-- ============================================================
-- Signal templates (tenant-scoped + global templates where tenant_id IS NULL)
-- ============================================================
CREATE POLICY signal_templates_service_role ON public.signal_templates FOR ALL TO service_role USING (true);
CREATE POLICY signal_templates_tenant_read ON public.signal_templates FOR SELECT TO public USING (tenant_id = get_current_tenant_id() OR tenant_id IS NULL);
CREATE POLICY signal_templates_tenant_write ON public.signal_templates FOR INSERT TO public WITH CHECK (tenant_id = get_current_tenant_id());
CREATE POLICY signal_templates_tenant_update ON public.signal_templates FOR UPDATE TO public USING (tenant_id = get_current_tenant_id());
CREATE POLICY signal_templates_tenant_delete ON public.signal_templates FOR DELETE TO public USING (tenant_id = get_current_tenant_id());

-- ============================================================
-- Integration credentials (tenant isolation via JWT or app setting)
-- ============================================================
CREATE POLICY integration_credentials_service_role ON public.integration_credentials FOR ALL TO service_role USING (true);
CREATE POLICY integration_credentials_tenant_isolation ON public.integration_credentials FOR ALL TO public
  USING (tenant_id = COALESCE((current_setting('request.jwt.claims', true)::json->>'tenant_id'), current_setting('app.current_tenant_id', true))::uuid);

-- ============================================================
-- Email verification tenant policies (via app.current_tenant_id setting)
-- ============================================================

-- bounce_signals
CREATE POLICY bs_select_tenant ON public.bounce_signals FOR SELECT TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY bs_insert_tenant ON public.bounce_signals FOR INSERT TO public WITH CHECK (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY bs_update_tenant ON public.bounce_signals FOR UPDATE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY bs_delete_tenant ON public.bounce_signals FOR DELETE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);

-- domain_intelligence
CREATE POLICY di_select_tenant ON public.domain_intelligence FOR SELECT TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY di_insert_tenant ON public.domain_intelligence FOR INSERT TO public WITH CHECK (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY di_update_tenant ON public.domain_intelligence FOR UPDATE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY di_delete_tenant ON public.domain_intelligence FOR DELETE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);

-- email_verifications
CREATE POLICY ev_select_tenant ON public.email_verifications FOR SELECT TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY ev_insert_tenant ON public.email_verifications FOR INSERT TO public WITH CHECK (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY ev_update_tenant ON public.email_verifications FOR UPDATE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY ev_delete_tenant ON public.email_verifications FOR DELETE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);

-- verification_queue
CREATE POLICY vq_select_tenant ON public.verification_queue FOR SELECT TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY vq_insert_tenant ON public.verification_queue FOR INSERT TO public WITH CHECK (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY vq_update_tenant ON public.verification_queue FOR UPDATE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
CREATE POLICY vq_delete_tenant ON public.verification_queue FOR DELETE TO public USING (tenant_id = (current_setting('app.current_tenant_id'))::uuid);
