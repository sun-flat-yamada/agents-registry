---
name: unit-test-tdd
description: V-model phase V5. Writes unit tests test-first (red, green, refactor) for functions and classes, covering the requirement's edge cases and error paths, then checks the tests for gaps with pr-test-analyzer. Use whenever a unit of code is added, changed or fixed.
---

# Unit Test - Test-Driven (V5)

Pin down the behavior of each unit with tests written before the code. Pairs with `implementation-loop` (V4).

## Cycle

1. **Red.** Write one test for the next behavior. Run it and confirm it fails *for the reason you expect* (not a typo or import error).
2. **Green.** Write the minimum code that passes it.
3. **Refactor.** Clean up code and test while the tests stay green.

Repeat per behavior. For a bug fix, the first test reproduces the bug.

## What to test

For each unit, derive cases from the requirements (`REQ-n`) and the interface contracts (`IF-n`):

- the normal path;
- boundaries: empty, zero, one, maximum, off-by-one;
- invalid input and each documented error;
- invariants that must always hold.

## How to write the tests

- Use the project's existing test framework, file layout and naming. Find an existing test next to similar code and follow it.
- Test observable behavior through the public interface, not private details, so refactoring does not break tests.
- One reason to fail per test; name the test after the behavior (`returns_empty_list_when_no_items`).
- Keep unit tests fast and isolated: no network, no real clock, no shared state between tests. Replace only true external dependencies with fakes.
- Treat coverage as a signal for missed paths, not as the goal.

## Gap check

When the unit's tests are done, run the `pr-test-analyzer` agent on the change. Add tests for every critical gap it reports (untested error path, missing boundary, behavior covered only indirectly). Skip suggestions that only add coverage without guarding a behavior.

## Rules

- Never change a test's expectation just to make it pass; decide first whether the test or the code is wrong.
- Never skip, disable or delete a failing test to get green.

## Hand-off

- `integration-test` (V6) takes over at the boundaries between units.
