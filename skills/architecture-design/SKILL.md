---
name: architecture-design
description: V-model phase V2. Explores the existing codebase, compares two or three architecture approaches with trade-offs, records the chosen one as an ADR, and defines the system-test viewpoints for V7. Use after requirements are agreed and before detailed design.
---

# Architecture Design (V2)

Decide how the feature fits into the system, and leave the decision written down. The system-test viewpoints defined here are what `system-test` (V7) checks later.

## Inputs

- `docs/specs/<feature-slug>/01-requirements.md` from `requirements-definition` (V1). If it does not exist, ask whether to run V1 first.

## Process

1. **Explore the codebase in parallel.** Launch two or three `code-explorer` agents, each on a different aspect (similar existing features, the architecture and abstractions of the affected area, extension points and conventions). Ask each to return the 5-10 most important files. Read those files yourself before going on.
2. **Summarize what exists.** Components, boundaries, data stores, external dependencies and the conventions the new work must follow.
3. **Design alternatives.** Produce two or three approaches with different focuses, for example:
   - minimal change: smallest diff, maximum reuse;
   - clean architecture: best long-term structure;
   - pragmatic balance.
   For each, state the components touched, new dependencies, risks, and how well it meets each non-functional requirement.
4. **Recommend and let the user choose.** Give a comparison table and your recommendation with reasons. Wait for the user's choice.
5. **Record the decision as an ADR** in `docs/adr/NNNN-<title>.md` (or the project's ADR location): context, decision, alternatives considered, consequences.
6. **Define system-test viewpoints.** For each requirement area, list what an end-to-end test must show on the running system (`ST-n`).

## Output

Write `docs/specs/<feature-slug>/02-architecture.md`:

```markdown
# <Feature> - Architecture

## Context
<existing components and boundaries this feature touches>

## Decision
<chosen approach, link to ADR>

## Components
| Component | Responsibility | New / Changed | Depends on |

## System-Test Viewpoints
| ID | Covers | What the running system must show |
| :--- | :--- | :--- |
| ST-1 | REQ-1, REQ-2 | ... |
```

## Quality bar

- The decision cites the requirements and non-functional requirements it satisfies.
- Rejected alternatives are recorded with the reason, so the next person does not re-litigate them.
- Every Must requirement is covered by at least one `ST-n`.

## Hand-off

- `detailed-design` (V3) refines each component into interfaces.
- `system-test` (V7) checks every `ST-n`.
