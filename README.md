# Unified Agent & Skills Registry

[English](README.md) | [日本語](README.ja.md)

[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin%20Ready-blueviolet.svg)](https://docs.claude.com)
[![GitHub Copilot CLI](https://img.shields.io/badge/GitHub%20Copilot%20CLI-Supported-blue.svg)](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)
[![Agent Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard%20Compliant-brightgreen.svg)](https://github.com)
[![Security Audited](https://img.shields.io/badge/Security-Cisco%20%26%20NVIDIA%20Audited-success.svg)](docs/security-audit.md)
[![Harness Engineering](https://img.shields.io/badge/Harness%20Engineering-RHO%20Enabled-orange.svg)](docs/harness-engineering.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sun.flat.yamada)

This repository is a curated Agent & Skills Registry for software development. It registers **one best agent or skill for each phase of the V-model** and refreshes it as better approaches appear. The **Claude Code Plugin format & Agent Skills Standard** is the Master (Source of Truth); **Claude Code** is the main client, and the same plugin also installs in **GitHub Copilot CLI**.

It comes equipped out-of-the-box with autonomous self-diagnosis and update cycles powered by cutting-edge **Harness Engineering (RHO)**, as well as a **robust security audit CI/CD pipeline leveraging Cisco & NVIDIA tools**.

---

## 🏛️ Architecture

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       Master (Source of Truth)                              │
│   .claude-plugin/plugin.json · skills/*/SKILL.md · agents/*.agent.md        │
│   commands/*.md · registry.yml (one best entry per V-model slot)            │
└──────────────────────┬───────────────────────────────┬──────────────────────┘
                       │                               │
                       ▼                               ▼
       ┌───────────────────────────────┐ ┌───────────────────────────────┐
       │      Claude Code (main)       │ │      GitHub Copilot CLI       │
       │  /plugin marketplace add      │ │  copilot plugin marketplace   │
       │  /plugin install              │ │  copilot plugin install       │
       │  (reads .claude-plugin/)      │ │  (reads .claude-plugin/ too)  │
       └───────────────────────────────┘ └───────────────────────────────┘
                       │                               │
                       └───────────────┬───────────────┘
                                       ▼
       ┌───────────────────────────────────────────────────────────────┐
       │         Automated Security Auditing & CI/CD Pipeline          │
       │    • Cisco AI Skill Scanner + NVIDIA SkillSpector + Linter    │
       │    • Copilot CLI plugin load check                            │
       │    • SARIF 2.1.0 output to GitHub Code Scanning               │
       └───────────────────────────────────────────────────────────────┘
```

---

## ⚡ Quickstart

### 1. Install

Both clients read the same `.claude-plugin/` manifests from this repository.

**Claude Code**
```bash
/plugin marketplace add sun-flat-yamada/agents-registry
/plugin install agent-registry-bundle@agent-registry-marketplace
```

**GitHub Copilot CLI**
```bash
copilot plugin marketplace add sun-flat-yamada/agents-registry
copilot plugin install agent-registry-bundle@agent-registry-marketplace
```

The X2 security slot uses Anthropic's `claude-security` plugin, which runs only in Claude Code: `/plugin install claude-security@claude-plugins-official`. See [docs/usage-and-deployment.md](docs/usage-and-deployment.md) for what works in each client.

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
| [🗓️ **Monthly Review**](docs/v-model-skeleton.md#4-月次レビュー) | Once a month a scheduled task checks Anthropic's official repositories for changes and opens a draft PR when a slot can be improved. Merges are always decided by a human. |
| [🛡️ **Security Audit Guide**](docs/security-audit.md) | Integration specs for Cisco AI Skill Scanner, NVIDIA SkillSpector, and Built-in Linter, CLI reference, and CI/CD automated scan pipeline. |
| [🧠 **Harness Engineering Guide**](docs/harness-engineering.md) | Autonomous environment self-diagnosis, Harness Improvement Plan (HIP) formulation, and safe automatic update cycles based on Retrospective Harness Optimization (RHO). |
| [🚀 **Installation & Multi-Harness Deployment**](docs/usage-and-deployment.md) | Usage guide for Claude Code, multi-platform deployment via Microsoft APM (`apm.yml`), and Master layer auto-sync procedures. |

---

## 🧭 V-Model Slots (One Best per Phase)

This registry registers **only one best entry per V-model phase slot** for software development. The slot definitions, selection criteria and replacement rule are in [docs/v-model-skeleton.md](docs/v-model-skeleton.md); the current assignment, sources and reasons are in [`registry.yml`](registry.yml).

| Slot | Phase | Entry | Uses | Source |
| :--- | :--- | :--- | :--- | :--- |
| V1 | Requirements | [`requirements-definition`](skills/requirements-definition/SKILL.md) | — | in-house |
| V2 | Architecture design | [`architecture-design`](skills/architecture-design/SKILL.md) | `code-explorer` | in-house |
| V3 | Detailed design | [`detailed-design`](skills/detailed-design/SKILL.md) | `code-architect`, `type-design-analyzer` | in-house |
| V4 | Implementation | [`implementation-loop`](skills/implementation-loop/SKILL.md) | `code-simplifier` | in-house |
| V5 | Unit test | [`unit-test-tdd`](skills/unit-test-tdd/SKILL.md) | `pr-test-analyzer` | in-house |
| V6 | Integration test | [`integration-test`](skills/integration-test/SKILL.md) | — | in-house |
| V7 | System test | [`system-test`](skills/system-test/SKILL.md) | [`webapp-testing`](skills/webapp-testing/SKILL.md) | in-house |
| V8 | Acceptance test | [`acceptance-test`](skills/acceptance-test/SKILL.md) | — | in-house |
| X1 | Code review (cross-cutting) | [`/code-review`](commands/code-review.md) | — | Anthropic official (vendored) |
| X2 | Security (cross-cutting) | `claude-security` plugin | — | Anthropic official (install: `/plugin install claude-security@claude-plugins-official`) |

The phases hand off through traceable IDs: requirements `REQ-n` / acceptance criteria `AC-n` (V1 → V8), system-test viewpoints `ST-n` (V2 → V7), and interfaces `IF-n` / integration-test points `IT-n` (V3 → V6). The agents in the *Uses* column (`code-explorer`, `code-architect`, `type-design-analyzer`, `code-simplifier`, `pr-test-analyzer`) and `webapp-testing` are copied verbatim from Anthropic's official repositories; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

### 🧠 Registry Tooling (not a slot)
- [`retrospective-harness`](skills/retrospective-harness/SKILL.md) / [`retrospective-harness-agent`](agents/retrospective-harness-agent.agent.md): Self-diagnosis of agent execution history and Harness Improvement Plan (HIP) formulation.
- [`update-harness`](skills/update-harness/SKILL.md) / [`update-harness-agent`](agents/update-harness-agent.agent.md): Atomic, verified application of an approved HIP.
- [`meta-skill-manager`](skills/meta-skill-manager/SKILL.md): Creating, updating and auditing Agent Skills.

### 📦 Archived
- [`archive/non-dev/`](archive/non-dev/README.md): personal, office and domain agents/skills (accounting, investing, cooking, personal wiki/workspace, etc.).
- [`archive/dev-retired/`](archive/dev-retired/README.md): development assets replaced by a slot entry (the former code-review suite, `e2e-live`, `reviewer-security`, …) or outside every slot.

Archived items are kept as-is but are no longer distributed.

---

## ⚡ Commands

| Command | File | Description |
| :--- | :--- | :--- |
| `/code-review` | [`commands/code-review.md`](commands/code-review.md) | X1 slot. Reviews a pull request with parallel agents and keeps only findings that an independent agent confirms (Anthropic official). |
| `/retrospective-harness` | [`commands/retrospective-harness.md`](commands/retrospective-harness.md) | Harness self-diagnosis and Harness Improvement Plan (HIP) formulation. |
| `/update-harness` | [`commands/update-harness.md`](commands/update-harness.md) | Automated harness updates based on the Improvement Plan (HIP). |

---

## 📂 Repository Structure Overview

```text
/
├── registry.yml         # V-model slot assignments (one best entry per slot)
├── archive/             # Archived agents & skills: non-dev/ and dev-retired/ (not distributed)
├── licenses/            # Upstream licenses for vendored files (see THIRD_PARTY_NOTICES.md)
├── skills/              # Agent Skills Standard compliant skills (Master)
├── agents/              # Domain-specialized agents and persona definitions (Master)
├── commands/            # Slash commands and reusable prompt instructions
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
