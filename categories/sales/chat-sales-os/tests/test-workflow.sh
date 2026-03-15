#!/bin/bash
set -euo pipefail

echo "Testing chat-sales-os workflow..."

WORKSPACE="${1:-.}"

if [[ ! -d "$WORKSPACE" ]]; then
    echo "FAIL: Workspace not found: $WORKSPACE"
    exit 1
fi

if [[ -d "$WORKSPACE/personas" ]]; then
    echo "PASS: Personas directory exists"
else
    echo "FAIL: Personas directory not found"
    exit 1
fi

# Check sales role files
for f in IDENTITY.md SOUL.md TASKS.md; do
    if [[ -f "$WORKSPACE/sales/$f" ]]; then
        echo "PASS: sales/$f exists"
    else
        echo "FAIL: sales/$f not found"
        exit 1
    fi
done

# Check shared README
if [[ -f "$WORKSPACE/shared/README.md" ]]; then
    echo "PASS: shared/README.md exists"
else
    echo "FAIL: shared/README.md not found"
    exit 1
fi

echo "All tests passed for chat-sales-os"
