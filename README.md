# Unified Agent & Skills Registry

[English](README.md) | [日本語](README.ja.md)

[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin%20Ready-blueviolet.svg)](https://docs.claude.com)
[![Agent Package Manager](https://img.shields.io/badge/Microsoft%20APM-Multi--Harness-blue.svg)](https://github.com/microsoft/apm)
[![Agent Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard%20Compliant-brightgreen.svg)](https://github.com)
[![Security Audited](https://img.shields.io/badge/Security-Cisco%20%26%20NVIDIA%20Audited-success.svg)](docs/security-audit.md)
[![Harness Engineering](https://img.shields.io/badge/Harness%20Engineering-RHO%20Enabled-orange.svg)](docs/harness-engineering.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

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
| [🛡️ **Security Audit Guide**](docs/security-audit.md) | Integration specs for Cisco AI Skill Scanner, NVIDIA SkillSpector, and Built-in Linter, CLI reference, and CI/CD automated scan pipeline. |
| [🧠 **Harness Engineering Guide**](docs/harness-engineering.md) | Autonomous environment self-diagnosis, Harness Improvement Plan (HIP) formulation, and safe automatic update cycles based on Retrospective Harness Optimization (RHO). |
| [🚀 **Installation & Multi-Harness Deployment**](docs/usage-and-deployment.md) | Usage guide for Claude Code, multi-platform deployment via Microsoft APM (`apm.yml`), and Master layer auto-sync procedures. |

---

## 🤖 Registered Agents (19 Agents)

This registry includes 19 domain-specialized agents (`agents/*.md`):

### 🧠 Harness Engineering (Self-Diagnosis & Improvement)
| Agent | Description |
| :--- | :--- |
| [`retrospective-harness-agent`](agents/retrospective-harness-agent.md) | Diagnostic agent that analyzes bottlenecks from past session history and error logs, formulating a Harness Improvement Plan (HIP). |
| [`update-harness-agent`](agents/update-harness-agent.md) | Application agent that atomically and safely applies updates to Skills, Agents, Hooks, and Rules based on the HIP plan. |

### 🛡️ Code Review Suite (Code Quality & Security)
| Agent | Description |
| :--- | :--- |
| [`code-reviewer`](agents/code-reviewer.md) | Main agent that conducts multi-faceted code reviews covering quality, security, performance, and maintainability. |
| [`code-review-orchestrator`](agents/code-review-orchestrator.md) | Orchestrates 4 specialized review agents in parallel to generate a deduplicated, priority-sorted integrated report. |
| [`reviewer-security`](agents/reviewer-security.md) | Security specialist agent focusing on OWASP Top 10, vulnerabilities, input validation, and cryptography. |
| [`reviewer-memory-safety`](agents/reviewer-memory-safety.md) | Specialist agent focusing on memory safety, resource leaks, concurrency, and thread safety. |
| [`reviewer-style-quality`](agents/reviewer-style-quality.md) | Specialist agent focusing on clean code, naming conventions, design patterns, and readability. |
| [`reviewer-effective`](agents/reviewer-effective.md) | Specialist agent focusing on language-specific idioms (Effective C++, C#, Java, Python, etc.). |

### 🏛️ Workspace & Knowledge Core (Self-Improving Workspace)
| Agent | Description |
| :--- | :--- |
| [`workspace-agent`](agents/workspace-agent.md) | Autonomous operations agent for Wiki/Collection/Automation based on the "The Workspace Is the Self-Improving Agent" philosophy. |
| [`collection-architect`](agents/collection-architect.md) | Architect agent responsible for collection schema design, data modeling, and integrity validation. |
| [`wiki-curator`](agents/wiki-curator.md) | Curator agent responsible for knowledge base structuring, note promotion, linting, and periodic maintenance. |

### 🎭 Specialized Roles & Personas
| Agent | Description |
| :--- | :--- |
| [`agent-personal`](agents/agent-personal.md) | Personal companion assisting with personal productivity, task organization, and daily decision-making. |
| [`agent-office`](agents/agent-office.md) | Office assistant supporting business document creation, meeting summary, and office workflows. |
| [`agent-guide`](agents/agent-guide.md) | Guide agent providing system usage instructions, onboarding, and reference guides. |
| [`agent-artist`](agents/agent-artist.md) | Creator supporting creative ideation, prompt design, and visual idea generation. |
| [`agent-tutor`](agents/agent-tutor.md) | One-on-one tutor guiding structured curriculum design, concept explanations, and comprehension checks. |
| [`agent-storyteller`](agents/agent-storyteller.md) | Storyteller managing world-building, character settings, and narrative writing. |
| [`agent-accounting`](agents/agent-accounting.md) | Accounting agent assisting with invoicing, expense calculations, and bookkeeping data organization. |
| [`agent-investor`](agents/agent-investor.md) | Investor agent assisting with portfolio analysis, market data, and financial hypothesis validation. |

---

## 🛠️ Registered Skills (25 Skills)

All skills fully comply with the **Agent Skills Standard (`skills/<slug>/SKILL.md`)**:

### 🧠 Harness Engineering & Optimization (2)
- [`retrospective-harness`](skills/retrospective-harness/SKILL.md): Self-diagnosis of agent execution history and automatic formulation of Harness Improvement Plans (HIP).
- [`update-harness`](skills/update-harness/SKILL.md): Atomic updating and verification of Skills / Agents / Hooks based on formulated HIP.

### 🏛️ Workspace & Core Primitives (8)
- [`code-review`](skills/code-review/SKILL.md): Multi-language code review and Effective rule enforcement.
- [`string-helpers`](skills/string-helpers/SKILL.md): String manipulation utilities such as casing, slugification, and padding.
- [`wiki-ingest`](skills/wiki-ingest/SKILL.md): Structured ingestion of external text and web documents.
- [`wiki-promote`](skills/wiki-promote/SKILL.md): Note promotion, key summary extraction, and index updating.
- [`wiki-lint`](skills/wiki-lint/SKILL.md): Static verification of broken links, orphan notes, and tag consistency.
- [`collection-builder`](skills/collection-builder/SKILL.md): Definition and validation of JSON Schema compliant collections.
- [`meta-skill-manager`](skills/meta-skill-manager/SKILL.md): Skill metadata management, dependency checking, and registration support.
- [`automation-scheduler`](skills/automation-scheduler/SKILL.md): Automated scheduling for cron, timer, and event-driven tasks.

### 🔧 Developer Tools & Environment (7)
- [`archive-shipped-plans`](skills/archive-shipped-plans/SKILL.md): Archiving and cleanup of completed implementation plans and documents.
- [`e2e-live`](skills/e2e-live/SKILL.md): Execution of E2E live tests and log validation.
- [`make-e2e-live`](skills/make-e2e-live/SKILL.md): Generation of E2E live test scenarios and fixture construction.
- [`setup-app`](skills/setup-app/SKILL.md): Initial application setup and dependency resolution.
- [`setup-ollama-local`](skills/setup-ollama-local/SKILL.md): Local LLM (Ollama) environment setup and model configuration.
- [`setup-relay`](skills/setup-relay/SKILL.md): Configuration for communication relay server and MCP relay.
- [`setup-wizard`](skills/setup-wizard/SKILL.md): Interactive onboarding wizard execution.

### 💼 Domain & Productivity Presets (8)
- [`cooking-coach`](skills/cooking-coach/SKILL.md): Recipe suggestions and step-by-step guides tailored to ingredients and nutrition.
- [`library`](skills/library/SKILL.md): Book and literature management, reading logs, and citation metadata organization.
- [`zenn-publisher`](skills/zenn-publisher/SKILL.md): Writing, format validation, and publishing assistance for technical articles (Zenn, etc.).
- [`presentation-deck`](skills/presentation-deck/SKILL.md): Slide structure proposals and presentation outline generation.
- [`storyteller`](skills/storyteller/SKILL.md): Character creation, world-building, and short scenario writing.
- [`portfolio-tracker`](skills/portfolio-tracker/SKILL.md): Asset allocation, portfolio rebalancing, and P&L tracking.
- [`billing-invoice`](skills/billing-invoice/SKILL.md): Qualified invoice and billing format generation from billing data.
- [`edgar-sec-filings`](skills/edgar-sec-filings/SKILL.md): Search and retrieval of corporate filings and financial data from US SEC EDGAR.

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
