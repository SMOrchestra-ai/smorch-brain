# QA Onboarding Guide — SMOrchestra Projects

**Last Updated:** 2026-04-17
**For:** Lana Al-Kurd (@lanaalkurdsmo) and future QA team members
**Owner:** Mamoun Alamouri

---

## Before You Start Any QA

### 1. Confirm What You're Testing

Ask the developer (or check Linear ticket):
- Which project?
- Which URL? (staging or production)
- What changed? (link to PR or commit)
- What specifically to test?

### 2. Verify You're Testing the Right Version

SSH to the server and check the commit:
```bash
# For projects on contabo-main:
ssh contabo-main "cd /opt/apps/{project}/ && git log --oneline -1"

# For projects on smo-dev:
ssh smo-dev "cd /opt/apps/{project}/ && git log --oneline -1"
```

Or hit the health endpoint:
```
https://{project-url}/api/health
```
Response includes `commit` field — match it against the PR.

### 3. Check Project-Specific Test Scenarios

Each project has test scenarios at: `{repo}/docs/qa/test-scenarios.md`

---

## Project Directory

| Project | URL | Server | Health Check | Test Scenarios |
|---------|-----|--------|-------------|----------------|
| EO MENA | entrepreneursoasis.me | contabo-main | /api/health | docs/qa/test-scenarios.md |
| EO Scorecard | score.entrepreneursoasis.me | contabo-main | /api/health | docs/qa/test-scenarios.md |
| Content Auto | TBD | smo-dev | port 3301 /health | docs/qa/test-scenarios.md |
| SSE v3 | TBD | smo-dev | /api/health | docs/qa/test-scenarios.md |
| Digital Revenue | TBD | TBD | /api/health | docs/qa/test-scenarios.md |
| GTM Scorecard | TBD | TBD | /api/health | docs/qa/test-scenarios.md |

---

## QA Workflow

```
Developer finishes work
        │
        ▼
PR created on GitHub ──── Developer posts in Linear/Telegram:
        │                  "Ready for QA: {URL}, PR #{number}"
        ▼
Developer deploys to server (dev branch)
        │
        ▼
QA receives notification ── Check Linear or Telegram
        │
        ▼
QA verifies commit hash ── /api/health or SSH git log
        │
        ▼
QA runs test scenarios ── Project-specific test-scenarios.md
        │
        ▼
    ┌───┴───┐
    │       │
  PASS    FAIL
    │       │
    ▼       ▼
Comment   Comment on Linear with:
on PR:    - Steps to reproduce
"QA ✅"   - Expected vs actual
    │     - Screenshot/recording
    ▼     - Severity (P0/P1/P2)
Merge       │
to main     ▼
            Developer fixes → re-deploys → QA re-tests
```

---

## How to Report Bugs

Use this format in Linear (or Telegram if urgent):

```
**Bug:** [short description]
**Project:** [project name]
**URL:** [exact URL where bug appears]
**Commit:** [from /api/health]
**Severity:** P0/P1/P2

**Steps to reproduce:**
1. Go to ...
2. Click ...
3. Enter ...

**Expected:** [what should happen]
**Actual:** [what actually happens]

**Screenshot/Video:** [attach]
**Device:** [desktop/mobile, browser, viewport]
```

---

## Escalation Matrix

| Severity | Definition | Action | Response Time |
|----------|-----------|--------|---------------|
| **P0 — Critical** | App down, data loss, security breach, payment failure | Telegram Mamoun immediately + Linear ticket | < 30 min |
| **P1 — High** | Core feature broken, blocking user flow, wrong data displayed | Linear ticket + Telegram notification | < 2 hours |
| **P2 — Medium** | UI glitch, non-blocking bug, cosmetic issue, edge case | Linear ticket only | < 24 hours |
| **P3 — Low** | Enhancement suggestion, nice-to-have, minor text fix | Linear ticket with "enhancement" label | Next sprint |

---

## Arabic/RTL Testing Checklist

For every page in every project:
- [ ] Toggle language to Arabic — all text renders correctly
- [ ] Layout is RTL — navigation, cards, forms all flip
- [ ] Arabic fonts load — Cairo (headers), Tajawal (body)
- [ ] Numbers display correctly (not mirrored)
- [ ] Forms accept Arabic input
- [ ] Error messages show in Arabic
- [ ] WhatsApp messages render in Arabic

---

## Mobile Testing

Test on these viewports:
- iPhone 14 Pro (390 × 844)
- Samsung Galaxy S24 (360 × 780)
- iPad (768 × 1024)

Check:
- [ ] No horizontal scroll
- [ ] Buttons are tappable (min 44px)
- [ ] Forms are usable on mobile
- [ ] Navigation menu works (hamburger/drawer)
- [ ] Images don't overflow

---

## Tools You Need

| Tool | Purpose | Access |
|------|---------|--------|
| GitHub | PR reviews, code access | @lanaalkurdsmo added to SMOrchestra-ai |
| Linear | Task tracking, bug reports | SMOrchestra workspace |
| Telegram | Urgent communication | SMOrchestra group |
| SSH | Server verification | Keys configured for contabo-main, smo-dev |
| Browser DevTools | Responsive testing, console errors | Chrome/Firefox |
