---
name: retrospective-harness
description: Audits past agent execution trajectories and harness static integrity using deterministic extractors and idempotency-preserving convergence constraints to produce a prioritized Harness Improvement Plan (HIP).
---

# Retrospective Harness Skill

This skill operationalizes the **Retrospective Harness Optimization (RHO)** paradigm, continuous self-improvement patterns (e.g. `/evolve`), and **rigorous idempotency engineering**.

## Core Purpose
An AI agent's effectiveness is constrained by its **Harness** — system instructions (`CLAUDE.md`, `.cursorrules`), lifecycle hooks (`hooks/hooks.json`), skills (`skills/*/SKILL.md`), and tool configs (`.mcp.json`).

When agents encounter failures or friction, naive approaches apply ad-hoc prompt edits ("reverse engineering from the answer"), causing rule bloat, contradiction, and non-deterministic oscillation. This skill eliminates those pathologies by:
1. **Executing deterministic extractors** (static linters and canonical trajectory parsers) to eliminate probabilistic guesswork.
2. **Enforcing 5 universal idempotency constraints** (derived from multiple abstraction-concretization cycles) ensuring changes converge to a fixed point ($f(f(x)) = f(x)$) without overfitting to specific session outputs.

---

## The Deterministic Extraction Pipeline

Before engaging LLM reasoning, always run the deterministic tooling suite:

### 1. Static Harness Audit (`scripts/lint-harness.ps1`)
Deterministically checks all skill manifests, YAML frontmatter, line lengths (>300 lines flag cognitive bloat), hooks schema, and local markdown link integrity:
```powershell
powershell.exe -ExecutionPolicy Bypass -File skills/retrospective-harness/scripts/lint-harness.ps1 -OutputFormat Json
```

### 2. Trajectory Canonical Parsing (`scripts/parse-trajectory.ps1`)
Masks ephemeral tokens (PIDs, timestamps, temporary paths) and computes invariant SHA256 **Canonical Signatures** for all execution failures (exit codes != 0, unhandled exceptions, permission blocks, rollback commands):
```powershell
powershell.exe -ExecutionPolicy Bypass -File skills/retrospective-harness/scripts/parse-trajectory.ps1 -InputPath <log-path> -OutputFormat Json
```

### 3. Multi-Harness Sync Verification (`scripts/sync-apm.ps1`)
Verifies consistency between Master and client harnesses:
```powershell
powershell.exe -ExecutionPolicy Bypass -File scripts/sync-apm.ps1 -VerifyOnly
```

---

## Universal Idempotency Invariants (Anti-Overfitting Gate)

When translating extracted friction signatures into improvement items, **never reverse-engineer an ad-hoc rule from a single output**. Every proposed change must satisfy five universal invariants:

### Axiom 1: Canonical Signature Invariant
- Every action item must tie directly to one or more deterministic `CanonicalSignature` hashes.
- Actions based on vague impressions or ephemeral context without a reproducible signature are rejected.

### Axiom 2: Layer Escalation Lattice (Principle of Least Action)
Harness control layers form a strict precedence lattice:
$$\text{Hook (Physical Enforcement)} \succ \text{Skill (Procedural Orchestration)} \succ \text{Context (Domain Data)} \succ \text{Instruction (Probabilistic Guideline)}$$
- **Mechanical failures** (syntax, non-zero exits, format, lint, permissions): **MUST** be placed in `hooks/hooks.json` or deterministic scripts. Patching these via instructions is **STRICTLY PROHIBITED**.
- **Tool sequences & multi-step operations**: Packaged into `skills/*/SKILL.md`.
- **Instruction rules**: Reserved exclusively for domain tradeoffs and high-level architectural intentions.

### Axiom 3: Subsumption & Anti-Redundancy Constraint
- If the proposed rule $R_{new}$ is already logically subsumed by an existing rule ($R_{new} \subseteq R_{existing}$), generate a `NO_OP` and reject the duplicate.

### Axiom 4: Anti-Oscillation & Cycle-Breaking
- If the proposed diff reverses a recent commit or previous HIP action item (undo/toggle), reject the simple reversal. Elevate the conflicting forces into an explicit tradeoff parameter or environment toggle.

### Axiom 5: Fixed-Point Virtual Verification
- In the virtual updated state $S'$, re-evaluating the diagnostic function must yield $\Delta S' = \emptyset$ (zero additional diffs) and introduce zero new linter errors.

---

## Execution Workflow

### Step 1: Deterministic Ingestion & Extraction
1. Run `lint-harness.ps1` to capture all static defects and health scores.
2. Run `parse-trajectory.ps1` over recent session transcripts or git commit history to capture sorted `CanonicalSignature` groups.
3. Run `sync-apm.ps1 -VerifyOnly` to check multi-target synchronization.

### Step 2: Idempotent Diagnostic Synthesis
1. Cross-reference signatures against `references/best-practices.md` and `references/idempotency-and-determinism.md`.
2. Apply the **Layer Escalation Lattice** to route each friction event to its canonical layer (Hook vs Skill vs Instruction).
3. Filter out subsumed or oscillating candidates.

### Step 3: Produce Harness Improvement Plan (HIP)
Generate the report at `plans/harness-improvement-plan.md` using this strict schema:

```markdown
# Harness Improvement Plan (HIP)

## 1. Deterministic Metrics & Health Audit
- Harness Static Health Score: [e.g., 92/100] (from lint-harness.ps1)
- Total Raw Friction Events: [Count]
- Unique Canonical Signatures: [Count]
- APM Multi-Harness Sync Status: [OK / MISMATCH]

---

## 2. Prioritized Action Items

### [P0 - Critical] Item Title
- **Canonical Signature**: `[SHA256 Hash]` (e.g., `8f3d1b2a9e4c...`)
- **Target Component**: [e.g., `hooks/hooks.json`, `skills/xyz/SKILL.md`]
- **Layer Allocation**: [Hook / Skill / Context / Instruction]
  - *Justification*: [Why this is the minimal deterministic layer per the Lattice Rule]
- **Observed Friction**: [Normalized pattern and frequency]
- **Root Cause**: [Defect in current harness]
- **Idempotency Verification**:
  - *Subsumption Check*: [Confirmed not covered by existing rules]
  - *Anti-Oscillation*: [Confirmed not reversing past changes]
  - *Fixed-Point Expectation*: [Virtual re-evaluation delta = empty]
- **Proposed Diff / Specification**:
  ```[json/markdown/yaml/powershell]
  [concrete code snippet]
  ```
- **Validation Test**: [Deterministic command to verify fix]

---

## 3. Next Steps
Invoke `@update-harness-agent` to apply approved items with automated backup, verification, and rollback.
```
