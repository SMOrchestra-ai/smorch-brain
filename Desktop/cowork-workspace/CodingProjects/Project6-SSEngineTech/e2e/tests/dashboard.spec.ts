import { test, expect } from "../fixtures/auth";

test.describe("Dashboard", () => {
  test("dashboard page loads after login", async ({ authenticatedPage }) => {
    await expect(authenticatedPage).toHaveURL(/\/dashboard/);
    // Page title or heading should indicate dashboard
    await expect(
      authenticatedPage
        .locator('h1, h2, [data-testid="dashboard-title"]')
        .first(),
    ).toBeVisible();
  });

  test("dashboard shows stat cards", async ({ authenticatedPage }) => {
    // Stat/metric cards should be present (signals, leads, campaigns, etc.)
    const statCards = authenticatedPage.locator(
      '[data-testid="stat-card"], .stat-card, .metric-card, .card',
    );
    // Expect at least one card-like element
    await expect(statCards.first()).toBeVisible({ timeout: 10_000 });
  });

  test("dashboard shows active runs section", async ({ authenticatedPage }) => {
    // Look for an active runs / recent activity / pipeline section
    const activitySection = authenticatedPage.locator(
      '[data-testid="active-runs"], [data-testid="recent-activity"], table, .activity-feed',
    );
    await expect(activitySection.first()).toBeVisible({ timeout: 10_000 });
  });
});
