---
name: make-e2e-live
description: Authors, scaffolds, and maintains Playwright E2E live test scenarios. Identifies test coverage gaps, generates deterministic assertions, and standardizes test steps.
---

# Make E2E Live Test Skill

This skill guides the authoring, scaffolding, and continuous evolution of live End-to-End browser test suites. While `e2e-live` executes tests, `make-e2e-live` expands and refines the test suite itself.

## Workflow Principles
- **Focused Scope**: Keep PRs tight (1-3 test scenarios or 1 test configuration refinement per change).
- **Flake Prevention**: Use nonce IDs, deterministic test steps (`test.step`), and avoid hardcoded wall-clock sleeps.
- **Traceability**: Link each test scenario to a feature requirement or past bug ID.

## Implementation Procedure

### 1. Identify Uncovered Scenarios
- Inspect existing test files under `e2e/` or `test/`.
- Review recent commit logs to identify newly introduced user flows, API changes, or edge cases.

### 2. Scaffold Scenario File
Author standard Playwright test following conventions:
```typescript
import { test, expect } from '@playwright/test';

test.describe('Feature Domain — Scenario Title', () => {
  test('verifies user flow and deterministic output', async ({ page }) => {
    await test.step('1. Navigate and initialize session', async () => {
      await page.goto('/');
      await expect(page.locator('[data-testid="app-ready"]')).toBeVisible();
    });

    await test.step('2. Submit prompt and trigger tool execution', async () => {
      await page.fill('[data-testid="chat-input"]', 'Create a quarterly report');
      await page.click('[data-testid="send-btn"]');
    });

    await test.step('3. Assert final rendered artifact', async () => {
      const artifactLink = page.locator('a[href*="artifacts/"]');
      await expect(artifactLink).toBeVisible({ timeout: 15000 });
    });
  });
});
```

### 3. Local Verification
Run the newly created spec in headed mode to verify selectors and stability before committing.
