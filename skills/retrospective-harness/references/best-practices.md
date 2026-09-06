# Harness Engineering Best Practices Reference

This document synthesizes core guidelines and architectural patterns gathered from leading industry sources, official documentation, and award-winning agent harnesses.

---

## 1. Anthropic Official Standards (`anthropics/claude-plugins-official`)
- **Deterministic vs. Probabilistic Separation**:
  - Never rely on markdown prompts (`CLAUDE.md`) to guarantee security or deterministic formatting. Use `hooks/hooks.json` (`PreToolUse`, `PostToolUse`) to physically intercept and enforce critical guardrails.
- **Plugin Manifest Rigor**:
  - Manifests (`.claude-plugin/plugin.json`) must strictly declare schema versions, relative paths, and exports without leaking machine-specific paths.
  - Paths inside `.mcp.json` should leverage `${CLAUDE_PLUGIN_ROOT}` for portable resolution.
- **Targeted Tool Gating**:
  - Match hooks to exact tools (e.g. `matcher: "Bash"` or `matcher: "Write"`) to minimize invocation overhead and latency.

---

## 2. Contest-Winning Architecture: Affaan Mustafa / Everything Claude Code
*(Anthropic x Forum Ventures Hackathon Grand Prize Winner - 100k+ Stars Ecosystem)*

- **The `/evolve` Pattern**:
  - Whenever an agent makes a mistake that the user corrects, immediately crystallize that learning into a permanent rule or skill rather than leaving it in volatile chat context.
- **Context Rot Mitigation**:
  - Decompose large complex goals into dedicated, isolated sub-agents (e.g., Architect, Planner, TDD Builder, Security Reviewer).
  - Keep root instructions lean; load heavy domain knowledge on-demand via skills.
- **AgentShield & Safe Execution**:
  - Protect sensitive environments (`.env`, secrets, git branches) through pre-execution validation scripts.

---

## 3. Academic & Frontier Research: Retrospective Harness Optimization (RHO)
*(Research Paradigm - `wbopan/retro-harness`)*

- **Trajectory Self-Validation**:
  - Instead of requiring human-labeled ground truth, analyze past task rollouts using self-consistency and deterministic lint results to pinpoint where deviations occurred.
- **Pairwise Self-Preference**:
  - When updating a harness component, generate multiple candidate prompt/rule variations and evaluate which candidate best mitigates past failure trajectories without degrading unrelated capabilities.
- **Measurable Benchmarking**:
  - Quantify harness quality through reproducible test suites (e.g., SWE-Bench Pro methodologies) before promoting harness changes to production.

---

## 4. Microsoft APM & Multi-Harness Standards (`microsoft/apm`)
- **Single Source of Truth, Multi-Target Deployment**:
  - Maintain the master configuration in standardized files, then map and compile to client-specific harnesses:
    - Claude Code: `.claude/` / `CLAUDE.md` / `hooks/`
    - GitHub Copilot: `.github/copilot-instructions.md`
    - Cursor: `.cursor/rules/` or `.cursorrules`
    - Google Gemini / Antigravity: `skills/*/SKILL.md`
- **Policy Enforcement**:
  - Enforce package pinning, integrity hashes, and dependency security (`apm-policy.yml`).

---

## 5. Google DeepMind & Agent Skills Standard
- **Self-Contained Skill Anatomy**:
  - Every skill must reside in `skills/<slug>/` containing `SKILL.md` with explicit YAML frontmatter (`name`, `description`).
  - Keep auxiliary scripts in `scripts/`, reference documents in `references/`, and examples in `examples/`.
- **Imperative Instruction Voice**:
  - Write procedures in concise, unambiguous second person ("Run format check...", "Verify exit code...").

---

## 6. Deterministic Extraction & Idempotency Axioms (Retrospective Rigor)
- **Deterministic Pipeline Precedence**:
  - Never allow raw, non-deterministic text parsing to drive diagnostic plans. Execute deterministic scripts (`lint-harness.ps1`, `parse-trajectory.ps1`) to extract invariant failure signatures and static harness violations before LLM reasoning.
- **Strict Prohibition of Reverse-Engineered Ad-Hoc Patches**:
  - Never patch an ad-hoc failure by adding a narrow, single-instance prompt constraint (overfitting). Abstract and concretize iteratively to identify the invariant condition.
- **Universal Idempotency Invariants (Fixed-Point Convergence)**:
  1. *Canonical Signature*: Mask volatile tokens (PID, timestamp, ephemeral paths) to project friction into invariant hash equivalents.
  2. *Layer Escalation Lattice*: Mechanically enforceable rules belong exclusively in `hooks/` or linters, workflow steps in `skills/`, and only true domain tradeoffs in `instructions/`.
  3. *Subsumption & Anti-Redundancy*: Reject new rules already subsumed by existing constraints.
  4. *Anti-Oscillation*: Prohibit reversing past improvements without elevating the conflict into an explicit tradeoff parameter.
  5. *Fixed-Point Verification*: Ensure virtual re-evaluation of the updated harness produces zero additional deltas.
- Refer to `references/idempotency-and-determinism.md` for complete mathematical and architectural derivations.

