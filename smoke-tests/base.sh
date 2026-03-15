#!/bin/bash
set -uo pipefail

WORKSPACE="${1:-}"

if [[ -z "$WORKSPACE" ]]; then
    echo "Usage: $0 <workspace-path>"
    echo "Example: $0 /root/workspace-test-boss"
    exit 1
fi

TESTS_PASSED=0
TESTS_FAILED=0

test_workspace_exists() {
    echo -n "Testing workspace exists: "
    if [[ -d "$WORKSPACE" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_generated_env() {
    echo -n "Testing .generated/.env exists: "
    if [[ -f "$WORKSPACE/.generated/.env" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_personas_directory() {
    echo -n "Testing personas directory exists: "
    if [[ -d "$WORKSPACE/personas" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_config_directory() {
    echo -n "Testing config directory exists: "
    if [[ -d "$WORKSPACE/config" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_readme_exists() {
    echo -n "Testing README.md exists: "
    if [[ -f "$WORKSPACE/README.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo "========================================"
echo "  Smoke Tests - Base"
echo "========================================"
echo ""

test_workspace_exists
test_generated_env
test_personas_directory
test_config_directory
test_readme_exists

echo ""
echo "========================================"
echo "  Results: $TESTS_PASSED passed, $TESTS_FAILED failed"
echo "========================================"

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi

exit 0
