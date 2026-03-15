#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if --direct flag is used
if [[ "$*" == *"--direct"* ]]; then
    # Remove --direct flag and forward remaining arguments to install-os.sh
    ARGS=()
    while [[ $# -gt 0 ]]; do
        case $1 in
            --direct)
                shift
                ;;
            *)
                ARGS+=("$1")
                shift
                ;;
        esac
    done
    bash "$SCRIPT_DIR/installers/install-os.sh" "${ARGS[@]}"
else
    # Default to interactive menu
    bash "$SCRIPT_DIR/installers/menu-install.sh" "$@"
fi
