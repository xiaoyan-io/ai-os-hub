#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUB_ROOT="$(dirname "$SCRIPT_DIR")"
REGISTRY_FILE="$HUB_ROOT/registry.yaml"

parse_yaml() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Registry file not found: $file" >&2
        return 1
    fi
    
    awk '
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

print_header() {
    echo ""
    echo "========================================"
    echo "  AI OS Hub - Interactive Installer"
    echo "========================================"
    echo ""
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
            echo "  $count) $name ($id)"
            cat_map[$count]="$id"
            ((count++))
        fi
    done <<< "$categories"
    
    while true; do
        echo ""
        echo -n "Select category [1]: "
        read -r sel
        
        if [[ -z "$sel" ]]; then
            sel=1
        fi
        
        if [[ "$sel" =~ ^[0-9]+$ ]] && [[ -n "${cat_map[$sel]}" ]]; then
            SELECTED_CATEGORY="${cat_map[$sel]}"
            return 0
        fi
        
        echo "Invalid selection. Please try again."
    done
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
            echo "  $count) $name ($id)"
            os_map[$count]="$id"
            ((count++))
        fi
    done <<< "$templates"
    
    while true; do
        echo ""
        echo -n "Select OS [1]: "
        read -r sel
        
        if [[ -z "$sel" ]]; then
            sel=1
        fi
        
        if [[ "$sel" =~ ^[0-9]+$ ]] && [[ -n "${os_map[$sel]}" ]]; then
            SELECTED_OS="${os_map[$sel]}"
            return 0
        fi
        
        echo "Invalid selection. Please try again."
    done
}

prompt_workspace() {
    while true; do
        echo ""
        echo -n "Workspace path: "
        read -r WORKSPACE
        
        if [[ -n "$WORKSPACE" ]]; then
            return 0
        fi
        
        echo "Workspace path is required. Please try again."
    done
}

prompt_node() {
    local default_node
    default_node=$(hostname)
    
    echo ""
    echo -n "Node name [$default_node]: "
    read -r NODE
    
    if [[ -z "$NODE" ]]; then
        NODE="$default_node"
    fi
}

prompt_company_name() {
    while true; do
        echo ""
        echo -n "Company name: "
        read -r COMPANY_NAME
        
        if [[ -n "$COMPANY_NAME" ]]; then
            return 0
        fi
        
        echo "Company name is required for company templates. Please try again."
    done
}

prompt_family_name() {
    while true; do
        echo ""
        echo -n "Family name: "
        read -r FAMILY_NAME
        
        if [[ -n "$FAMILY_NAME" ]]; then
            return 0
        fi
        
        echo "Family name is required for family-care templates. Please try again."
    done
}

prompt_language() {
    local default_lang="en"
    
    echo ""
    echo -n "Language code [$default_lang]: "
    read -r LANGUAGE
    
    if [[ -z "$LANGUAGE" ]]; then
        LANGUAGE="$default_lang"
    fi
}

prompt_optional_fields() {
    local input
    echo ""
    echo "Optional Configuration (press Enter to skip each):"
    echo "-----------------------------------------------"
    
    echo -n "Telegram token: "
    read -r input
    [[ -n "$input" ]] && TELEGRAM_TOKEN="$input"
    
    echo -n "API key: "
    read -r input
    [[ -n "$input" ]] && API_KEY="$input"
    
    echo -n "Base URL: "
    read -r input
    [[ -n "$input" ]] && BASE_URL="$input"
}

print_summary() {
    echo ""
    echo "========================================"
    echo "  Installation Summary"
    echo "========================================"
    echo "  Category:    $SELECTED_CATEGORY"
    echo "  OS:          $SELECTED_OS"
    echo "  Workspace:   $WORKSPACE"
    echo "  Node:        $NODE"
    echo "  Language:    $LANGUAGE"
    
    if [[ -n "${COMPANY_NAME:-}" ]]; then
        echo "  Company:     $COMPANY_NAME"
    fi
    if [[ -n "${FAMILY_NAME:-}" ]]; then
        echo "  Family:      $FAMILY_NAME"
    fi
    if [[ -n "${TELEGRAM_TOKEN:-}" ]]; then
        echo "  Telegram:    configured"
    fi
    if [[ -n "${API_KEY:-}" ]]; then
        echo "  API Key:     configured"
    fi
    if [[ -n "${BASE_URL:-}" ]]; then
        echo "  Base URL:    $BASE_URL"
    fi
    
    echo "========================================"
}

confirm_install() {
    local confirm
    while true; do
        echo ""
        echo -n "Proceed with installation? [Y/n]: "
        read -r confirm
        
        if [[ "$confirm" =~ ^[Yy]$ ]] || [[ -z "$confirm" ]]; then
            return 0
        elif [[ "$confirm" =~ ^[Nn]$ ]]; then
            echo "Installation cancelled."
            exit 0
        fi
        
        echo "Please enter Y or n."
    done
}

main() {
    print_header
    
    select_category
    select_os "$SELECTED_CATEGORY"
    prompt_workspace
    prompt_node
    
    if [[ "$SELECTED_CATEGORY" == "company" ]]; then
        prompt_company_name
    elif [[ "$SELECTED_CATEGORY" == "personal" ]]; then
        if [[ "$SELECTED_OS" == *"family"* ]]; then
            prompt_family_name
        fi
    fi
    
    prompt_language
    prompt_optional_fields
    
    print_summary
    confirm_install
    
    local args=(
        "--category" "$SELECTED_CATEGORY"
        "--os" "$SELECTED_OS"
        "--workspace" "$WORKSPACE"
        "--node" "$NODE"
        "--language" "$LANGUAGE"
        "--skip-openclaw"
    )
    
    [[ -n "${COMPANY_NAME:-}" ]] && args+=("--company-name" "$COMPANY_NAME")
    [[ -n "${FAMILY_NAME:-}" ]] && args+=("--family-name" "$FAMILY_NAME")
    [[ -n "${TELEGRAM_TOKEN:-}" ]] && args+=("--telegram-token" "$TELEGRAM_TOKEN")
    [[ -n "${API_KEY:-}" ]] && args+=("--api-key" "$API_KEY")
    [[ -n "${BASE_URL:-}" ]] && args+=("--base-url" "$BASE_URL")
    
    bash "$SCRIPT_DIR/install-os.sh" "${args[@]}"
}

main "$@"
