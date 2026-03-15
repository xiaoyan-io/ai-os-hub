#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUB_ROOT="$(dirname "$SCRIPT_DIR")"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/render-config.sh"

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Install an AI OS template to a workspace.

OPTIONS:
    --category CATEGORY      Template category (company, sales, construction, personal)
    --os OS_NAME             OS template name
    --workspace PATH         Target workspace path
    --node NODE              Node identifier (default: default)
    --telegram-token TOKEN   Telegram bot token
    --api-key KEY            API key
    --base-url URL           Base URL for API
    --company-name NAME      Company name
    --family-name NAME       Family name
    --language LANG          Language code (default: en)
    --skip-openclaw          Skip OpenClaw installation
    -h, --help               Show this help message

EXAMPLES:
    $0 --category company --os boss-secretary-os --workspace /root/workspace-test --node default --company-name "My Company" --language en

EOF
    exit 1
}

CATEGORY=""
OS_NAME=""
WORKSPACE=""
NODE="default"
TELEGRAM_TOKEN=""
API_KEY=""
BASE_URL=""
COMPANY_NAME=""
FAMILY_NAME=""
LANGUAGE="en"
SKIP_OPENCLAW=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --category)
            CATEGORY="$2"
            shift 2
            ;;
        --os)
            OS_NAME="$2"
            shift 2
            ;;
        --workspace)
            WORKSPACE="$2"
            shift 2
            ;;
        --node)
            NODE="$2"
            shift 2
            ;;
        --telegram-token)
            TELEGRAM_TOKEN="$2"
            shift 2
            ;;
        --api-key)
            API_KEY="$2"
            shift 2
            ;;
        --base-url)
            BASE_URL="$2"
            shift 2
            ;;
        --company-name)
            COMPANY_NAME="$2"
            shift 2
            ;;
        --family-name)
            FAMILY_NAME="$2"
            shift 2
            ;;
        --language)
            LANGUAGE="$2"
            shift 2
            ;;
        --skip-openclaw)
            SKIP_OPENCLAW=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$CATEGORY" ]] || [[ -z "$OS_NAME" ]] || [[ -z "$WORKSPACE" ]]; then
    echo "ERROR: --category, --os, and --workspace are required" >&2
    usage
fi

log_info "Checking dependencies..."
check_dependencies

log_info "Validating OS template: $CATEGORY/$OS_NAME"
validate_os_exists "$CATEGORY" "$OS_NAME"

TEMPLATE_PATH=$(get_template_path "$CATEGORY" "$OS_NAME")

log_info "Creating workspace: $WORKSPACE"
mkdir -p "$WORKSPACE"

if [[ -d "$TEMPLATE_PATH/files" ]]; then
    log_info "Copying template files..."
    cp -r "$TEMPLATE_PATH/files"/* "$WORKSPACE/" 2>/dev/null || true
fi

log_info "Generating configuration..."
generate_env_file "$WORKSPACE" "$NODE" "$TELEGRAM_TOKEN" "$API_KEY" "$BASE_URL" "$COMPANY_NAME" "$FAMILY_NAME" "$LANGUAGE" "$CATEGORY" "$OS_NAME"

log_info "Rendering placeholders..."
render_placeholders "$TEMPLATE_PATH" "$WORKSPACE" "$COMPANY_NAME" "$FAMILY_NAME" "$NODE" "$LANGUAGE"

if [[ "$SKIP_OPENCLAW" == "false" ]]; then
    if ! command -v openclaw &> /dev/null; then
        log_info "Installing OpenClaw..."
        curl -fsSL https://openclaw.ai/install.sh | bash
    fi
fi

log_success "Installation complete!"
log_info "Workspace: $WORKSPACE"
log_info "OS: $CATEGORY/$OS_NAME"
log_info "Node: $NODE"
log_info "Language: $LANGUAGE"
