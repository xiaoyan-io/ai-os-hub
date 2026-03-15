# AI OS Hub 使用手册

## 快速开始

### 一键部署（推荐）

部署并启动一个 AI OS 实例，自动处理所有配置：

```bash
./deploy-os.sh \
  --category personal \
  --os family-care-os \
  --family-name "My Family" \
  --language zh \
  --telegram-token "your-token-here" \
  --api-key "your-api-key-here" \
  --base-url "https://api.openai.com/v1" \
  --daemon
```

这会自动完成：安装模板 → 配置 OpenClaw → 启动服务 → 分配端口

### 工作空间管理

查看和管理已安装的工作空间：

```bash
# 列出所有工作空间
./run-workspace.sh --list

# 交互式选择启动
./run-workspace.sh

# 指定工作空间启动
./run-workspace.sh --workspace /root/workspace-family-care

# 后台运行
./run-workspace.sh --workspace /root/workspace-family-care --daemon
```

### 手动安装

#### 交互式安装
```bash
./install.sh
```

#### 命令行安装
```bash
./install.sh --direct \
  --category sales \
  --os alan-sales-os \
  --workspace ~/workspace-sales \
  --company-name "My Company" \
  --language en \
  --skip-openclaw
```

## 完整参数列表

### deploy-os.sh 参数

| 参数 | 必需 | 描述 | 默认值 |
|------|------|--------|--------|
| `--category` | 是 | 模板分类 (company, sales, construction, personal) | - |
| `--os` | 是 | OS 模板名称 | - |
| `--api-key` | 是 | LLM API 密钥 | - |
| `--workspace` | 否 | 工作空间路径 (自动生成) | - |
| `--node` | 否 | 节点标识 | default |
| `--language` | 否 | 语言代码 | en |
| `--company-name` | 否 | 公司名称 | - |
| `--family-name` | 否 | 家庭名称 | - |
| `--telegram-token` | 否 | Telegram 机器人令牌 | - |
| `--base-url` | 否 | API 基础 URL | https://api.openai.com/v1 |
| `--port` | 否 | 网关端口 (自动分配) | - |
| `--daemon` | 否 | 后台运行 | false |

### run-workspace.sh 参数

| 参数 | 描述 |
|------|------|
| `--list` | 列出可用工作空间 |
| `--workspace PATH` | 指定工作空间路径 |
| `--port PORT` | 指定端口 (自动分配) |
| `--daemon` | 后台运行 |
| `--help` | 显示帮助 |

## 支持的 OS 模板

### 公司类
- `boss-secretary-os` - 上司-秘书工作流
- `alan-boss-os` - 个人行政助理

### 销售类
- `chat-sales-os` - AI 销售对话系统
- `alan-sales-os` - 个人销售跟进

### 建筑类
- `site-report-os` - 施工现场报告系统

### 个人类
- `personal-os` - 个人 AI 助理
- `alan-personal-os` - 个人助手
- `family-care-os` - 家庭健康护理
- `alan-family-care-os` - 个人家庭护理

## 验证与测试

### 完整流程测试
```bash
./test-e2e.sh
```

### 工作空间验证
```bash
./smoke-tests/base.sh --workspace /path/to/workspace --role care
```

## 服务访问

- **Telegram Bot** - 与你的机器人聊天
- **Gateway** - `http://localhost:端口号`
- **后台日志** - `/tmp/openclaw-[workspace].log`

## 配置参考

### .env 配置示例
```bash
OPENAI_API_KEY="your-api-key-here"
OPENAI_BASE_URL="https://api.openai.com/v1"
TELEGRAM_TOKEN="your-telegram-token-here"
NODE_NAME="default"
FAMILY_NAME="My Family"
LANGUAGE="zh"
```

## 故障排除

1. **端口冲突** - 使用 `--port` 指定不同端口或让系统自动分配
2. **API 密钥错误** - 检查 `.env` 文件中的 `OPENAI_API_KEY`
3. **Telegram 机器人无法访问** - 确认 `TELEGRAM_TOKEN` 正确
4. **工作空间未发现** - 检查 `~/.openclaw/` 目录下是否存在相关配置