#!/bin/bash
# stop-os.sh - 停止运行中的 AI OS 实例

if [ "$1" == "--all" ]; then
    echo "正在停止所有 AI OS 实例..."
    pkill -f "openclaw-gateway"
    echo "所有实例已停止。"
    exit 0
fi

# 查找运行中的工作空间
# 逻辑：查找包含 openclaw-gateway 和 workspace 的进程
RUNNING_PROCS=$(ps aux | grep "node.*openclaw-gateway" | grep -v grep)

if [ -z "$RUNNING_PROCS" ]; then
    echo "未发现运行中的 AI OS 实例。"
    exit 0
fi

echo "========================================"
echo "    AI OS Hub - 实例管理器 (停止)"
echo "========================================"
# 提取工作空间路径并去重
WORKSPACES=$(echo "$RUNNING_PROCS" | grep -o "/root/workspace-[^ ]*" | sort -u)

if [ -z "$WORKSPACES" ]; then
    echo "无法识别具体工作空间路径，仅显示原始进程："
    echo "$RUNNING_PROCS" | awk '{print "PID: "$2" - "$11" "$12}'
else
    IFS=$'\n' read -rd '' -a WS_ARRAY <<< "$WORKSPACES"
    for i in "${!WS_ARRAY[@]}"; do
        echo "[$i] ${WS_ARRAY[$i]}"
    done
fi
echo "========================================"

read -p "请选择要停止的工作空间编号: " choice

# Update status file
update_status_stop() {
    local ws_path="$1"
    local status_file="/root/ai-os-hub/status.json"
    local ws_name=$(basename "$ws_path")
    
    if [[ -f "$status_file" ]]; then
        cat "$status_file" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if '$ws_name' in data['instances']:
    del data['instances']['$ws_name']
json.dump(data, sys.stdout, indent=2)
" > "${status_file}.tmp" && mv "${status_file}.tmp" "$status_file"
    fi
}

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -lt "${#WS_ARRAY[@]}" ]; then
    TARGET_WS="${WS_ARRAY[$choice]}"
    echo "正在停止工作空间: $TARGET_WS"
    # 获取该工作空间相关的所有 PID 并杀掉
    PIDS=$(ps aux | grep "$TARGET_WS" | grep -v grep | awk '{print $2}')
    if [ -n "$PIDS" ]; then
        kill $PIDS
        update_status_stop "$TARGET_WS"
        echo "已成功停止 (PIDs: $PIDS)"
    else
        echo "停止失败，未找到相关进程。"
    fi
else
    echo "无效选择。"
fi
