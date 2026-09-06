---
description: Trigger deterministic retrospective analysis of recent agent trajectories, extract invariant friction signatures, enforce idempotency constraints, and generate a prioritized Harness Improvement Plan (HIP).
---

# Retrospective Harness Command

Analyze recent execution sessions, command logs, tool failures, and user corrections to formulate a prioritized **Harness Improvement Plan (HIP)** grounded in deterministic tooling and universal idempotency constraints.

## Instructions for Agent
1. **Deterministic Extraction**:
   - Run `powershell.exe -ExecutionPolicy Bypass -File skills/retrospective-harness/scripts/lint-harness.ps1 -OutputFormat Json` to obtain static harness health.
   - Run `powershell.exe -ExecutionPolicy Bypass -File skills/retrospective-harness/scripts/parse-trajectory.ps1 -InputPath <log> -OutputFormat Json` to extract invariant `CanonicalSignature` hashes.
   - Run `powershell.exe -ExecutionPolicy Bypass -File scripts/sync-apm.ps1 -VerifyOnly` to check multi-target integrity.
2. **Universal Idempotency Filtering (Anti-Overfitting)**:
   - For each detected signature, apply the **Layer Escalation Lattice** (mechanical = Hook; orchestration = Skill; policy = Instruction).
   - Reject ad-hoc prompt patches and rules subsumed by existing configuration.
   - Check against past commit history to eliminate oscillating undo/reversion loops.
3. **Fixed-Point Plan Generation**:
   - Output a structured, prioritized plan at `plans/harness-improvement-plan.md` complete with Canonical Signatures, Layer Justifications, Idempotency Checklists, diffs, and verification commands.
