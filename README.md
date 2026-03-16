# AI OS Hub

A collection of AI operating system templates for OpenClaw with one-click deployment tools.

## Project Overview

AI OS Hub provides pre-built operating system templates for various use cases. Each template includes persona definitions, task configurations, and file structures needed to deploy a complete AI OS. Includes automation tools for installation, configuration, and deployment.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/xiaoyan-io/ai-os-hub.git
cd ai-os-hub

# Interactive installation (recommended)
bash install.sh

# Or one-click deployment with API credentials
bash deploy-os.sh --category personal --os family-care-os \
  --family-name "My Family" \
  --api-key "sk-..." \
  --telegram-token "..."

# Or run an existing workspace
bash run-workspace.sh --list
bash run-workspace.sh --workspace /root/workspace-family-care --daemon
```

## Directory Structure

```
ai-os-hub/
├── install.sh                    # Interactive installation entry point
├── deploy-os.sh                  # One-click OS deployment (install + start)
├── run-workspace.sh              # Workspace detection and management
├── categories/                   # OS templates
│   ├── company/                 # Company category templates
│   ├── sales/                   # Sales category templates
│   ├── construction/            # Construction category templates
│   └── personal/                # Personal category templates
├── installers/                  # Installation tools
│   ├── common.sh               # Shared functions
│   ├── render-config.sh        # Template rendering
│   ├── install-os.sh           # Direct OS installer
│   ├── menu-install.sh         # Interactive menu installer
│   ├── start-os.sh             # Universal OS launcher
│   └── start-family-care.sh    # Specific launcher for family-care
├── smoke-tests/                 # Test scripts
├── registry.yaml               # Template registry
└── README.md
```

## Available OS Templates

### Company OS

- **boss-secretary-os**: Executive assistant system for boss-secretary workflow
- **alan-boss-os**: Personal-use executive template for internal summaries and directives

### Sales OS

- **chat-sales-os**: AI-powered sales conversation system
- **alan-sales-os**: Personal-use sales follow-up template for lead intake and chat closing

### Construction OS

- **site-report-os**: Construction site reporting and documentation system

### Personal OS

- **personal-os**: Personal AI assistant for daily tasks
- **alan-personal-os**: Personal-use AI assistant for daily tasks, notes, planning and project organization
- **family-care-os**: Family health and care management system
- **alan-family-care-os**: Personal-use family care helper for household reminders and care coordination

## Deployment Options

### Option 1: Interactive Installation

```bash
bash install.sh
# or
bash installers/menu-install.sh
```

Features:

- Select category and OS from menu
- Dynamic prompts based on template type
- Installation summary before execution
- Default values with Enter key

### Option 2: Direct Installation

```bash
bash installers/install-os.sh \
  --category personal \
  --os alan-personal-os \
  --workspace ~/my-workspace \
  --node default \
  --language en
```

### Option 3: One-Click Deployment (Recommended)

```bash
bash deploy-os.sh \
  --category sales \
  --os alan-sales-os \
  --company-name "My Company" \
  --api-key "sk-..." \
  --telegram-token "..." \
  --daemon
```

Automatically handles:

- Template installation
- Credential configuration
- OpenClaw setup
- Agent startup
- Port assignment (auto or manual)
- Background operation

### Parameters

| Parameter | Required | Description | Default |
|-----------|----------|-------------|---------|
| `--category` | Yes | Template category | - |
| `--os` | Yes | OS template ID | - |
| `--workspace` | No | Target workspace path (auto-generated if not specified) | - |
| `--node` | No | Node identifier | default |
| `--language` | No | Language code | en |
| `--company-name` | No | Company name | - |
| `--family-name` | No | Family name | - |
| `--telegram-token` | No | Telegram bot token | - |
| `--api-key` | Yes | LLM API key | - |
| `--base-url` | No | API base URL | <https://api.openai.com/v1> |
| `--port` | No | Gateway port (auto-assigned if not specified) | - |
| `--daemon` | No | Run as background daemon | false |

## Running Workspaces

### Option 1: Interactive Workspace Runner

```bash
bash run-workspace.sh
# Lists available workspaces and prompts selection
```

### Option 2: Direct Workspace Start

```bash
bash run-workspace.sh --list  # Show workspaces
bash run-workspace.sh --workspace /root/workspace-family-care
bash run-workspace.sh --workspace /root/workspace-family-care --daemon
```

### Option 3: Direct Start Script

```bash
bash installers/start-os.sh /root/workspace-family-care 8080
```

Features:

- Auto port assignment (8080-8099 range)
- Telegram/OpenAI configuration
- Agent creation and binding
- Background operation support

## Workspace Output Structure

After installation, the workspace will have:

```
<workspace>/
├── .generated/
│   └── .env           # Environment variables
├── <role-1>/         # Role directory
│   ├── SOUL.md
│   ├── IDENTITY.md
│   └── TASKS.md
├── <role-2>/         # Role directory
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

## Developer

- **OpenClaw Team**: Core developers and maintainers.
- **AI OS Hub Contributors**: Community members who have provided templates and improvements.

## Requirements

- bash 4.0+
- git
- curl
- sed
- find
- node.js (for OpenClaw)
- npm (for OpenClaw)

## Testing

```bash
# Test workspace without role
bash smoke-tests/base.sh --workspace /path/to/workspace

# Test workspace with specific role
bash smoke-tests/base.sh --workspace /path/to/workspace --role boss

# List available workspaces
bash run-workspace.sh --list
```
