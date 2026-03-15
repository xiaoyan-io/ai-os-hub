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

if grep -q "do not claim to be a doctor" "$WORKSPACE/TASKS.md" 2>/dev/null; then
    echo "PASS: Medical boundary found in TASKS.md"
else
    echo "FAIL: Medical boundary not found in TASKS.md"
    exit 1
fi

echo "All tests passed for family-care-os"
