---
name: acceptance-test
description: V-model phase V8. Verifies the finished system against every acceptance criterion (AC-n) from the requirements, with concrete evidence for each, and returns a pass/fail verdict that names which phase to revisit for each failure. Use before declaring a feature done or a release ready.
---

# Acceptance Test (V8)

Check the finished work against what was agreed in `requirements-definition` (V1) - not against what was built.

## Inputs

- The `Acceptance Criteria` table in `docs/specs/<feature-slug>/01-requirements.md`. If there is none, stop and ask the user for the acceptance criteria rather than inventing them from the code.

## Process

1. **Prepare the system as a user would get it**: build and start it the documented way (README, scripts), not through test-only shortcuts.
2. **Check each `AC-n` in order.** Set up the Given, perform the When, observe the Then. Use the most direct evidence available:
   - CLI or API: the command and its output or response;
   - web UI: the `webapp-testing` skill, with a screenshot or the asserted DOM state;
   - data: the query and its result.
3. **Record the verdict per criterion** - PASS only when the observed result matches the Then clause exactly. Partial is FAIL.
4. **Check the non-functional requirements** that have measurable bounds the same way.
5. **Trace each failure back** to the phase that has to change: a wrong requirement (V1), a design that cannot meet it (V2/V3), or an implementation bug (V4).
6. **Report** and let the user make the acceptance decision.

## Output

Write `docs/specs/<feature-slug>/08-acceptance.md`:

```markdown
# <Feature> - Acceptance Test Report

Version / commit: <sha>   Date: <YYYY-MM-DD>

| AC | Covers | Result | Evidence | If failed: revisit |
| :--- | :--- | :--- | :--- | :--- |
| AC-1 | REQ-1 | PASS | `curl ...` -> 201, body ... | - |
| AC-2 | REQ-2 | FAIL | screenshot ac-2.png: error banner missing | V4 implementation |

## Non-functional Requirements
| Requirement | Bound | Measured | Result |

## Verdict
<N of M criteria passed. Ready / Not ready for acceptance, and what blocks it.>
```

## Rules

- Never mark a criterion PASS without evidence someone else can re-check.
- Do not change the acceptance criteria during the test; if one is wrong, report it as a V1 issue.
- The final accept / reject decision belongs to the user.
