# MENA Master Coverage Gaps Registry

Cross-tool registry of MENA-specific limitations discovered during operator skill creation. Updated every time a new tool is evaluated.

## Universal MENA Gaps (Apply to Most Western SaaS Tools)

| Gap Category | Detail | Standard Workaround |
|-------------|--------|-------------------|
| Arabic RTL text | Most tools render Arabic but don't support RTL layout | Use WhatsApp (native RTL) for Arabic messaging; email for English |
| Name parsing | "Al-", "bin-", "Abu-" patterns break standard first/last split | AI Formula or Code node to handle Arabic name patterns |
| Email coverage | 20-40% hit rate vs 85%+ for US | Hybrid: Clay waterfall + Claygent research + LinkedIn/WhatsApp as primary |
| Phone format | +971/+966/+974/+965 not always recognized | Force E.164 format, validate prefix before operations |
| Business hours | Sun-Thu (UAE/KSA), Fri-Sat off | Configure all scheduling tools for Gulf calendar |
| Ramadan | ~30 days, timing shifts to post-Iftar | Reduce volume 50%+, shift timing, soften messaging tone |
| ISP reputation | MENA ISPs slower to warm, faster to block | Warm up slower, lower daily send limits for .ae/.sa domains |
| Payment processing | Many tools don't accept Gulf payment methods | Use international card or PayPal; some require US billing address |
| Data localization | Saudi PDPL requires data residency considerations | Verify tool's data center locations; document compliance posture |
| Support timezone | Most tools have US/EU support hours | Document self-service resolution paths for common issues |

## Tool-Specific MENA Findings

(Updated as each operator skill is built)

### Template for New Entries

```
### [Tool Name] - [Date Evaluated]
| MENA Gap | Severity (Critical/High/Medium/Low) | Workaround | Verified? |
|----------|------|------------|-----------|
| [Gap 1] | [Severity] | [Workaround] | Yes/No |
```
