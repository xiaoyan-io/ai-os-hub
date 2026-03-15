#!/bin/bash
set -euo pipefail

echo "Testing family-care-os workflow..."

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

# Check care role files
for f in IDENTITY.md SOUL.md TASKS.md; do
    if [[ -f "$WORKSPACE/care/$f" ]]; then
        echo "PASS: care/$f exists"
    else
        echo "FAIL: care/$f not found"
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

# Check medical boundary in SOUL.md
if grep -q "do not claim to be a doctor" "$WORKSPACE/care/SOUL.md" 2>/dev/null; then
    echo "PASS: Medical boundary found in care/SOUL.md"
else
    echo "FAIL: Medical boundary not found in care/SOUL.md"
    exit 1
fi

# Check medical boundary in TASKS.md
if grep -q "do not claim to be a doctor" "$WORKSPACE/care/TASKS.md" 2>/dev/null; then
    echo "PASS: Medical boundary found in care/TASKS.md"
else
    echo "FAIL: Medical boundary not found in care/TASKS.md"
    exit 1
fi

echo "All tests passed for family-care-os"
