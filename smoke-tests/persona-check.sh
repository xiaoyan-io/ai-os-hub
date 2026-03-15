#!/bin/bash
set -uo pipefail

WORKSPACE=""
ROLE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --workspace)
            WORKSPACE="$2"
            shift 2
            ;;
        --role)
            ROLE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 --workspace <path> --role <role-name>"
            echo "Example: $0 --workspace /root/workspace-test-boss --role boss"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$WORKSPACE" ]]; then
    echo "ERROR: --workspace is required"
    exit 1
fi

if [[ -z "$ROLE" ]]; then
    echo "ERROR: --role is required"
    exit 1
fi

TESTS_PASSED=0
TESTS_FAILED=0

test_soul_md() {
    echo -n "Testing $ROLE/SOUL.md exists: "
    if [[ -f "$WORKSPACE/$ROLE/SOUL.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_identity_md() {
    echo -n "Testing $ROLE/IDENTITY.md exists: "
    if [[ -f "$WORKSPACE/$ROLE/IDENTITY.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_tasks_md() {
    echo -n "Testing $ROLE/TASKS.md exists: "
    if [[ -f "$WORKSPACE/$ROLE/TASKS.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_persona_files() {
    echo -n "Testing persona yaml files exist: "
    local persona_count
    persona_count=$(find "$WORKSPACE/personas" -name "*.yaml" 2>/dev/null | wc -l)
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
echo "Workspace: $WORKSPACE"
echo "Role: $ROLE"
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
