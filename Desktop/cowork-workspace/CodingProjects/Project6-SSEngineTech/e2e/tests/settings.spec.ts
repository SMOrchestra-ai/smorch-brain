import { test, expect } from "../fixtures/auth";

test.describe("Settings", () => {
  test("settings page loads", async ({ authenticatedPage }) => {
    await authenticatedPage.goto("/settings");
    await expect(authenticatedPage).toHaveURL(/\/settings/);
    await expect(
      authenticatedPage
        .locator('h1, h2, [data-testid="settings-title"]')
        .first(),
    ).toBeVisible();
  });

  test("workspace name field exists", async ({ authenticatedPage }) => {
    await authenticatedPage.goto("/settings");

    // Look for a workspace/organization name input
    const nameField = authenticatedPage.locator(
      'input[name="workspace_name"], input[name="name"], input[data-testid="workspace-name"], input[placeholder*="orkspace"], input[placeholder*="ame"]',
    );
    await expect(nameField.first()).toBeVisible({ timeout: 10_000 });
  });
});
