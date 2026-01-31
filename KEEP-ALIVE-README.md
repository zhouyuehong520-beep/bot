# GitHub Codespaces 保持活跃脚本

## 问题

GitHub Codespaces 会在不活跃一段时间后自动休眠（通常 30 分钟），这会导致正在运行的进程中断。

## 解决方案

`keep-alive.sh` 脚本会在后台定期执行轻量级的系统操作，保持 Codespaces 处于活跃状态。

## 使用方法

### 方法 1: 使用 nohup 在后台运行（推荐）

```bash
nohup ./keep-alive.sh > /tmp/keep-alive.out 2>&1 &
```

- 查看日志: `tail -f /tmp/keep-alive.log`
- 查看输出: `tail -f /tmp/keep-alive.out`
- 停止脚本: 找到进程 `ps aux | grep keep-alive.sh` 然后 `kill <PID>`

### 方法 2: 使用 screen

```bash
# 创建 screen 会话
screen -S keep-alive

# 在 screen 中运行脚本
./keep-alive.sh

# 分离会话: Ctrl+A, D
# 重新连接: screen -r keep-alive
```

### 方法 3: 使用 tmux

```bash
# 创建 tmux 会话
tmux new -s keep-alive

# 在 tmux 中运行脚本
./keep-alive.sh

# 分离会话: Ctrl+B, D
# 重新连接: tmux attach -t keep-alive
```

## 快速启动命令

复制以下命令到终端：

```bash
cd /home/codespace/.openclaw/workspace && nohup ./keep-alive.sh > /tmp/keep-alive.out 2>&1 &
```

## 检查脚本是否在运行

```bash
ps aux | grep keep-alive.sh
```

如果看到进程在运行，说明脚本正在工作。

## 注意事项

- 脚本每 4 分钟执行一次（可修改脚本中的 `sleep 240` 调整间隔）
- 即使使用此脚本，GitHub 仍会在 **24-48 小时后自动关闭** Codespaces（硬性限制）
- 如果需要永久保持运行，考虑使用：
  - **GitHub Actions** 定期唤醒
  - **自托管服务器**
  - **云服务器**（AWS、Azure 等）
