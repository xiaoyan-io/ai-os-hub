#!/bin/bash
set -euo pipefail

echo "=== AI OS Hub End-to-End Test ==="
echo ""

# Check prerequisites
command -v bash >/dev/null 2>&1 || { echo "ERROR: bash not found"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "ERROR: git not found"; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "ERROR: curl not found"; exit 1; }

# Create temporary workspace
WORKSPACE=$(mktemp -d)
echo "Created temporary workspace: $WORKSPACE"

# Test installation
echo ""
echo "1. Testing installation..."
bash ./install.sh --direct \
  --category personal \
  --os personal-os \
  --workspace "$WORKSPACE" \
  --node test \
  --language en \
  --skip-openclaw

if [[ ! -f "$WORKSPACE/.generated/.env" ]]; then
    echo "ERROR: .env file not generated"
    exit 1
fi

if [[ ! -f "$WORKSPACE/personal/SOUL.md" ]]; then
    echo "ERROR: personal/SOUL.md not copied"
    exit 1
fi

echo "✓ Installation successful"

# Test smoke tests
echo ""
echo "2. Testing smoke tests..."
bash ./smoke-tests/base.sh --workspace "$WORKSPACE" --role personal
echo "✓ Smoke tests passed"

# Test run-workspace detection
echo ""
echo "3. Testing workspace detection..."
bash ./run-workspace.sh --list
echo "✓ Workspace detection works"

# Clean up
rm -rf "$WORKSPACE"
echo ""
echo "✓ All end-to-end tests passed!"
echo "Workspace cleaned up: $WORKSPACE"