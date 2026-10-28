---
name: setup-ollama-local
description: Guides setup and configuration for connecting AI agent CLIs to a local Ollama LLM server. Covers version verification, model pulls, context-window requirements, and endpoint redirection.
---

# Setup Ollama Local LLM Skill

This skill assists users in connecting their AI agent workflows to a local **Ollama** server, enabling local, private, and offline LLM execution.

## Prerequisites & Constraints
- **Ollama Version**: v0.14.0 or later (required for standard Anthropic/OpenAI messages API compatibility).
- **Context Window**: Agent harnesses typically require at least a **64k context window** to accommodate system prompts, skills, and tools.
- **Hardware Requirements**: Recommended minimum 16GB+ unified memory / VRAM for running 8B-14B parameter models with tool-calling capabilities.

## Setup Steps

### 1. Detect & Install Ollama
Check if Ollama is installed and operational:
```bash
ollama --version
curl -s http://localhost:11434/api/tags
```
If not installed, guide user to download from https://ollama.com or install via package managers (`brew install ollama`, `winget install Ollama.Ollama`).

### 2. Pull Capable Agent Models
Recommend models with proven function calling and long context:
```bash
ollama pull qwen2.5-coder:14b
# or
ollama pull llama3.1:8b
```

### 3. Configure Agent CLI Redirection
Set the target CLI base URL to point to the local Ollama instance:
```bash
export ANTHROPIC_BASE_URL="http://localhost:11434"
export OPENAI_BASE_URL="http://localhost:11434/v1"
```

### 4. Connection & Latency Verification
Run a verification turn to ensure tool parsing works without schema degradation.
