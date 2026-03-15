#!/bin/bash
set -euo pipefail

# Auto-detect OpenClaw binary
OPENCLAW_BIN=$(find /root/.nvm/versions/node/v24.13.1/lib/node_modules/openclaw -name "openclaw.mjs" -type f | head -1)
if [[ -z "$OPENCLAW_BIN" ]]; then
    echo "ERROR: openclaw.mjs not found"
    exit 1
fi
echo "Using OpenClaw: $OPENCLAW_BIN"

# Export PATH to make node available
export PATH="/root/.nvm/versions/node/v24.13.1/bin:$PATH"

# Define workspace
WORKSPACE="/root/workspace-family-care"
if [[ ! -d "$WORKSPACE" ]]; then
    echo "ERROR: workspace not found: $WORKSPACE"
    exit 1
fi

# Get credentials from .env
source "$WORKSPACE/.generated/.env"

echo "Starting family-care OS with:"
echo "- Family: $FAMILY_NAME"
echo "- Language: $LANGUAGE"
echo "- Telegram Bot: ${TELEGRAM_TOKEN:0:10}..."  # Show partial token
echo "- API Base: $OPENAI_BASE_URL"
echo ""

# Step 1: Configure API provider
echo "[1/4] Configuring API provider..."
node "$OPENCLAW_BIN" config set "providers.openai.baseUrl=$OPENAI_BASE_URL" 2>/dev/null
node "$OPENCLAW_BIN" config set "providers.openai.apiKey=$OPENAI_API_KEY" 2>/dev/null

# Step 2: Add Telegram channel if not exists
echo "[2/4] Checking Telegram channel..."
if ! node "$OPENCLAW_BIN" channels list 2>/dev/null | grep -q "Telegram"; then
    echo "Adding Telegram channel..."
    node "$OPENCLAW_BIN" channels add --channel telegram --token "$TELEGRAM_TOKEN" --account default 2>/dev/null
fi

# Step 3: Create family-care agent if not exists
echo "[3/4] Checking family-care agent..."
if ! node "$OPENCLAW_BIN" agents list 2>/dev/null | grep -q "family-care"; then
    echo "Creating family-care agent..."
    node "$OPENCLAW_BIN" agents add family-care \
        --workspace "$WORKSPACE" \
        --bind telegram:default \
        --non-interactive 2>/dev/null
fi

# Step 4: Start gateway
echo "[4/4] Starting OpenClaw gateway..."
echo "Agent is ready! You can now message your Telegram bot."
echo "Press Ctrl+C to stop."
exec node "$OPENCLAW_BIN" gateway --port 8080