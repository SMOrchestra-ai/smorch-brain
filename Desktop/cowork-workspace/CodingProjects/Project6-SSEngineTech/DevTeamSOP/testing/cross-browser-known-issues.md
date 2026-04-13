# Cross-Browser Known Issues

**Last Updated:** 2026-04-14
**Browsers Tested:** Chromium, Firefox, WebKit (Safari), MS Edge

---

## Active Issues

_None identified at initial baseline. Issues will be logged here as cross-browser testing reveals them._

## Configuration

Playwright is configured with 4 browser projects in `e2e/playwright.config.ts`:
- `chromium` — primary, used for all E2E and visual regression tests
- `firefox` — full E2E suite
- `webkit` — full E2E suite (Safari equivalent)
- `msedge` — full E2E suite (Chromium-based)

## CSS Compatibility Notes

- RTL logical CSS (`ms-`, `me-`, `ps-`, `pe-`, `start-`, `end-`) requires Tailwind 3.3+ — verified compatible
- `backdrop-blur` may have performance issues on Firefox with many overlapping elements
- Safari WebKit requires `-webkit-` prefix for some animations — Tailwind handles this via autoprefixer
- All `@supports` queries preferred over user-agent sniffing for browser-specific fixes

## Testing Protocol

1. Run full E2E suite: `npx playwright test --project=chromium --project=firefox --project=webkit --project=msedge`
2. Visual regression baselines captured per-browser for Dashboard page
3. Failures logged here with: browser, page, description, screenshot diff, fix applied
