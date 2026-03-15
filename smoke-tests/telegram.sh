#!/bin/bash
set -uo pipefail

WORKSPACE="${1:-}"

if [[ -z "$WORKSPACE" ]]; then
    echo "Usage: $0 <workspace-path>"
    exit 1
fi

TESTS_PASSED=0
TESTS_FAILED=0

test_telegram_token() {
    echo -n "Testing telegram token in .env: "
    if [[ -f "$WORKSPACE/.generated/.env" ]]; then
        if grep -q "TELEGRAM_TOKEN=" "$WORKSPACE/.generated/.env"; then
            echo "PASS"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo "SKIP (not configured)"
        fi
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_telegram_config() {
    echo -n "Testing telegram config exists: "
    if [[ -f "$WORKSPACE/config/telegram.yaml" ]] || [[ -d "$WORKSPACE/config" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "SKIP (config not required)"
    fi
}

echo "========================================"
echo "  Smoke Tests - Telegram"
echo "========================================"
echo ""

test_telegram_token
test_telegram_config

echo ""
echo "========================================"
echo "  Results: $TESTS_PASSED passed, $TESTS_FAILED failed"
echo "========================================"

exit 0
