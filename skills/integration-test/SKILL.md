---
name: integration-test
description: V-model phase V6. Writes and runs integration tests that prove the interfaces from the detailed design (IF-n / IT-n) work together - modules with each other and with real databases, queues or services - including failure paths. Use after the connected components are implemented.
---

# Integration Test (V6)

Prove that units which pass on their own also work together. Pairs with `detailed-design` (V3).

## Inputs

- The `Interfaces` and `Integration-Test Points` tables in `docs/specs/<feature-slug>/03-detailed-design.md`. Without a design document, list the boundaries the change crosses and confirm them first.

## Process

1. **Map each `IT-n` to a test.** One test file or group per interface; the test name cites the `IT-n` / `IF-n` it covers.
2. **Use real collaborators where it is cheap.** Run the real database, cache or queue in a disposable form (test containers, an in-memory engine with the same dialect, a local emulator). Fake only what is outside your control or costly: third-party APIs, payment, e-mail. When faking, assert the request your code sends, so a contract change is caught.
3. **Cover the contract, not just the happy path.** For every interface: a success case, each documented error, and at least one case where the other side misbehaves (timeout, malformed response, constraint violation).
4. **Control state.** Each test sets up and tears down its own data; tests must pass in any order and in parallel if the suite runs in parallel.
5. **Run them through the project's own test command** and put them where the project keeps integration tests (often a separate directory or tag so the fast unit suite stays fast).
6. **Report traceability.**

```text
IT-1 (IF-1 OrderService -> PaymentGateway): PASS
IT-2 (IF-2 OrderRepository -> PostgreSQL):  PASS
IT-3 (IF-2, constraint violation):          PASS
Not covered: none
```

## Rules

- A failing integration test is a design or implementation bug until proven otherwise. Fix the cause; do not loosen the assertion.
- Do not test third-party code itself; test your use of it.
- Never skip or quarantine a failing test to get green.

## Hand-off

- `system-test` (V7) runs on the assembled system against the `ST-n` viewpoints.
