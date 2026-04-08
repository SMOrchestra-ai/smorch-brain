-- ============================================
-- Seed Data for MENA Region (UAE, KSA, Qatar)
-- Idempotent Inserts
-- ============================================

-- Create tables if they don't exist based on expected schema
CREATE TABLE IF NOT EXISTS tenants (
    id UUID PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    country TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS accounts (
    id UUID PRIMARY KEY,
    tenant_id UUID REFERENCES tenants(id),
    name TEXT NOT NULL,
    industry TEXT,
    website TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(tenant_id, name)
);

CREATE TABLE IF NOT EXISTS leads (
    id UUID PRIMARY KEY,
    account_id UUID REFERENCES accounts(id),
    tenant_id UUID REFERENCES tenants(id),
    first_name TEXT,
    last_name TEXT,
    email TEXT UNIQUE,
    phone TEXT,
    title TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS signals (
    id UUID PRIMARY KEY,
    lead_id UUID REFERENCES leads(id),
    account_id UUID REFERENCES accounts(id),
    signal_type TEXT,
    description TEXT,
    detected_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(lead_id, signal_type, detected_at)
);

CREATE TABLE IF NOT EXISTS intent_scores (
    id UUID PRIMARY KEY,
    account_id UUID REFERENCES accounts(id),
    score INT,
    score_date DATE,
    factors JSONB,
    UNIQUE(account_id, score_date)
);

CREATE TABLE IF NOT EXISTS outreach_templates (
    id UUID PRIMARY KEY,
    tenant_id UUID REFERENCES tenants(id),
    name TEXT,
    subject TEXT,
    body TEXT,
    channel TEXT,
    UNIQUE(tenant_id, name, channel)
);

-- 1. Tenants
INSERT INTO tenants (id, name, country) VALUES ('90a5750d-9dd5-4b37-a719-beaa29a70adb', 'UAE Tenant', 'UAE') ON CONFLICT (name) DO NOTHING;
INSERT INTO tenants (id, name, country) VALUES ('b877246f-abff-4300-aae6-1adc62c5a179', 'Saudi Arabia Tenant', 'Saudi Arabia') ON CONFLICT (name) DO NOTHING;
INSERT INTO tenants (id, name, country) VALUES ('13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Qatar Tenant', 'Qatar') ON CONFLICT (name) DO NOTHING;

-- 2. Accounts
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'ADNOC', 'Energy') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('af4c9c50-1be7-41a6-8cbe-947901ac1a67', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Emirates Global Aluminium', 'Manufacturing') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('d824f4a9-5ab8-43cc-911f-de311292e502', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Etisalat', 'Telecommunications') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('f38b809b-c881-498b-95ba-26eb8195652f', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Emirates Airlines', 'Aviation') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('f5c0a821-d68d-40fd-b8cf-f91c92a4a543', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'DP World', 'Logistics') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Aramco', 'Energy') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'b877246f-abff-4300-aae6-1adc62c5a179', 'SABIC', 'Chemicals') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'b877246f-abff-4300-aae6-1adc62c5a179', 'STC', 'Telecommunications') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('439ad011-3c4b-4998-8412-3785e4c188af', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Al Rajhi Bank', 'Banking') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Maaden', 'Mining') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('97b5834b-b581-4317-a298-356e040fa1f6', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'QNB', 'Banking') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('5ee83325-5698-45d4-976c-5d35d51dc540', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Ooredoo', 'Telecommunications') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('34a59020-5957-4e19-9c91-f3186103d1a3', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Qatar Airways', 'Aviation') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('137cfba8-31b8-49ac-a1ea-d5a3fef0d498', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Mabani', 'Real Estate') ON CONFLICT (tenant_id, name) DO NOTHING;
INSERT INTO accounts (id, tenant_id, name, industry) VALUES ('701551c1-2675-4ca0-8546-6c8c5f10f33c', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'QatarEnergy', 'Energy') ON CONFLICT (tenant_id, name) DO NOTHING;

-- 3. Contacts (Leads)
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('cd38a38d-d72e-4424-9b6a-1059c26cadb9', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Saud', 'Al Shammari', 'saud.al shammari0@example.com', '+971504892053', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('f0c45878-b10b-43a6-b381-7503a3fc1df2', 'd824f4a9-5ab8-43cc-911f-de311292e502', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Hussein', 'Al Kuwari', 'hussein.al kuwari1@example.com', '+971501515271', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('5e2ca477-1b11-4718-88dd-ab79bede576e', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Sultan', 'Al Mutairi', 'sultan.al mutairi2@example.com', '+971502896434', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('17ee6184-d58e-4fbd-8e94-59172a5e9dd8', 'd824f4a9-5ab8-43cc-911f-de311292e502', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Maha', 'Al Qahtani', 'maha.al qahtani3@example.com', '+971503694592', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('178e4738-24d5-4681-af6f-64ee742e9ec4', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Yousef', 'Al Otaibi', 'yousef.al otaibi4@example.com', '+971504931953', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('548486e0-c487-45a5-bcb4-c79e5f6ead3f', '97b5834b-b581-4317-a298-356e040fa1f6', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Adel', 'Al Sayegh', 'adel.al sayegh5@example.com', '+971507695751', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('ee87a5a3-3f9e-4466-8695-af825f4e3c05', 'f5c0a821-d68d-40fd-b8cf-f91c92a4a543', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Majed', 'Al Quraishi', 'majed.al quraishi6@example.com', '+971501239828', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('81f91b81-a5de-4385-a583-ae00c0117542', 'f38b809b-c881-498b-95ba-26eb8195652f', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Ali', 'Al Maktoum', 'ali.al maktoum7@example.com', '+971502428522', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('fb4e3c86-b7e5-4606-a1de-b05ce26a3cea', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Maha', 'Al Qahtani', 'maha.al qahtani8@example.com', '+971504106486', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('ff01055b-05b6-4b52-9e12-a6ed981a7405', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Bader', 'Al Harthy', 'bader.al harthy9@example.com', '+971509373382', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('3145e720-f392-413e-873d-506cca9e92fa', '137cfba8-31b8-49ac-a1ea-d5a3fef0d498', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Fatima', 'Al Suwaidi', 'fatima.al suwaidi10@example.com', '+971502497095', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('5c8de483-1e2c-4756-93a6-709b8b7f250f', '5ee83325-5698-45d4-976c-5d35d51dc540', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Reem', 'Al Attiyah', 'reem.al attiyah11@example.com', '+971509069338', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('c6d68f7b-c068-4e8b-a2bb-35d88159e224', '34a59020-5957-4e19-9c91-f3186103d1a3', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Reem', 'Al Attiyah', 'reem.al attiyah12@example.com', '+971502099748', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('1895e728-ee8a-4a09-a37e-1943c0c53aff', 'd824f4a9-5ab8-43cc-911f-de311292e502', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Saeed', 'Al Nuaimi', 'saeed.al nuaimi13@example.com', '+971506650477', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('051236d3-fa7a-4cde-a1bf-da712ccb0817', '701551c1-2675-4ca0-8546-6c8c5f10f33c', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Sarah', 'Al Ghamdi', 'sarah.al ghamdi14@example.com', '+971502824085', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('e45737af-3da2-487c-a0ba-d68d6a3f6406', '439ad011-3c4b-4998-8412-3785e4c188af', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Majed', 'Al Quraishi', 'majed.al quraishi15@example.com', '+971508043072', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('c9251c0a-3969-45fe-9c00-0571f99e5768', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Bader', 'Al Harthy', 'bader.al harthy16@example.com', '+971504813167', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('ba607a52-b83b-4800-aea7-1995bdb96158', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Walid', 'Al Jishi', 'walid.al jishi17@example.com', '+971506009765', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('91133b86-0436-4ce2-a6c5-6cf12401f7eb', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Khalid', 'Al Dawsari', 'khalid.al dawsari18@example.com', '+971502700725', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('f9ba2584-bb89-435e-b6bd-1c310ebfd90c', '5ee83325-5698-45d4-976c-5d35d51dc540', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Rashid', 'Al Marri', 'rashid.al marri19@example.com', '+971504543341', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('665b4976-cbc5-4afa-af81-30577c7376ab', '701551c1-2675-4ca0-8546-6c8c5f10f33c', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Rashid', 'Al Marri', 'rashid.al marri20@example.com', '+971504288525', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('9c3d8a7a-b5c9-4339-a59b-a67af4a7632d', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Maha', 'Al Qahtani', 'maha.al qahtani21@example.com', '+971502096300', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('99c25bd0-1784-4168-8a57-e9719fc45075', '701551c1-2675-4ca0-8546-6c8c5f10f33c', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Yousef', 'Al Otaibi', 'yousef.al otaibi22@example.com', '+971509091207', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('33567809-3d5f-4cd3-b9a5-46aeebcb36ff', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Turki', 'Al Zahrani', 'turki.al zahrani23@example.com', '+971501251115', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('c3a16309-92eb-41d2-9239-a12aa337d9cc', '97b5834b-b581-4317-a298-356e040fa1f6', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Khalid', 'Al Dawsari', 'khalid.al dawsari24@example.com', '+971502282010', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('077f3a79-747e-42c5-b56f-5426f9e78525', '439ad011-3c4b-4998-8412-3785e4c188af', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Walid', 'Al Jishi', 'walid.al jishi25@example.com', '+971501076331', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('61e7a1bf-6f13-4f61-945e-9bd430d582e1', '97b5834b-b581-4317-a298-356e040fa1f6', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Adel', 'Al Sayegh', 'adel.al sayegh26@example.com', '+971506103997', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('f883017d-c6f8-4dd8-a99f-2a034df0b9bd', 'd824f4a9-5ab8-43cc-911f-de311292e502', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Hassan', 'Al Thani', 'hassan.al thani27@example.com', '+971501034600', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('3b7bae04-6833-42d3-ab7f-2282fe3c1518', '439ad011-3c4b-4998-8412-3785e4c188af', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Hind', 'Al Dosari', 'hind.al dosari28@example.com', '+971501407391', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('dbb73ac9-5a1b-412d-8d99-daf00dde4a41', '439ad011-3c4b-4998-8412-3785e4c188af', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Salim', 'Al Jabri', 'salim.al jabri29@example.com', '+971503977326', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('1a8a45f4-3b80-43c7-815e-4831f606b513', 'f5c0a821-d68d-40fd-b8cf-f91c92a4a543', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Rashid', 'Al Marri', 'rashid.al marri30@example.com', '+971504510634', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('63fca31a-7083-410a-b5a4-3c21e230e704', 'f38b809b-c881-498b-95ba-26eb8195652f', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Salim', 'Al Jabri', 'salim.al jabri31@example.com', '+971504671617', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('c65a5237-f8a4-451b-9bb7-ae0a5dcd2d4e', '439ad011-3c4b-4998-8412-3785e4c188af', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Zayed', 'Al Nahyan', 'zayed.al nahyan32@example.com', '+971502382472', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('bd742611-232b-4f44-9851-56ceb828f793', 'af4c9c50-1be7-41a6-8cbe-947901ac1a67', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Zayed', 'Al Nahyan', 'zayed.al nahyan33@example.com', '+971501136231', 'Director') ON CONFLICT (email) DO NOTHING;
INSERT INTO leads (id, account_id, tenant_id, first_name, last_name, email, phone, title) VALUES ('c03d9dae-39e5-475f-9fde-9814590aaa78', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Ahmed', 'Mansour', 'ahmed.mansour34@example.com', '+971503675791', 'Director') ON CONFLICT (email) DO NOTHING;

-- 4. Signals
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('97fe1f35-bb58-4abe-980b-36a5b17718e5', 'f883017d-c6f8-4dd8-a99f-2a034df0b9bd', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('0fa613c5-5247-4883-b771-e9cbfc37cb14', 'ee87a5a3-3f9e-4466-8695-af825f4e3c05', '439ad011-3c4b-4998-8412-3785e4c188af', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('a1853fd8-3e48-4d31-94ad-54316979ed60', '1a8a45f4-3b80-43c7-815e-4831f606b513', '439ad011-3c4b-4998-8412-3785e4c188af', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('0e06ca54-30d0-4b11-bf27-e6ef60755bdb', '3b7bae04-6833-42d3-ab7f-2282fe3c1518', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('e1248598-faa3-476a-94ce-ffcc65bba516', 'bd742611-232b-4f44-9851-56ceb828f793', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('5921b803-c3bd-4ad7-b622-0742a7b504dd', 'f0c45878-b10b-43a6-b381-7503a3fc1df2', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('11e1b6c9-2d9d-464c-b975-94a660a32da8', '99c25bd0-1784-4168-8a57-e9719fc45075', '5ee83325-5698-45d4-976c-5d35d51dc540', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('964e8552-62f0-4b7a-a986-019228fbec00', '051236d3-fa7a-4cde-a1bf-da712ccb0817', 'f5c0a821-d68d-40fd-b8cf-f91c92a4a543', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('e1904e30-9451-40d8-a789-a0640dd57272', '33567809-3d5f-4cd3-b9a5-46aeebcb36ff', '34a59020-5957-4e19-9c91-f3186103d1a3', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('49bd3c61-8e23-4d18-9e47-35f88f8110ca', '63fca31a-7083-410a-b5a4-3c21e230e704', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('1cf041f0-94c6-4f3f-93a6-35195658b34e', 'f9ba2584-bb89-435e-b6bd-1c310ebfd90c', '5ee83325-5698-45d4-976c-5d35d51dc540', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('d5a679c0-957c-46e8-8478-91700ee2a87d', '99c25bd0-1784-4168-8a57-e9719fc45075', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('924a6747-e07d-43ea-96c4-4bfdb3f7b31a', '1a8a45f4-3b80-43c7-815e-4831f606b513', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('f778bab3-8721-4330-9881-1b799b491745', 'c3a16309-92eb-41d2-9239-a12aa337d9cc', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('1f23918f-49a7-4c41-9778-fcf6c7539f7c', '178e4738-24d5-4681-af6f-64ee742e9ec4', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('5fa1ce1d-9131-4faa-b305-a48b87c8533b', '99c25bd0-1784-4168-8a57-e9719fc45075', '137cfba8-31b8-49ac-a1ea-d5a3fef0d498', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('6a6af387-84fc-449a-ab92-6f642a3475ed', '5e2ca477-1b11-4718-88dd-ab79bede576e', '5ee83325-5698-45d4-976c-5d35d51dc540', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('91e28e15-3ec2-449f-a309-d17c6c624fa5', 'f9ba2584-bb89-435e-b6bd-1c310ebfd90c', '137cfba8-31b8-49ac-a1ea-d5a3fef0d498', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('58b755f8-cd06-4e27-b262-b2fb3e1276c3', '9c3d8a7a-b5c9-4339-a59b-a67af4a7632d', '5ee83325-5698-45d4-976c-5d35d51dc540', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('24e0c02d-d01e-40fa-b4f5-b6a46d7e2ac6', 'fb4e3c86-b7e5-4606-a1de-b05ce26a3cea', '5ee83325-5698-45d4-976c-5d35d51dc540', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('b05b67ba-4494-447a-bf3f-1e89dd1f3b1e', 'fb4e3c86-b7e5-4606-a1de-b05ce26a3cea', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('728d3723-1f1d-4c6d-86bc-af839f4a3d4a', 'f0c45878-b10b-43a6-b381-7503a3fc1df2', 'af4c9c50-1be7-41a6-8cbe-947901ac1a67', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('16d0e69b-2bf1-4f03-b223-510c38a20317', 'ee87a5a3-3f9e-4466-8695-af825f4e3c05', '97b5834b-b581-4317-a298-356e040fa1f6', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('c6a12909-9dda-4a4c-8fe4-eb95c70d2ffd', '1895e728-ee8a-4a09-a37e-1943c0c53aff', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('b7058cad-d109-4d74-926e-00a4e7df7442', 'e45737af-3da2-487c-a0ba-d68d6a3f6406', '701551c1-2675-4ca0-8546-6c8c5f10f33c', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('57cb2f30-19ee-4482-9cdc-6f9784344d0f', '077f3a79-747e-42c5-b56f-5426f9e78525', '5ee83325-5698-45d4-976c-5d35d51dc540', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('92676730-e223-4da2-bc9f-1bf2c5f2a477', '63fca31a-7083-410a-b5a4-3c21e230e704', '34a59020-5957-4e19-9c91-f3186103d1a3', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('ab21c20a-8b97-4b3f-b86d-2926c08f172d', 'cd38a38d-d72e-4424-9b6a-1059c26cadb9', '137cfba8-31b8-49ac-a1ea-d5a3fef0d498', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('b3a02c38-3ba1-43bb-a49f-f085fcccf64f', 'c65a5237-f8a4-451b-9bb7-ae0a5dcd2d4e', 'd824f4a9-5ab8-43cc-911f-de311292e502', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('437f4c77-f44d-496f-ac51-9a7f8850559f', '548486e0-c487-45a5-bcb4-c79e5f6ead3f', '34a59020-5957-4e19-9c91-f3186103d1a3', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('6d95643c-91a3-4a65-a803-203107d629a3', '5c8de483-1e2c-4756-93a6-709b8b7f250f', '701551c1-2675-4ca0-8546-6c8c5f10f33c', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('1fc5bcb7-a8b0-4887-90ce-e1741957d33b', 'f0c45878-b10b-43a6-b381-7503a3fc1df2', 'af4c9c50-1be7-41a6-8cbe-947901ac1a67', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('045f032a-2317-40b0-8ee6-34004bcf98fd', '5e2ca477-1b11-4718-88dd-ab79bede576e', '137cfba8-31b8-49ac-a1ea-d5a3fef0d498', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('1e3a413c-68d3-4883-ad31-d9191837f550', 'c3a16309-92eb-41d2-9239-a12aa337d9cc', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('41905356-cbf6-4610-a254-709f13d17631', '665b4976-cbc5-4afa-af81-30577c7376ab', '439ad011-3c4b-4998-8412-3785e4c188af', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('8d1aa373-e47f-4c92-81ff-457cc4ea7132', 'f9ba2584-bb89-435e-b6bd-1c310ebfd90c', '34a59020-5957-4e19-9c91-f3186103d1a3', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('b2f3da96-54fc-48c3-880c-a580c276ab61', '5c8de483-1e2c-4756-93a6-709b8b7f250f', 'af4c9c50-1be7-41a6-8cbe-947901ac1a67', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('566a2d18-e403-4189-ae85-a4be692b1148', '81f91b81-a5de-4385-a583-ae00c0117542', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('522e5bd3-468b-49ee-a9fc-82c8c58e50c3', 'cd38a38d-d72e-4424-9b6a-1059c26cadb9', '439ad011-3c4b-4998-8412-3785e4c188af', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('d4632115-fc74-4451-98a9-0607e160c6d0', 'dbb73ac9-5a1b-412d-8d99-daf00dde4a41', '97b5834b-b581-4317-a298-356e040fa1f6', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('a6387252-ee6e-450f-aaa9-4da189d58cc9', '63fca31a-7083-410a-b5a4-3c21e230e704', 'f38b809b-c881-498b-95ba-26eb8195652f', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('d618b88f-78a7-4771-8de6-b544010a237a', 'f9ba2584-bb89-435e-b6bd-1c310ebfd90c', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('8374d721-0983-4f52-848c-0d34dc58fb63', 'c65a5237-f8a4-451b-9bb7-ae0a5dcd2d4e', '97b5834b-b581-4317-a298-356e040fa1f6', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('e1b811f8-9b85-4820-a55d-d8366b90522d', 'e45737af-3da2-487c-a0ba-d68d6a3f6406', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('86c756d0-964a-47cb-bed9-45f5f5453195', 'ee87a5a3-3f9e-4466-8695-af825f4e3c05', '34a59020-5957-4e19-9c91-f3186103d1a3', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('582cf9fe-a21b-47e4-ab1e-83e0b09c89ad', '17ee6184-d58e-4fbd-8e94-59172a5e9dd8', '5ee83325-5698-45d4-976c-5d35d51dc540', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('84039aba-9474-4554-9f64-939713638cef', 'c65a5237-f8a4-451b-9bb7-ae0a5dcd2d4e', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('c5570c85-f169-4cb0-8f85-df1c428063c5', '3145e720-f392-413e-873d-506cca9e92fa', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('db060d5b-7b7a-4e7e-b626-8d6ba55c9678', 'c03d9dae-39e5-475f-9fde-9814590aaa78', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('2ef51a57-9e1d-4dee-8f5e-1ab298e50938', '5c8de483-1e2c-4756-93a6-709b8b7f250f', '439ad011-3c4b-4998-8412-3785e4c188af', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('31926c57-c46f-4673-9bff-d170e8ccd8be', 'cd38a38d-d72e-4424-9b6a-1059c26cadb9', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('914d0c61-62dd-4792-8941-3c421c71efcc', '1895e728-ee8a-4a09-a37e-1943c0c53aff', '97b5834b-b581-4317-a298-356e040fa1f6', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('0d5d0e40-2fdc-413f-8547-8d2202b0aacb', '548486e0-c487-45a5-bcb4-c79e5f6ead3f', '34a59020-5957-4e19-9c91-f3186103d1a3', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('d8c3fbd1-754c-4195-8e77-b91ff53e2aff', '33567809-3d5f-4cd3-b9a5-46aeebcb36ff', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('d48489e2-ae59-4d57-a52f-eb6a972c544e', 'f883017d-c6f8-4dd8-a99f-2a034df0b9bd', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('75f48ae6-16ed-4341-baa7-51fea9e4a5ef', 'bd742611-232b-4f44-9851-56ceb828f793', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('85b304d2-d62e-48e3-9df6-b1d533aae2e8', 'c3a16309-92eb-41d2-9239-a12aa337d9cc', 'f5c0a821-d68d-40fd-b8cf-f91c92a4a543', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('52a67ad2-4b91-4372-bd5b-c10d97cc25e2', '3145e720-f392-413e-873d-506cca9e92fa', 'f5c0a821-d68d-40fd-b8cf-f91c92a4a543', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('796ffb47-c1b7-4cad-b8fa-4e4ac656ed28', '5e2ca477-1b11-4718-88dd-ab79bede576e', '34a59020-5957-4e19-9c91-f3186103d1a3', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('068bd8b9-c394-4c20-8a3d-7e267e68a9fd', '61e7a1bf-6f13-4f61-945e-9bd430d582e1', '701551c1-2675-4ca0-8546-6c8c5f10f33c', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('8267e8f0-61c7-4f75-8d1d-c47b1d56fd17', '665b4976-cbc5-4afa-af81-30577c7376ab', '701551c1-2675-4ca0-8546-6c8c5f10f33c', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('37faa86d-6faf-4c85-a5ff-d5726347dfd4', '3b7bae04-6833-42d3-ab7f-2282fe3c1518', '97b5834b-b581-4317-a298-356e040fa1f6', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('5caa9c87-01f9-4adf-acb0-e3612951ae23', 'f0c45878-b10b-43a6-b381-7503a3fc1df2', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('6af0c912-57d6-4d00-8ac8-4a5a6ad008af', 'c03d9dae-39e5-475f-9fde-9814590aaa78', '97b5834b-b581-4317-a298-356e040fa1f6', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('20f23b96-bf13-4f34-81ed-ab3dc0954bc0', 'c3a16309-92eb-41d2-9239-a12aa337d9cc', 'af4c9c50-1be7-41a6-8cbe-947901ac1a67', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('d9819f70-b526-40c2-972b-c228e40576e0', 'fb4e3c86-b7e5-4606-a1de-b05ce26a3cea', '439ad011-3c4b-4998-8412-3785e4c188af', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('12374d2f-d837-4604-8837-e0a129713110', 'c65a5237-f8a4-451b-9bb7-ae0a5dcd2d4e', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'funding_round', 'Detected funding_round on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('f9fd7304-fba2-4703-b517-47d3f7f60fef', 'bd742611-232b-4f44-9851-56ceb828f793', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('ff036485-c738-4c1b-a064-48e1d698c6e6', '63fca31a-7083-410a-b5a4-3c21e230e704', '34a59020-5957-4e19-9c91-f3186103d1a3', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('6de6155b-bd4e-4575-b566-3da03b9c31cc', '3b7bae04-6833-42d3-ab7f-2282fe3c1518', 'f5c0a821-d68d-40fd-b8cf-f91c92a4a543', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('cb372e5b-08aa-49c6-bd3e-673ad2a8b3c6', 'e45737af-3da2-487c-a0ba-d68d6a3f6406', 'af4c9c50-1be7-41a6-8cbe-947901ac1a67', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('590a76f8-98ae-4994-9049-a7cfe62b6838', '5e2ca477-1b11-4718-88dd-ab79bede576e', '701551c1-2675-4ca0-8546-6c8c5f10f33c', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('72bf45ba-d792-4a94-8127-dda83712f2c5', '051236d3-fa7a-4cde-a1bf-da712ccb0817', '5ee83325-5698-45d4-976c-5d35d51dc540', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('a6f71bc3-1665-4317-bed9-0aa9b28447c9', '1a8a45f4-3b80-43c7-815e-4831f606b513', 'f38b809b-c881-498b-95ba-26eb8195652f', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('b264a3e2-4c8c-4d62-8339-9fa1c3fbfd8f', '178e4738-24d5-4681-af6f-64ee742e9ec4', '137cfba8-31b8-49ac-a1ea-d5a3fef0d498', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('5cbc40c6-617c-43dd-a96e-d4af756cddd7', 'ba607a52-b83b-4800-aea7-1995bdb96158', 'd824f4a9-5ab8-43cc-911f-de311292e502', 'expansion', 'Detected expansion on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('02b58f4b-84fb-4287-a384-56dd19a832db', 'f9ba2584-bb89-435e-b6bd-1c310ebfd90c', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'new_hire', 'Detected new_hire on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('c5213913-2d34-4a7f-b61b-ac13cc15c4b9', 'f9ba2584-bb89-435e-b6bd-1c310ebfd90c', '97b5834b-b581-4317-a298-356e040fa1f6', 'technology_adoption', 'Detected technology_adoption on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('357e61d6-7907-4399-a7ed-5e458bbb48fa', '5e2ca477-1b11-4718-88dd-ab79bede576e', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 'job_change', 'Detected job_change on LinkedIn') ON CONFLICT DO NOTHING;
INSERT INTO signals (id, lead_id, account_id, signal_type, description) VALUES ('79d7d736-48aa-43f6-a43b-aa1e44b9dfa2', 'bd742611-232b-4f44-9851-56ceb828f793', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 'leadership_change', 'Detected leadership_change on LinkedIn') ON CONFLICT DO NOTHING;

-- 5. Intent Scores
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('ec9d139f-a3cc-4c57-9319-bc2281b73d70', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', 60, CURRENT_DATE - 0, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('fef386dd-f979-4661-acc9-b0a86be791d9', 'af4c9c50-1be7-41a6-8cbe-947901ac1a67', 84, CURRENT_DATE - 1, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('6ca4eca0-390f-4c59-94a2-7f54ba401576', 'd824f4a9-5ab8-43cc-911f-de311292e502', 63, CURRENT_DATE - 2, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('49c41b78-6f80-4d0b-8697-7577f295ddc7', 'f38b809b-c881-498b-95ba-26eb8195652f', 80, CURRENT_DATE - 3, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('76af3b2d-3d96-4338-9c79-4a6a642cbff1', 'f5c0a821-d68d-40fd-b8cf-f91c92a4a543', 77, CURRENT_DATE - 4, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('0031ff51-6959-4190-b363-594c74cf63d7', '2ccab2c9-4e1b-4514-b4a6-046ee7cbd4ef', 63, CURRENT_DATE - 5, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('38ee75e6-24ae-4b77-be36-27bf0af14bea', '3e8cf3ef-879f-4ec1-b0b8-bab9310d87b4', 65, CURRENT_DATE - 6, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('61131507-14e7-43bb-a3a1-4e4d1bbf970b', 'b8d5ac83-ced2-476c-ab0c-b0f45797994b', 85, CURRENT_DATE - 7, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('1205c7fb-32e5-4628-b0e4-fdab0a477454', '439ad011-3c4b-4998-8412-3785e4c188af', 82, CURRENT_DATE - 8, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('5ffad32f-6e2d-48e0-a6d1-067bc31d9892', '5c476a3a-7823-4d22-89e1-ef78e33f4feb', 70, CURRENT_DATE - 9, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('e8ea1578-fe62-490c-979d-040586710a3b', '97b5834b-b581-4317-a298-356e040fa1f6', 76, CURRENT_DATE - 10, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('7c1b43d5-b698-42a8-8fed-105f9aafe376', '5ee83325-5698-45d4-976c-5d35d51dc540', 68, CURRENT_DATE - 11, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('9fee424e-6e34-48b7-991c-71efb2cb82c8', '34a59020-5957-4e19-9c91-f3186103d1a3', 77, CURRENT_DATE - 12, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('523b395e-8313-41d5-b5f6-9804c792e274', '137cfba8-31b8-49ac-a1ea-d5a3fef0d498', 60, CURRENT_DATE - 13, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('08bef5d3-96f5-4814-95a1-b0d5257ac6b4', '701551c1-2675-4ca0-8546-6c8c5f10f33c', 62, CURRENT_DATE - 14, '{"website_visits": 5}') ON CONFLICT DO NOTHING;
INSERT INTO intent_scores (id, account_id, score, score_date, factors) VALUES ('62351aa4-f77b-4375-90b9-daa2f555300d', 'ea6fb981-ec7f-4fcb-b1d3-deeddb5474f3', 95, CURRENT_DATE - 15, '{"website_visits": 5}') ON CONFLICT DO NOTHING;

-- 6. Outreach Templates
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('4225b441-bd97-482a-ad85-ea6eb3bd0739', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Template 0', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('212f8dc7-984f-42f8-be13-2d9c6f39ac89', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Template 1', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('82513199-5c8b-4565-bee3-b1ce7cdd417a', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Template 2', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('937643cc-62b2-40b7-86f3-42bd3a251800', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Template 3', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('95333822-5680-46ad-bb29-48cc8bde3f2a', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Template 4', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('5959e368-c14c-441d-9097-9815d803952c', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Template 5', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('9bbb9efe-1092-49e0-8692-470d0c5664e2', '90a5750d-9dd5-4b37-a719-beaa29a70adb', 'Template 6', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('e7e2d822-5c62-482d-98a1-68bbe7124eed', 'b877246f-abff-4300-aae6-1adc62c5a179', 'Template 7', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
INSERT INTO outreach_templates (id, tenant_id, name, subject, body, channel) VALUES ('d9e0117f-6368-40d0-a785-b078ff8fe56c', '13fc16ed-6622-47c0-af2e-48bb366c90d3', 'Template 8', 'Intro', 'Hello {first_name}', 'email') ON CONFLICT DO NOTHING;
