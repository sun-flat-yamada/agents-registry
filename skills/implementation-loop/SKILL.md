---
name: implementation-loop
description: V-model phase V4. Implements the detailed design step by step, writing the unit test first and running the project's own build, type check, lint and tests after every step, then simplifies the changed code. Use when writing or changing production code.
---

# Implementation Loop (V4)

Write code in small steps that are verified as they go. Each step pairs with `unit-test-tdd` (V5).

## Inputs

- The build sequence in `docs/specs/<feature-slug>/03-detailed-design.md` from `detailed-design` (V3). For a small change without a design document, write a three-to-five step plan first and confirm it.

## Discover the project's checks first

Before the first change, find the commands the project already uses - in `package.json`, `Makefile`, `pyproject.toml`, `CONTRIBUTING.md`, `CLAUDE.md`, `AGENTS.md` or CI workflows - for build, type check, lint, format and tests. Use those commands, not generic ones.

## The loop (per build-sequence step)

1. **Test first.** Write or extend the unit test for this step with `unit-test-tdd` and watch it fail for the expected reason.
2. **Implement the smallest change** that makes it pass, following the conventions found in V2 and the interfaces in V3.
3. **Verify.** Run, in order: build, type check, lint, and the affected tests. If any fails, fix it before moving on - never stack a new step on a red one.
4. **Check the diff.** Re-read `git diff` for unintended changes, leftover debug output, hard-coded secrets and missing error handling.
5. **Tick the step** in the build sequence and move on.

## Finish

1. Run the full test suite and the full verification once more.
2. Run the `code-simplifier` agent on the changed code. Accept only changes that keep behavior identical, then re-run verification.
3. Report a short verification summary:

```text
Build: PASS   Types: PASS   Lint: PASS   Tests: 42/42 PASS
Steps done: 5/5   Deviations from design: <none, or what and why>
```

## Rules

- Follow the design. If the design turns out to be wrong, stop, explain the problem, and update `03-detailed-design.md` with the user's agreement instead of drifting silently.
- Do not weaken, skip or delete a test to get green.
- Keep each step's diff reviewable on its own.

## Hand-off

- `integration-test` (V6) runs once the components it connects exist.
- Code review (X1, `/code-review`) runs on the pull request.
