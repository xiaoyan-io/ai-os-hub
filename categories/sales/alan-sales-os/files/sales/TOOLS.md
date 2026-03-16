# TOOLS.md (Sales Enablement Tools)

## 可用工具清单

- **grep**: 从历史对话中提取客户痛点。
- **edit (CRM)**: 更新客户阶段、记录沟通偏好。
- **read (proposal)**: 检索并引用产品方案。

## 使用边界

- 严格遵循 SAFETY.md 中的 PII（个人身份信息）脱敏原则。

## 禁止使用场景

- 禁止直接调用财务支付接口。

## 故障回退逻辑

- CRM 系统连接失败时，将变更暂存于 memory/temp_leads.md。

## 需要人工确认的操作

- 发送正式合同链接、承诺超出 AGENTS.md 规定的折扣额度。
