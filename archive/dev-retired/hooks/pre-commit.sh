#!/usr/bin/env bash
set -e

echo "[Hook] Running pre-commit validation (lint and format checks)..."

if [ -f "package.json" ]; then
    if grep -q '"lint"' package.json; then
        echo "[Hook] Executing npm run lint..."
        npm run lint
    fi
    if grep -q '"format"' package.json; then
        echo "[Hook] Executing npm run format..."
        npm run format
    fi
fi

echo "[Hook] Pre-commit checks passed successfully."
exit 0
