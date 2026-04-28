-- Migration 011: All Production Indexes
-- ~170 non-primary-key indexes, grouped by table.
-- Unique constraints created inline with tables are noted but skipped.

-- ============================================================
-- account_intent_scores
-- ============================================================
-- UNIQUE (customer_id, account_id) already created in 008

-- ============================================================
-- accounts
-- ============================================================
-- UNIQUE (customer_id, domain) already created in 008
CREATE INDEX IF NOT EXISTS idx_accounts_customer ON public.accounts (customer_id);
CREATE INDEX IF NOT EXISTS idx_accounts_domain ON public.accounts (domain);

-- ============================================================
-- ace_optimization_recommendations
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_ace_opt_recs_campaign_status ON public.ace_optimization_recommendations (campaign_id, status);

-- ============================================================
-- ace_skills
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_ace_skills_key_active ON public.ace_skills (skill_key, is_active);
CREATE INDEX IF NOT EXISTS idx_ace_skills_tenant ON public.ace_skills (tenant_id);
-- UNIQUE (tenant_id, skill_key, version) already created in 003

-- ============================================================
-- activation_outreach
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_activation_account ON public.activation_outreach (account_id);

-- ============================================================
-- arabic_name_mappings
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_anm_arabic_name ON public.arabic_name_mappings (arabic_name);
CREATE INDEX IF NOT EXISTS idx_anm_region ON public.arabic_name_mappings (region);
CREATE INDEX IF NOT EXISTS idx_anm_romanized ON public.arabic_name_mappings USING gin (romanized_variants);
-- UNIQUE (arabic_name) already created in 007

-- ============================================================
-- audit_log
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_audit_customer ON public.audit_log (customer_id);

-- ============================================================
-- audit_logs
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON public.audit_logs (created_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_resource ON public.audit_logs (resource_type, resource_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_tenant_action ON public.audit_logs (tenant_id, action);

-- ============================================================
-- bounce_signals
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_bs_bounce_type ON public.bounce_signals (bounce_type);
CREATE INDEX IF NOT EXISTS idx_bs_bounced_at ON public.bounce_signals (bounced_at);
CREATE INDEX IF NOT EXISTS idx_bs_email ON public.bounce_signals (email);
CREATE INDEX IF NOT EXISTS idx_bs_source_platform ON public.bounce_signals (source_platform);
CREATE INDEX IF NOT EXISTS idx_bs_tenant_email ON public.bounce_signals (tenant_id, email);
CREATE INDEX IF NOT EXISTS idx_bs_tenant_id ON public.bounce_signals (tenant_id);
CREATE INDEX IF NOT EXISTS idx_bs_verification_id ON public.bounce_signals (email_verification_id);
CREATE INDEX IF NOT EXISTS idx_bs_warmup ON public.bounce_signals (is_warmup_period);

-- ============================================================
-- campaign_analytics
-- ============================================================
-- UNIQUE (campaign_id) already created in 003

-- ============================================================
-- campaign_engagements
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaign_engagements_campaign_lead_id ON public.campaign_engagements (campaign_lead_id);
CREATE INDEX IF NOT EXISTS idx_campaign_engagements_created_at ON public.campaign_engagements (created_at);
CREATE INDEX IF NOT EXISTS idx_campaign_engagements_event_type ON public.campaign_engagements (event_type);

-- ============================================================
-- campaign_error_log
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaign_error_log_campaign ON public.campaign_error_log (campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_error_log_unresolved ON public.campaign_error_log (campaign_id, resolved) WHERE resolved = false;

-- ============================================================
-- campaign_leads
-- ============================================================
-- UNIQUE (campaign_id, lead_id) already created in 003
CREATE INDEX IF NOT EXISTS idx_campaign_leads_campaign_id ON public.campaign_leads (campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_leads_engagement_score ON public.campaign_leads (engagement_score);
CREATE INDEX IF NOT EXISTS idx_campaign_leads_lead_id ON public.campaign_leads (lead_id);
CREATE INDEX IF NOT EXISTS idx_campaign_leads_status ON public.campaign_leads (status);

-- ============================================================
-- campaign_messages
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaign_messages_campaign_lead_id ON public.campaign_messages (campaign_lead_id);
CREATE INDEX IF NOT EXISTS idx_campaign_messages_channel ON public.campaign_messages (channel);
CREATE INDEX IF NOT EXISTS idx_campaign_messages_status ON public.campaign_messages (status);

-- ============================================================
-- campaign_metrics
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaign_metrics_campaign_channel ON public.campaign_metrics (campaign_id, channel);
CREATE INDEX IF NOT EXISTS idx_campaign_metrics_campaign_period ON public.campaign_metrics (campaign_id, period_start, period_end);
CREATE INDEX IF NOT EXISTS idx_campaign_metrics_tenant ON public.campaign_metrics (tenant_id);

-- ============================================================
-- campaign_replies
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaign_replies_campaign_class ON public.campaign_replies (campaign_id, classification);
CREATE INDEX IF NOT EXISTS idx_campaign_replies_pending ON public.campaign_replies (action_taken) WHERE action_taken IS NULL;
CREATE INDEX IF NOT EXISTS idx_campaign_replies_tenant ON public.campaign_replies (tenant_id);

-- ============================================================
-- campaign_status_log
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaign_status_log_campaign ON public.campaign_status_log (campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_status_log_tenant ON public.campaign_status_log (tenant_id);

-- ============================================================
-- campaign_triggers
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaign_triggers_campaign_id ON public.campaign_triggers (campaign_id);
CREATE INDEX IF NOT EXISTS idx_campaign_triggers_enabled ON public.campaign_triggers (enabled);
CREATE INDEX IF NOT EXISTS idx_campaign_triggers_priority ON public.campaign_triggers (priority);

-- ============================================================
-- campaigns
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_campaigns_ace_status ON public.campaigns (ace_status);
CREATE INDEX IF NOT EXISTS idx_campaigns_campaign_type ON public.campaigns (campaign_type);
CREATE INDEX IF NOT EXISTS idx_campaigns_created_at ON public.campaigns (created_at);
CREATE INDEX IF NOT EXISTS idx_campaigns_is_ace ON public.campaigns (is_ace_campaign);
CREATE INDEX IF NOT EXISTS idx_campaigns_tenant_status ON public.campaigns (tenant_id, status);

-- ============================================================
-- company_entities
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_company_entities_company_name ON public.company_entities (company_name);
CREATE INDEX IF NOT EXISTS idx_company_entities_lead_id ON public.company_entities (lead_id);
CREATE INDEX IF NOT EXISTS idx_company_entities_tenant_id ON public.company_entities (tenant_id);

-- ============================================================
-- contacts
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_contacts_account ON public.contacts (account_id);
CREATE INDEX IF NOT EXISTS idx_contacts_customer ON public.contacts (customer_id);

-- ============================================================
-- credit_transactions
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_credit_transactions_context ON public.credit_transactions (context_type, context_id);
CREATE INDEX IF NOT EXISTS idx_credit_transactions_tenant_created ON public.credit_transactions (tenant_id, created_at);

-- ============================================================
-- deals
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_deals_customer ON public.deals (customer_id);

-- ============================================================
-- disposable_domains
-- ============================================================
-- UNIQUE (domain) already created in 007
CREATE INDEX IF NOT EXISTS idx_dd_domain ON public.disposable_domains (domain);

-- ============================================================
-- domain_intelligence
-- ============================================================
-- UNIQUE (tenant_id, domain) already created in 007
CREATE INDEX IF NOT EXISTS idx_di_domain ON public.domain_intelligence (domain);
CREATE INDEX IF NOT EXISTS idx_di_is_catch_all ON public.domain_intelligence (is_catch_all);
CREATE INDEX IF NOT EXISTS idx_di_is_disposable ON public.domain_intelligence (is_disposable);
CREATE INDEX IF NOT EXISTS idx_di_is_mena_gov ON public.domain_intelligence (is_mena_gov);
CREATE INDEX IF NOT EXISTS idx_di_mx_provider ON public.domain_intelligence (mx_provider);
CREATE INDEX IF NOT EXISTS idx_di_tenant_id ON public.domain_intelligence (tenant_id);
CREATE INDEX IF NOT EXISTS idx_di_dns_expires ON public.domain_intelligence (dns_expires_at);

-- ============================================================
-- email_verifications
-- ============================================================
-- UNIQUE (tenant_id, email) already created in 007
CREATE INDEX IF NOT EXISTS idx_ev_expires ON public.email_verifications (expires_at);
CREATE INDEX IF NOT EXISTS idx_ev_email ON public.email_verifications (email);
CREATE INDEX IF NOT EXISTS idx_ev_lead_id ON public.email_verifications (lead_id);
CREATE INDEX IF NOT EXISTS idx_ev_tenant_id ON public.email_verifications (tenant_id);
CREATE INDEX IF NOT EXISTS idx_ev_tenant_verdict ON public.email_verifications (tenant_id, verdict);
CREATE INDEX IF NOT EXISTS idx_ev_verdict ON public.email_verifications (verdict);
CREATE INDEX IF NOT EXISTS idx_ev_verified_at ON public.email_verifications (verified_at);

-- ============================================================
-- enrichment_logs
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_enrichment_logs_lead_id ON public.enrichment_logs (lead_id);
CREATE INDEX IF NOT EXISTS idx_enrichment_logs_status ON public.enrichment_logs (status);

-- ============================================================
-- enrichment_results
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_enrichment_results_class ON public.enrichment_results (class_rating);
CREATE INDEX IF NOT EXISTS idx_enrichment_results_dialect ON public.enrichment_results (recommended_dialect);
CREATE INDEX IF NOT EXISTS idx_enrichment_results_final_score ON public.enrichment_results (final_priority_score);
CREATE INDEX IF NOT EXISTS idx_enrichment_results_lead_id ON public.enrichment_results (lead_id);

-- ============================================================
-- ghl_integrations
-- ============================================================
-- UNIQUE (tenant_id) already created in 006
CREATE INDEX IF NOT EXISTS idx_ghl_integrations_workspace_id ON public.ghl_integrations (ghl_workspace_id);

-- ============================================================
-- heyreach_integrations
-- ============================================================
-- UNIQUE (tenant_id) already created in 006

-- ============================================================
-- individual_entities
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_individual_entities_company_id ON public.individual_entities (company_id);
CREATE INDEX IF NOT EXISTS idx_individual_entities_decision_maker ON public.individual_entities (is_decision_maker);
CREATE INDEX IF NOT EXISTS idx_individual_entities_lead_id ON public.individual_entities (lead_id);
CREATE INDEX IF NOT EXISTS idx_individual_entities_tenant_id ON public.individual_entities (tenant_id);

-- ============================================================
-- influencer_entities
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_influencer_entities_engagement_rate ON public.influencer_entities (engagement_rate);
CREATE INDEX IF NOT EXISTS idx_influencer_entities_instagram_followers ON public.influencer_entities (instagram_followers);
CREATE INDEX IF NOT EXISTS idx_influencer_entities_lead_id ON public.influencer_entities (lead_id);
CREATE INDEX IF NOT EXISTS idx_influencer_entities_platform ON public.influencer_entities (platform);
CREATE INDEX IF NOT EXISTS idx_influencer_entities_tenant_id ON public.influencer_entities (tenant_id);
CREATE INDEX IF NOT EXISTS idx_influencer_entities_topic ON public.influencer_entities (topic_category);
CREATE INDEX IF NOT EXISTS idx_influencer_entities_youtube_followers ON public.influencer_entities (youtube_followers);

-- ============================================================
-- instantly_integrations
-- ============================================================
-- UNIQUE (tenant_id) already created in 006
CREATE INDEX IF NOT EXISTS idx_instantly_integrations_account_id ON public.instantly_integrations (instantly_account_id);

-- ============================================================
-- integration_credentials
-- ============================================================
-- UNIQUE (tenant_id, provider) already created in 006
CREATE INDEX IF NOT EXISTS idx_integration_credentials_provider ON public.integration_credentials (provider);
CREATE INDEX IF NOT EXISTS idx_integration_credentials_tenant_id ON public.integration_credentials (tenant_id);
CREATE INDEX IF NOT EXISTS idx_integration_credentials_tenant_provider_active ON public.integration_credentials (tenant_id, provider, is_active);

-- ============================================================
-- integrations_audit
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_integrations_audit_created_at ON public.integrations_audit (created_at);
CREATE INDEX IF NOT EXISTS idx_integrations_audit_tenant_action ON public.integrations_audit (tenant_id, action);

-- ============================================================
-- invitations
-- ============================================================
-- UNIQUE (token) already created in 001
CREATE INDEX IF NOT EXISTS idx_invitations_email ON public.invitations (email);
CREATE INDEX IF NOT EXISTS idx_invitations_expires_at ON public.invitations (expires_at);
CREATE INDEX IF NOT EXISTS idx_invitations_tenant_status ON public.invitations (tenant_id, status);

-- ============================================================
-- lead_scores_history
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_lead_scores_history_campaign_id ON public.lead_scores_history (campaign_id);
CREATE INDEX IF NOT EXISTS idx_lead_scores_history_created_at ON public.lead_scores_history (created_at);
CREATE INDEX IF NOT EXISTS idx_lead_scores_history_lead_id ON public.lead_scores_history (lead_id);

-- ============================================================
-- leads
-- ============================================================
-- UNIQUE (tenant_id, external_id, source_hash) already created in 002
CREATE INDEX IF NOT EXISTS idx_leads_campaign_id ON public.leads USING gin (campaign_id);
CREATE INDEX IF NOT EXISTS idx_leads_fit_score ON public.leads (fit_score);
CREATE INDEX IF NOT EXISTS idx_leads_lead_type ON public.leads (lead_type);
CREATE INDEX IF NOT EXISTS idx_leads_priority_class ON public.leads (priority_class);
CREATE INDEX IF NOT EXISTS idx_leads_scraper_type ON public.leads (scraper_type);
CREATE INDEX IF NOT EXISTS idx_leads_tenant_email ON public.leads (tenant_id, email);

-- ============================================================
-- runs
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_runs_created_at ON public.runs (created_at);
CREATE INDEX IF NOT EXISTS idx_runs_created_by ON public.runs (created_by);
CREATE INDEX IF NOT EXISTS idx_runs_status ON public.runs (status);
CREATE INDEX IF NOT EXISTS idx_runs_tenant_id ON public.runs (tenant_id);

-- ============================================================
-- scraper_jobs
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_scraper_jobs_scraper_run_id ON public.scraper_jobs (scraper_run_id);
CREATE INDEX IF NOT EXISTS idx_scraper_jobs_status ON public.scraper_jobs (status);

-- ============================================================
-- scraper_runs
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_scraper_runs_created_at ON public.scraper_runs (created_at);
CREATE INDEX IF NOT EXISTS idx_scraper_runs_scraper_type ON public.scraper_runs (scraper_type);
CREATE INDEX IF NOT EXISTS idx_scraper_runs_tenant_status ON public.scraper_runs (tenant_id, status);

-- ============================================================
-- scraper_types
-- ============================================================
-- UNIQUE (name) already created in 004

-- ============================================================
-- signal_audit_log
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_action ON public.signal_audit_log (action_type);
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_actor ON public.signal_audit_log (actor_user_id);
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_campaign ON public.signal_audit_log (campaign_id);
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_category ON public.signal_audit_log (action_category);
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_created ON public.signal_audit_log (created_at);
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_signal ON public.signal_audit_log (signal_id);
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_tenant ON public.signal_audit_log (tenant_id);
CREATE INDEX IF NOT EXISTS idx_signal_audit_log_tenant_date ON public.signal_audit_log (tenant_id, created_at);

-- ============================================================
-- signal_campaign_runs
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signal_campaign_runs_campaign ON public.signal_campaign_runs (campaign_id);
CREATE INDEX IF NOT EXISTS idx_signal_campaign_runs_status ON public.signal_campaign_runs (status);
CREATE INDEX IF NOT EXISTS idx_signal_campaign_runs_tenant ON public.signal_campaign_runs (tenant_id);

-- ============================================================
-- signal_campaigns
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signal_campaigns_client ON public.signal_campaigns (client_id);
CREATE INDEX IF NOT EXISTS idx_signal_campaigns_dates ON public.signal_campaigns (start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_signal_campaigns_status ON public.signal_campaigns (campaign_status);
CREATE INDEX IF NOT EXISTS idx_signal_campaigns_tenant ON public.signal_campaigns (tenant_id);
CREATE INDEX IF NOT EXISTS idx_signal_campaigns_tenant_client ON public.signal_campaigns (tenant_id, client_id);
CREATE INDEX IF NOT EXISTS idx_signal_campaigns_tenant_status ON public.signal_campaigns (tenant_id, campaign_status);
-- UNIQUE (tenant_id, client_id, campaign_name) already created in 005

-- ============================================================
-- signal_clients
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signal_clients_status ON public.signal_clients (client_status);
CREATE INDEX IF NOT EXISTS idx_signal_clients_tenant ON public.signal_clients (tenant_id);
CREATE INDEX IF NOT EXISTS idx_signal_clients_tenant_status ON public.signal_clients (tenant_id, client_status);
-- UNIQUE (tenant_id, client_id) already created in 005
-- UNIQUE (tenant_id, client_name) already created in 005

-- ============================================================
-- signal_credit_usage
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signal_credit_usage_created ON public.signal_credit_usage (created_at);
CREATE INDEX IF NOT EXISTS idx_signal_credit_usage_signal ON public.signal_credit_usage (signal_id);
CREATE INDEX IF NOT EXISTS idx_signal_credit_usage_tenant ON public.signal_credit_usage (tenant_id);
CREATE INDEX IF NOT EXISTS idx_signal_credit_usage_tenant_type ON public.signal_credit_usage (tenant_id, credit_type);
CREATE INDEX IF NOT EXISTS idx_signal_credit_usage_type ON public.signal_credit_usage (credit_type);

-- ============================================================
-- signal_events
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signal_events_run_id ON public.signal_events (signal_run_id);
CREATE INDEX IF NOT EXISTS idx_signal_events_campaign ON public.signal_events (campaign_id);
CREATE INDEX IF NOT EXISTS idx_signal_events_company ON public.signal_events (company_name);
CREATE INDEX IF NOT EXISTS idx_signal_events_company_domain ON public.signal_events (company_domain);
CREATE INDEX IF NOT EXISTS idx_signal_events_created ON public.signal_events (created_at);
CREATE INDEX IF NOT EXISTS idx_signal_events_dashboard ON public.signal_events (tenant_id, created_at DESC, score_tier);
CREATE INDEX IF NOT EXISTS idx_signal_events_decision ON public.signal_events (outreach_decision);
CREATE INDEX IF NOT EXISTS idx_signal_events_detail_gin ON public.signal_events USING gin (signal_detail);
CREATE INDEX IF NOT EXISTS idx_signal_events_enrichment ON public.signal_events (enrichment_status);
CREATE INDEX IF NOT EXISTS idx_signal_events_enrichment_gin ON public.signal_events USING gin (enrichment_data);
CREATE INDEX IF NOT EXISTS idx_signal_events_outreach ON public.signal_events (outreach_status);
CREATE INDEX IF NOT EXISTS idx_signal_events_score ON public.signal_events (composite_score);
CREATE INDEX IF NOT EXISTS idx_signal_events_score_gin ON public.signal_events USING gin (score_breakdown);
CREATE INDEX IF NOT EXISTS idx_signal_events_tenant ON public.signal_events (tenant_id);
CREATE INDEX IF NOT EXISTS idx_signal_events_tenant_campaign ON public.signal_events (tenant_id, campaign_id);
CREATE INDEX IF NOT EXISTS idx_signal_events_tenant_client ON public.signal_events (tenant_id, client_id);

-- ============================================================
-- signal_templates
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signal_templates_active ON public.signal_templates (is_active);
CREATE INDEX IF NOT EXISTS idx_signal_templates_tenant ON public.signal_templates (tenant_id);
CREATE INDEX IF NOT EXISTS idx_signal_templates_tenant_type ON public.signal_templates (tenant_id, signal_type_id);
CREATE INDEX IF NOT EXISTS idx_signal_templates_type ON public.signal_templates (signal_type_id);
-- UNIQUE (tenant_id, signal_type_id, template_name) already created in 005

-- ============================================================
-- signal_types
-- ============================================================
-- UNIQUE (signal_type_name) already created in 005

-- ============================================================
-- signal_weights
-- ============================================================
-- UNIQUE (customer_id, signal_type) already created in 008
CREATE INDEX IF NOT EXISTS idx_signal_weights_customer ON public.signal_weights (customer_id);

-- ============================================================
-- signals
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_signals_account_detected ON public.signals (account_id, detected_at);
CREATE INDEX IF NOT EXISTS idx_signals_customer_type ON public.signals (customer_id, signal_type);
CREATE INDEX IF NOT EXISTS idx_signals_expires ON public.signals (expires_at);

-- ============================================================
-- tenant_credits
-- ============================================================
-- UNIQUE (tenant_id) already created in 001

-- ============================================================
-- tenant_leads
-- ============================================================
-- UNIQUE (tenant_id, lead_id) already created in 002
CREATE INDEX IF NOT EXISTS idx_tenant_leads_lead_id ON public.tenant_leads (lead_id);
CREATE INDEX IF NOT EXISTS idx_tenant_leads_source_run_id ON public.tenant_leads (source_run_id);
CREATE INDEX IF NOT EXISTS idx_tenant_leads_tenant_id ON public.tenant_leads (tenant_id);

-- ============================================================
-- tenants
-- ============================================================
-- UNIQUE (workspace_name) already created in 001

-- ============================================================
-- users
-- ============================================================
-- UNIQUE (tenant_id, email) already created in 001
CREATE INDEX IF NOT EXISTS idx_users_tenant_email ON public.users (tenant_id, email);

-- ============================================================
-- verification_queue
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_vq_batch ON public.verification_queue (tenant_id, status, scheduled_at);
CREATE INDEX IF NOT EXISTS idx_vq_email ON public.verification_queue (email);
CREATE INDEX IF NOT EXISTS idx_vq_lead_id ON public.verification_queue (lead_id);
CREATE INDEX IF NOT EXISTS idx_vq_scheduled_at ON public.verification_queue (scheduled_at);
CREATE INDEX IF NOT EXISTS idx_vq_status ON public.verification_queue (status);
CREATE INDEX IF NOT EXISTS idx_vq_status_priority ON public.verification_queue (status, priority);
CREATE INDEX IF NOT EXISTS idx_vq_tenant_id ON public.verification_queue (tenant_id);
