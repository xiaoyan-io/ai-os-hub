#!/bin/bash
set -euo pipefail

USAGE="Usage: $0 <workspace_path> [openclaw_port]"

WORKSPACE="${1:-}"
PORT="${2:-8080}"

if [[ -z "$WORKSPACE" ]]; then
    echo "ERROR: workspace path required"
    echo "$USAGE"
    exit 1
fi

if [[ ! -d "$WORKSPACE" ]]; then
    echo "ERROR: workspace not found: $WORKSPACE"
    exit 1
fi

# Auto-detect OpenClaw binary
OPENCLAW_BIN=$(find /root/.nvm/versions/node/v24.13.1/lib/node_modules/openclaw -name "openclaw.mjs" -type f | head -1)
if [[ -z "$OPENCLAW_BIN" ]]; then
    echo "ERROR: openclaw.mjs not found"
    exit 1
fi

# Export PATH
export PATH="/root/.nvm/versions/node/v24.13.1/bin:$PATH"

# Load credentials from .generated/.env
ENV_FILE="$WORKSPACE/.generated/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    echo "ERROR: .env file not found: $ENV_FILE"
    exit 1
fi
source "$ENV_FILE"

# Extract OS info for display
OS_NAME=$(basename "$(dirname "$WORKSPACE")")
echo "Starting OS: $OS_NAME in workspace: $(basename "$WORKSPACE")"
echo "Family/Company: ${FAMILY_NAME:-$(echo $COMPANY_NAME)}"
echo "Language: $LANGUAGE"
echo "Node: $NODE_NAME"
[[ -n "$TELEGRAM_TOKEN" ]] && echo "Telegram: enabled"
[[ -n "$OPENAI_API_KEY" ]] && echo "API: $OPENAI_BASE_URL"
echo ""

# Configure API provider
if [[ -n "$OPENAI_API_KEY" && -n "$OPENAI_BASE_URL" ]]; then
    echo "[1/4] Configuring API provider..."
    node "$OPENCLAW_BIN" config set "providers.openai.baseUrl=$OPENAI_BASE_URL" 2>/dev/null
    node "$OPENCLAW_BIN" config set "providers.openai.apiKey=$OPENAI_API_KEY" 2>/dev/null
fi

# Configure Telegram if token exists
if [[ -n "$TELEGRAM_TOKEN" ]]; then
    echo "[2/4] Checking Telegram channel..."
    if ! node "$OPENCLAW_BIN" channels list 2>/dev/null | grep -q "Telegram"; then
        echo "Adding Telegram channel..."
        node "$OPENCLAW_BIN" channels add --channel telegram --token "$TELEGRAM_TOKEN" --account default 2>/dev/null
    fi
fi

# Create agent using workspace basename as agent name
AGENT_NAME=$(basename "$WORKSPACE" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]')
echo "[3/4] Checking agent: $AGENT_NAME..."

if ! node "$OPENCLAW_BIN" agents list 2>/dev/null | grep -q "$AGENT_NAME"; then
    echo "Creating agent: $AGENT_NAME..."
    
    # Determine channel bindings
    BINDINGS="default"
    if [[ -n "$TELEGRAM_TOKEN" ]]; then
        BINDINGS="telegram:default"
    fi
    
    node "$OPENCLAW_BIN" agents add "$AGENT_NAME" \
        --workspace "$WORKSPACE" \
        --bind "$BINDINGS" \
        --non-interactive 2>/dev/null
fi

# Start gateway
echo "[4/4] Starting OpenClaw gateway on port $PORT..."
echo "Agent is ready! Press Ctrl+C to stop."
exec node "$OPENCLAW_BIN" gateway --port "$PORT"