-- ============================================
-- Email Verification Module — ALL MIGRATIONS COMBINED
-- Project: Signal Sales Engine (SSE)
-- Supabase Project: ozylyahdhuueozqhxiwz
-- Run this in Supabase SQL Editor in ONE go
-- ============================================

-- ============================================
-- MIGRATION 001: Core Tables (6 tables)
-- ============================================

CREATE TABLE IF NOT EXISTS public.email_verifications (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID NOT NULL,
    email                   TEXT NOT NULL,
    lead_id                 UUID,
    l1_syntax_valid         BOOLEAN,
    l1_format_score         NUMERIC(3,2),
    l2_domain_exists        BOOLEAN,
    l2_mx_records           JSONB DEFAULT '[]',
    l2_is_catch_all         BOOLEAN,
    l2_is_disposable        BOOLEAN,
    l2_domain_age_days      INTEGER,
    l3_mailbox_exists       BOOLEAN,
    l3_smtp_code            INTEGER,
    l3_smtp_message         TEXT,
    l3_is_role_account      BOOLEAN,
    l4_data_confidence      NUMERIC(3,2),
    l4_historical_bounces   INTEGER DEFAULT 0,
    l4_last_seen_active     TIMESTAMPTZ,
    l4_engagement_score     NUMERIC(3,2),
    verdict                 TEXT NOT NULL DEFAULT 'unknown'
                            CHECK (verdict IN (
                                'deliverable', 'risky', 'undeliverable',
                                'unknown', 'catch_all', 'disposable'
                            )),
    risk_score              NUMERIC(3,2),
    verification_provider   TEXT,
    verified_at             TIMESTAMPTZ,
    expires_at              TIMESTAMPTZ,
    raw_response            JSONB DEFAULT '{}',
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.email_verifications
    ADD CONSTRAINT uq_email_verifications_tenant_email
    UNIQUE (tenant_id, email);

CREATE TABLE IF NOT EXISTS public.domain_intelligence (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID NOT NULL,
    domain                  TEXT NOT NULL,
    mx_records              JSONB DEFAULT '[]',
    mx_provider             TEXT,
    has_spf                 BOOLEAN,
    has_dkim                BOOLEAN,
    has_dmarc               BOOLEAN,
    dmarc_policy            TEXT,
    is_catch_all            BOOLEAN,
    is_disposable           BOOLEAN,
    is_government           BOOLEAN DEFAULT FALSE,
    domain_age_days         INTEGER,
    registrar               TEXT,
    country_code            TEXT,
    is_mena_gov             BOOLEAN DEFAULT FALSE,
    gov_tld_pattern         TEXT,
    last_checked_at         TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.domain_intelligence
    ADD CONSTRAINT uq_domain_intelligence_tenant_domain
    UNIQUE (tenant_id, domain);

CREATE TABLE IF NOT EXISTS public.bounce_signals (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id                   UUID NOT NULL,
    email                       TEXT NOT NULL,
    email_verification_id       UUID REFERENCES public.email_verifications(id) ON DELETE SET NULL,
    bounce_type                 TEXT NOT NULL CHECK (bounce_type IN ('hard', 'soft', 'complaint', 'block')),
    bounce_code                 TEXT,
    bounce_reason               TEXT,
    source_platform             TEXT,
    source_campaign_id          UUID,
    sending_account_age_days    INTEGER,
    is_warmup_period            BOOLEAN DEFAULT FALSE,
    bounce_weight               NUMERIC(3,2) DEFAULT 1.00,
    bounced_at                  TIMESTAMPTZ NOT NULL,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.verification_queue (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id               UUID NOT NULL,
    email                   TEXT NOT NULL,
    lead_id                 UUID,
    priority                INTEGER NOT NULL DEFAULT 5 CHECK (priority BETWEEN 1 AND 10),
    status                  TEXT NOT NULL DEFAULT 'pending'
                            CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
    attempts                INTEGER NOT NULL DEFAULT 0,
    max_attempts            INTEGER NOT NULL DEFAULT 3,
    last_error              TEXT,
    scheduled_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    started_at              TIMESTAMPTZ,
    completed_at            TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.disposable_domains (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain                  TEXT NOT NULL UNIQUE,
    source                  TEXT DEFAULT 'seed',
    added_at                TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.arabic_name_mappings (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    arabic_name             TEXT NOT NULL,
    romanized_variants      TEXT[] NOT NULL,
    gender                  TEXT CHECK (gender IN ('male', 'female', 'unisex')),
    frequency_rank          INTEGER,
    region                  TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.arabic_name_mappings
    ADD CONSTRAINT uq_arabic_name_mappings_name
    UNIQUE (arabic_name);


-- ============================================
-- MIGRATION 002: Indexes & RLS
-- ============================================

CREATE INDEX IF NOT EXISTS idx_ev_tenant_id ON public.email_verifications (tenant_id);
CREATE INDEX IF NOT EXISTS idx_ev_email ON public.email_verifications (email);
CREATE INDEX IF NOT EXISTS idx_ev_lead_id ON public.email_verifications (lead_id) WHERE lead_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_ev_verdict ON public.email_verifications (verdict);
CREATE INDEX IF NOT EXISTS idx_ev_tenant_verdict ON public.email_verifications (tenant_id, verdict);
CREATE INDEX IF NOT EXISTS idx_ev_verified_at ON public.email_verifications (verified_at DESC NULLS LAST);
CREATE INDEX IF NOT EXISTS idx_ev_expires_at ON public.email_verifications (expires_at) WHERE expires_at IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_di_tenant_id ON public.domain_intelligence (tenant_id);
CREATE INDEX IF NOT EXISTS idx_di_domain ON public.domain_intelligence (domain);
CREATE INDEX IF NOT EXISTS idx_di_mx_provider ON public.domain_intelligence (mx_provider) WHERE mx_provider IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_di_is_catch_all ON public.domain_intelligence (is_catch_all) WHERE is_catch_all = TRUE;
CREATE INDEX IF NOT EXISTS idx_di_is_disposable ON public.domain_intelligence (is_disposable) WHERE is_disposable = TRUE;
CREATE INDEX IF NOT EXISTS idx_di_is_mena_gov ON public.domain_intelligence (is_mena_gov) WHERE is_mena_gov = TRUE;

CREATE INDEX IF NOT EXISTS idx_bs_tenant_id ON public.bounce_signals (tenant_id);
CREATE INDEX IF NOT EXISTS idx_bs_email ON public.bounce_signals (email);
CREATE INDEX IF NOT EXISTS idx_bs_tenant_email ON public.bounce_signals (tenant_id, email);
CREATE INDEX IF NOT EXISTS idx_bs_verification_id ON public.bounce_signals (email_verification_id) WHERE email_verification_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_bs_bounce_type ON public.bounce_signals (bounce_type);
CREATE INDEX IF NOT EXISTS idx_bs_source_platform ON public.bounce_signals (source_platform) WHERE source_platform IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_bs_bounced_at ON public.bounce_signals (bounced_at DESC);
CREATE INDEX IF NOT EXISTS idx_bs_warmup ON public.bounce_signals (is_warmup_period) WHERE is_warmup_period = TRUE;

CREATE INDEX IF NOT EXISTS idx_vq_tenant_id ON public.verification_queue (tenant_id);
CREATE INDEX IF NOT EXISTS idx_vq_status ON public.verification_queue (status);
CREATE INDEX IF NOT EXISTS idx_vq_status_priority ON public.verification_queue (status, priority ASC, scheduled_at ASC) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_vq_email ON public.verification_queue (email);
CREATE INDEX IF NOT EXISTS idx_vq_lead_id ON public.verification_queue (lead_id) WHERE lead_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_vq_scheduled_at ON public.verification_queue (scheduled_at);

CREATE INDEX IF NOT EXISTS idx_dd_domain ON public.disposable_domains (domain);

CREATE INDEX IF NOT EXISTS idx_anm_arabic_name ON public.arabic_name_mappings (arabic_name);
CREATE INDEX IF NOT EXISTS idx_anm_region ON public.arabic_name_mappings (region) WHERE region IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_anm_romanized ON public.arabic_name_mappings USING GIN (romanized_variants);

-- RLS
ALTER TABLE public.email_verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.domain_intelligence ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bounce_signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.verification_queue ENABLE ROW LEVEL SECURITY;

CREATE POLICY ev_select_tenant ON public.email_verifications FOR SELECT USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY ev_insert_tenant ON public.email_verifications FOR INSERT WITH CHECK (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY ev_update_tenant ON public.email_verifications FOR UPDATE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY ev_delete_tenant ON public.email_verifications FOR DELETE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);

CREATE POLICY di_select_tenant ON public.domain_intelligence FOR SELECT USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY di_insert_tenant ON public.domain_intelligence FOR INSERT WITH CHECK (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY di_update_tenant ON public.domain_intelligence FOR UPDATE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY di_delete_tenant ON public.domain_intelligence FOR DELETE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);

CREATE POLICY bs_select_tenant ON public.bounce_signals FOR SELECT USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY bs_insert_tenant ON public.bounce_signals FOR INSERT WITH CHECK (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY bs_update_tenant ON public.bounce_signals FOR UPDATE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY bs_delete_tenant ON public.bounce_signals FOR DELETE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);

CREATE POLICY vq_select_tenant ON public.verification_queue FOR SELECT USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY vq_insert_tenant ON public.verification_queue FOR INSERT WITH CHECK (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY vq_update_tenant ON public.verification_queue FOR UPDATE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
CREATE POLICY vq_delete_tenant ON public.verification_queue FOR DELETE USING (tenant_id = current_setting('app.current_tenant_id')::UUID);


-- ============================================
-- MIGRATION 003: Auto-Queue Trigger
-- ============================================

CREATE OR REPLACE FUNCTION public.fn_auto_queue_verification()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    IF NEW.verdict = 'unknown' OR NEW.verdict IS NULL THEN
        INSERT INTO public.verification_queue (
            tenant_id, email, lead_id, priority, status, scheduled_at
        ) VALUES (
            NEW.tenant_id, NEW.email, NEW.lead_id, 5, 'pending', now()
        ) ON CONFLICT DO NOTHING;
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_auto_queue_verification ON public.email_verifications;
CREATE TRIGGER trg_auto_queue_verification
    AFTER INSERT ON public.email_verifications
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_auto_queue_verification();

DROP TRIGGER IF EXISTS trg_auto_requeue_verification ON public.email_verifications;
CREATE TRIGGER trg_auto_requeue_verification
    AFTER UPDATE OF verdict ON public.email_verifications
    FOR EACH ROW
    WHEN (NEW.verdict = 'unknown' AND OLD.verdict IS DISTINCT FROM 'unknown')
    EXECUTE FUNCTION public.fn_auto_queue_verification();


-- ============================================
-- MIGRATION 004: Seed Data
-- ============================================

-- Arabic name romanization mappings (Top 50)
INSERT INTO public.arabic_name_mappings (arabic_name, romanized_variants, gender, frequency_rank, region) VALUES
    ('محمد', ARRAY['mohammed','muhammad','mohamed','mohamad','mohammad','muhammed'], 'male', 1, 'general'),
    ('أحمد', ARRAY['ahmed','ahmad','ahmet'], 'male', 2, 'general'),
    ('علي', ARRAY['ali','aly'], 'male', 3, 'general'),
    ('عبدالله', ARRAY['abdullah','abdallah','abdalla','abd allah'], 'male', 4, 'general'),
    ('عبدالرحمن', ARRAY['abdulrahman','abdelrahman','abdul rahman','abd al-rahman','abderrahman'], 'male', 5, 'general'),
    ('خالد', ARRAY['khaled','khalid','khald'], 'male', 6, 'general'),
    ('عمر', ARRAY['omar','omer','umar'], 'male', 7, 'general'),
    ('يوسف', ARRAY['youssef','yousef','yusuf','yosef','yousuf','joseph'], 'male', 8, 'general'),
    ('إبراهيم', ARRAY['ibrahim','ebrahim','abraham','ibraheem'], 'male', 9, 'general'),
    ('حسن', ARRAY['hassan','hasan','hasen'], 'male', 10, 'general'),
    ('حسين', ARRAY['hussein','husain','hussain','hossein','hosein'], 'male', 11, 'general'),
    ('سعيد', ARRAY['saeed','said','saeid','saied'], 'male', 12, 'general'),
    ('فاطمة', ARRAY['fatima','fatma','fatimah','fatime'], 'female', 13, 'general'),
    ('عائشة', ARRAY['aisha','aysha','aicha','ayesha','aesha'], 'female', 14, 'general'),
    ('مريم', ARRAY['maryam','mariam','mariem','myriam','miriam'], 'female', 15, 'general'),
    ('نورة', ARRAY['noura','nora','noorah','norah'], 'female', 16, 'gulf'),
    ('سلطان', ARRAY['sultan','soltan'], 'male', 17, 'gulf'),
    ('فيصل', ARRAY['faisal','faysal','feisal','faycel'], 'male', 18, 'gulf'),
    ('سعود', ARRAY['saud','saoud','sauod'], 'male', 19, 'gulf'),
    ('ناصر', ARRAY['nasser','naser','nasir','nasr'], 'male', 20, 'general'),
    ('طارق', ARRAY['tariq','tarek','tarik','tareq'], 'male', 21, 'general'),
    ('عبدالعزيز', ARRAY['abdulaziz','abdelaziz','abdul aziz','abd al-aziz'], 'male', 22, 'gulf'),
    ('سارة', ARRAY['sara','sarah','sahra'], 'female', 23, 'general'),
    ('لينا', ARRAY['lina','leena','lena'], 'female', 24, 'levant'),
    ('هند', ARRAY['hind','hend'], 'female', 25, 'general'),
    ('منصور', ARRAY['mansour','mansoor','mansor'], 'male', 26, 'general'),
    ('ماجد', ARRAY['majed','majid','maged'], 'male', 27, 'general'),
    ('رائد', ARRAY['raed','raid','raeed'], 'male', 28, 'general'),
    ('سامي', ARRAY['sami','sammy','samy'], 'male', 29, 'general'),
    ('كريم', ARRAY['karim','kareem','kerim'], 'male', 30, 'general'),
    ('جمال', ARRAY['jamal','gamal','jamaal','djamel'], 'male', 31, 'general'),
    ('حمد', ARRAY['hamad','hamed','hamd'], 'male', 32, 'gulf'),
    ('راشد', ARRAY['rashid','rashed','rachid','rasheed'], 'male', 33, 'gulf'),
    ('زايد', ARRAY['zayed','zaid','zayid'], 'male', 34, 'gulf'),
    ('مبارك', ARRAY['mubarak','mobarak','moubarak','mbarek'], 'male', 35, 'gulf'),
    ('عادل', ARRAY['adel','adil','adeel'], 'male', 36, 'general'),
    ('نادية', ARRAY['nadia','nadya','nadiya'], 'female', 37, 'general'),
    ('ريم', ARRAY['reem','rima','rim'], 'female', 38, 'general'),
    ('دانة', ARRAY['dana','danah','danna'], 'female', 39, 'gulf'),
    ('لطيفة', ARRAY['latifa','lateefa','latifah','ltifa'], 'female', 40, 'gulf'),
    ('وليد', ARRAY['walid','waleed','oualid'], 'male', 41, 'general'),
    ('بدر', ARRAY['badr','bader','bedr'], 'male', 42, 'gulf'),
    ('تركي', ARRAY['turki','turky','torki'], 'male', 43, 'gulf'),
    ('مشعل', ARRAY['mishal','meshal','mishaal','mashaal'], 'male', 44, 'gulf'),
    ('هشام', ARRAY['hisham','hesham','hicham','hichem'], 'male', 45, 'general'),
    ('ياسر', ARRAY['yasser','yaser','yasir','yassir'], 'male', 46, 'general'),
    ('نواف', ARRAY['nawaf','nowaf','nawwaf'], 'male', 47, 'gulf'),
    ('أمل', ARRAY['amal','amel','amaal'], 'female', 48, 'general'),
    ('مها', ARRAY['maha','mahha'], 'female', 49, 'general'),
    ('تميم', ARRAY['tamim','tameem','tammam'], 'male', 50, 'gulf')
ON CONFLICT (arabic_name) DO UPDATE SET
    romanized_variants = EXCLUDED.romanized_variants,
    gender = EXCLUDED.gender,
    frequency_rank = EXCLUDED.frequency_rank,
    region = EXCLUDED.region,
    updated_at = now();

-- MENA government domains
INSERT INTO public.domain_intelligence (tenant_id, domain, is_government, is_mena_gov, is_catch_all, gov_tld_pattern, country_code, last_checked_at) VALUES
    ('00000000-0000-0000-0000-000000000000', 'gov.sa',       TRUE, TRUE, TRUE, '*.gov.sa',       'SA', now()),
    ('00000000-0000-0000-0000-000000000000', 'moe.gov.sa',   TRUE, TRUE, TRUE, '*.gov.sa',       'SA', now()),
    ('00000000-0000-0000-0000-000000000000', 'moh.gov.sa',   TRUE, TRUE, TRUE, '*.gov.sa',       'SA', now()),
    ('00000000-0000-0000-0000-000000000000', 'mci.gov.sa',   TRUE, TRUE, TRUE, '*.gov.sa',       'SA', now()),
    ('00000000-0000-0000-0000-000000000000', 'mofa.gov.sa',  TRUE, TRUE, TRUE, '*.gov.sa',       'SA', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.ae',       TRUE, TRUE, TRUE, '*.gov.ae',       'AE', now()),
    ('00000000-0000-0000-0000-000000000000', 'mofaic.gov.ae',TRUE, TRUE, TRUE, '*.gov.ae',       'AE', now()),
    ('00000000-0000-0000-0000-000000000000', 'mohre.gov.ae', TRUE, TRUE, TRUE, '*.gov.ae',       'AE', now()),
    ('00000000-0000-0000-0000-000000000000', 'economy.gov.ae',TRUE, TRUE, TRUE, '*.gov.ae',      'AE', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.qa',       TRUE, TRUE, TRUE, '*.gov.qa',       'QA', now()),
    ('00000000-0000-0000-0000-000000000000', 'moi.gov.qa',   TRUE, TRUE, TRUE, '*.gov.qa',       'QA', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.kw',       TRUE, TRUE, TRUE, '*.gov.kw',       'KW', now()),
    ('00000000-0000-0000-0000-000000000000', 'mof.gov.kw',   TRUE, TRUE, TRUE, '*.gov.kw',       'KW', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.bh',       TRUE, TRUE, TRUE, '*.gov.bh',       'BH', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.om',       TRUE, TRUE, TRUE, '*.gov.om',       'OM', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.jo',       TRUE, TRUE, TRUE, '*.gov.jo',       'JO', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.eg',       TRUE, TRUE, TRUE, '*.gov.eg',       'EG', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.iq',       TRUE, TRUE, TRUE, '*.gov.iq',       'IQ', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.lb',       TRUE, TRUE, TRUE, '*.gov.lb',       'LB', now()),
    ('00000000-0000-0000-0000-000000000000', 'gov.ma',       TRUE, TRUE, TRUE, '*.gov.ma',       'MA', now())
ON CONFLICT (tenant_id, domain) DO UPDATE SET
    is_government = EXCLUDED.is_government,
    is_mena_gov = EXCLUDED.is_mena_gov,
    is_catch_all = EXCLUDED.is_catch_all,
    gov_tld_pattern = EXCLUDED.gov_tld_pattern,
    country_code = EXCLUDED.country_code,
    last_checked_at = EXCLUDED.last_checked_at,
    updated_at = now();

-- Disposable domains (Top 500)
INSERT INTO public.disposable_domains (domain, source) VALUES
    ('mailinator.com', 'seed'),('guerrillamail.com', 'seed'),('guerrillamail.net', 'seed'),
    ('guerrillamail.org', 'seed'),('guerrillamail.de', 'seed'),('grr.la', 'seed'),
    ('tempmail.com', 'seed'),('temp-mail.org', 'seed'),('temp-mail.io', 'seed'),
    ('throwaway.email', 'seed'),('yopmail.com', 'seed'),('yopmail.fr', 'seed'),
    ('yopmail.net', 'seed'),('sharklasers.com', 'seed'),('guerrillamailblock.com', 'seed'),
    ('dispostable.com', 'seed'),('10minutemail.com', 'seed'),('10minutemail.net', 'seed'),
    ('20minutemail.com', 'seed'),('trashmail.com', 'seed'),('trashmail.me', 'seed'),
    ('trashmail.net', 'seed'),('trashmail.org', 'seed'),('trashmail.io', 'seed'),
    ('mailnesia.com', 'seed'),('maildrop.cc', 'seed'),('discard.email', 'seed'),
    ('fakeinbox.com', 'seed'),('mailcatch.com', 'seed'),('mintemail.com', 'seed'),
    ('meltmail.com', 'seed'),('tempail.com', 'seed'),('mohmal.com', 'seed'),
    ('emailondeck.com', 'seed'),('tempr.email', 'seed'),('33mail.com', 'seed'),
    ('mailexpire.com', 'seed'),('jetable.org', 'seed'),('nospam.ze.tc', 'seed'),
    ('spamgourmet.com', 'seed'),('mytemp.email', 'seed'),('tmpmail.org', 'seed'),
    ('tmpmail.net', 'seed'),('binkmail.com', 'seed'),('filzmail.com', 'seed'),
    ('spamfree24.org', 'seed'),('crazymailing.com', 'seed'),('armyspy.com', 'seed'),
    ('cuvox.de', 'seed'),('dayrep.com', 'seed'),('einrot.com', 'seed'),
    ('fleckens.hu', 'seed'),('gustr.com', 'seed'),('jourrapide.com', 'seed'),
    ('rhyta.com', 'seed'),('superrito.com', 'seed'),('teleworm.us', 'seed'),
    ('tempomail.fr', 'seed'),('tittbit.in', 'seed'),('trashinbox.com', 'seed'),
    ('mailtemp.info', 'seed'),('harakirimail.com', 'seed'),('mailforspam.com', 'seed'),
    ('safetymail.info', 'seed'),('trashymail.com', 'seed'),('trashymail.net', 'seed'),
    ('mailhazard.com', 'seed'),('mailhazard.us', 'seed'),('bspamfree.org', 'seed'),
    ('spambox.us', 'seed'),('spamcero.com', 'seed'),('spamherelots.com', 'seed'),
    ('uggsrock.com', 'seed'),('tempsky.com', 'seed'),('getnada.com', 'seed'),
    ('abyssmail.com', 'seed'),('boximail.com', 'seed'),('clrmail.com', 'seed'),
    ('dropmail.me', 'seed'),('emailfake.com', 'seed'),('emkei.cz', 'seed'),
    ('fakemail.net', 'seed'),('fixmail.tk', 'seed'),('flurred.com', 'seed'),
    ('getairmail.com', 'seed'),('givmail.com', 'seed'),('inboxbear.com', 'seed'),
    ('mailnator.com', 'seed'),('mailsac.com', 'seed'),('moakt.com', 'seed'),
    ('mvrht.com', 'seed'),('nwytg.net', 'seed'),('pokemail.net', 'seed'),
    ('protonmail.com', 'seed'),('receiveee.com', 'seed'),('spamstack.net', 'seed'),
    ('sute.jp', 'seed'),('tempinbox.com', 'seed'),('tempmailaddress.com', 'seed'),
    ('wegwerfmail.de', 'seed'),('wegwerfmail.net', 'seed'),('wegwerfmail.org', 'seed'),
    ('wh4f.org', 'seed'),('yolanda.dev', 'seed'),('zeroe.ml', 'seed'),
    ('spam4.me', 'seed'),('trash-mail.at', 'seed'),('trash-mail.com', 'seed'),
    ('trashcanmail.com', 'seed'),('mailinator.net', 'seed'),('mailinator.org', 'seed'),
    ('mailinater.com', 'seed'),('mailinator2.com', 'seed'),('reallymymail.com', 'seed'),
    ('reconmail.com', 'seed'),('sogetthis.com', 'seed'),('soodonims.com', 'seed'),
    ('spamevader.com', 'seed'),('spamspot.com', 'seed'),('tempemail.co.za', 'seed'),
    ('tempemail.net', 'seed'),('tempmail.eu', 'seed'),('tempmail.it', 'seed'),
    ('tempmailer.com', 'seed'),('tempmailo.com', 'seed'),('tempmails.org', 'seed'),
    ('temporaryemail.net', 'seed'),('temporaryemail.us', 'seed'),
    ('temporaryforwarding.com', 'seed'),('temporaryinbox.com', 'seed'),
    ('thankyou2010.com', 'seed'),('thisisnotmyrealemail.com', 'seed'),
    ('throwawayemailaddress.com', 'seed'),('tmail.ws', 'seed'),('tmails.net', 'seed'),
    ('tradepulse.email', 'seed'),('trbvm.com', 'seed'),('trialmail.de', 'seed'),
    ('trickmail.net', 'seed'),('veryreallyelongatedname.com', 'seed'),
    ('vomoto.com', 'seed'),('vpn.st', 'seed'),('vsimcard.com', 'seed'),
    ('vubby.com', 'seed'),('w3internet.co.uk', 'seed'),('whatiaas.com', 'seed'),
    ('whatpaas.com', 'seed'),('wimsg.com', 'seed'),('worldspace.link', 'seed'),
    ('wxnw.net', 'seed'),('xagloo.com', 'seed'),('xemaps.com', 'seed'),
    ('xjoi.com', 'seed'),('xmail.com', 'seed'),('xmaily.com', 'seed'),
    ('xoxox.cc', 'seed'),('xyzfree.net', 'seed'),('yapped.net', 'seed'),
    ('yeah.net', 'seed'),('yep.it', 'seed'),('yogamaven.com', 'seed'),
    ('ypmail.webarnak.fr.eu.org', 'seed'),('yuurok.com', 'seed'),
    ('zehnminuten.de', 'seed'),('zehnminutenmail.de', 'seed'),
    ('zippymail.info', 'seed'),('zoaxe.com', 'seed'),('zoemail.org', 'seed'),
    ('anonbox.net', 'seed'),('anonymbox.com', 'seed'),('antichef.com', 'seed'),
    ('antichef.net', 'seed'),('antireg.ru', 'seed'),('antispam.de', 'seed'),
    ('antispammail.de', 'seed'),('baxomale.ht.cx', 'seed'),('beefmilk.com', 'seed'),
    ('bigstring.com', 'seed'),('bio-muesli.net', 'seed'),('bobmail.info', 'seed'),
    ('bodhi.lawlita.com', 'seed'),('bofthew.com', 'seed'),('bootybay.de', 'seed'),
    ('boun.cr', 'seed'),('bouncr.com', 'seed'),('breakthru.com', 'seed'),
    ('brefmail.com', 'seed'),('broadbandninja.com', 'seed'),('bsnow.net', 'seed'),
    ('buffemail.com', 'seed'),('bugmenot.com', 'seed'),('bumpymail.com', 'seed'),
    ('bund.us', 'seed'),('bundes-ede.de', 'seed'),('burnthespam.info', 'seed'),
    ('buyusedlibrarybooks.org', 'seed'),('byom.de', 'seed'),('c2.hu', 'seed'),
    ('cachedot.net', 'seed'),('casualdx.com', 'seed'),('cellurl.com', 'seed'),
    ('centermail.com', 'seed'),('centermail.net', 'seed'),('chammy.info', 'seed'),
    ('cheatmail.de', 'seed'),('chogmail.com', 'seed'),('choicemail1.com', 'seed'),
    ('clixser.com', 'seed'),('cmail.net', 'seed'),('cmail.org', 'seed'),
    ('coldemail.info', 'seed'),('cool.fr.nf', 'seed'),('correo.blogos.net', 'seed'),
    ('cosmorph.com', 'seed'),('courriel.fr.nf', 'seed'),
    ('courrieltemporaire.com', 'seed'),('cubiclink.com', 'seed'),
    ('curryworld.de', 'seed'),('dacoolest.com', 'seed'),('dandikmail.com', 'seed'),
    ('dbunker.com', 'seed'),('dcemail.com', 'seed'),('deadaddress.com', 'seed'),
    ('deadspam.com', 'seed'),('dealja.com', 'seed'),('delikkt.de', 'seed'),
    ('despam.it', 'seed'),('despammed.com', 'seed'),('devnullmail.com', 'seed'),
    ('dfgh.net', 'seed'),('digitalsanctuary.com', 'seed'),('dingbone.com', 'seed'),
    ('dispomail.eu', 'seed'),('disposableaddress.com', 'seed'),
    ('disposableinbox.com', 'seed'),('dispose.it', 'seed'),('dodgeit.com', 'seed'),
    ('dodgit.com', 'seed'),('dodgit.org', 'seed'),('donemail.ru', 'seed'),
    ('dontreg.com', 'seed'),('dontsendmespam.de', 'seed'),('drdrb.com', 'seed'),
    ('drdrb.net', 'seed'),('dump-email.info', 'seed'),('dumpandjunk.com', 'seed'),
    ('dumpmail.de', 'seed'),('dumpyemail.com', 'seed'),('e4ward.com', 'seed'),
    ('easytrashmail.com', 'seed'),('email60.com', 'seed'),('emaildienst.de', 'seed'),
    ('emailgo.de', 'seed'),('emailias.com', 'seed'),('emailigo.de', 'seed'),
    ('emailinfive.com', 'seed'),('emaillime.com', 'seed'),('emailmiser.com', 'seed'),
    ('emailproxsy.com', 'seed'),('emails.ga', 'seed'),('emailsensei.com', 'seed'),
    ('emailtemporario.com.br', 'seed'),('emailto.de', 'seed'),
    ('emailwarden.com', 'seed'),('emailx.at.hm', 'seed'),('emailxfer.com', 'seed'),
    ('emeil.in', 'seed'),('emeil.ir', 'seed'),('emz.net', 'seed'),
    ('enterto.com', 'seed'),('ephemail.net', 'seed'),('etranquil.com', 'seed'),
    ('etranquil.net', 'seed'),('etranquil.org', 'seed'),('evopo.com', 'seed'),
    ('explodemail.com', 'seed'),('express.net.ua', 'seed'),('eyepaste.com', 'seed'),
    ('fakemailz.com', 'seed'),('fammix.com', 'seed'),('fansworldwide.de', 'seed'),
    ('fantasymail.de', 'seed'),('fastacura.com', 'seed'),('fastchevy.com', 'seed'),
    ('fastchrysler.com', 'seed'),('fastkawasaki.com', 'seed'),
    ('fastmazda.com', 'seed'),('fastmitsubishi.com', 'seed'),
    ('fastnissan.com', 'seed'),('fastsubaru.com', 'seed'),('fastsuzuki.com', 'seed'),
    ('fasttoyota.com', 'seed'),('fastyamaha.com', 'seed'),
    ('fettomeansen.com', 'seed'),('fightallspam.com', 'seed'),('fiifke.de', 'seed'),
    ('fivemail.de', 'seed'),('fizmail.com', 'seed'),('flyspam.com', 'seed'),
    ('footard.com', 'seed'),('forgetmail.com', 'seed'),('fr33mail.info', 'seed'),
    ('frapmail.com', 'seed'),('front14.org', 'seed'),('fudgerub.com', 'seed'),
    ('fux0ringduh.com', 'seed'),('fyii.de', 'seed'),('garbagemail.org', 'seed'),
    ('garliclife.com', 'seed'),('gehensipp.de', 'seed'),('get2mail.fr', 'seed'),
    ('getonemail.com', 'seed'),('getonemail.net', 'seed'),('ghosttexter.de', 'seed'),
    ('girlsundertheinfluence.com', 'seed'),('gishpuppy.com', 'seed'),
    ('gmal.com', 'seed'),('gmial.com', 'seed'),('goemailgo.com', 'seed'),
    ('gorillaswithdirtyarmpits.com', 'seed'),('gotmail.com', 'seed'),
    ('gotmail.net', 'seed'),('gotmail.org', 'seed'),
    ('gotti.otherinbox.com', 'seed'),('great-host.in', 'seed'),
    ('greensloth.com', 'seed'),('greyspam.com', 'seed'),('gsrv.co.uk', 'seed'),
    ('guerrillamail.biz', 'seed'),('guerrillamail.info', 'seed'),('h8s.org', 'seed'),
    ('haltospam.com', 'seed'),('hat-gansen.de', 'seed'),('hatespam.org', 'seed'),
    ('herp.in', 'seed'),('hidemail.de', 'seed'),('hidzz.com', 'seed'),
    ('hmamail.com', 'seed'),('hopemail.biz', 'seed'),('hotpop.com', 'seed'),
    ('hulapla.de', 'seed'),('ieatspam.eu', 'seed'),('ieatspam.info', 'seed'),
    ('imails.info', 'seed'),('inbax.tk', 'seed'),('inbox.si', 'seed'),
    ('inboxalias.com', 'seed'),('inboxclean.com', 'seed'),('inboxclean.org', 'seed'),
    ('incognitomail.com', 'seed'),('incognitomail.net', 'seed'),
    ('incognitomail.org', 'seed'),('insorg-mail.info', 'seed'),('ipoo.org', 'seed'),
    ('irish2me.com', 'seed'),('iwi.net', 'seed'),('jetable.com', 'seed'),
    ('jetable.fr.nf', 'seed'),('jetable.net', 'seed'),('jnxjn.com', 'seed'),
    ('jobbikszansen.hu', 'seed'),('jsrsolutions.com', 'seed'),('junk1e.com', 'seed'),
    ('kasmail.com', 'seed'),('kaspop.com', 'seed'),('keepmymail.com', 'seed'),
    ('killmail.com', 'seed'),('killmail.net', 'seed'),('kimsdisk.com', 'seed'),
    ('kingsq.ga', 'seed'),('kiois.com', 'seed'),('klzlk.com', 'seed'),
    ('kook.ml', 'seed'),('kulturbetrieb.info', 'seed'),('kurzepost.de', 'seed'),
    ('lawlita.com', 'seed'),('letthemeatspam.com', 'seed'),('lhsdv.com', 'seed'),
    ('lifebyfood.com', 'seed'),('link2mail.net', 'seed'),('litedrop.com', 'seed'),
    ('lol.ovpn.to', 'seed'),('lolfreak.net', 'seed'),('lookugly.com', 'seed'),
    ('lopl.co.cc', 'seed'),('lortemail.dk', 'seed'),('lovemeleaveme.com', 'seed'),
    ('lr78.com', 'seed'),('lroid.com', 'seed'),('lukop.dk', 'seed'),
    ('m21.cc', 'seed'),('mail-hierarchie.de', 'seed'),('mail-temporaire.fr', 'seed'),
    ('mail.by', 'seed'),('mail.mezimages.net', 'seed'),('mail.zp.ua', 'seed'),
    ('mail1a.de', 'seed'),('mail21.cc', 'seed'),('mail2rss.org', 'seed'),
    ('mail333.com', 'seed'),('mail4trash.com', 'seed'),('mailbidon.com', 'seed'),
    ('mailblocks.com', 'seed'),('mailbucket.org', 'seed'),('mailcat.biz', 'seed'),
    ('maileater.com', 'seed'),('mailfa.tk', 'seed'),('mailfreeonline.com', 'seed'),
    ('mailfs.com', 'seed'),('mailguard.me', 'seed'),('mailimate.com', 'seed'),
    ('mailin8r.com', 'seed'),('mailincubator.com', 'seed'),
    ('mailismagic.com', 'seed'),('mailjunk.cf', 'seed'),('mailjunk.ga', 'seed'),
    ('mailjunk.gq', 'seed'),('mailjunk.ml', 'seed'),('mailjunk.tk', 'seed'),
    ('mailmate.com', 'seed'),('mailme.ir', 'seed'),('mailme.lv', 'seed'),
    ('mailme24.com', 'seed'),('mailmetrash.com', 'seed'),('mailmoat.com', 'seed'),
    ('mailnull.com', 'seed'),('mailorg.org', 'seed'),('mailpick.biz', 'seed'),
    ('mailproxsy.com', 'seed'),('mailquack.com', 'seed'),('mailrock.biz', 'seed'),
    ('mailscrap.com', 'seed'),('mailshell.com', 'seed'),('mailsiphon.com', 'seed'),
    ('mailslapping.com', 'seed'),('mailslite.com', 'seed'),
    ('mailtothis.com', 'seed'),('mailtrash.net', 'seed'),('mailtv.net', 'seed'),
    ('mailtv.tv', 'seed'),('mailzilla.com', 'seed'),('mailzilla.org', 'seed'),
    ('makemetheking.com', 'seed'),('manifestgenerator.com', 'seed'),
    ('manybrain.com', 'seed'),('mbx.cc', 'seed'),('mega.zik.dj', 'seed'),
    ('meinspamschutz.de', 'seed'),('messagebeamer.de', 'seed'),
    ('mezimages.net', 'seed'),('mfsa.ru', 'seed'),('mierdamail.com', 'seed'),
    ('migmail.pl', 'seed'),('migumail.com', 'seed'),
    ('ministry-of-silly-walks.de', 'seed'),('misterpinball.de', 'seed'),
    ('mmmmail.com', 'seed'),('mobi.web.id', 'seed'),('mobileninja.co.uk', 'seed'),
    ('moncourrier.fr.nf', 'seed'),('monemail.fr.nf', 'seed'),
    ('monmail.fr.nf', 'seed'),('monumentmail.com', 'seed'),
    ('ms9.mailslite.com', 'seed'),('msa.minsmail.com', 'seed'),
    ('mt2015.com', 'seed'),('mx0.wwwnew.eu', 'seed'),
    ('my10minutemail.com', 'seed'),('myalias.pw', 'seed'),
    ('mycard.net.ua', 'seed'),('mycleaninbox.net', 'seed'),
    ('myemailboxy.com', 'seed'),('mymail-in.net', 'seed'),
    ('mymailoasis.com', 'seed'),('mynetstore.de', 'seed'),('mypacks.net', 'seed'),
    ('mypartyclip.de', 'seed'),('myphantom.com', 'seed'),('mysamp.de', 'seed'),
    ('myspaceinc.com', 'seed'),('myspaceinc.net', 'seed'),
    ('myspaceinc.org', 'seed'),('myspacepimpedup.com', 'seed'),
    ('mytrashmail.com', 'seed'),('nabala.com', 'seed'),('nagi.be', 'seed')
ON CONFLICT (domain) DO NOTHING;


-- ============================================
-- MIGRATION 005: dns_expires_at column
-- ============================================

ALTER TABLE public.domain_intelligence
    ADD COLUMN IF NOT EXISTS dns_expires_at TIMESTAMPTZ;

UPDATE public.domain_intelligence
SET dns_expires_at = last_checked_at + INTERVAL '7 days'
WHERE last_checked_at IS NOT NULL AND dns_expires_at IS NULL;

COMMENT ON COLUMN public.domain_intelligence.dns_expires_at
    IS 'Cache expiry timestamp for DNS lookup results. Default: last_checked_at + 7 days.';


-- ============================================
-- MIGRATION 006: Additional indexes
-- ============================================

CREATE INDEX IF NOT EXISTS idx_domain_intelligence_dns_expires
ON public.domain_intelligence(dns_expires_at)
WHERE dns_expires_at IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_verification_queue_batch
ON public.verification_queue(tenant_id, status, priority, scheduled_at)
WHERE status = 'pending';

CREATE INDEX IF NOT EXISTS idx_email_verifications_expires
ON public.email_verifications(expires_at)
WHERE expires_at IS NOT NULL;


-- ============================================
-- DONE — Verify with:
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = 'public'
-- AND table_name IN ('email_verifications','domain_intelligence','bounce_signals','verification_queue','disposable_domains','arabic_name_mappings');
-- Expected: 6 rows
-- ============================================
