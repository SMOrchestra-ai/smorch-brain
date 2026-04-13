import http from "k6/http";
import { check, sleep, group } from "k6";
import { Rate, Trend } from "k6/metrics";

// Custom metrics
const errorRate = new Rate("errors");
const dashboardLatency = new Trend("dashboard_latency", true);
const leadsLatency = new Trend("leads_latency", true);
const signalsLatency = new Trend("signals_latency", true);

// Environment config
const BASE_URL = __ENV.BASE_URL || "https://sse.smorchestra.ai/api";
const AUTH_TOKEN = __ENV.AUTH_TOKEN || "";

const headers = {
  "Content-Type": "application/json",
  Authorization: `Bearer ${AUTH_TOKEN}`,
};

// ============================================
// SCENARIOS
// ============================================
export const options = {
  scenarios: {
    // Smoke test: 1 user, quick validation
    smoke: {
      executor: "constant-vus",
      vus: 1,
      duration: "30s",
      tags: { scenario: "smoke" },
      exec: "smokeTest",
    },
    // Load test: ramp to 50 concurrent users
    load: {
      executor: "ramping-vus",
      startVUs: 0,
      stages: [
        { duration: "1m", target: 10 },
        { duration: "3m", target: 50 },
        { duration: "2m", target: 50 },
        { duration: "1m", target: 0 },
      ],
      tags: { scenario: "load" },
      exec: "loadTest",
      startTime: "35s",
    },
    // Stress test: push to 100 concurrent users
    stress: {
      executor: "ramping-vus",
      startVUs: 0,
      stages: [
        { duration: "1m", target: 50 },
        { duration: "2m", target: 100 },
        { duration: "1m", target: 100 },
        { duration: "1m", target: 0 },
      ],
      tags: { scenario: "stress" },
      exec: "loadTest",
      startTime: "8m",
    },
    // Soak test: 10 users for 30 minutes
    soak: {
      executor: "constant-vus",
      vus: 10,
      duration: "30m",
      tags: { scenario: "soak" },
      exec: "loadTest",
      startTime: "14m",
    },
  },
  thresholds: {
    http_req_duration: ["p(95)<500", "p(99)<1000"],
    "http_req_duration{method:GET}": ["p(95)<500"],
    "http_req_duration{method:POST}": ["p(95)<1000"],
    errors: ["rate<0.01"],
    http_req_failed: ["rate<0.01"],
    dashboard_latency: ["p(95)<400"],
    leads_latency: ["p(95)<500"],
    signals_latency: ["p(95)<500"],
  },
};

// ============================================
// SMOKE TEST
// ============================================
export function smokeTest() {
  group("Health Check", () => {
    const res = http.get(`${BASE_URL}/health`);
    check(res, {
      "health status 200": (r) => r.status === 200,
      "health response has success": (r) => JSON.parse(r.body).success === true,
    }) || errorRate.add(1);
  });
  sleep(1);
}

// ============================================
// LOAD TEST (shared by load, stress, soak)
// ============================================
export function loadTest() {
  // Dashboard metrics
  group("Dashboard Load", () => {
    const res = http.get(`${BASE_URL}/analytics/dashboard`, { headers });
    dashboardLatency.add(res.timings.duration);
    check(res, {
      "dashboard status 200 or 401": (r) =>
        r.status === 200 || r.status === 401,
      "dashboard response time < 500ms": (r) => r.timings.duration < 500,
    }) || errorRate.add(1);
  });

  sleep(0.5);

  // Leads list (paginated)
  group("Leads List", () => {
    const res = http.get(`${BASE_URL}/leads?limit=50&offset=0`, { headers });
    leadsLatency.add(res.timings.duration);
    check(res, {
      "leads status 200 or 401": (r) => r.status === 200 || r.status === 401,
      "leads response time < 500ms": (r) => r.timings.duration < 500,
    }) || errorRate.add(1);
  });

  sleep(0.5);

  // Signals fetch
  group("Signals Fetch", () => {
    const res = http.get(`${BASE_URL}/signals?limit=50&offset=0`, { headers });
    signalsLatency.add(res.timings.duration);
    check(res, {
      "signals status 200 or 401": (r) => r.status === 200 || r.status === 401,
      "signals response time < 500ms": (r) => r.timings.duration < 500,
    }) || errorRate.add(1);
  });

  sleep(0.5);

  // Credits balance check
  group("Credits Balance", () => {
    const res = http.get(`${BASE_URL}/credits/balance`, { headers });
    check(res, {
      "credits status 200 or 401": (r) => r.status === 200 || r.status === 401,
    }) || errorRate.add(1);
  });

  sleep(0.5);

  // Campaign list
  group("Campaigns List", () => {
    const res = http.get(`${BASE_URL}/campaigns?limit=20&offset=0`, {
      headers,
    });
    check(res, {
      "campaigns status 200 or 401": (r) =>
        r.status === 200 || r.status === 401,
    }) || errorRate.add(1);
  });

  sleep(1);
}

// ============================================
// DEFAULT (runs if no scenario specified)
// ============================================
export default function () {
  smokeTest();
  loadTest();
}
