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

test_role_directory() {
    if [[ -z "$ROLE" ]]; then
        return
    fi
    echo -n "Testing role directory exists ($ROLE): "
    if [[ -d "$WORKSPACE/$ROLE" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_role_soul() {
    if [[ -z "$ROLE" ]]; then
        return
    fi
    echo -n "Testing $ROLE/SOUL.md exists: "
    if [[ -f "$WORKSPACE/$ROLE/SOUL.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_role_identity() {
    if [[ -z "$ROLE" ]]; then
        return
    fi
    echo -n "Testing $ROLE/IDENTITY.md exists: "
    if [[ -f "$WORKSPACE/$ROLE/IDENTITY.md" ]]; then
        echo "PASS"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "FAIL"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

test_role_tasks() {
    if [[ -z "$ROLE" ]]; then
        return
    fi
    echo -n "Testing $ROLE/TASKS.md exists: "
    if [[ -f "$WORKSPACE/$ROLE/TASKS.md" ]]; then
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
echo "Workspace: $WORKSPACE"
[[ -n "$ROLE" ]] && echo "Role: $ROLE"
echo ""

test_workspace_exists
test_generated_env

if [[ -n "$ROLE" ]]; then
    test_role_directory
    test_role_soul
    test_role_identity
    test_role_tasks
fi

echo ""
echo "========================================"
echo "  Results: $TESTS_PASSED passed, $TESTS_FAILED failed"
echo "========================================"

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi

exit 0
