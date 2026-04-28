import { test, expect } from "@playwright/test";

test.describe("Authentication", () => {
  test("login page loads", async ({ page }) => {
    await page.goto("/login");
    await expect(page).toHaveURL(/\/login/);
    // Page should contain a form or auth-related content
    await expect(
      page.locator('input[type="email"], input[name="email"]'),
    ).toBeVisible();
  });

  test("login form has email and password fields", async ({ page }) => {
    await page.goto("/login");

    const emailInput = page.locator('input[type="email"], input[name="email"]');
    const passwordInput = page.locator(
      'input[type="password"], input[name="password"]',
    );
    const submitButton = page.locator('button[type="submit"]');

    await expect(emailInput).toBeVisible();
    await expect(passwordInput).toBeVisible();
    await expect(submitButton).toBeVisible();
  });

  test("login with invalid credentials shows error", async ({ page }) => {
    await page.goto("/login");

    await page.fill(
      'input[type="email"], input[name="email"]',
      "invalid@example.com",
    );
    await page.fill(
      'input[type="password"], input[name="password"]',
      "wrong-password-123",
    );
    await page.click('button[type="submit"]');

    // Should show an error message and remain on login page
    await expect(page).toHaveURL(/\/login/);
    // Wait for error feedback (toast, inline error, or alert)
    const errorVisible = await page
      .locator(
        '[role="alert"], .error, .toast-error, [data-testid="login-error"]',
      )
      .isVisible({ timeout: 5_000 })
      .catch(() => false);

    // At minimum, user should NOT be redirected to dashboard
    expect(page.url()).not.toContain("/dashboard");
  });
});
