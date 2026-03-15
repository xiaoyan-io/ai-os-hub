# AI OS Hub v0.1

A collection of AI operating system templates for OpenClaw.

## Project Overview

AI OS Hub provides pre-built operating system templates for various use cases. Each template includes persona definitions, task configurations, and file structures needed to deploy a complete AI OS.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/xiaoyan-io/ai-os-hub.git
cd ai-os-hub

# Interactive installation (recommended)
bash install.sh

# Or direct installation
bash installers/install-os.sh \
  --category personal \
  --os alan-personal-os \
  --workspace ~/my-workspace \
  --language en
```

## Directory Structure

```
ai-os-hub/
├── install.sh              # Unified entry point (calls menu-install.sh)
├── categories/             # OS templates
│   ├── company/           # Company category templates
│   ├── sales/             # Sales category templates
│   ├── construction/       # Construction category templates
│   └── personal/          # Personal category templates
├── installers/            # Installation scripts
│   ├── common.sh         # Shared functions
│   ├── render-config.sh  # Template rendering
│   ├── install-os.sh     # Direct OS installer
│   └── menu-install.sh  # Interactive menu installer
├── smoke-tests/          # Test scripts
├── registry.yaml         # Template registry
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

## Personal-Use Templates

The `alan-*` templates are customized versions designed for personal use:

| Template | Purpose |
|----------|---------|
| `alan-personal-os` | Personal note-taking, planning, project organization |
| `alan-family-care-os` | Family health reminders, symptom tracking, care coordination |
| `alan-boss-os` | Executive summaries, directives, priority tracking |
| `alan-sales-os` | Lead intake, chat follow-up, client closing |

## Installation

### Option 1: Interactive Menu (Recommended)

```bash
bash install.sh
# or
bash installers/menu-install.sh
```

Features:
- Select category and OS from menu
- Dynamic prompts based on template type
- Validation for required fields
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

**Parameters:**

| Parameter | Required | Description | Default |
|-----------|----------|-------------|---------|
| `--category` | Yes | Template category | - |
| `--os` | Yes | OS template ID | - |
| `--workspace` | Yes | Target workspace path | - |
| `--node` | No | Node identifier | hostname |
| `--language` | No | Language code | en |
| `--company-name` | No | Company name | - |
| `--family-name` | No | Family name | - |
| `--telegram-token` | No | Telegram bot token | - |
| `--api-key` | No | OpenAI API key | - |
| `--base-url` | No | Base URL for API | - |
| `--skip-openclaw` | No | Skip OpenClaw installation | false |

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

## Testing

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
