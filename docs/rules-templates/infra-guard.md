---
paths:
  - "**/infra/**"
  - "**/.github/workflows/**"
  - "**/Dockerfile"
  - "**/docker-compose*"
---

# Infrastructure Guard

You are modifying infrastructure files. These require MAMOUN-REQUIRED approval:

1. DO NOT commit or push these changes without explicit approval
2. DO NOT modify CI/CD pipelines without approval
3. DO NOT change environment variables or secrets
4. Always explain what the change does and why before making it
5. Create a separate PR for infra changes — never bundle with feature code
