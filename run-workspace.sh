#!/bin/bash
set -euo pipefail

OPENCLAW_BIN=$(find /root/.nvm/versions/node/v24.13.1/lib/node_modules/openclaw -name "openclaw.mjs" -type f | head -1)
if [[ -z "$OPENCLAW_BIN" ]]; then
    echo "ERROR: openclaw.mjs not found"
    exit 1
fi

export PATH="/root/.nvm/versions/node/v24.13.1/bin:$PATH"

SHOW_ONLY=false
WORKSPACE=""
PORT=""
DAEMON=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --list|-l)
            SHOW_ONLY=true
            shift
            ;;
        --workspace|-w)
            WORKSPACE="$2"
            shift 2
            ;;
        --port|-p)
            PORT="$2"
            shift 2
            ;;
        --daemon|-d)
            DAEMON=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo "  --list, -l           Show available workspaces only"
            echo "  --workspace PATH, -w PATH   Specify workspace to run"
            echo "  --port PORT, -p PORT   Specify gateway port (auto if not set)"
            echo "  --daemon, -d          Run in background as daemon"
            echo "  --help, -h            Show this help"
            echo ""
            echo "Without --workspace, launches interactive picker."
            echo "Ports auto-assigned if not specified (8080->8099 range)."
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Find available port starting from 8080
find_available_port() {
    local start_port=${1:-8080}
    local end_port=${2:-8099}
    
    for port in $(seq $start_port $end_port); do
        if ! ss -tuln | grep -q ":$port "; then
            echo $port
            return
        fi
    done
    
    echo "ERROR: No available ports in range $start_port-$end_port" >&2
    exit 1
}

# Auto-detect workspaces
echo "Detecting workspaces..."
declare -A WORKSPACES

for env_file in /root/workspace-*/.generated/.env /home/*/workspace-*/.generated/.env /opt/*/workspace-*/.generated/.env; do
    [[ -f "$env_file" ]] || continue
    ws_dir=$(dirname "$(dirname "$env_file")")
    os_id=$(grep "^OS_ID=" "$env_file" | cut -d'=' -f2 || echo "unknown")
    family_or_company=$(grep "^FAMILY_NAME=\|^COMPANY_NAME=" "$env_file" | head -1 | cut -d'=' -f2 || echo "unknown")
    lang=$(grep "^LANGUAGE=" "$env_file" | cut -d'=' -f2 || echo "unknown")
    
    WORKSPACES["$ws_dir"]="$os_id | $family_or_company | $lang"
done

if [[ ${#WORKSPACES[@]} -eq 0 ]]; then
    echo "No workspaces found with .env files"
    echo "Expected pattern: */workspace-*/.generated/.env"
    exit 1
fi

if [[ "$SHOW_ONLY" == "true" ]]; then
    echo "Available workspaces:"
    for ws in "${!WORKSPACES[@]}"; do
        echo "  $ws -> ${WORKSPACES[$ws]}"
    done
    exit 0
fi

if [[ -n "$WORKSPACE" ]]; then
    if [[ ! -d "$WORKSPACE" ]]; then
        echo "ERROR: workspace not found: $WORKSPACE"
        exit 1
    fi
    TARGET_WS="$WORKSPACE"
else
    # Interactive selection
    echo "Available workspaces:"
    ws_list=()
    i=1
    for ws in "${!WORKSPACES[@]}"; do
        ws_list+=("$ws")
        echo "  $i) $ws -> ${WORKSPACES[$ws]}"
        ((i++))
    done
    
    echo ""
    read -p "Select workspace (1-${#ws_list[@]}): " selection
    if ! [[ "$selection" =~ ^[1-${#ws_list[@]}]$ ]]; then
        echo "Invalid selection"
        exit 1
    fi
    
    TARGET_WS="${ws_list[$((selection-1))]}"
fi

# Determine port
if [[ -z "$PORT" ]]; then
    PORT=$(find_available_port)
    echo "Auto-assigning port: $PORT"
else
    if ss -tuln | grep -q ":$PORT "; then
        echo "ERROR: Port $PORT already in use"
        exit 1
    fi
fi

# Update status file for dashboard
update_status() {
    local ws_path="$1"
    local port="$2"
    local pid="$3"
    local status_file="/root/ai-os-hub/status.json"
    
    # Simple JSON append/update using temporary file
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local ws_name=$(basename "$ws_path")
    
    # If file doesn't exist, create it
    if [[ ! -f "$status_file" ]]; then
        echo "{\"instances\": {}}" > "$status_file"
    fi
    
    # Use python for safer JSON manipulation if available, otherwise just use a simple placeholder
    # For now, let's use a robust temporary file method
    cat "$status_file" | python3 -c "
import sys, json
data = json.load(sys.stdin)
data['instances']['$ws_name'] = {
    'path': '$ws_path',
    'port': $port,
    'pid': $pid,
    'startTime': '$timestamp',
    'status': 'running'
}
json.dump(data, sys.stdout, indent=2)
" > "${status_file}.tmp" && mv "${status_file}.tmp" "$status_file"
}

echo "Launching workspace: $TARGET_WS on port $PORT"

if [[ "$DAEMON" == "true" ]]; then
    LOG_FILE="/tmp/openclaw-$(basename "$TARGET_WS").log"
    echo "Running as daemon, logging to: $LOG_FILE"
    nohup /root/ai-os-hub/installers/start-os.sh "$TARGET_WS" "$PORT" > "$LOG_FILE" 2>&1 &
    PID=$!
    echo "Started PID: $PID"
    update_status "$TARGET_WS" "$PORT" "$PID"
    echo "Access gateway at: http://localhost:$PORT"
else
    # Update status for foreground too (though PID will change if exec is used)
    update_status "$TARGET_WS" "$PORT" "$$"
    exec /root/ai-os-hub/installers/start-os.sh "$TARGET_WS" "$PORT"
fi
