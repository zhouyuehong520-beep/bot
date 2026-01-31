#!/bin/bash

# GitHub Codespaces Keep-Alive Script
# 定期执行轻量级操作以防止 Codespaces 休眠

LOG_FILE="/tmp/keep-alive.log"

# 记录时间和运行状态
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S UTC')] $1" >> "$LOG_FILE"
}

# 保持活跃的操作
keep_alive() {
    # 做一些轻量级的系统操作
    # 1. 检查系统负载
    uptime >> /dev/null
    
    # 2. 列出进程（轻量级）
    ps aux | head -5 >> /dev/null
    
    # 3. 简单的 CPU 操作（非常轻量）
    echo $$ > /dev/null
    
    log "Keep-alive ping executed"
}

# 主循环
while true; do
    keep_alive
    # 每 4 分钟执行一次（GitHub Codespaces 休眠超时通常是 30 分钟）
    sleep 240
done
