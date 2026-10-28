---
name: requirements-definition
description: V-model phase V1. Turns a vague feature request into numbered, testable requirements with Given/When/Then acceptance criteria that the acceptance-test skill (V8) verifies later. Use before designing or coding a new feature or a non-trivial change.
---

# Requirements Definition (V1)

Turn a request into requirements that can be verified. The output of this skill is the input of `acceptance-test` (V8), so every requirement must be checkable by someone who did not write it.

## Output

Write `docs/specs/<feature-slug>/01-requirements.md` (follow the project's own spec location if it already has one):

```markdown
# <Feature> - Requirements

## Goal
<one or two sentences: the problem being solved and for whom>

## Scope
- In: ...
- Out: ...

## Requirements
| ID | Requirement | Priority |
| :--- | :--- | :--- |
| REQ-1 | <observable behavior, not implementation> | Must / Should / Could |

## Acceptance Criteria
| ID | Covers | Given | When | Then |
| :--- | :--- | :--- | :--- | :--- |
| AC-1 | REQ-1 | <state> | <action> | <observable result> |

## Non-functional Requirements
<performance, security, compatibility, accessibility - only those that matter here, each with a measurable bound>

## Assumptions and Open Questions
- [ ] ...
```

## Process

1. **Restate the request.** Summarize what is being asked in the user's terms: the problem, who has it, and what "done" looks like.
2. **Read before asking.** Look at the existing code, docs and issues that the request touches, so questions are concrete and nothing the repository already answers is asked again.
3. **Find the gaps.** List underspecified points: edge cases, error handling, empty and boundary inputs, permissions, backward compatibility, scope boundaries, performance needs.
4. **Ask once, as one organized list.** Present all questions together and wait for answers before writing the final document. If the user says "whatever you think is best", state your recommendation and get an explicit yes.
5. **Write requirements as observable behavior.** Each `REQ-n` says what the system does, not how. Split any requirement that contains "and" into two.
6. **Give every Must requirement at least one acceptance criterion.** Each `AC-n` names the requirement it covers and has a Then clause that can be observed from outside (output, UI state, stored data, exit code).
7. **Confirm.** Show the document and get the user's approval. Record remaining assumptions instead of guessing silently.

## Quality bar

- No requirement without an ID; no acceptance criterion without a `Covers` link.
- No words that cannot be tested ("fast", "user-friendly", "robust") without a measurable bound.
- Out-of-scope items are written down, so later phases do not expand the scope silently.

## Hand-off

- `architecture-design` (V2) reads the requirements and non-functional requirements.
- `acceptance-test` (V8) verifies every `AC-n` against the finished system.
