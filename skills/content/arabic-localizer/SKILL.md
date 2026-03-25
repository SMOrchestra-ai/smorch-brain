---
name: arabic-localizer
description: Arabic Localization — RTL validation, bilingual content, Gulf Arabic tone, and MENA market adaptation for all SMOrchestra products
category: content
triggers:
  - arabic
  - RTL
  - localization
  - i18n
  - bilingual
  - translation
  - Gulf Arabic
  - MENA
---

# Arabic Localizer Skill

You handle Arabic localization for all SMOrchestra products. Core market: UAE, Saudi Arabia, Qatar, Kuwait.

## Language Rules

### Tone
- **Gulf Arabic (conversational)** for SME-facing content (SalesMfast)
- **MSA (Modern Standard Arabic)** for formal documents and enterprise proposals
- **Mixed Arabic + English tech terms** — never force-translate technical terms
  - ✅ "استخدم الـ API" (use the API)
  - ❌ "استخدم واجهة برمجة التطبيقات" (nobody says this)

### Words to NEVER translate:
- CRM, API, SaaS, AI, ML, WhatsApp, LinkedIn, SEO, ROI, KPI
- Dashboard, Pipeline, Funnel, Lead, Campaign
- Any product name: SalesMfast, CXMfast, ScrapMfast

### Words to ALWAYS translate:
- Navigation labels (الرئيسية، الإعدادات، لوحة التحكم)
- Form labels and buttons (إرسال، حفظ، إلغاء، التالي، السابق)
- Error messages and notifications
- Status indicators (نشط، معلق، مكتمل)

## RTL Technical Checklist

### CSS
```css
/* Always use logical properties */
✅ margin-inline-start: 1rem;
❌ margin-left: 1rem;

✅ padding-inline-end: 0.5rem;
❌ padding-right: 0.5rem;

✅ text-align: start;
❌ text-align: left;

/* Direction attribute */
html[dir="rtl"] { direction: rtl; }

/* Flex direction flips automatically with dir="rtl" */
/* But icon order may need manual adjustment */
```

### HTML
```html
<!-- Root level -->
<html dir="rtl" lang="ar">

<!-- Mixed content sections -->
<p dir="rtl">هذا نص عربي مع <span dir="ltr">English text</span> في الوسط</p>

<!-- Numbers always LTR -->
<span dir="ltr">+971 50 123 4567</span>
<span dir="ltr">AED 1,500.00</span>
```

### Common RTL Bugs
| Bug | Cause | Fix |
|-----|-------|-----|
| Icons facing wrong direction | Hardcoded transform | Use `scaleX(-1)` in RTL or use bidirectional icons |
| Numbers reversed | Inheriting RTL direction | Wrap numbers in `dir="ltr"` span |
| Form inputs misaligned | Using left/right instead of start/end | Use logical CSS properties |
| Scrollbar on wrong side | Browser default | `direction: rtl` on container |
| Breadcrumbs wrong order | Hardcoded separator `>` | Use CSS `::before` with `content: "‹"` |

## i18n Architecture

### Recommended structure:
```
/i18n/
  en.json          # English (default)
  ar.json          # Arabic
  shared.json      # Untranslated terms (product names, tech terms)
```

### JSON format:
```json
{
  "nav": {
    "home": "الرئيسية",
    "settings": "الإعدادات",
    "dashboard": "لوحة التحكم"
  },
  "actions": {
    "save": "حفظ",
    "cancel": "إلغاء",
    "submit": "إرسال",
    "next": "التالي",
    "previous": "السابق",
    "delete": "حذف",
    "edit": "تعديل",
    "search": "بحث"
  },
  "status": {
    "active": "نشط",
    "inactive": "غير نشط",
    "pending": "قيد الانتظار",
    "completed": "مكتمل"
  }
}
```

### URL parameter support:
```
https://app.com/dashboard           → English (default)
https://app.com/dashboard?lang=ar   → Arabic
```

## Font Stack

### Arabic-optimized:
```css
font-family: 'Cairo', 'Tajawal', 'IBM Plex Sans Arabic', system-ui, sans-serif;
```

- **Cairo** — Primary. Clean, modern, excellent screen readability
- **Tajawal** — Secondary. Slightly more traditional, good for body text
- **IBM Plex Sans Arabic** — Monospace alternative for code-adjacent content

### Font loading:
```html
<link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&family=Tajawal:wght@400;500;700&display=swap" rel="stylesheet">
```

## MENA Market Adaptation

### Currency formatting:
- UAE: `AED 1,500.00` or `١,٥٠٠.٠٠ د.إ`
- Saudi: `SAR 1,500.00` or `١,٥٠٠.٠٠ ر.س`
- Use `Intl.NumberFormat('ar-AE', { style: 'currency', currency: 'AED' })`

### Date formatting:
- Use `Intl.DateTimeFormat('ar-AE')` for Arabic dates
- Hijri calendar support when relevant
- Week starts on Sunday in Gulf countries

### Phone numbers:
- UAE: `+971 XX XXX XXXX`
- Saudi: `+966 XX XXX XXXX`
- Always display LTR regardless of page direction
