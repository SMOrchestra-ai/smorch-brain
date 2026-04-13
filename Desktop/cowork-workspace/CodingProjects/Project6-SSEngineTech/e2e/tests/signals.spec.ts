import { test, expect } from "../fixtures/auth";

test.describe("Signals", () => {
  test("signals dashboard loads", async ({ authenticatedPage }) => {
    await authenticatedPage.goto("/signals");
    await expect(authenticatedPage).toHaveURL(/\/signals/);
    await expect(
      authenticatedPage
        .locator('h1, h2, [data-testid="signals-title"]')
        .first(),
    ).toBeVisible();
  });

  test("signal filters are visible", async ({ authenticatedPage }) => {
    await authenticatedPage.goto("/signals");

    // Filter controls for signal type, source, date range, etc.
    const filters = authenticatedPage.locator(
      'select, [data-testid="signal-filter"], input[placeholder*="earch"], input[placeholder*="ilter"], .filter-bar, [role="combobox"]',
    );
    await expect(filters.first()).toBeVisible({ timeout: 10_000 });
  });
});
