# AI OS Hub v0.1

A collection of AI operating system templates for OpenClaw.

## Project Overview

AI OS Hub provides pre-built operating system templates for various use cases. Each template includes persona definitions, task configurations, and file structures needed to deploy a complete AI OS.

## Directory Structure

```
ai-os-hub/
├── categories/              # OS templates
│   ├── company/            # Company category templates
│   │   └── boss-secretary-os/
│   ├── sales/              # Sales category templates
│   │   └── chat-sales-os/
│   ├── construction/      # Construction category templates
│   │   └── site-report-os/
│   └── personal/           # Personal category templates
│       ├── personal-os/
│       └── family-care-os/
├── installers/             # Installation scripts
│   ├── common.sh          # Shared functions
│   ├── render-config.sh   # Template rendering
│   ├── install-os.sh      # Direct OS installer
│   └── menu-install.sh    # Interactive menu installer
├── smoke-tests/            # Test scripts
├── registry.yaml          # Template registry
└── README.md
```

## Template Directory Standard

Each OS template follows this structure:

```
<os-name>/
├── os.yaml           # OS definition (not copied to workspace)
├── files/            # Files copied to workspace
│   ├── <role-1>/
│   │   ├── SOUL.md
│   │   ├── IDENTITY.md
│   │   └── TASKS.md
│   ├── <role-2>/
│   │   ├── SOUL.md
│   │   ├── IDENTITY.md
│   │   └── TASKS.md
│   └── shared/
│       └── README.md
└── tests/            # Template tests
```

## Available OS Templates

### Company OS
- **boss-secretary-os**: Executive assistant system for boss-secretary workflow

### Sales OS
- **chat-sales-os**: AI-powered sales conversation system

### Construction OS
- **site-report-os**: Construction site reporting and documentation system

### Personal OS
- **personal-os**: Personal AI assistant for daily tasks
- **family-care-os**: Family health and care management system

## Installation

### Quick Install (install-os.sh)

Direct installation with parameters:

```bash
bash installers/install-os.sh \
  --category company \
  --os boss-secretary-os \
  --workspace /path/to/workspace \
  --node sg2 \
  --company-name "My Company" \
  --language en
```

Parameters:
- `--category`: Template category (company, sales, construction, personal)
- `--os`: OS template ID
- `--workspace`: Target workspace path
- `--node`: Node identifier (default: sg2)
- `--telegram-token`: Telegram bot token (optional)
- `--api-key`: OpenAI API key (optional)
- `--base-url`: Base URL for API (optional)
- `--company-name`: Company name (optional)
- `--family-name`: Family name (optional)
- `--language`: Language code (default: en)
- `--skip-openclaw`: Skip OpenClaw installation

### Interactive Install (menu-install.sh)

Menu-driven installation:

```bash
bash installers/menu-install.sh
```

## Workspace Output Structure

After installation, the workspace will have:

```
<workspace>/
├── .generated/
│   └── .env           # Environment variables
├── boss/              # Role directory
│   ├── SOUL.md
│   ├── IDENTITY.md
│   └── TASKS.md
├── secretary/         # Role directory
│   ├── SOUL.md
│   ├── IDENTITY.md
│   └── TASKS.md
└── shared/
    └── README.md
```

## Supported Placeholders

Templates support the following placeholders:
- `{{COMPANY_NAME}}` - Company name
- `{{FAMILY_NAME}}` - Family name
- `{{NODE_NAME}}` - Node identifier
- `{{LANGUAGE}}` - Language code

## Testing

Run smoke tests:

```bash
# Test workspace without role
bash smoke-tests/base.sh --workspace /path/to/workspace

# Test workspace with specific role
bash smoke-tests/base.sh --workspace /path/to/workspace --role boss
```

## Requirements

- bash 4.0+
- git
- curl
- sed
- find
