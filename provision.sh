#!/bin/bash

# AI OS Agent Provisioning Script
# This script initializes local memory and user profiles from templates.

set -e

PROJECT_ROOT=$(pwd)
LOG_FILE="$PROJECT_ROOT/provision.log"

echo "Starting AI OS Agent Provisioning..." | tee $LOG_FILE

# Find all directories that contain .template.md files
TEMPLATES=$(find categories -name "*.template.md")

for template in $TEMPLATES; do
    # Define target filename by removing .template
    target="${template/.template/}"
    
    if [ ! -f "$target" ]; then
        echo "[INIT] Creating $target from $(basename $template)" | tee -a $LOG_FILE
        cp "$template" "$target"
        # Optional: Replace basic placeholders if defined in registry
        # sed -i "s/__AI_NAME__/家安/g" "$target"
    else
        echo "[SKIP] $target already exists. Skipping to protect existing memory." | tee -a $LOG_FILE
    fi
done

# Ensure USER.md exists for all active agents
AGENT_DIRS=$(find categories -name "IDENTITY.md" | xargs -n1 dirname)

for dir in $AGENT_DIRS; do
    if [ ! -f "$dir/USER.md" ]; then
        if [ -f "$dir/USER.template.md" ]; then
            echo "[INIT] Initializing USER.md in $dir" | tee -a $LOG_FILE
            cp "$dir/USER.template.md" "$dir/USER.md"
        fi
    fi
done

echo "Provisioning Complete. See $LOG_FILE for details." | tee -a $LOG_FILE
chmod +x "$PROJECT_ROOT/provision.sh"
