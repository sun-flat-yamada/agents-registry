---
name: system-test
description: V-model phase V7. Runs end-to-end tests on the assembled, running system against the system-test viewpoints (ST-n) from the architecture - through the UI with the webapp-testing skill, or through the CLI or API - and reports results with evidence. Use after integration tests pass and before acceptance testing.
---

# System Test (V7)

Test the whole system the way it actually runs. Pairs with `architecture-design` (V2).

## Inputs

- The `System-Test Viewpoints` table in `docs/specs/<feature-slug>/02-architecture.md`. Without it, derive viewpoints from the requirements and confirm them first.

## Process

1. **Start the real system.** Build and launch it with the project's documented commands, with its real configuration and data stores (a disposable copy is fine). No test-only code paths.
2. **Pick the driver per surface:**
   - Web UI: use the `webapp-testing` skill (Playwright). Use its `scripts/with_server.py` to start servers, wait for `networkidle`, find selectors from the rendered DOM, and save screenshots as evidence.
   - HTTP API: call the running endpoints and assert status, body and side effects.
   - CLI: run the built binary or entry point and assert output and exit code.
3. **Write one test per `ST-n`** that walks a complete user journey from entry to observable result. Name it after the viewpoint it covers.
4. **Include the unhappy journeys**: invalid input from the user, a dependency that is down, permissions that are missing.
5. **Check the non-functional viewpoints** that apply at system level (response time under expected load, behavior after restart).
6. **Keep tests deterministic**: wait for conditions instead of sleeping, control test data, and make every test independent.
7. **Report.**

```text
ST-1 (REQ-1, REQ-2) checkout journey:      PASS  evidence: st-1.png
ST-2 (REQ-3) payment provider unavailable: FAIL  expected retry banner, got blank page
```

## Rules

- A flaky test is a defect: find the race or the shared state and fix it. Never skip, quarantine or retry-until-green.
- If an existing E2E suite exists, extend it with its framework and conventions instead of starting a second one.

## Hand-off

- `acceptance-test` (V8) verifies the acceptance criteria on the same running system.
