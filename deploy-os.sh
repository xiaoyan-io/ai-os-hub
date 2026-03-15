#!/bin/bash
set -euo pipefail

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Deploy an AI OS template with one command.

OPTIONS:
    --category CATEGORY      Template category (company, sales, construction, personal)
    --os OS_NAME             OS template name
    --workspace PATH         Target workspace path (auto-generated if not specified)
    --node NODE              Node identifier (default: default)
    --telegram-token TOKEN   Telegram bot token
    --api-key KEY            API key for LLM
    --base-url URL           Base URL for API (default: https://api.openai.com/v1)
    --company-name NAME      Company name (for company templates)
    --family-name NAME       Family name (for personal/family templates)
    --language LANG          Language code (default: en)
    --port PORT              Gateway port (auto-assigned if not specified)
    --daemon                 Run as background daemon
    --help                   Show this help message

EXAMPLES:
    $0 --category personal --os family-care-os --family-name "My Family" --language zh \\
        --telegram-token "123456789:ABC..." --api-key "sk-..." --daemon

    $0 --category company --os alan-boss-os --company-name "Acme Inc" --node "alan" \\
        --telegram-token "123456789:ABC..." --api-key "sk-..." --port 8081

EOF
    exit 1
}

CATEGORY=""
OS_NAME=""
WORKSPACE=""
NODE="default"
TELEGRAM_TOKEN=""
API_KEY=""
BASE_URL="https://api.openai.com/v1"
COMPANY_NAME=""
FAMILY_NAME=""
LANGUAGE="en"
PORT=""
DAEMON=false

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
        --port)
            PORT="$2"
            shift 2
            ;;
        --daemon)
            DAEMON=true
            shift
            ;;
        --help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -z "$CATEGORY" ]] || [[ -z "$OS_NAME" ]] || [[ -z "$API_KEY" ]]; then
    echo "ERROR: --category, --os, and --api-key are required"
    usage
fi

# Auto-generate workspace path if not specified
if [[ -z "$WORKSPACE" ]]; then
    WORKSPACE="/root/workspace-$(echo "$CATEGORY-$OS_NAME" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g')"
    echo "Auto-generating workspace: $WORKSPACE"
fi

if [[ -d "$WORKSPACE" ]]; then
    echo "ERROR: workspace already exists: $WORKSPACE"
    echo "Remove it first or specify a different path"
    exit 1
fi

echo "Installing OS template: $CATEGORY/$OS_NAME"
bash /root/ai-os-hub/installers/install-os.sh \
    --category "$CATEGORY" \
    --os "$OS_NAME" \
    --workspace "$WORKSPACE" \
    --node "$NODE" \
    --telegram-token "$TELEGRAM_TOKEN" \
    --api-key "$API_KEY" \
    --base-url "$BASE_URL" \
    --company-name "$COMPANY_NAME" \
    --family-name "$FAMILY_NAME" \
    --language "$LANGUAGE" \
    --skip-openclaw

echo "Installation complete!"

# Auto-assign port if not specified
if [[ -z "$PORT" ]]; then
    PORT=$(/root/ai-os-hub/run-workspace.sh --list 2>/dev/null | grep -E "tcp.*:(808[0-9]|809[0-9])" | awk '{print $5}' | cut -d':' -f2 | sort -nr | head -1)
    if [[ -z "$PORT" ]]; then
        PORT=8080
    else
        PORT=$((PORT + 1))
    fi
    # Validate port in range
    if [[ $PORT -lt 8080 || $PORT -gt 8099 ]]; then
        PORT=8080
    fi
    echo "Auto-assigning port: $PORT"
fi

echo "Starting agent: $WORKSPACE on port: $PORT"
if [[ "$DAEMON" == "true" ]]; then
    /root/ai-os-hub/run-workspace.sh --workspace "$WORKSPACE" --port "$PORT" --daemon
else
    echo "Access gateway at: http://localhost:$PORT"
    /root/ai-os-hub/run-workspace.sh --workspace "$WORKSPACE" --port "$PORT"
fi