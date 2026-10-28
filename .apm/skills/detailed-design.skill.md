---
name: detailed-design
description: V-model phase V3. Turns the chosen architecture into an implementation blueprint - files, interfaces, types, data flow, and build sequence - and defines the integration-test points for V6. Use after the architecture is decided and before writing code.
---

# Detailed Design (V3)

Make the design concrete enough that implementation is mechanical. The interfaces named here are what `integration-test` (V6) exercises.

## Inputs

- `docs/specs/<feature-slug>/02-architecture.md` and its ADR from `architecture-design` (V2).

## Process

1. **Produce the blueprint.** Launch the `code-architect` agent with the architecture document and the files identified in V2. Ask for: every file to create or modify, each component's responsibility and dependencies, data flow from entry point to storage and output, and a phased build sequence.
2. **Pin down interfaces.** For every boundary between components (function signatures, API endpoints, events, schemas), write the contract: inputs, outputs, errors, and invariants. Number them `IF-n`.
3. **Review the types.** For each new or changed type, run `type-design-analyzer` and apply its findings on encapsulation and invariant expression before code exists - it is cheaper to fix a type on paper.
4. **Plan error handling and state.** Say where each error is detected, how it propagates, and what the caller sees. No silent fallbacks.
5. **Define integration-test points.** For each `IF-n`, state what an integration test must prove (`IT-n`), including at least one failure path.
6. **Order the build.** Turn the blueprint into a checklist where each step leaves the code buildable and testable.

## Output

Write `docs/specs/<feature-slug>/03-detailed-design.md`:

```markdown
# <Feature> - Detailed Design

## Files
| Path | Create / Modify | Change |

## Interfaces
| ID | Boundary | Signature / Schema | Errors | Invariants |

## Data Flow
<entry point -> transformations -> storage / output>

## Integration-Test Points
| ID | Covers | What must be proven |
| :--- | :--- | :--- |
| IT-1 | IF-1 | ... |

## Build Sequence
- [ ] Step 1: ...
```

## Quality bar

- Every component in the architecture maps to files in the blueprint.
- Every `IF-n` has errors and invariants written, not only the happy path.
- Every `IF-n` is covered by at least one `IT-n`.

## Hand-off

- `implementation-loop` (V4) follows the build sequence.
- `integration-test` (V6) implements every `IT-n`.
