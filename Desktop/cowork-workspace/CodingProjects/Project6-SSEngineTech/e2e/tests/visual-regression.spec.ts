import { test, expect } from "../fixtures/auth";

const VIEWPORTS = [
  { name: "mobile", width: 375, height: 812 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const;

const PAGES = [
  { name: "dashboard", path: "/dashboard" },
  { name: "leads", path: "/leads" },
  { name: "signals", path: "/signals" },
  { name: "campaigns", path: "/campaigns" },
  { name: "analytics", path: "/analytics" },
  { name: "reports", path: "/reports" },
  { name: "settings", path: "/settings" },
  { name: "credits", path: "/credits" },
  { name: "scrapers", path: "/scrapers" },
  { name: "triggers", path: "/triggers" },
] as const;

const RTL_PAGES = ["dashboard", "leads", "signals", "settings"] as const;

for (const viewport of VIEWPORTS) {
  test.describe(`Visual Regression — ${viewport.name} (${viewport.width}px)`, () => {
    test.beforeEach(async ({ page }) => {
      await page.setViewportSize({
        width: viewport.width,
        height: viewport.height,
      });
    });

    for (const pg of PAGES) {
      test(`${pg.name} page matches baseline`, async ({
        authenticatedPage,
      }) => {
        await authenticatedPage.goto(pg.path, { waitUntil: "networkidle" });
        await authenticatedPage.waitForTimeout(500);
        await expect(authenticatedPage).toHaveScreenshot(
          `${pg.name}-${viewport.name}-ltr.png`,
          { maxDiffPixelRatio: 0.001, fullPage: true },
        );
      });
    }
  });
}

// RTL visual regression for key pages
test.describe("Visual Regression — RTL mode (desktop)", () => {
  test.beforeEach(async ({ page }) => {
    await page.setViewportSize({ width: 1440, height: 900 });
  });

  for (const pageName of RTL_PAGES) {
    const pg = PAGES.find((p) => p.name === pageName)!;
    test(`${pg.name} RTL matches baseline`, async ({ authenticatedPage }) => {
      await authenticatedPage.goto(pg.path, { waitUntil: "networkidle" });
      // Toggle RTL via localStorage and reload
      await authenticatedPage.evaluate(() => {
        localStorage.setItem("app-direction", "rtl");
        document.documentElement.setAttribute("dir", "rtl");
        document.documentElement.setAttribute("lang", "ar");
      });
      await authenticatedPage.reload({ waitUntil: "networkidle" });
      await authenticatedPage.waitForTimeout(500);
      await expect(authenticatedPage).toHaveScreenshot(
        `${pg.name}-desktop-rtl.png`,
        { maxDiffPixelRatio: 0.001, fullPage: true },
      );
    });
  }
});
