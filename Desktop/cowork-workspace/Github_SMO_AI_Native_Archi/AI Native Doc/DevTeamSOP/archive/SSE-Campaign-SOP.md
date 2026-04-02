1) Cleaned transcription

The goal is to create a solid SOP for a signal sales engine for my organization. We are an agency and we execute this as a service. The product and platform are called SalesMfast.

The concept and stack work like this. We created an app that starts by scraping data using Apify currently, and we plan to expand to other scrapers. The data then goes into Clay and Relevance for enrichment, scoring, intent signals, and other signal and trigger analysis. That is the first side of the application: scraping, enrichment, and signal gathering.

Once that data is collected, it enters our platform and is presented in a dashboard. At the same time, we have campaign management running. The campaign management takes the input from the signals and findings, then writes emails, LinkedIn messages, and sometimes WhatsApp messages. We use HeyReach in the orchestration. We use AI skills to write and score things. The system writes the emails and kicks off the campaign.

The campaign then runs through preset workflows in Instantly, HeyReach, and GoHighLevel when needed, including WhatsApp and CRM handling. Email is sent into multi-step sequences, and LinkedIn messages are also fired. The messaging is signal-based, built from the findings we gathered. Usually it is short, punchy, and to the point. It focuses on outcome and proof for the customer. So the core messaging logic is: capture the signal, then write around outcome and proof.

What I want is a deep research effort on what the best signal-based GTM and outbound looks like, then help us turn that into a clear SOP for the team. Part of the SOP must include how to gather data and how to report on it. We also want MCP connections across all the platforms so we can gather analytics and reports, benchmark campaigns, score them from all aspects, and provide recommendations. So one major part is audit and scoring, and the other major part is the SOP itself.

Scoring is very important to us.

The next thing I want is a multi-level stress-testing SOP for the platform. First is technical and coding stress testing, to make sure the platform works properly, there are no workflow errors, and everything functions as intended. Then there is functional stress testing, to verify it works as intended operationally. Then there is result and outcome stress testing, which means testing whether the campaign performs against benchmark, including open rate, reply rate, and so on.

Inside that scoring, I want multidimensional scoring. I want the offer scored from multiple dimensions. I also want the campaigns scored from multiple dimensions. We need multiple score systems, and I want Claude or the AI layer to use these scores to evaluate the campaigns and provide recommendations.

Another stress test is cost per lead. Eventually I want to expand scraping further. We already use Clay to get more data and enrichment, but I want more sources. I want the platform to understand cost per lead landed, how much it costs us against performance, so this becomes another decision point in the system.

We run campaigns weekly, and we run multiple campaigns weekly. Stress testing the platform is extremely important. If I compare stress testing versus just getting results, I would put it at 51% stress testing and 49% results. It is that important, because I want the team to actually use the platform and stay disciplined with it.

I also want the team, as part of the campaign process, to run a parallel version of the campaign the old way. We used to do almost the same process manually: use LinkedIn search, use Clay for enrichment, produce emails with AI, but the orchestration was human-led instead of AI-led. So I want to define this as human-orchestrated campaigns versus AI-orchestrated campaigns.

I want the team to run those in parallel so we can benchmark both approaches. The manual version will not really test infrastructure or functional reliability, but it will test performance and cost, at least partially. I want this included in the SOP so we can clearly measure the difference between the two scenarios: human-orchestrated versus AI-orchestrated.

2) Structured summary
Objective

Build a rigorous SOP for SalesMfast, your signal-based outbound engine, so the team can run it consistently, score it properly, stress test it continuously, and compare AI-orchestrated campaigns against human-orchestrated campaigns.

Current system architecture

Data layer
Apify and other scrapers collect raw prospect and account data.

Enrichment and intelligence layer
Clay and Relevance enrich records, detect signals, score accounts, identify intent, and classify triggers.

Application layer
SalesMfast surfaces this intelligence inside a dashboard.

Campaign orchestration layer
The system generates signal-based outreach across email, LinkedIn, and sometimes WhatsApp.

Execution layer
Instantly, HeyReach, and GoHighLevel execute the workflows and manage CRM / WhatsApp / sequencing.

Messaging doctrine

Every outreach message should be driven by:

a real signal
a clear business outcome
proof or evidence
What the SOP must cover
Data gathering
Signal detection and scoring
Campaign creation and execution
Analytics, reporting, and benchmarking
Audit and recommendation engine
Stress testing across multiple layers
Cost-per-lead measurement
AI-orchestrated vs human-orchestrated comparison model
Stress-testing layers requested
Technical / infrastructure stress test
Does the code, workflow, and automation run without failure?
Functional stress test
Does the process behave correctly end to end?
Performance / outcome stress test
Does it perform against benchmarks?
Economic stress test
Does it produce acceptable cost per lead and cost per positive outcome?
Key design priority

Stress testing is not optional QA. It is part of the operating model.

Comparison requirement

Run a parallel human-led version of the same campaign to compare:

performance
cost
speed
consistency
scalability
recommendation quality
3) Strategic analysis and expanded SOP
First: the sharp diagnosis

What you are building is not just an outbound automation SOP.

It is a signal-to-action operating system.

That distinction matters because most outbound SOPs fail for one of three reasons:

They optimize send volume instead of decision quality.
They collect signals but do not translate them into action thresholds.
They treat campaign performance as the output, when the real output is decision quality under scale.

Your instinct to weight stress testing at 51% is correct.

Why? Because if the machine is unstable, any result you get is noisy. You cannot tell whether the campaign won because of signal quality, operator quality, luck, or broken routing. In other words, without stress testing, you do not have a sales engine. You have anecdotes.

That is the right strategic frame.

4) What current best practice says about signal-based GTM

The current best-practice model in signal-based GTM is converging around a few principles:

A signal-based motion works best when outreach is triggered by a combination of fit, intent, and engagement, rather than static list-building. Demandbase explicitly frames warm outbound this way and recommends “signal stacking,” scoring thresholds, automated routing, playbooks, and continuous refinement.

LinkedIn’s own Sales Navigator positioning also aligns with this. Buyer Intent is designed to help sellers identify the right accounts, the right people inside those accounts, and the right time to reach out, including visibility into the activities that indicate intent.

A second best practice is to avoid tracking everything at once. UserGems argues that most signal programs fail because teams start too broad, and recommends beginning with one high-impact signal, proving it, then expanding.

A third best practice is that scoring must be time-bound and contextual, not just cumulative. Demandbase’s engagement framework argues that traditional lead scoring misses account-level engagement, anonymous activity, and recency, and that scoring should tie activity to defined time windows.

That maps almost perfectly to what you want.

So the right SOP is not “scrape, enrich, send.”
The right SOP is:

detect → validate → stack → score → route → message → launch → measure → compare → refine

5) The operating model I recommend for SalesMfast
A. Core system architecture
Layer 1: Signal acquisition

Sources include Apify, Clay scraping, first-party data, website visitors, LinkedIn activity, hiring signals, funding signals, competitor-research signals, tech stack signals, CRM history, and campaign engagement.

Layer 2: Signal normalization

Every incoming event must be normalized into a common record structure:

account_id
contact_id
source
signal_type
signal_subtype
timestamp
confidence_score
freshness_window
ICP_fit_score
intent_score
trigger_score
proof_available
recommended_play

If you do not normalize this layer, the platform becomes a pile of disconnected alerts.

Layer 3: Signal classification

Use four primary classes:

Fit: Should we care?
Intent: Are they in market?
Trigger: Why now?
Engagement: Are they interacting with us specifically?

This is stronger than using intent alone. Demandbase’s fit-intent-engagement model supports this direction, and adding trigger as a separate class is smart because it captures timing events like hiring, job changes, funding, expansion, or tool change.

Layer 4: Signal stacking

Single signals are weak. Combinations matter more. Demandbase explicitly recommends stacking signals and notes that individual signals are often weak in isolation.

Example stack:

ICP fit: high
new VP Sales hired
competitor comparison page visit
3 stakeholders engaged
relevant case study downloaded

That should not be treated the same as:

ICP fit: medium
one blog visit

Your SOP must forbid treating those two cases equally.

Layer 5: Decision engine

Every account enters one of four routing states:

Tier 0: discard or suppress
Tier 1: monitor only
Tier 2: nurture / light-touch
Tier 3: launch outbound now
Layer 6: Message generation

Message generation should never start from a blank page. It should be assembled from structured inputs:

signal summary
likely pain hypothesis
offer angle
outcome claim
proof asset
CTA type
channel rules
Layer 7: Campaign execution

Execution across Instantly, HeyReach, and GHL should be channel-sequenced, not tool-sequenced.

Meaning:
You do not start with “what does Instantly do?”
You start with “what sequence does this buyer deserve?”

That is the difference between automation and orchestration.

6) Recommended master SOP for weekly campaign operations
Phase 1: Campaign brief

Every campaign begins with a one-page brief containing:

ICP definition
negative ICP
target geography
offer
wedge
proof assets
signal set to activate
suppression rules
channels used
success threshold
benchmark threshold
budget cap
human owner

No brief, no campaign.

Phase 2: Data acquisition and QA

The team pulls data from approved scraping sources and first-party systems.

Checks:

duplicate rate
missing fields
invalid domains
invalid LinkedIn URLs
stale signals
source-level reliability
enrichment completion rate

Output:
a clean prospect/account set with signal records.

Phase 3: Scoring and routing

Each account gets scored on four axes:

Fit
Intent
Trigger
Engagement

Then a composite Priority Score is created.

Suggested formula:

Priority Score = (Fit x 0.30) + (Intent x 0.30) + (Trigger x 0.20) + (Engagement x 0.20)

Then overlay:

freshness multiplier
buying committee multiplier
proof-match multiplier
suppression penalty

Example:

signal older than 30 days = penalty
3+ relevant stakeholders = uplift
no relevant case study = penalty
recent negative reply from same domain = suppression
Phase 4: Offer scoring

This needs its own score, separate from lead scoring.

Offer score dimensions

Score each from 1 to 5:

Pain severity
Urgency / trigger relevance
Clarity of outcome
Proof strength
Differentiation
Ease of adoption
ROI plausibility
ICP resonance
Timing fit
Channel fit

Offer Score = average of all dimensions

Rule:
If Offer Score is below threshold, do not blame outreach first. Fix the offer or wedge before scaling.

This is where most agencies lie to themselves. They say the campaign failed. Often the campaign did not fail. The offer was weak, vague, or badly timed.

Phase 5: Message assembly

For each segment, generate:

primary email
follow-up variants
LinkedIn connection note if used
LinkedIn message sequence
WhatsApp template only for approved use cases
fallback CTA variant

Message rules should reflect current evidence. Instantly’s 2026 benchmark says average reply rate across billions of interactions was 3.43%, top quartile 5.5%+, top performers 10%+, with 58% of replies coming from the first email and 42% from follow-ups. It also says top-performing campaigns tend to keep emails under 80 words and A/B test weekly. Belkins’ 2025 study similarly found reply rates in the mid-single digits and that shorter emails perform better.

So your SOP should enforce:

short email by default
one message, one signal
one outcome
one proof point
one CTA

Not “personalized fluff.”
Not “we help companies like yours.”
Not long intros.
That is dead weight.

Phase 6: Compliance and deliverability gate

Before launch, pass a mandatory gate.

Google requires bulk senders to use SPF or DKIM, DMARC, valid PTR/DNS, TLS, and to keep spam rates under 0.3%. Microsoft has also tightened high-volume sender requirements around SPF, DKIM, and DMARC.

So your gate should include:

SPF pass
DKIM pass
DMARC pass
mailbox health pass
bounce threshold pass
spam complaint threshold pass
unsubscribe / opt-out handling pass
domain warm-up status pass
sending volume status pass

If this gate fails, do not launch. A “good message” on broken infrastructure is still a bad campaign.

Phase 7: Launch

Launch by batch, not full blast.

Recommended operating logic:

seed batch
monitor
expand
monitor
scale

Because if routing, deliverability, or message logic is broken, you want to discover it at 100 leads, not 10,000.

Phase 8: Daily monitoring

Track:

sends
delivered
bounced
opens if available but not over-weighted
replies
positive replies
meetings booked
disqualifications
unsubscribes
spam flags
connection accepts
LinkedIn replies
WhatsApp delivery / reply if used
workflow failures
token / AI generation failures
routing failures
sync failures to CRM
Phase 9: Weekly review

Every Friday:

score the campaign
compare against benchmark
isolate failures by layer
recommend next action

This is where Claude should behave like an operator, not a writer.

7) The scorecards you actually need

You said multidimensional scoring matters. Correct. One score is useless.

You need at least five scorecards.

1. Data Quality Score

Measures whether the inputs are trustworthy.

Dimensions:

completeness
freshness
uniqueness
validity
source confidence
enrichment depth
signal confidence
2. Offer Score

Measures whether the proposition is worth taking to market.

Dimensions:

pain
urgency
outcome clarity
proof
differentiation
credibility
adoption friction
ROI logic
3. Campaign Design Score

Measures the structure before launch.

Dimensions:

ICP precision
segment logic
signal-message match
channel mix
sequence quality
CTA quality
proof usage
suppression logic
test design quality
4. Execution Health Score

Measures operational reliability.

Dimensions:

workflow uptime
send success
sync success
AI generation success
routing success
data latency
dashboard accuracy
CRM logging accuracy
5. Performance Score

Measures market response.

Dimensions:

bounce rate
deliverability
positive reply rate
meeting rate
connection acceptance
LinkedIn reply rate
time-to-first-positive-reply
cost per positive reply
cost per meeting
opportunity creation rate

Use weights. Do not average blindly.

A campaign with strong opens and weak replies is not “doing okay.” It is failing at message-market fit.

8) Performance benchmarks you can use as guardrails

Use these as directional guardrails, not universal truth.

For cold email, recent large-scale benchmark data from Instantly shows:

average reply rate: 3.43%
top quartile: 5.5%+
top 10%: 10%+
58% of replies come from step one
42% come from follow-ups
short emails and weekly A/B tests correlate with better results.

Belkins’ 2025 study found:

average reply rate around 5.8%
shorter emails under 200 words did better
6 to 8 sentence emails performed best in that dataset.

So for your internal operating thresholds, I would set:

Red: reply rate below 3%
Yellow: 3% to 5%
Green: 5% to 8%
Elite: 8%+

That is pragmatic.

For LinkedIn, reliable universal official benchmarks are weaker, but LinkedIn itself emphasizes personalization and warns that spammy behavior can restrict accounts. Personalization and adequate response windows are explicitly recommended in Sales Navigator guidance.

So for LinkedIn, build your own internal benchmarks by ICP and region rather than trust internet-wide vanity stats.

That is the adult move.

9) Stress-testing framework

This is the section that matters most.

Layer 1: Technical stress test

Question: Does the system run without breaking?

Test areas:

scraper uptime
enrichment API success rates
routing accuracy
queue handling
duplicate prevention
AI content generation success
platform handoff success
CRM sync
dashboard refresh latency
audit log integrity

Pass criteria:

zero critical failures
error rate below threshold
no silent failures
full observability

What to test:

normal loads
peak loads
malformed input
missing fields
duplicate signals
stale signals
channel outage
API timeout
retry logic
fallback behavior
Layer 2: Functional stress test

Question: Does the workflow behave as the SOP says it should?

Test scenarios:

correct signal classification
correct scoring
correct routing
correct sequence assignment
correct suppression
correct proof insertion
correct CRM update
correct recommendation output

Example:
If account has high fit + pricing-page activity + new VP Sales + competitor stack, does it get routed to the correct campaign with the right message logic and the right owner?

If not, the system is not functional, even if nothing crashed.

Layer 3: Outcome stress test

Question: Does it perform against benchmark?

This is where you compare:

reply rate
positive reply rate
meetings booked
meeting show rate
opportunity rate
speed to first meeting
copy variant performance
signal cluster performance
Layer 4: Economic stress test

Question: Is the machine economically rational?

Track:

data acquisition cost
enrichment cost
AI generation cost
tool execution cost
labor cost
cost per lead contacted
cost per reply
cost per positive reply
cost per meeting
cost per opportunity
cost per customer

This is the section most people fake.

You should not ask, “Did we book meetings?”
You should ask, “What did each useful conversation actually cost by motion, signal, channel, and operator model?”

10) Human-orchestrated vs AI-orchestrated comparison design

This is one of the smartest parts of your brief.

You need a controlled comparison, not casual opinion.

Experimental design

Run matched campaigns where the following stay constant:

same ICP
same offer
same geography
same list size
same signal classes
same proof assets
same channels
same campaign window

Only the orchestration model changes.

Variant A

Human-orchestrated
Human manually reviews signals, enriches, drafts, routes, and launches.

Variant B

AI-orchestrated
System scores, drafts, routes, and launches with human approval or audit checkpoints.

Compare across 4 categories
1. Performance
reply rate
positive reply rate
meeting rate
opportunity rate
2. Speed
time from signal capture to launch
time from signal capture to first touch
time from signal capture to positive reply
3. Economics
labor hours
software cost
total cost per meeting
total cost per opportunity
4. Quality and consistency
message quality score
score variance across campaigns
routing accuracy
compliance rate
reporting completeness
Critical rule

Do not compare raw totals only.

Compare:

per 100 leads
per 1000 dollars spent
per operator hour
per signal type

Because AI may win on speed and scale, while human may win on judgment in some signal classes. That is the actual insight you want.

11) Recommendation engine logic for Claude

Claude should not just “comment on campaign performance.”

It should produce a structured diagnosis.

Diagnostic output format

For every campaign, Claude should answer:

What happened?
Is this an infrastructure issue, data issue, offer issue, message issue, routing issue, or channel issue?
Which scorecard dimensions dragged performance down?
Which segment, signal, or step underperformed?
What is the highest-leverage fix for next week?
What should be stopped immediately?
What should be scaled?
Root-cause logic

Example:

high open, low reply = message / offer / CTA problem
low deliverability, high bounce = data / infra problem
strong reply, weak meetings = CTA / qualification problem
strong meetings, weak opps = sales handoff / offer / targeting problem
weak AI vs strong human on same audience = prompt / routing / proof packaging issue

This is where the SOP becomes a management system.

12) The scoreboard hierarchy I would implement

Use a weekly dashboard with five top-level indices:

Platform Reliability Index
Data Quality Index
Campaign Quality Index
Performance Index
Economic Efficiency Index

Then roll them into one master number:

SalesMfast Operating Score

But only for executive view.

For operators, keep the underlying scores visible. Composite scores hide truth if overused.

13) What I would add that you did not explicitly ask for

You asked for a good SOP. A good SOP still fails without these three controls.

Signal decay rules

Freshness must matter. UserGems explicitly recommends decay rules and warns against acting on old signals.

So define:

funding signal valid for X days
hiring signal valid for Y days
page visit valid for Z days
job-change signal valid for N days

If you do not do this, stale signals will poison relevance.

Signal suppression rules

If someone got touched recently, do not keep firing multiple signal-based messages. UserGems also recommends suppression windows and signal-fatigue prevention.

Buying-committee logic

Demandbase’s engagement approach emphasizes account-level and multi-person engagement, not just single-lead scoring.

That means your engine should reward:

multiple relevant stakeholders
cross-functional activity
repeated account-level engagement

One junior contact clicking once is not the same as three stakeholders showing activity.

14) The blunt conclusion

Your real SOP is not an outreach SOP.

It is a decision-quality SOP for turning noisy market signals into reliable revenue actions.

That means SalesMfast should be designed around six non-negotiables:

structured signal taxonomy
weighted multidimensional scoring
routing thresholds
mandatory stress testing
human-vs-AI comparison framework
weekly recommendation engine tied to root cause

If you get those right, you will have a real platform.

If you skip them and focus on sending faster, you will just industrialize bad decisions.

The next artifact you should build is a single operator-grade document with these sections:
Purpose, Definitions, System Architecture, Weekly Workflow, Scorecards, Benchmarks, Stress Tests, Experiment Design, Dashboard Specs, and Recommendation Logic.