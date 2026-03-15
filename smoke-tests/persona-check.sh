#!/bin/bash
set -uo pipefail

WORKSPACE="${1:-}"

if [[ -z "$WORKSPACE" ]]; then
    echo "Usage: $0 <workspace-path>"
    exit 1
fi

TESTS_PASSED=0
TESTS_FAILED=0

test_soul_md() {
    echo -n "Testing SOUL.md exists: "
    if [[ -f "$WORKSPACE/SOUL.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_identity_md() {
    echo -n "Testing IDENTITY.md exists: "
    if [[ -f "$WORKSPACE/IDENTITY.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_tasks_md() {
    echo -n "Testing TASKS.md exists: "
    if [[ -f "$WORKSPACE/TASKS.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_persona_files() {
    echo -n "Testing persona files exist: "
    local persona_count
    persona_count=$(find "$WORKSPACE/personas" "$WORKSPACE/files/personas" -name "*.yaml" 2>/dev/null | wc -l)
    if [[ $persona_count -gt 0 ]]; then
        echo "PASS ($persona_count personas found)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo "========================================"
echo "  Smoke Tests - Persona Check"
echo "========================================"
echo ""

test_soul_md
test_identity_md
test_tasks_md
test_persona_files

echo ""
echo "========================================"
echo "  Results: $TESTS_PASSED passed, $TESTS_FAILED failed"
echo "========================================"

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi

exit 0
