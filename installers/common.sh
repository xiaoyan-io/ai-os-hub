#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUB_ROOT="$(dirname "$SCRIPT_DIR")"

check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        echo "ERROR: Required command '$cmd' not found" >&2
        return 1
    fi
    return 0
}

check_dependencies() {
    local deps=("bash" "git" "curl" "sed" "find")
    for dep in "${deps[@]}"; do
        check_command "$dep" || return 1
    done
    return 0
}

get_template_path() {
    local category="$1"
    local os_name="$2"
    echo "$HUB_ROOT/templates/$category/$os_name"
}

validate_os_exists() {
    local category="$1"
    local os_name="$2"
    local template_path
    template_path=$(get_template_path "$category" "$os_name")
    
    if [[ ! -d "$template_path" ]]; then
        echo "ERROR: OS template not found: $category/$os_name" >&2
        return 1
    fi
    
    if [[ ! -f "$template_path/os.yaml" ]]; then
        echo "ERROR: os.yaml not found in template: $category/$os_name" >&2
        return 1
    fi
    
    return 0
}

backup_existing() {
    local path="$1"
    if [[ -e "$path" ]]; then
        local backup="${path}.bak"
        local counter=1
        while [[ -e "$backup" ]]; do
            backup="${path}.bak.$counter"
            ((counter++))
        done
        mv "$path" "$backup"
        echo "Backed up existing file to: $backup"
    fi
}

log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

log_success() {
    echo "[SUCCESS] $*"
}
