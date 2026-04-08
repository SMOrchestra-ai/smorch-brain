-- SSE V3 MENA Seed Data
-- Idempotent: safe to re-run (ON CONFLICT DO NOTHING on all inserts)
-- Created: 2026-04-08
-- Purpose: Populate test data for QA soak test (SMO-55)
--
-- UUID Prefix Convention:
--   a1 = tenants, b1 = users, d1 = leads, e1 = company_entities
--   f1 = individual_entities, ca = campaigns, cb = campaign_leads
--   cc = lead_scores_history, cd = tenant_credits, ce = enrichment_results
--
-- Insertion order respects FK dependencies:
--   tenants → users → industries → leads → company_entities → individual_entities
--   → campaigns → campaign_leads → lead_scores_history → tenant_credits → enrichment_results

-- ============================================================
-- 1. TENANTS (3)
-- ============================================================
INSERT INTO tenants (id, workspace_name, subscription_tier, monthly_limits, created_at, updated_at) VALUES
('a1000000-0000-0000-0000-000000000001', 'TechFlow Solutions', 'growth', '{"leads": 500, "campaigns": 10, "enrichments": 1000}'::jsonb, NOW(), NOW()),
('a1000000-0000-0000-0000-000000000002', 'Nexus Digital', 'enterprise', '{"leads": 2000, "campaigns": 50, "enrichments": 5000}'::jsonb, NOW(), NOW()),
('a1000000-0000-0000-0000-000000000003', 'Gulf Innovate', 'starter', '{"leads": 100, "campaigns": 3, "enrichments": 200}'::jsonb, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 2. USERS (3: 1 admin per tenant)
-- ============================================================
INSERT INTO users (id, tenant_id, email, password_hash, first_name, last_name, role, is_active, created_at, updated_at) VALUES
('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'admin@techflow.ae', '$2b$10$seedhashplaceholder001', 'Ahmad', 'Al-Rashid', 'admin', true, NOW(), NOW()),
('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 'admin@nexusdigital.sa', '$2b$10$seedhashplaceholder002', 'Fatima', 'Al-Saud', 'admin', true, NOW(), NOW()),
('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003', 'admin@gulfinnovate.qa', '$2b$10$seedhashplaceholder003', 'Khalid', 'Al-Thani', 'admin', true, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 3. INDUSTRIES (6) — industries.id is integer, not UUID
-- ============================================================
INSERT INTO industries (id, label, hierarchy, description, created_at, updated_at) VALUES
(1, 'Technology', 'sector/technology', 'Software, SaaS, IT services, cloud computing', NOW(), NOW()),
(2, 'Financial Services', 'sector/financial', 'Banking, fintech, insurance, investment management', NOW(), NOW()),
(3, 'Real Estate', 'sector/real-estate', 'Property development, PropTech, facility management', NOW(), NOW()),
(4, 'E-commerce', 'sector/ecommerce', 'Online retail, marketplaces, D2C brands', NOW(), NOW()),
(5, 'Healthcare', 'sector/healthcare', 'HealthTech, hospitals, pharmaceuticals, medical devices', NOW(), NOW()),
(6, 'Education', 'sector/education', 'EdTech, universities, training, online learning', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 4. LEADS (15: 5 per tenant) — fit_score is numeric(3,2), range 0.00-9.99
-- ============================================================
INSERT INTO leads (id, tenant_id, lead_type, platform, name, email, phone, company_name, industry, location, fit_score, created_at, updated_at) VALUES
-- TechFlow (UAE)
('d1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'company', 'linkedin', 'Careem', 'info@careem.com', '+971501234567', 'Careem', 'Technology', 'Dubai, UAE', 9.10, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'company', 'linkedin', 'Fetchr', 'info@fetchr.us', '+971502345678', 'Fetchr', 'Logistics', 'Dubai, UAE', 7.50, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'company', 'clay', 'Property Finder', 'info@propertyfinder.ae', '+971503456789', 'Property Finder', 'Real Estate', 'Dubai, UAE', 5.50, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'company', 'linkedin', 'Kitopi', 'info@kitopi.com', '+971504567890', 'Kitopi', 'FoodTech', 'Dubai, UAE', 7.00, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 'company', 'clay', 'Tabby', 'info@tabby.ai', '+971505678901', 'Tabby', 'Fintech', 'Dubai, UAE', 5.00, NOW(), NOW()),
-- Nexus Digital (Saudi)
('d1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000002', 'company', 'linkedin', 'Foodics', 'info@foodics.com', '+966501234567', 'Foodics', 'FoodTech/SaaS', 'Riyadh, Saudi Arabia', 8.80, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000002', 'company', 'linkedin', 'Jahez', 'info@jahez.net', '+966502345678', 'Jahez', 'Delivery', 'Riyadh, Saudi Arabia', 6.50, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000002', 'company', 'clay', 'Tamara', 'info@tamara.co', '+966503456789', 'Tamara', 'Fintech', 'Riyadh, Saudi Arabia', 4.80, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000002', 'company', 'linkedin', 'Lucidya', 'info@lucidya.com', '+966504567890', 'Lucidya', 'MarTech', 'Riyadh, Saudi Arabia', 7.20, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000010', 'a1000000-0000-0000-0000-000000000002', 'company', 'clay', 'Salla', 'info@salla.sa', '+966505678901', 'Salla', 'E-commerce', 'Riyadh, Saudi Arabia', 3.50, NOW(), NOW()),
-- Gulf Innovate (Qatar)
('d1000000-0000-0000-0000-000000000011', 'a1000000-0000-0000-0000-000000000003', 'company', 'clay', 'Mzad Qatar', 'info@mzadqatar.com', '+974501234567', 'Mzad Qatar', 'Marketplace', 'Doha, Qatar', 5.20, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000012', 'a1000000-0000-0000-0000-000000000003', 'company', 'linkedin', 'QNB', 'info@qnb.com', '+974502345678', 'Qatar National Bank', 'Banking', 'Doha, Qatar', 9.50, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000013', 'a1000000-0000-0000-0000-000000000003', 'company', 'linkedin', 'Ooredoo Qatar', 'info@ooredoo.qa', '+974503456789', 'Ooredoo', 'Telecom', 'Doha, Qatar', 6.80, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000014', 'a1000000-0000-0000-0000-000000000003', 'company', 'clay', 'Manateq', 'info@manateq.qa', '+974504567890', 'Manateq', 'Industrial', 'Doha, Qatar', 3.00, NOW(), NOW()),
('d1000000-0000-0000-0000-000000000015', 'a1000000-0000-0000-0000-000000000003', 'company', 'linkedin', 'Meeza', 'info@meeza.net', '+974505678901', 'Meeza', 'IT Services', 'Doha, Qatar', 2.50, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 5. COMPANY ENTITIES (15: 1 per lead)
-- ============================================================
INSERT INTO company_entities (id, tenant_id, lead_id, company_name, website, industry, company_size, country, city, linkedin_url, main_email, main_phone, created_at, updated_at) VALUES
('e1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 'Careem', 'https://www.careem.com', 'Technology', '1000-5000', 'UAE', 'Dubai', 'https://linkedin.com/company/careem', 'info@careem.com', '+971501234567', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000002', 'Fetchr', 'https://www.fetchr.us', 'Logistics', '200-500', 'UAE', 'Dubai', 'https://linkedin.com/company/fetchr', 'info@fetchr.us', '+971502345678', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000003', 'Property Finder', 'https://www.propertyfinder.ae', 'Real Estate', '500-1000', 'UAE', 'Dubai', 'https://linkedin.com/company/propertyfinder', 'info@propertyfinder.ae', '+971503456789', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000004', 'Kitopi', 'https://www.kitopi.com', 'FoodTech', '500-2000', 'UAE', 'Dubai', 'https://linkedin.com/company/kitopi', 'info@kitopi.com', '+971504567890', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000005', 'Tabby', 'https://www.tabby.ai', 'Fintech', '200-500', 'UAE', 'Dubai', 'https://linkedin.com/company/tabby', 'info@tabby.ai', '+971505678901', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000006', 'Foodics', 'https://www.foodics.com', 'FoodTech/SaaS', '500-1000', 'Saudi Arabia', 'Riyadh', 'https://linkedin.com/company/foodics', 'info@foodics.com', '+966501234567', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000007', 'Jahez', 'https://www.jahez.net', 'Delivery', '1000-3000', 'Saudi Arabia', 'Riyadh', 'https://linkedin.com/company/jahez', 'info@jahez.net', '+966502345678', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000008', 'Tamara', 'https://www.tamara.co', 'Fintech', '200-500', 'Saudi Arabia', 'Riyadh', 'https://linkedin.com/company/tamara', 'info@tamara.co', '+966503456789', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000009', 'Lucidya', 'https://www.lucidya.com', 'MarTech', '50-200', 'Saudi Arabia', 'Riyadh', 'https://linkedin.com/company/lucidya', 'info@lucidya.com', '+966504567890', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000010', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000010', 'Salla', 'https://www.salla.sa', 'E-commerce', '200-500', 'Saudi Arabia', 'Riyadh', 'https://linkedin.com/company/salla', 'info@salla.sa', '+966505678901', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000011', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000011', 'Mzad Qatar', 'https://www.mzadqatar.com', 'Marketplace', '20-50', 'Qatar', 'Doha', 'https://linkedin.com/company/mzadqatar', 'info@mzadqatar.com', '+974501234567', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000012', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000012', 'Qatar National Bank', 'https://www.qnb.com', 'Banking', '10000+', 'Qatar', 'Doha', 'https://linkedin.com/company/qnb', 'info@qnb.com', '+974502345678', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000013', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000013', 'Ooredoo', 'https://www.ooredoo.qa', 'Telecom', '5000-10000', 'Qatar', 'Doha', 'https://linkedin.com/company/ooredoo', 'info@ooredoo.qa', '+974503456789', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000014', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000014', 'Manateq', 'https://www.manateq.qa', 'Industrial', '100-500', 'Qatar', 'Doha', 'https://linkedin.com/company/manateq', 'info@manateq.qa', '+974504567890', NOW(), NOW()),
('e1000000-0000-0000-0000-000000000015', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000015', 'Meeza', 'https://www.meeza.net', 'IT Services', '200-500', 'Qatar', 'Doha', 'https://linkedin.com/company/meeza', 'info@meeza.net', '+974505678901', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 6. INDIVIDUAL ENTITIES (30: 2 per company, Arabic MENA names)
-- ============================================================
INSERT INTO individual_entities (id, tenant_id, lead_id, company_id, first_name, last_name, job_title, email, phone, linkedin_url, is_decision_maker, seniority_level, created_at, updated_at) VALUES
-- Careem
('f1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001', 'Omar', 'Al-Hashimi', 'CTO', 'omar.h@careem.com', '+971551234567', 'https://linkedin.com/in/omaralhashimi', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001', 'Layla', 'Mansour', 'VP Engineering', 'layla.m@careem.com', '+971551234568', 'https://linkedin.com/in/laylamansour', true, 'VP', NOW(), NOW()),
-- Fetchr
('f1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000002', 'e1000000-0000-0000-0000-000000000002', 'Tariq', 'Al-Zaabi', 'VP Operations', 'tariq.z@fetchr.us', '+971552345678', 'https://linkedin.com/in/tariqalzaabi', true, 'VP', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000002', 'e1000000-0000-0000-0000-000000000002', 'Noura', 'Al-Falasi', 'Head of Technology', 'noura.f@fetchr.us', '+971552345679', 'https://linkedin.com/in/nouraalfalasi', true, 'Director', NOW(), NOW()),
-- Property Finder
('f1000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000003', 'e1000000-0000-0000-0000-000000000003', 'Saeed', 'Al-Maktoum', 'CIO', 'saeed.m@propertyfinder.ae', '+971553456789', 'https://linkedin.com/in/saeedalmaktoum', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000003', 'e1000000-0000-0000-0000-000000000003', 'Mariam', 'Al-Suwaidi', 'Product Manager', 'mariam.s@propertyfinder.ae', '+971553456790', 'https://linkedin.com/in/mariamalsuwaidi', false, 'Manager', NOW(), NOW()),
-- Kitopi
('f1000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000004', 'e1000000-0000-0000-0000-000000000004', 'Yousef', 'Al-Shamsi', 'CEO', 'yousef.s@kitopi.com', '+971554567890', 'https://linkedin.com/in/yousefalshamsi', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000004', 'e1000000-0000-0000-0000-000000000004', 'Huda', 'Al-Nuaimi', 'Head of Growth', 'huda.n@kitopi.com', '+971554567891', 'https://linkedin.com/in/hudaalnuaimi', false, 'Director', NOW(), NOW()),
-- Tabby
('f1000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000005', 'e1000000-0000-0000-0000-000000000005', 'Rashid', 'Al-Ketbi', 'CTO', 'rashid.k@tabby.ai', '+971555678901', 'https://linkedin.com/in/rashidalketbi', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000010', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000005', 'e1000000-0000-0000-0000-000000000005', 'Aisha', 'Al-Dhaheri', 'Engineering Lead', 'aisha.d@tabby.ai', '+971555678902', 'https://linkedin.com/in/aishaaldhaheri', false, 'Lead', NOW(), NOW()),
-- Foodics
('f1000000-0000-0000-0000-000000000011', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000006', 'e1000000-0000-0000-0000-000000000006', 'Abdullah', 'Al-Ghamdi', 'CEO', 'abdullah.g@foodics.com', '+966551234567', 'https://linkedin.com/in/abdullahalghamdi', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000012', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000006', 'e1000000-0000-0000-0000-000000000006', 'Sara', 'Al-Otaibi', 'VP Product', 'sara.o@foodics.com', '+966551234568', 'https://linkedin.com/in/saraalotaibi', true, 'VP', NOW(), NOW()),
-- Jahez
('f1000000-0000-0000-0000-000000000013', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000007', 'e1000000-0000-0000-0000-000000000007', 'Mohammed', 'Al-Qahtani', 'CTO', 'mohammed.q@jahez.net', '+966552345678', 'https://linkedin.com/in/mohammedalqahtani', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000014', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000007', 'e1000000-0000-0000-0000-000000000007', 'Noor', 'Al-Harbi', 'Data Engineering Lead', 'noor.h@jahez.net', '+966552345679', 'https://linkedin.com/in/nooralharbi', false, 'Lead', NOW(), NOW()),
-- Tamara
('f1000000-0000-0000-0000-000000000015', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000008', 'e1000000-0000-0000-0000-000000000008', 'Sultan', 'Al-Dosari', 'CEO', 'sultan.d@tamara.co', '+966553456789', 'https://linkedin.com/in/sultanaldosari', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000016', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000008', 'e1000000-0000-0000-0000-000000000008', 'Reem', 'Al-Shehri', 'Head of Engineering', 'reem.s@tamara.co', '+966553456790', 'https://linkedin.com/in/reemalshehri', true, 'Director', NOW(), NOW()),
-- Lucidya
('f1000000-0000-0000-0000-000000000017', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000009', 'e1000000-0000-0000-0000-000000000009', 'Faisal', 'Al-Zahrani', 'CEO', 'faisal.z@lucidya.com', '+966554567890', 'https://linkedin.com/in/faisalalzahrani', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000018', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000009', 'e1000000-0000-0000-0000-000000000009', 'Dalal', 'Al-Mutairi', 'VP Sales', 'dalal.m@lucidya.com', '+966554567891', 'https://linkedin.com/in/dalalmutairi', true, 'VP', NOW(), NOW()),
-- Salla
('f1000000-0000-0000-0000-000000000019', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000010', 'e1000000-0000-0000-0000-000000000010', 'Bandar', 'Al-Rajhi', 'CTO', 'bandar.r@salla.sa', '+966555678901', 'https://linkedin.com/in/bandaralrajhi', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000020', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000010', 'e1000000-0000-0000-0000-000000000010', 'Lina', 'Al-Juhani', 'Product Manager', 'lina.j@salla.sa', '+966555678902', 'https://linkedin.com/in/linaaljuhani', false, 'Manager', NOW(), NOW()),
-- Mzad Qatar
('f1000000-0000-0000-0000-000000000021', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000011', 'e1000000-0000-0000-0000-000000000011', 'Hamad', 'Al-Marri', 'CEO', 'hamad.m@mzadqatar.com', '+974551234567', 'https://linkedin.com/in/hamadalmarri', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000022', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000011', 'e1000000-0000-0000-0000-000000000011', 'Maha', 'Al-Kuwari', 'Operations Manager', 'maha.k@mzadqatar.com', '+974551234568', 'https://linkedin.com/in/mahaalkuwari', false, 'Manager', NOW(), NOW()),
-- QNB
('f1000000-0000-0000-0000-000000000023', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000012', 'e1000000-0000-0000-0000-000000000012', 'Jassim', 'Al-Thani', 'CIO', 'jassim.t@qnb.com', '+974552345678', 'https://linkedin.com/in/jassimalthani', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000024', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000012', 'e1000000-0000-0000-0000-000000000012', 'Sheikha', 'Al-Misnad', 'Digital Transformation Lead', 'sheikha.m@qnb.com', '+974552345679', 'https://linkedin.com/in/sheikhamisnad', true, 'Director', NOW(), NOW()),
-- Ooredoo
('f1000000-0000-0000-0000-000000000025', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000013', 'e1000000-0000-0000-0000-000000000013', 'Nasser', 'Al-Attiyah', 'VP Technology', 'nasser.a@ooredoo.qa', '+974553456789', 'https://linkedin.com/in/nasseralattiyah', true, 'VP', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000026', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000013', 'e1000000-0000-0000-0000-000000000013', 'Fatma', 'Al-Sulaiti', 'Innovation Manager', 'fatma.s@ooredoo.qa', '+974553456790', 'https://linkedin.com/in/fatmaalsulaiti', false, 'Manager', NOW(), NOW()),
-- Manateq
('f1000000-0000-0000-0000-000000000027', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000014', 'e1000000-0000-0000-0000-000000000014', 'Ali', 'Al-Naimi', 'CEO', 'ali.n@manateq.qa', '+974554567890', 'https://linkedin.com/in/alialnaimi', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000028', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000014', 'e1000000-0000-0000-0000-000000000014', 'Amna', 'Al-Hajri', 'IT Director', 'amna.h@manateq.qa', '+974554567891', 'https://linkedin.com/in/amnalhajri', true, 'Director', NOW(), NOW()),
-- Meeza
('f1000000-0000-0000-0000-000000000029', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000015', 'e1000000-0000-0000-0000-000000000015', 'Mansoor', 'Al-Mahmoud', 'CTO', 'mansoor.m@meeza.net', '+974555678901', 'https://linkedin.com/in/mansooralmahmoud', true, 'C-Suite', NOW(), NOW()),
('f1000000-0000-0000-0000-000000000030', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000015', 'e1000000-0000-0000-0000-000000000015', 'Hessa', 'Al-Dosari', 'Cloud Services Manager', 'hessa.d@meeza.net', '+974555678902', 'https://linkedin.com/in/hessadosari', false, 'Manager', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 7. CAMPAIGNS (5)
-- ============================================================
INSERT INTO campaigns (id, tenant_id, name, campaign_type, status, target_profile, email_platform, channels, sequence, language, region, created_by, created_at, updated_at) VALUES
('ca000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'UAE Tech Decision Makers - Email', 'outbound', 'active',
 '{"industries":["Technology","SaaS"],"company_size":"50-500","countries":["UAE"],"job_titles":["CTO","VP Engineering","Head of IT"]}'::jsonb,
 'instantly', '["email"]'::jsonb,
 '[{"step":1,"channel":"email","delay_days":0,"template":"intro"},{"step":2,"channel":"email","delay_days":3,"template":"follow_up"}]'::jsonb,
 'en', 'UAE', 'b1000000-0000-0000-0000-000000000001', NOW(), NOW()),
('ca000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'UAE Tech Leaders - LinkedIn', 'outbound', 'active',
 '{"industries":["Technology","E-commerce"],"company_size":"100-1000","countries":["UAE"],"job_titles":["CEO","CTO","Founder"]}'::jsonb,
 'instantly', '["linkedin"]'::jsonb,
 '[{"step":1,"channel":"linkedin","delay_days":0,"template":"connection_request"},{"step":2,"channel":"linkedin","delay_days":2,"template":"message"}]'::jsonb,
 'en', 'UAE', 'b1000000-0000-0000-0000-000000000001', NOW(), NOW()),
('ca000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000002', 'Saudi Fintech Outreach - Multi', 'outbound', 'active',
 '{"industries":["Financial Services","Fintech"],"company_size":"50-500","countries":["Saudi Arabia"],"job_titles":["CEO","CFO","Head of Digital"]}'::jsonb,
 'instantly', '["email","linkedin"]'::jsonb,
 '[{"step":1,"channel":"email","delay_days":0,"template":"intro_ar"},{"step":2,"channel":"linkedin","delay_days":2,"template":"connection"},{"step":3,"channel":"email","delay_days":5,"template":"follow_up_ar"}]'::jsonb,
 'ar', 'Saudi Arabia', 'b1000000-0000-0000-0000-000000000002', NOW(), NOW()),
('ca000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000002', 'Saudi Enterprise - WhatsApp', 'nurture', 'draft',
 '{"industries":["E-commerce","Retail"],"company_size":"200-2000","countries":["Saudi Arabia"],"job_titles":["CMO","Head of Marketing","Growth Lead"]}'::jsonb,
 'instantly', '["whatsapp"]'::jsonb,
 '[{"step":1,"channel":"whatsapp","delay_days":0,"template":"whatsapp_intro_ar"}]'::jsonb,
 'ar', 'Saudi Arabia', 'b1000000-0000-0000-0000-000000000002', NOW(), NOW()),
('ca000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000003', 'Qatar Innovation Leaders - Email', 'outbound', 'active',
 '{"industries":["Technology","Telecom","Real Estate"],"company_size":"100-5000","countries":["Qatar"],"job_titles":["CTO","CIO","Digital Director"]}'::jsonb,
 'instantly', '["email"]'::jsonb,
 '[{"step":1,"channel":"email","delay_days":0,"template":"intro"},{"step":2,"channel":"email","delay_days":4,"template":"case_study"},{"step":3,"channel":"email","delay_days":7,"template":"final_follow_up"}]'::jsonb,
 'en', 'Qatar', 'b1000000-0000-0000-0000-000000000003', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 8. CAMPAIGN LEADS (15: 3 per campaign)
-- ============================================================
INSERT INTO campaign_leads (id, tenant_id, campaign_id, lead_id, status, lead_email, created_at, updated_at) VALUES
('cb000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 'active', 'info@careem.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000002', 'active', 'info@fetchr.us', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000003', 'active', 'info@propertyfinder.ae', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000004', 'active', 'info@kitopi.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000005', 'active', 'info@tabby.ai', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000001', 'contacted', 'info@careem.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000006', 'active', 'info@foodics.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000007', 'active', 'info@jahez.net', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000008', 'contacted', 'info@tamara.co', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000010', 'a1000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000004', 'd1000000-0000-0000-0000-000000000009', 'active', 'info@lucidya.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000011', 'a1000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000004', 'd1000000-0000-0000-0000-000000000010', 'active', 'info@salla.sa', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000012', 'a1000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000004', 'd1000000-0000-0000-0000-000000000006', 'contacted', 'info@foodics.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000013', 'a1000000-0000-0000-0000-000000000003', 'ca000000-0000-0000-0000-000000000005', 'd1000000-0000-0000-0000-000000000011', 'active', 'info@mzadqatar.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000014', 'a1000000-0000-0000-0000-000000000003', 'ca000000-0000-0000-0000-000000000005', 'd1000000-0000-0000-0000-000000000012', 'active', 'info@qnb.com', NOW(), NOW()),
('cb000000-0000-0000-0000-000000000015', 'a1000000-0000-0000-0000-000000000003', 'ca000000-0000-0000-0000-000000000005', 'd1000000-0000-0000-0000-000000000013', 'contacted', 'info@ooredoo.qa', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 9. LEAD SCORES HISTORY (15: 3 hot, 5 warm, 4 cool, 3 cold)
-- ============================================================
INSERT INTO lead_scores_history (id, tenant_id, lead_id, campaign_id, fit_score, engagement_score, total_score, score_reason, created_at) VALUES
-- Hot (3)
('cc000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000001', 9.2, 8.5, 8.85, 'Hiring + funding signals. CTO engaged on LinkedIn.', NOW()),
('cc000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000006', 'ca000000-0000-0000-0000-000000000003', 8.8, 9.1, 8.95, 'Market expansion, hiring engineers. CEO replied.', NOW()),
('cc000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000012', 'ca000000-0000-0000-0000-000000000005', 9.5, 8.0, 8.75, 'Digital transformation. CIO evaluating vendors.', NOW()),
-- Warm (5)
('cc000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000001', 7.5, 6.8, 7.15, 'Tech stack upgrade. VP Ops opened 2 emails.', NOW()),
('cc000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000004', 'ca000000-0000-0000-0000-000000000002', 7.0, 7.2, 7.10, 'Kitchen expansion. LinkedIn accepted, no reply.', NOW()),
('cc000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000007', 'ca000000-0000-0000-0000-000000000003', 6.5, 7.0, 6.75, 'Hiring data engineers. Email opened 3x.', NOW()),
('cc000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000009', 'ca000000-0000-0000-0000-000000000004', 7.2, 6.0, 6.60, 'Potential partner. Warm but slow engagement.', NOW()),
('cc000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000013', 'ca000000-0000-0000-0000-000000000005', 6.8, 7.5, 7.15, 'Innovation lab. Email clicked, visited site.', NOW()),
-- Cool (4)
('cc000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000003', 'ca000000-0000-0000-0000-000000000001', 5.5, 4.0, 4.75, 'Stable, no expansion signals. Low engagement.', NOW()),
('cc000000-0000-0000-0000-000000000010', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000005', 'ca000000-0000-0000-0000-000000000002', 5.0, 5.5, 5.25, 'BNPL consumer-focused. B2B not priority.', NOW()),
('cc000000-0000-0000-0000-000000000011', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000008', 'ca000000-0000-0000-0000-000000000003', 4.8, 5.0, 4.90, 'Internal team handles automation. Low need.', NOW()),
('cc000000-0000-0000-0000-000000000012', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000011', 'ca000000-0000-0000-0000-000000000005', 5.2, 4.5, 4.85, 'Small team. Budget constraints.', NOW()),
-- Cold (3)
('cc000000-0000-0000-0000-000000000013', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000010', 'ca000000-0000-0000-0000-000000000004', 3.5, 2.0, 2.75, 'SME merchant platform. No automation signals.', NOW()),
('cc000000-0000-0000-0000-000000000014', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000014', NULL, 3.0, 1.5, 2.25, 'Industrial zones. No tech signals.', NOW()),
('cc000000-0000-0000-0000-000000000015', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000015', NULL, 2.5, 2.0, 2.25, 'IT services, govt contracts. Long cycle.', NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 10. TENANT CREDITS (3)
-- ============================================================
INSERT INTO tenant_credits (id, tenant_id, balance, last_updated) VALUES
('cd000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 5000, NOW()),
('cd000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 10000, NOW()),
('cd000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003', 1000, NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 11. ENRICHMENT RESULTS (15: 1 per lead)
--     final_priority_score is a GENERATED column — do not insert
-- ============================================================
INSERT INTO enrichment_results (id, tenant_id, lead_id, layer1_gemini, layer2_relevance, layer3_authority, scoring, class_rating, created_at, updated_at) VALUES
('ce000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000001',
 '{"summary":"Super app ride-hailing payments delivery","industry":"Technology","employees":"1000-5000"}'::jsonb,
 '{"icp_match":0.92,"industry_fit":"high","size_fit":"enterprise","geo":"UAE"}'::jsonb,
 '{"dm_found":3,"c_suite":true,"linkedin":"high"}'::jsonb,
 '{"fit":9.2,"potential":"very_high","priority":"hot"}'::jsonb, 'A', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000002',
 '{"summary":"Last-mile delivery logistics","industry":"Logistics","employees":"200-500"}'::jsonb,
 '{"icp_match":0.75,"industry_fit":"medium","size_fit":"mid_market","geo":"UAE"}'::jsonb,
 '{"dm_found":2,"c_suite":true,"linkedin":"medium"}'::jsonb,
 '{"fit":7.5,"potential":"medium","priority":"warm"}'::jsonb, 'B', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000003',
 '{"summary":"MENA real estate portal","industry":"Real Estate","employees":"500-1000"}'::jsonb,
 '{"icp_match":0.55,"industry_fit":"low","size_fit":"enterprise","geo":"UAE"}'::jsonb,
 '{"dm_found":2,"c_suite":false,"linkedin":"low"}'::jsonb,
 '{"fit":5.5,"potential":"low","priority":"cool"}'::jsonb, 'C', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000004',
 '{"summary":"Cloud kitchen tech platform","industry":"FoodTech","employees":"500-2000"}'::jsonb,
 '{"icp_match":0.70,"industry_fit":"medium","size_fit":"growth","geo":"UAE"}'::jsonb,
 '{"dm_found":2,"c_suite":true,"linkedin":"medium"}'::jsonb,
 '{"fit":7.0,"potential":"medium","priority":"warm"}'::jsonb, 'B', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000001', 'd1000000-0000-0000-0000-000000000005',
 '{"summary":"BNPL fintech UAE","industry":"Fintech","employees":"200-500"}'::jsonb,
 '{"icp_match":0.50,"industry_fit":"medium","size_fit":"mid_market","geo":"UAE"}'::jsonb,
 '{"dm_found":1,"c_suite":false,"linkedin":"medium"}'::jsonb,
 '{"fit":5.0,"potential":"low","priority":"cool"}'::jsonb, 'C', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000006', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000006',
 '{"summary":"Restaurant management SaaS","industry":"FoodTech/SaaS","employees":"500-1000"}'::jsonb,
 '{"icp_match":0.88,"industry_fit":"high","size_fit":"growth","geo":"Saudi Arabia"}'::jsonb,
 '{"dm_found":3,"c_suite":true,"linkedin":"very_high"}'::jsonb,
 '{"fit":8.8,"potential":"very_high","priority":"hot"}'::jsonb, 'A', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000007', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000007',
 '{"summary":"Food delivery platform Saudi","industry":"Delivery","employees":"1000-3000"}'::jsonb,
 '{"icp_match":0.65,"industry_fit":"medium","size_fit":"enterprise","geo":"Saudi Arabia"}'::jsonb,
 '{"dm_found":2,"c_suite":true,"linkedin":"medium"}'::jsonb,
 '{"fit":6.5,"potential":"medium","priority":"warm"}'::jsonb, 'B', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000008', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000008',
 '{"summary":"BNPL Saudi market","industry":"Fintech","employees":"200-500"}'::jsonb,
 '{"icp_match":0.48,"industry_fit":"medium","size_fit":"growth","geo":"Saudi Arabia"}'::jsonb,
 '{"dm_found":1,"c_suite":false,"linkedin":"low"}'::jsonb,
 '{"fit":4.8,"potential":"low","priority":"cool"}'::jsonb, 'C', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000009', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000009',
 '{"summary":"Arabic social listening analytics","industry":"MarTech","employees":"50-200"}'::jsonb,
 '{"icp_match":0.72,"industry_fit":"high","size_fit":"smb","geo":"Saudi Arabia"}'::jsonb,
 '{"dm_found":2,"c_suite":true,"linkedin":"medium"}'::jsonb,
 '{"fit":7.2,"potential":"medium","priority":"warm"}'::jsonb, 'B', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000010', 'a1000000-0000-0000-0000-000000000002', 'd1000000-0000-0000-0000-000000000010',
 '{"summary":"E-commerce platform Saudi SMEs","industry":"E-commerce","employees":"200-500"}'::jsonb,
 '{"icp_match":0.35,"industry_fit":"low","size_fit":"mid_market","geo":"Saudi Arabia"}'::jsonb,
 '{"dm_found":1,"c_suite":false,"linkedin":"low"}'::jsonb,
 '{"fit":3.5,"potential":"very_low","priority":"cold"}'::jsonb, 'D', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000011', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000011',
 '{"summary":"Qatar online classifieds","industry":"Marketplace","employees":"20-50"}'::jsonb,
 '{"icp_match":0.52,"industry_fit":"low","size_fit":"smb","geo":"Qatar"}'::jsonb,
 '{"dm_found":1,"c_suite":true,"linkedin":"low"}'::jsonb,
 '{"fit":5.2,"potential":"low","priority":"cool"}'::jsonb, 'C', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000012', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000012',
 '{"summary":"Qatar National Bank largest in MENA","industry":"Banking","employees":"10000+"}'::jsonb,
 '{"icp_match":0.95,"industry_fit":"very_high","size_fit":"enterprise","geo":"Qatar"}'::jsonb,
 '{"dm_found":4,"c_suite":true,"linkedin":"high"}'::jsonb,
 '{"fit":9.5,"potential":"very_high","priority":"hot"}'::jsonb, 'A', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000013', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000013',
 '{"summary":"Major telecom operator Qatar","industry":"Telecom","employees":"5000-10000"}'::jsonb,
 '{"icp_match":0.68,"industry_fit":"medium","size_fit":"enterprise","geo":"Qatar"}'::jsonb,
 '{"dm_found":2,"c_suite":false,"linkedin":"medium"}'::jsonb,
 '{"fit":6.8,"potential":"medium","priority":"warm"}'::jsonb, 'B', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000014', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000014',
 '{"summary":"Qatar economic zones industrial","industry":"Industrial","employees":"100-500"}'::jsonb,
 '{"icp_match":0.30,"industry_fit":"very_low","size_fit":"mid_market","geo":"Qatar"}'::jsonb,
 '{"dm_found":1,"c_suite":false,"linkedin":"very_low"}'::jsonb,
 '{"fit":3.0,"potential":"very_low","priority":"cold"}'::jsonb, 'D', NOW(), NOW()),
('ce000000-0000-0000-0000-000000000015', 'a1000000-0000-0000-0000-000000000003', 'd1000000-0000-0000-0000-000000000015',
 '{"summary":"IT services data center Qatar","industry":"IT Services","employees":"200-500"}'::jsonb,
 '{"icp_match":0.25,"industry_fit":"low","size_fit":"mid_market","geo":"Qatar"}'::jsonb,
 '{"dm_found":1,"c_suite":false,"linkedin":"very_low"}'::jsonb,
 '{"fit":2.5,"potential":"very_low","priority":"cold"}'::jsonb, 'D', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- VERIFICATION QUERIES (run after seeding)
-- ============================================================
-- SELECT 'tenants' as tbl, count(*) FROM tenants
-- UNION ALL SELECT 'users', count(*) FROM users
-- UNION ALL SELECT 'industries', count(*) FROM industries
-- UNION ALL SELECT 'leads', count(*) FROM leads
-- UNION ALL SELECT 'company_entities', count(*) FROM company_entities
-- UNION ALL SELECT 'individual_entities', count(*) FROM individual_entities
-- UNION ALL SELECT 'campaigns', count(*) FROM campaigns
-- UNION ALL SELECT 'campaign_leads', count(*) FROM campaign_leads
-- UNION ALL SELECT 'lead_scores_history', count(*) FROM lead_scores_history
-- UNION ALL SELECT 'tenant_credits', count(*) FROM tenant_credits
-- UNION ALL SELECT 'enrichment_results', count(*) FROM enrichment_results;
