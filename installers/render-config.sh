#!/bin/bash
set -euo pipefail

render_placeholders() {
    local source_dir="$1"
    local target_dir="$2"
    local company_name="${3:-}"
    local family_name="${4:-}"
    local node_name="${5:-sg2}"
    local language="${6:-en}"
    
    find "$target_dir" -type f \( -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.sh" -o -name "*.txt" -o -name "*.env" \) 2>/dev/null | while read -r file; do
        local content
        content=$(cat "$file")
        
        if [[ -n "$company_name" ]]; then
            content=$(echo "$content" | sed "s|{{COMPANY_NAME}}|$company_name|g")
        fi
        if [[ -n "$family_name" ]]; then
            content=$(echo "$content" | sed "s|{{FAMILY_NAME}}|$family_name|g")
        fi
        content=$(echo "$content" | sed "s|{{NODE_NAME}}|$node_name|g")
        content=$(echo "$content" | sed "s|{{LANGUAGE}}|$language|g")
        
        echo "$content" > "$file"
    done
}

generate_env_file() {
    local target_dir="$1"
    local node_name="${2:-sg2}"
    local telegram_token="${3:-}"
    local api_key="${4:-}"
    local base_url="${5:-}"
    local company_name="${6:-}"
    local family_name="${7:-}"
    local language="${8:-en}"
    local category="${9:-}"
    local os_id="${10:-}"
    
    local generated_dir="$target_dir/.generated"
    mkdir -p "$generated_dir"
    
    cat > "$generated_dir/.env" << EOF
NODE_NAME=$node_name
TELEGRAM_TOKEN=$telegram_token
OPENAI_API_KEY=$api_key
OPENAI_BASE_URL=$base_url
COMPANY_NAME=$company_name
FAMILY_NAME=$family_name
LANGUAGE=$language
CATEGORY=$category
OS_ID=$os_id
EOF
}
