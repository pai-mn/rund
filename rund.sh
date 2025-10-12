#!/bin/bash

# 配置文件目录（存储PID文件）
RUND_DIR="$HOME/.rund"
PID_DIR="$RUND_DIR/pids"
mkdir -p "$PID_DIR"

# 帮助信息
usage() {
    echo "Usage:"
    echo "  rund start <command>   # 后台启动命令"
    echo "  rund status           # 查看运行中的进程"
    echo "  rund stop <pid>       # 停止指定PID的进程"
    exit 1
}

# 启动命令（后台运行，记录PID）
start() {
    local cmd="$*"
    if [ -z "$cmd" ]; then
        echo "Error: Command is empty!"
        usage
    fi

    # 启动进程，分离终端，记录PID
    nohup $cmd >/dev/null 2>&1 &
    local pid=$!
    echo "$cmd" > "$PID_DIR/$pid"
    echo "Started PID $pid: $cmd"
}

# 查看所有进程
status() {
    if [ -z "$(ls -A "$PID_DIR")" ]; then
        echo "No processes running."
        return
    fi

    echo "Running processes:"
    echo "------------------"
    for pid_file in "$PID_DIR"/*; do
        local pid=$(basename "$pid_file")
        local cmd=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null; then
            echo "PID $pid: $cmd"
        else
            echo "PID $pid: $cmd (DEAD)"
            rm -f "$pid_file"
        fi
    done
}

# 停止进程
stop() {
    local pid="$1"
    if [ -z "$pid" ]; then
        echo "Error: PID not specified!"
        usage
    fi

    local pid_file="$PID_DIR/$pid"
    if [ ! -f "$pid_file" ]; then
        echo "Error: PID $pid not found or not started by rund."
        exit 1
    fi

    # 尝试终止进程
    if kill "$pid" 2>/dev/null; then
        echo "Stopped PID $pid: $(cat "$pid_file")"
        rm -f "$pid_file"
    else
        echo "Failed to stop PID $pid (process may already be dead)."
        rm -f "$pid_file"
    fi
}

# 主逻辑
case "$1" in
    start)
        shift
        start "$@"
        ;;
    status)
        status
        ;;
    stop)
        shift
        stop "$@"
        ;;
    *)
        usage
        ;;
esac