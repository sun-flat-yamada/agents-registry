---
name: archive-shipped-plans
description: Archives merged and completed implementation plans from `plans/` into `plans/done/`, updates stale file references across codebase/docs, and creates a consolidated cleanup PR.
---

# Archive Shipped Plans Skill

This skill automates the hygiene of repository planning artifacts. As features ship and pull requests merge, completed design plans in `plans/*.md` are migrated into `plans/done/`, and all internal documentation cross-references are updated.

## Operating Principles
- **Verifiable Merged Status**: Never guess whether a plan is merged. Verify against GitHub (`gh pr view <num> --json mergedAt`) or git commit logs.
- **Multi-Phase Plan Verification**: A merged PR does not always mean every phase of a plan is complete. Check acceptance criteria checklists (`- [x]`) before archiving.
- **Reference Integrity**: When moving `plans/<name>.md` to `plans/done/<name>.md`, find and replace all stale path references across the repository.

## Execution Steps

### 1. Triage Plans
- Enumerate files matching `plans/*.md` (excluding `plans/done/` and decision records).
- Extract associated PR or Issue IDs from the filename or header.
- Query GitHub CLI or git history to determine merge status and completion date.

### 2. Multi-Phase Inspection
- Read the candidate plan to ensure all acceptance criteria checkboxes are marked and corresponding implementation files exist on disk.
- If uncompleted phases remain, keep the plan in active `plans/`.

### 3. Move & Cross-Reference Rewrite
- Move completed plan files into `plans/done/`.
- Search for references to the old plan path (`grep_search` for `plans/<name>.md`) and update them to `plans/done/<name>.md`.

### 4. Consolidated Summary
- Provide a clear summary table listing archived plans, merged PR dates, and updated documentation files.
