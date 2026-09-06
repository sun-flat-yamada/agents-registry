#!/usr/bin/env bash
# ==============================================================================
# Agent Registry Master -> .apm Sync & Validator (POSIX Bash version)
# ==============================================================================

set -e

VERIFY_ONLY=0
if [ "$1" = "--verify" ] || [ "$1" = "-VerifyOnly" ]; then
    VERIFY_ONLY=1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "=================================================="
echo "  Agent Registry Master -> .apm Sync & Validator  "
echo "=================================================="

HAS_ERRORS=0

sync_files() {
    local src_dir="$1"
    local target_dir="$2"
    local suffix="$3"

    if [ ! -d "$src_dir" ]; then
        return
    fi

    if [ "$VERIFY_ONLY" -eq 0 ]; then
        mkdir -p "$target_dir"
    fi

    for file in "$src_dir"/*.md; do
        [ -e "$file" ] || continue
        local base
        base="$(basename "$file" .md)"
        local dest="$target_dir/${base}${suffix}.md"

        if [ "$VERIFY_ONLY" -eq 1 ]; then
            if [ ! -f "$dest" ]; then
                echo "⚠️ [Missing] Target file does not exist: $dest"
                HAS_ERRORS=1
            fi
        else
            cp "$file" "$dest"
            echo "  [Synced] $(basename "$file") -> $dest"
        fi
    done
}

echo ""
echo "1. Processing Agents..."
sync_files "agents" ".apm/agents" ".agent"

echo ""
echo "2. Processing Commands / Prompts..."
sync_files "commands" ".apm/prompts" ".prompt"

echo ""
echo "3. Processing Instructions..."
sync_files "instructions" ".apm/instructions" ".instructions"

echo ""
echo "4. Processing Contexts..."
sync_files "contexts" ".apm/contexts" ".context"

echo ""
echo "5. Processing Chatmodes..."
sync_files "chatmodes" ".apm/chatmodes" ".chatmode"

echo ""
echo "6. Processing Skills..."
if [ -d "skills" ]; then
    if [ "$VERIFY_ONLY" -eq 0 ]; then
        mkdir -p ".apm/skills"
    fi
    for skill_dir in skills/*; do
        if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
            skill_name="$(basename "$skill_dir")"
            dest=".apm/skills/${skill_name}.skill.md"
            if [ "$VERIFY_ONLY" -eq 1 ]; then
                if [ ! -f "$dest" ]; then
                    echo "⚠️ [Missing] Target skill file does not exist: $dest"
                    HAS_ERRORS=1
                fi
            else
                cp "$skill_dir/SKILL.md" "$dest"
                echo "  [Synced Skill] ${skill_name}/SKILL.md -> $dest"
            fi
        fi
    done
fi

echo ""
echo "7. Processing References..."
if [ -d "skills/code-review/references" ]; then
    if [ "$VERIFY_ONLY" -eq 0 ]; then
        mkdir -p ".apm/references"
        cp -r skills/code-review/references/* .apm/references/ 2>/dev/null || true
        echo "  [Synced References] skills/code-review/references -> .apm/references"
    fi
fi

echo ""
echo "8. Processing Hooks..."
if [ -f "hooks/pre-commit.ps1" ] || [ -f "hooks/pre-commit.sh" ]; then
    dest_hook=".apm/hooks/pre-commit.hook.md"
    if [ "$VERIFY_ONLY" -eq 1 ]; then
        if [ ! -f "$dest_hook" ]; then
            echo "⚠️ [Missing] Target hook does not exist: $dest_hook"
            HAS_ERRORS=1
        fi
    else
        mkdir -p ".apm/hooks"
        cat << 'EOF' > "$dest_hook"
---
description: Pre-commit hook executing lint and format validation.
---
# Pre-Commit Hook

Invokes project linter and formatter prior to commit.

## Executable Action
`npm run lint && npm run format`
EOF
        echo "  [Synced Hook] hooks/ -> $dest_hook"
    fi
fi

echo ""
echo "=================================================="
if [ "$HAS_ERRORS" -ne 0 ]; then
    echo "❌ Verification failed: Inconsistencies detected between Master and .apm layer."
    exit 1
else
    echo "  Sync & Verification Complete: All assets in sync! "
    echo "=================================================="
    exit 0
fi
