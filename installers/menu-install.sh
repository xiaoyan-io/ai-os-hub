#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUB_ROOT="$(dirname "$SCRIPT_DIR")"
REGISTRY_FILE="$HUB_ROOT/registry.yaml"

parse_yaml() {
    local file="$1"
    local prefix="$2"
    
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Registry file not found: $file" >&2
        return 1
    fi
    
    awk -v prefix="$prefix" '
    /^categories:/ { in_categories = 1; next }
    /^templates:/ { in_categories = 0; in_templates = 1; next }
    /^  - id:/ && in_categories {
        gsub(/^  - id: /, "");
        gsub(/"/, "");
        cat_id = $0
        next
    }
    /^    name:/ && in_categories {
        gsub(/^    name: /, "");
        gsub(/"/, "");
        printf "%s:%s\n", cat_id, $0
        next
    }
    /^  - id:/ && in_templates {
        gsub(/^  - id: /, "");
        gsub(/"/, "");
        tmpl_id = $0
        next
    }
    /^    category:/ && in_templates {
        gsub(/^    category: /, "");
        gsub(/"/, "");
        tmpl_cat = $0
        next
    }
    /^    name:/ && in_templates {
        gsub(/^    name: /, "");
        gsub(/"/, "");
        printf "tmpl:%s:%s:%s\n", tmpl_cat, tmpl_id, $0
        next
    }
    ' "$file"
}

select_category() {
    local categories
    categories=$(parse_yaml "$REGISTRY_FILE" | grep -v "^tmpl:" | sort)
    
    echo "Available Categories:"
    echo "---------------------"
    
    local count=1
    declare -A cat_map
    while IFS=: read -r id name; do
        if [[ -n "$id" ]]; then
            echo "$count) $name ($id)"
            cat_map[$count]="$id"
            ((count++))
        fi
    done <<< "$categories"
    
    echo ""
    echo -n "Select category [1]: "
    read -r sel
    
    if [[ -z "$sel" ]]; then
        sel=1
    fi
    
    SELECTED_CATEGORY="${cat_map[$sel]:-}"
    
    if [[ -z "$SELECTED_CATEGORY" ]]; then
        echo "Invalid selection" >&2
        return 1
    fi
}

select_os() {
    local category="$1"
    local templates
    templates=$(parse_yaml "$REGISTRY_FILE" | grep "^tmpl:$category:" | cut -d: -f3-)
    
    echo "Available OS Templates in '$category':"
    echo "----------------------------------------"
    
    local count=1
    declare -A os_map
    while IFS=: read -r id name; do
        if [[ -n "$id" ]]; then
            echo "$count) $name ($id)"
            os_map[$count]="$id"
            ((count++))
        fi
    done <<< "$templates"
    
    echo ""
    echo -n "Select OS [1]: "
    read -r sel
    
    if [[ -z "$sel" ]]; then
        sel=1
    fi
    
    SELECTED_OS="${os_map[$sel]:-}"
    
    if [[ -z "$SELECTED_OS" ]]; then
        echo "Invalid selection" >&2
        return 1
    fi
}

prompt_workspace() {
    echo -n "Workspace path: "
    read -r WORKSPACE
    
    if [[ -z "$WORKSPACE" ]]; then
        echo "Workspace is required" >&2
        return 1
    fi
}

prompt_node() {
    echo -n "Node name [sg2]: "
    read -r NODE
    
    if [[ -z "$NODE" ]]; then
        NODE="sg2"
    fi
}

prompt_company_name() {
    echo -n "Company name: "
    read -r COMPANY_NAME
}

prompt_family_name() {
    echo -n "Family name: "
    read -r FAMILY_NAME
}

prompt_telegram_token() {
    echo -n "Telegram token (optional): "
    read -r TELEGRAM_TOKEN
}

prompt_api_key() {
    echo -n "API key (optional): "
    read -r API_KEY
}

prompt_base_url() {
    echo -n "Base URL (optional): "
    read -r BASE_URL
}

prompt_language() {
    echo -n "Language code [en]: "
    read -r LANGUAGE
    
    if [[ -z "$LANGUAGE" ]]; then
        LANGUAGE="en"
    fi
}

main() {
    echo "========================================"
    echo "  AI OS Hub - Interactive Installer"
    echo "========================================"
    echo ""
    
    select_category
    echo ""
    
    select_os "$SELECTED_CATEGORY"
    echo ""
    
    prompt_workspace
    prompt_node
    
    if [[ "$SELECTED_CATEGORY" == "company" ]]; then
        prompt_company_name
    elif [[ "$SELECTED_CATEGORY" == "personal" ]]; then
        if [[ "$SELECTED_OS" == "family-care-os" ]]; then
            prompt_family_name
        fi
    fi
    
    prompt_telegram_token
    prompt_api_key
    prompt_base_url
    prompt_language
    
    echo ""
    echo "========================================"
    echo "  Installation Summary"
    echo "========================================"
    echo "Category:    $SELECTED_CATEGORY"
    echo "OS:          $SELECTED_OS"
    echo "Workspace:   $WORKSPACE"
    echo "Node:        $NODE"
    [[ -n "$COMPANY_NAME" ]] && echo "Company:     $COMPANY_NAME"
    [[ -n "$FAMILY_NAME" ]] && echo "Family:      $FAMILY_NAME"
    echo "Language:    $LANGUAGE"
    echo "========================================"
    echo ""
    
    echo -n "Proceed with installation? [Y/n]: "
    read -r confirm
    
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    
    ARGS=(
        "--category" "$SELECTED_CATEGORY"
        "--os" "$SELECTED_OS"
        "--workspace" "$WORKSPACE"
        "--node" "$NODE"
        "--language" "$LANGUAGE"
        "--skip-openclaw"
    )
    
    [[ -n "$COMPANY_NAME" ]] && ARGS+=("--company-name" "$COMPANY_NAME")
    [[ -n "$FAMILY_NAME" ]] && ARGS+=("--family-name" "$FAMILY_NAME")
    [[ -n "$TELEGRAM_TOKEN" ]] && ARGS+=("--telegram-token" "$TELEGRAM_TOKEN")
    [[ -n "$API_KEY" ]] && ARGS+=("--api-key" "$API_KEY")
    [[ -n "$BASE_URL" ]] && ARGS+=("--base-url" "$BASE_URL")
    
    bash "$SCRIPT_DIR/install-os.sh" "${ARGS[@]}"
}

main "$@"
