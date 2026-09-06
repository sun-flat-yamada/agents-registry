#!/usr/bin/env bash
set -euo pipefail

# AI Skills and Agent Security Audit Runner (Bash / Linux / macOS / CI)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${ROOT_DIR}"

VENV_DIR="${ROOT_DIR}/.venv-security"
VENV_PYTHON="${VENV_DIR}/bin/python"

# Environment bootstrap if not in CI or if venv missing
if [ "${1:-}" != "--no-install" ]; then
    if [ ! -f "${VENV_PYTHON}" ]; then
        echo "==> Setting up security virtual environment..."
        if command -v uv >/dev/null 2>&1; then
            uv venv --python 3.12 "${VENV_DIR}"
            uv pip install -r "${SCRIPT_DIR}/requirements-security.txt" --python "${VENV_PYTHON}"
        elif command -v python3 >/dev/null 2>&1; then
            python3 -m venv "${VENV_DIR}"
            "${VENV_PYTHON}" -m pip install --upgrade pip
            "${VENV_PYTHON}" -m pip install -r "${SCRIPT_DIR}/requirements-security.txt"
        fi
    fi
fi

RUNNER="python3"
if [ -f "${VENV_PYTHON}" ]; then
    RUNNER="${VENV_PYTHON}"
fi

exec "${RUNNER}" "${SCRIPT_DIR}/security-audit.py" "$@"
