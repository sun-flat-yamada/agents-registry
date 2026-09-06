# Contributing to Agent Registry

Thank you for your interest in contributing to the **Unified Agent & Skills Registry** (`agents-registry`)!

This repository serves as a multi-harness registry supporting both **Claude Code Plugin** standard and **Microsoft APM (Agent Package Manager)**.

---

## 🏛️ Architecture & Source of Truth

The repository follows a single **Source of Truth (Master)** pattern:

```text
Source of Truth (Master)
  ├── .claude-plugin/plugin.json
  ├── skills/<skill-name>/SKILL.md
  ├── agents/<agent-name>.md
  ├── commands/<command-name>.md
  ├── instructions/*.md
  └── hooks/hooks.json
       │
       ▼ [sync-apm.ps1 / sync-apm.sh]
.apm/ (Auto-generated downstream assets for APM compatibility)
```

> **IMPORTANT**:
> Always modify files in the **Source of Truth** (`skills/`, `agents/`, `commands/`, `instructions/`, etc.).
> Do **NOT** manually edit files inside the `.apm/` directory. Run the sync script to update `.apm/`.

---

## 🛠️ Development & Synchronization

### 1. Prerequisites
- PowerShell (Windows/macOS/Linux) or POSIX Bash (Linux/macOS)
- Node.js (v18+)

### 2. Making Changes
When adding or updating skills, agents, prompts, or rules:
1. Create or modify files under `skills/`, `agents/`, `commands/`, `instructions/`, etc.
2. Update `.claude-plugin/plugin.json` and `apm.yml` to declare new primitives if added.
3. Run the APM synchronization script to mirror changes into `.apm/`:

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1
```

**Linux / macOS (Bash):**
```bash
chmod +x ./scripts/sync-apm.sh
./scripts/sync-apm.sh
```

### 3. Verifying Integrity
Before creating a Pull Request, verify that all primitives and `.apm` assets are perfectly in sync:

```powershell
# PowerShell
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1 -VerifyOnly
```

```bash
# Bash
./scripts/sync-apm.sh --verify
```

---

## 📋 Pull Request Process

1. **Fork & Branch**: Create a feature branch from `main` (`feature/add-new-skill` or `fix/harness-rule`).
2. **Follow Standards**:
   - Skills must follow the **Agent Skills Standard** (`skills/<name>/SKILL.md` with YAML frontmatter).
   - Rules and instructions should be concise and actionable.
3. **Verify**: Ensure `./scripts/sync-apm.ps1 -VerifyOnly` passes with exit code `0`.
4. **Submit PR**: Open a Pull Request against `main` describing your changes clearly.

---

## 📜 Code of Conduct

Please note that this project is released with a Contributor Code of Conduct. By participating in this project, you agree to abide by its terms. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
