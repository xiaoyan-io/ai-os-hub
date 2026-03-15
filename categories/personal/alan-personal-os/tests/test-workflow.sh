#!/bin/bash
set -euo pipefail

echo "Testing alan-personal-os workflow..."

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

# Check personal role files
for f in IDENTITY.md SOUL.md TASKS.md; do
    if [[ -f "$WORKSPACE/personal/$f" ]]; then
        echo "PASS: personal/$f exists"
    else
        echo "FAIL: personal/$f not found"
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

echo "All tests passed for alan-personal-os"
