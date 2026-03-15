#!/bin/bash
set -euo pipefail

echo "Testing site-report-os workflow..."

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

# Check site_manager role files
for f in IDENTITY.md SOUL.md TASKS.md; do
    if [[ -f "$WORKSPACE/site_manager/$f" ]]; then
        echo "PASS: site_manager/$f exists"
    else
        echo "FAIL: site_manager/$f not found"
        exit 1
    fi
done

# Check inspector role files
for f in IDENTITY.md SOUL.md TASKS.md; do
    if [[ -f "$WORKSPACE/inspector/$f" ]]; then
        echo "PASS: inspector/$f exists"
    else
        echo "FAIL: inspector/$f not found"
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

echo "All tests passed for site-report-os"
