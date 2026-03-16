#!/bin/bash
# view-logs.sh - 交互式日志查看工具

LOG_DIR="/tmp"
LOG_FILES=($(ls ${LOG_DIR}/openclaw-*.log 2>/dev/null))

if [ ${#LOG_FILES[@]} -eq 0 ]; then
    echo "未发现正在运行或已停止的 OpenClaw 日志。"
    exit 0
fi

echo "========================================"
echo "    AI OS Hub - 实时日志查看器"
echo "========================================"
for i in "${!LOG_FILES[@]}"; do
    FILE_NAME=$(basename "${LOG_FILES[$i]}")
    # 尝试从文件名获取工作空间名称
    WS_NAME=${FILE_NAME#openclaw-}
    WS_NAME=${WS_NAME%.log}
    echo "[$i] $WS_NAME ($FILE_NAME)"
done
echo "========================================"

read -p "请选择要查看的日志编号 (0-${#LOG_FILES[@]-1}) [默认 0]: " choice
choice=${choice:-0}

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -lt "${#LOG_FILES[@]}" ]; then
    echo "正在连接到日志: ${LOG_FILES[$choice]} (按 Ctrl+C 退出)"
    tail -f "${LOG_FILES[$choice]}"
else
    echo "无效选择。"
fi
