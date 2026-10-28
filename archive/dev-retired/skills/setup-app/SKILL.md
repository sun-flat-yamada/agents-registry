---
name: setup-app
description: Interactively guides application workspace setup and environment verification. Checks port availability, runtime dependencies (Docker, FFmpeg, CLI auth), and resolves common initialization pitfalls.
---

# Application Setup & Environment Verification Skill

This skill assists developers and end users in setting up, verifying, and diagnosing their local agentic application runtime environment.

## Verification Checklist

### 1. Port Availability Check
Verify that target development ports (e.g., 5173, 3000, 3001) are free:
- Windows (pwsh): `Get-NetTCPConnection -LocalPort 5173 -ErrorAction SilentlyContinue`
- POSIX: `lsof -i :5173`

### 2. Runtime Dependency Detection
Inspect the local machine for required toolchains:
| Tool / Component | Detection Command | Impact if Missing |
| :--- | :--- | :--- |
| **Node.js / Package Manager** | `node -v`, `npm -v`, `yarn -v` | Core build & runtime failure |
| **AI CLI / Credentials** | `claude --version`, active auth files | Agent execution loop blocked |
| **Container Engine (Docker)** | `docker info` | Sandbox isolation disabled |
| **Media Utilities (FFmpeg)** | `ffmpeg -version` | Audio/video processing unavailable |

### 3. Environment Variable Configuration
- Ensure `.env` is initialized from `.env.example`.
- Verify required API keys and local endpoint bindings.

### 4. Triage Common Initialization Pitfalls
- **Port Conflicts (`EADDRINUSE`)**: Identify blocking PID and suggest termination or port reallocation.
- **Missing Build Artifacts**: Guide execution of clean package installs (`npm install` / `yarn install`).
- **Cache Invalidation**: Clear Vite or bundle caches when lockfiles change.
