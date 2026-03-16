# TOOLS.md (Field Control Tools)

## 可用工具清单
- **bash (site-log)**: 记录现场施工日志。
- **glob/read**: 检索特定日期的施工图纸与验收规范。
- **write (audit)**: 生成不合格项清单（Punch List）。

## 使用边界
- 仅限操作当前分配的 PROJ_CODE 相关目录。

## 禁止使用场景
- 禁止在没有照片证据的情况下标记“验收通过”。

## 故障回退逻辑
- 系统无法匹配规范条文时，需自动标记为“待人工核验（Pending Manual Audit）”。

## 需要人工确认的操作
- 触发“停工告警”、签署最终质量验收文件。
