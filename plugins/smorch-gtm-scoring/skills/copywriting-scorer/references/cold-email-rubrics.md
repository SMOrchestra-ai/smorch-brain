# Subsystem 3A: Cold Email Copy — 9 Criteria

Cold email copy must survive three gauntlets: the spam filter (technical), the inbox scan (2 seconds to earn the open), and the read (10 seconds to earn the reply). 2026 Gmail and Microsoft are ruthless: DMARC enforcement, spam complaint tracking, and content filtering are all stricter than 2024.

## C1: Subject Line — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 3-6 words. Lowercase. Feels like an internal email, not marketing. Creates curiosity gap without clickbait. Personalized variable (company name or trigger). Zero spam trigger words. Example: "quick q about {{company}} expansion" |
| 7/10 | Good | 4-8 words. Mostly clean. Some personalization. Creates interest but could be sharper. "thoughts on {{company}}'s outbound" |
| 5/10 | Mediocre | Generic but not terrible. "Partnership opportunity" or "Quick question." No personalization. Would blend into inbox. |
| 1/10 | Failure | Marketing blast subject. "Unlock Your Growth Potential with AI-Powered Solutions!" All caps, exclamation, spam triggers. |

**Fix Action:** Rewrite as 4 words, lowercase, with one {{variable}}. Delete every word that sounds like marketing.

---

## C2: Opening Line (Hook) — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Signal-derived. References something specific the prospect DID (hired VP Sales, raised Series B, posted about X, expanded to new market). Timeline hook: "Noticed {{company}} just {{signal}}..." 2.3x higher reply rate than problem hooks per Instantly 2026 data. |
| 7/10 | Good | References something relevant about the prospect (industry, role, company stage). Not signal-specific but shows research. "As a [role] at a [stage] company in [market]..." |
| 5/10 | Mediocre | Generic problem statement. "Many companies in your industry struggle with..." Not personalized. Not signal-based. |
| 1/10 | Failure | "I hope this email finds you well." Or "My name is X and I work at Y." Instant delete. |

**Fix Action:** Replace the opening line with a timeline hook: "Noticed {{company}} just [signal]. When companies [do signal], they typically face [consequence]..." Use one real, verifiable signal about the prospect.

---

## C3: Spam Filter Survival — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Zero spam trigger words. No HTML formatting. No images or links in first email. Plain text appearance. Proper DMARC/DKIM/SPF. Under 80 words. No ALL CAPS. Single plain CTA. Passes Instantly spam checker clean. |
| 7/10 | Good | Mostly clean. Maybe one tracked link (not in first email). Under 100 words. No images. Minor formatting. Would pass most filters. |
| 5/10 | Mediocre | 1-2 minor triggers. Maybe one link. Slightly formatted. 100-150 words. 50/50 chance on strict filters. |
| 1/10 | Failure | Loaded with spam triggers. HTML template. Multiple links. Images. Looks like a newsletter. Over 200 words. Gmail rejects or marks spam. |

**Fix Action:** Run the email through a spam word checker. Remove: free, guarantee, act now, limited time, click here, no obligation, all caps words. Remove all links from email 1. Strip HTML to plain text. Cut to under 80 words.

---

## C4: Body Value Density — Weight: 12%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Every sentence adds value or moves toward CTA. No filler. Demonstrates understanding of their specific situation. Shows proof of competence in 1-2 sentences max. Total email: 50-80 words. |
| 7/10 | Good | Mostly value-dense. One sentence of context that could be cut. 80-100 words. Proof is present but could be sharper. |
| 5/10 | Mediocre | Some value but padded. "We've helped companies like yours..." without specifics. 100-150 words with unnecessary context. |
| 1/10 | Failure | Feature dump. Company history. "Founded in 2015, we are a leading provider of..." No value for the reader. |

**Fix Action:** Read each sentence and ask: "Does this give the prospect new information they care about?" Delete every sentence where the answer is no. Target: 50-80 words total.

---

## C5: Social Proof Integration — Weight: 8%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Subtle, specific, relevant. "Did this for {{similar company}} — went from X to Y in Z weeks." One line. Named or industry-specific. |
| 7/10 | Good | Relevant proof but slightly generic. "Helped 3 [industry] companies in [region] achieve [result]." Credible but not personalized to prospect. |
| 5/10 | Mediocre | Generic. "Trusted by 100+ companies." No specifics. Or proof not relevant to prospect's situation. |
| 1/10 | Failure | No social proof. Or bragging: "We're the #1 rated platform on G2." Self-focused, not prospect-focused. |

**Fix Action:** Replace generic proof with one specific line: "[Company similar to theirs] went from [metric A] to [metric B] in [timeframe]." Use a company the prospect would recognize or respect.

---

## C6: CTA Clarity & Friction — Weight: 15%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Single, low-friction CTA. "Worth a 15-min call this week?" or "Want me to send a 2-min video showing how this would work for {{company}}?" Binary yes/no. No calendar link in first email. |
| 7/10 | Good | Clear single CTA. Slightly higher friction. "Would Thursday or Friday work for a quick chat?" Specific but still easy. May include calendar link in email 2+. |
| 5/10 | Mediocre | Reasonable CTA but slightly high friction. "Let's schedule a 30-minute demo." Or multiple CTAs competing for attention. |
| 1/10 | Failure | No CTA. Or high friction: "Fill out this form." Or aggressive: "Ready to 10x your revenue?" |

**Fix Action:** Replace with a binary question the prospect can answer in 2 words: "Worth a quick call?" or "Want me to send a short video?" One CTA. Zero links in email 1.

---

## C7: Personalization Depth — Weight: 10%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 3 layers: (1) Signal/trigger, (2) Company-specific detail, (3) Role-specific pain. Feels like a human wrote this for one person. Not just {{firstName}} merge. |
| 7/10 | Good | 2 layers: company context + role relevance. Merge fields plus one custom detail. Feels semi-personalized. |
| 5/10 | Mediocre | First name + company name merge. Maybe industry mention. Template with merge fields visible. |
| 1/10 | Failure | Zero personalization. Mass blast obvious. Or fake personalization: "I've been following {{company}} for a while." |

**Fix Action:** Add one line that proves you looked at their specific situation: a recent hire they made, a product they launched, a post they wrote, or a market they entered. This line cannot be generated by a merge field alone.

---

## C8: Sequence Architecture — Weight: 8%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | 4-7 emails. Each follow-up adds NEW value (different angle, new proof, alternative CTA). 3-4 day spacing. Tone shifts from curious to helpful to direct. Step 1 gets 58% of replies; steps 2-7 add 42%. |
| 7/10 | Good | 3-5 emails with new angles per follow-up. 3-5 day spacing. Tone progression exists. Each email offers a different reason to reply. |
| 5/10 | Mediocre | 3 emails. Follow-ups are "just checking in" or "bumping this." No new value per touch. |
| 1/10 | Failure | 1 email, no follow-up. Or 10+ that repeat the same pitch. Or follow-ups within 24 hours. |

**Fix Action:** Write each follow-up with a NEW hook: email 2 = new proof point, email 3 = alternative CTA (video/resource), email 4 = social proof angle, email 5 = breakup email. Never repeat the same pitch.

---

## C9: Tone & Voice — Weight: 5%

| Level | Score | Description |
|-------|-------|-------------|
| 10/10 | Excellence | Peer-to-peer. Not supplicant ("I'd be honored..."). Not aggressive ("You're losing $X every day..."). Confident, casual, direct. Reads like a sharp colleague, not a salesperson. |
| 7/10 | Good | Professional and approachable. Slightly formal but not stiff. Reads naturally. |
| 5/10 | Mediocre | Professional but stiff. Corporate tone. "I would like to introduce..." Reads like a business letter from 2010. |
| 1/10 | Failure | Desperate, aggressive, or sycophantic. "I know you're incredibly busy but..." or "ACT NOW!" |

**Fix Action:** Read the email out loud. If you wouldn't say it to a peer at a conference, rewrite it. Remove all formal hedging ("I would like to," "I was wondering if"). Be direct.
