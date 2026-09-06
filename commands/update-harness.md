---
description: Apply an approved Harness Improvement Plan (HIP) to update instructions, hooks, skills, and configuration files with automated backup, multi-target synchronization, and validation rollback.
---

# Update Harness Command

Safely execute and validate the changes proposed in a **Harness Improvement Plan (HIP)**.

## Instructions for Agent
1. Read the approved improvement plan from `plans/harness-improvement-plan.md`.
2. Create an atomic timestamped backup of all target files under `.harness-backup/`.
3. Apply the proposed modifications layer by layer (Skills, Hooks, Instructions, Packaging).
4. Run validation checks (JSON lint, YAML parse, pre-commit dry-run, and APM sync verification).
5. If validation passes, complete the update and log the changelog; if validation fails, restore all backups immediately.
