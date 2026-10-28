# Unified Agent & Skills Registry

[English](README.md) | [日本語](README.ja.md)

[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin%20Ready-blueviolet.svg)](https://docs.claude.com)
[![Agent Package Manager](https://img.shields.io/badge/Microsoft%20APM-Multi--Harness-blue.svg)](https://github.com/microsoft/apm)
[![Agent Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard%20Compliant-brightgreen.svg)](https://github.com)
[![Security Audited](https://img.shields.io/badge/Security-Cisco%20%26%20NVIDIA%20Audited-success.svg)](docs/security-audit.md)
[![Harness Engineering](https://img.shields.io/badge/Harness%20Engineering-RHO%20Enabled-orange.svg)](docs/harness-engineering.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sun.flat.yamada)

This repository is a hybrid Agent Registry / Template that adopts de facto standards (**Claude Code Plugin format & Agent Skills Standard**) as the Master (Source of Truth), while fully supporting multi-harness distribution (Claude Code, Cursor, Copilot, Gemini) via **Microsoft APM (Agent Package Manager)**.

It comes equipped out-of-the-box with autonomous self-diagnosis and update cycles powered by cutting-edge **Harness Engineering (RHO)**, as well as a **robust security audit CI/CD pipeline leveraging Cisco & NVIDIA tools**.

---

## 🏛️ Architecture

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       Master (Source of Truth)                              │
│            Claude Code Plugin (.claude-plugin/plugin.json)                  │
│                     Agent Skills Standard (skills/*/SKILL.md)               │
└──────────────────────┬───────────────────────────────┬──────────────────────┘
                       │                               │
                       ▼                               ▼
       ┌───────────────────────────────┐ ┌───────────────────────────────┐
       │     Claude Code Ecosystem     │ │     Microsoft APM Deploy      │
       │  • /plugin install            │ │  • targets: claude, cursor,   │
       │  • /retrospective-harness     │ │    copilot, gemini            │
       │  • /update-harness            │ │  • scripts/sync-apm.ps1       │
       └───────────────────────────────┘ └───────────────────────────────┘
                       │                               │
                       └───────────────┬───────────────┘
                                       │
                                       ▼
       ┌───────────────────────────────────────────────────────────────┐
       │         Automated Security Auditing & CI/CD Pipeline          │
       │    • Cisco AI Skill Scanner + NVIDIA SkillSpector + Linter    │
       │    • Automatic incremental scan on skill/agent additions      │
       │    • SARIF 2.1.0 output to GitHub Code Scanning               │
       └───────────────────────────────────────────────────────────────┘
```

---

## ⚡ Quickstart

### 1. Use as a Claude Code Plugin
```bash
/plugin install github:sun-flat-yamada/agents-registry
```

### 2. Run Security Audit (Locally)
Inspect new or updated skills and agents for vulnerabilities and prompt injection:
```powershell
# Windows (PowerShell) - Fast scan for changed/added skills only
powershell -ExecutionPolicy Bypass -File ./scripts/audit-security.ps1 -ChangedOnly
```
```bash
# Linux / macOS (Bash)
./scripts/audit-security.sh --changed-only
```

### 3. Synchronize Master and .apm Layers
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1
```

---

## 📚 Detailed Documentation (Docs)

Detailed guides, configuration procedures, and architecture specs are organized under the `docs/` directory:

| Document | Overview |
| :--- | :--- |
| [🧭 **V-Model Skeleton & Selection Criteria**](docs/v-model-skeleton.md) | Phase slots, selection criteria and the replacement rule for registering one best entry per slot. |
| [🛡️ **Security Audit Guide**](docs/security-audit.md) | Integration specs for Cisco AI Skill Scanner, NVIDIA SkillSpector, and Built-in Linter, CLI reference, and CI/CD automated scan pipeline. |
| [🧠 **Harness Engineering Guide**](docs/harness-engineering.md) | Autonomous environment self-diagnosis, Harness Improvement Plan (HIP) formulation, and safe automatic update cycles based on Retrospective Harness Optimization (RHO). |
| [🚀 **Installation & Multi-Harness Deployment**](docs/usage-and-deployment.md) | Usage guide for Claude Code, multi-platform deployment via Microsoft APM (`apm.yml`), and Master layer auto-sync procedures. |

---

## 🧭 V-Model Slots (One Best per Phase)

This registry registers **only one best entry per V-model phase slot** for software development. The slot definitions, selection criteria and replacement rule are in [docs/v-model-skeleton.md](docs/v-model-skeleton.md); the current assignment is in [`registry.yml`](registry.yml).

| Slot | Phase | Current entry | Status |
| :--- | :--- | :--- | :--- |
| V1 | Requirements | — | empty |
| V2 | Architecture design | — | empty |
| V3 | Detailed design | — | empty |
| V4 | Implementation | — | empty |
| V5 | Unit test | — | empty |
| V6 | Integration test | — | empty |
| V7 | System test | [`e2e-live`](skills/e2e-live/SKILL.md) | provisional |
| V8 | Acceptance test | — | empty |
| X1 | Code review (cross-cutting) | [`code-review`](skills/code-review/SKILL.md) (orchestrator + reviewer sub-agents) | provisional |
| X2 | Security (cross-cutting) | [`reviewer-security`](agents/reviewer-security.md) | provisional |

*provisional* = mapped from existing assets and not yet compared against official sources.

### 🧠 Registry Tooling (not a slot)
- [`retrospective-harness`](skills/retrospective-harness/SKILL.md) / [`retrospective-harness-agent`](agents/retrospective-harness-agent.md): Self-diagnosis of agent execution history and Harness Improvement Plan (HIP) formulation.
- [`update-harness`](skills/update-harness/SKILL.md) / [`update-harness-agent`](agents/update-harness-agent.md): Atomic, verified application of an approved HIP.
- [`meta-skill-manager`](skills/meta-skill-manager/SKILL.md): Creating, updating and auditing Agent Skills.

### 🗂️ Not Yet Assigned
`archive-shipped-plans`, `make-e2e-live`, `setup-app`, `setup-ollama-local`, `string-helpers`, `explain` are development-related but not yet assigned to a slot. Each will be assigned, merged into a slot entry, or archived in the next curation PR.

### 📦 Archived (non-development)
Personal, office and domain agents/skills (accounting, investing, cooking, personal wiki/workspace, etc.) were moved to [`archive/non-dev/`](archive/non-dev/README.md). They are kept as-is but are no longer distributed.

---

## ⚡ Commands

| Command | File | Description |
| :--- | :--- | :--- |
| `/explain` | [`commands/explain.md`](commands/explain.md) | Detailed explanation of specified code or concepts. |
| `/code-review-subagent` | [`commands/code-review-subagent.md`](commands/code-review-subagent.md) | Multi-faceted parallel code review using specialized sub-agents. |
| `/retrospective-harness` | [`commands/retrospective-harness.md`](commands/retrospective-harness.md) | Harness self-diagnosis and Harness Improvement Plan (HIP) formulation. |
| `/update-harness` | [`commands/update-harness.md`](commands/update-harness.md) | Automated harness updates based on the Improvement Plan (HIP). |

---

## 📂 Repository Structure Overview

```text
/
├── registry.yml         # V-model slot assignments (one best entry per slot)
├── archive/non-dev/     # Archived non-development agents & skills (not distributed)
├── skills/              # Agent Skills Standard compliant skills (Master)
├── agents/              # Domain-specialized agents and persona definitions (Master)
├── hooks/               # Deterministic lifecycle hooks (hooks.json, etc.)
├── commands/            # Slash commands and reusable prompt instructions
├── instructions/        # Coding standards and common repository rules
├── contexts/            # Architecture and project context specifications
├── scripts/             # Security auditing & APM synchronization scripts
├── docs/                # Detailed technical documentation by category
├── .claude-plugin/      # Claude Code plugin manifest (Master)
├── .github/workflows/   # CI/CD pipelines (security-audit.yml, ci.yml)
├── .apm/                # APM backward-compatibility layer (auto-generated from Master)
└── apm.yml              # APM multi-target configuration file
```

---

## 🤝 Community & Contributing

- [Contribution Guidelines (CONTRIBUTING.md)](CONTRIBUTING.md)
- [Code of Conduct (CODE_OF_CONDUCT.md)](CODE_OF_CONDUCT.md)
- [License (LICENSE - MIT License)](LICENSE)

---

## 🤝 Contribution & Support

Contributions are welcome! If you find this tool useful, please consider supporting its development.

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sun.flat.yamada)
