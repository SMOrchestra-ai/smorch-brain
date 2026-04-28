import { defineConfig, devices } from "@playwright/test";

/**
 * Playwright config for SSE V3 E2E tests
 * - Chromium only (headless)
 * - Base URL from env or localhost:6002
 * - 30s timeout per test
 * - Retries on CI
 * - Screenshot on failure
 */
export default defineConfig({
  testDir: "./tests",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ["html", { outputFolder: "test-results/html-report", open: "never" }],
    ["list"],
  ],
  outputDir: "test-results/",

  use: {
    baseURL: process.env.BASE_URL || "http://localhost:6002",
    trace: "on-first-retry",
    screenshot: "only-on-failure",
    video: "retain-on-failure",
  },

  timeout: 30_000,

  /* Snapshot path for visual regression baselines */
  snapshotPathTemplate:
    "{testDir}/__screenshots__/{projectName}/{testFilePath}/{arg}{ext}",

  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
    {
      name: "firefox",
      use: { ...devices["Desktop Firefox"] },
    },
    {
      name: "webkit",
      use: { ...devices["Desktop Safari"] },
    },
    {
      name: "msedge",
      use: { ...devices["Desktop Edge"], channel: "msedge" },
    },
  ],
});
