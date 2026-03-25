---
paths:
  - "**/auth/**"
  - "**/security/**"
  - "**/middleware/auth*"
  - "**/.env*"
---

# Auth & Security Guard

You are modifying authentication or security-related files. STOP and verify:

1. Never hardcode credentials, tokens, or API keys
2. Never weaken auth checks (removing middleware, disabling validation)
3. Never log sensitive data (passwords, tokens, PII)
4. Always check for injection and XSS in any user-facing code
5. These changes require Mamoun's review regardless of diff size
