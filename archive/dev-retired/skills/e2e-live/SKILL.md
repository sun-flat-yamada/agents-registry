---
name: e2e-live
description: Executes comprehensive end-to-end live testing against real web applications and AI agent UI surfaces using Playwright. Detects regression in chat, tools, wiki, and visual artifact rendering.
---

# End-to-End Live Testing Skill

This skill governs the execution and diagnosis of live, browser-driven regression test suites. Unlike mocked unit tests, live E2E tests interact with running frontend servers and AI agent interfaces to verify end-user workflows.

## Prerequisites
- Development server running (e.g. `http://localhost:5173` or specified port).
- Playwright dependencies and browsers installed (`npx playwright install`).
- Valid API credentials configured if tests invoke live models.

## Execution Workflow

### 1. Headless Execution
Run standard live test suite:
```bash
npm run test:e2e:live
# or
npx playwright test --config=playwright.live.config.ts
```

### 2. Interactive Headed Debugging
When visual inspection is required to observe UI transitions, popups, or timing issues:
```bash
HEADED=1 npx playwright test --headed
```

### 3. Result & Trace Inspection
- **HTML Report**: Inspect generated test reports (typically `playwright-report/index.html`).
- **Trace Replay**: For failed assertions, examine the execution trace:
  ```bash
  npx playwright show-trace test-results/<spec>/trace.zip
  ```

### 4. Consolidated Reporting
- Report total passed, failed, and skipped counts.
- For failures, extract the failing selector, expected vs. actual DOM state, and screenshot links.
