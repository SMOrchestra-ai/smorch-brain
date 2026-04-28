import { test as base, expect, type Page } from "@playwright/test";

/**
 * Auth fixture for SSE V3 E2E tests.
 * Logs in via the /login page using Supabase Auth form.
 * Credentials come from environment variables:
 *   TEST_USER_EMAIL
 *   TEST_USER_PASSWORD
 */

const TEST_EMAIL = process.env.TEST_USER_EMAIL || "test@smorchestra.ai";
const TEST_PASSWORD = process.env.TEST_USER_PASSWORD || "";

async function login(page: Page) {
  await page.goto("/login");
  await page.waitForSelector('input[type="email"], input[name="email"]', {
    state: "visible",
  });

  await page.fill('input[type="email"], input[name="email"]', TEST_EMAIL);
  await page.fill(
    'input[type="password"], input[name="password"]',
    TEST_PASSWORD,
  );
  await page.click('button[type="submit"]');

  // Wait for redirect to dashboard (Supabase auth completes)
  await page.waitForURL("**/dashboard**", { timeout: 15_000 });
}

type AuthFixtures = {
  authenticatedPage: Page;
};

export const test = base.extend<AuthFixtures>({
  authenticatedPage: async ({ page }, use) => {
    await login(page);
    await use(page);
  },
});

export { expect };
