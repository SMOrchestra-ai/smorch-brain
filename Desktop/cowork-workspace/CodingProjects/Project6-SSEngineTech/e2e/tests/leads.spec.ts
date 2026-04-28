import { test, expect } from "../fixtures/auth";

test.describe("Leads", () => {
  test("leads page loads", async ({ authenticatedPage }) => {
    await authenticatedPage.goto("/leads");
    await expect(authenticatedPage).toHaveURL(/\/leads/);
    await expect(
      authenticatedPage.locator('h1, h2, [data-testid="leads-title"]').first(),
    ).toBeVisible();
  });

  test("leads table renders", async ({ authenticatedPage }) => {
    await authenticatedPage.goto("/leads");

    // Table or list of leads should be present
    const table = authenticatedPage.locator(
      'table, [data-testid="leads-table"], [role="grid"]',
    );
    await expect(table.first()).toBeVisible({ timeout: 10_000 });
  });

  test("filter bar is visible", async ({ authenticatedPage }) => {
    await authenticatedPage.goto("/leads");

    // Filter controls: search input, dropdowns, or filter buttons
    const filterBar = authenticatedPage.locator(
      'input[placeholder*="earch"], input[placeholder*="ilter"], [data-testid="filter-bar"], [data-testid="search-input"], .filter-bar',
    );
    await expect(filterBar.first()).toBeVisible({ timeout: 10_000 });
  });
});
