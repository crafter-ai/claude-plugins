---
paths:
  - "test/system/**/*.rb"
  - "test/integration/**/*.rb"
  - "spec/system/**/*.rb"
  - "spec/features/**/*.rb"
  - "spec/requests/**/*.rb"
  - "spec/integration/**/*.rb"
---

# E2E test scope

- E2E tests should focus exclusively on happy paths
- Each feature should have only one happy path test covering the main user journey
- Only add failure path tests if the failure has critical business or safety consequences (e.g., payment processing, data loss, access control)
- Edge cases and validation errors belong in unit or model tests, not E2E tests
