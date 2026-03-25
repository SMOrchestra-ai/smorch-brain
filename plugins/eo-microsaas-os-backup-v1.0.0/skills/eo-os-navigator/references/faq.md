# EO MicroSaaS OS - Frequently Asked Questions

## Getting Started

**Q: Do I need to complete the scorecards first?**
A: Recommended but not required. The scorecards at score.entrepreneursoasis.me give you the richest data for brain ingestion. If you don't have them, you can fill out 8 brain templates manually. The scorecard path produces better results because it forces you through structured thinking.

**Q: Can I skip straight to building my app?**
A: No. The development skills need your brain files (ICP, positioning, features, strategy) to generate code that actually fits your market. Without context, you get a generic SaaS that solves nothing specific. The gates exist to protect your time.

**Q: What if I only have some scorecards, not all 5?**
A: You need at minimum SC1 (Project Definition) and SC2 (ICP Clarity) to start brain ingestion. SC3-SC5 are strongly recommended. Missing scorecards mean missing brain files, which mean weaker outputs downstream.

## Environment Questions

**Q: What's the difference between Cowork and Claude Code?**
A: Cowork is for file-based work: reading scorecards, generating strategy documents, creating templates. Claude Code is a development environment with terminal access: it runs code, creates databases, builds apps, deploys to servers. Steps 1-3 work in Cowork. Steps 4-5 need Claude Code.

**Q: How do I move from Cowork to Claude Code?**
A: Copy your project-brain/ folder and any architecture/ files to your Claude Code project directory. Make sure the eo-microsaas-os plugin is installed in Claude Code too. Say "eo start" and the navigator will detect your progress and continue.

**Q: Can I do everything in Claude Code?**
A: Yes, all skills work in Claude Code. You can skip Cowork entirely and do the full journey in Claude Code. Cowork is just more comfortable for the strategy steps.

## Brain Files

**Q: What are the 12 brain files?**
A: companyprofile.md, founderprofile.md, brandvoice.md, niche.md, icp.md, positioning.md, competitor-analysis.md, market-analysis.md, strategy.md, gtm.md, project-instruction.md, cowork-instruction.md. Together they give Claude complete context about your business, market, and strategy.

**Q: Can I edit the brain files after they're generated?**
A: Yes, and you should. Brain ingestion creates a strong first draft from your scorecard data. Review each file and add details, correct assumptions, sharpen the positioning. These files are your operating context for the entire build.

**Q: What are the 8 brain templates?**
A: problem.md, icp.md, features.md, competitors.md, positioning.md, my-background.md, my-resources.md, my-goals.md. These are the manual entry path for founders who don't use the scorecards. They map to the same 12 brain files after normalization.

## Technical Questions

**Q: What tech stack will my MicroSaaS use?**
A: The eo-tech-architect skill recommends a stack based on your brain files (founder technical level, budget, market requirements). Typical MENA-optimized stacks include Next.js + Supabase + Vercel, but the recommendation adapts to your context.

**Q: Do I need to know how to code?**
A: No. The development skills generate code for you. But you need to understand what you're building (that's why the brain files matter) and be able to review outputs. Some terminal comfort helps for deployment.

**Q: What about Arabic/RTL support?**
A: Built into the system. The db-architect generates Arabic seed data, the microsaas-dev includes RTL layouts, the qa-testing validates Arabic rendering. Your brain files capture language requirements and the skills respect them.

## GTM & Launch

**Q: When should I start marketing?**
A: Step 2 (GTM Asset Factory) generates campaign assets BEFORE you build. This is intentional. You should start building audience and collecting signals while the product is being built. Don't wait for a finished product to start marketing.

**Q: Can I come back and regenerate GTM assets later?**
A: Yes. Update your brain files with new learnings, then rerun eo-gtm-asset-factory. The assets adapt to whatever's in your brain files.

## Troubleshooting

**Q: The navigator says my brain files are incomplete but I filled everything.**
A: Each file needs at least 200 characters of real content (not just headers). Check for files that have template headers but empty answers. Quality matters more than completeness.

**Q: QA/Security keeps failing. Can I skip to deploy?**
A: No. These gates protect you and your users. Fix the issues flagged in the reports. The reports include specific code fixes.
