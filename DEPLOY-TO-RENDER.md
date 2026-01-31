# Moltbot 部署到 Render 指南

## 前提条件
- 已注册 Render 账户
- 项目已推送到 GitHub

---

## 步骤 1: 确认项目在 GitHub

### 如果项目已在 GitHub：
- 确保仓库是公开的（或 Render 能访问）
- 仓库需要有 `package.json`（Node.js 项目）

### 如果需要创建新仓库：
```bash
cd /home/codespace/moltbot  # 进入你的项目目录
git init
git add .
git commit -m "Initial commit"
# 在 GitHub 创建新仓库，然后：
git remote add origin https://github.com/你的用户名/moltbot.git
git branch -M main
git push -u origin main
```

---

## 步骤 2: 在 Render 部署

### 方法 A: 使用 Web Dashboard（推荐）

1. 登录 [Render Dashboard](https://dashboard.render.com/)
2. 点击 **New** → **Web Service**
3. 选择 **Connect GitHub repository**
4. 选择你的 `moltbot` 仓库
5. 填写配置：
   - **Name**: moltbot
   - **Environment**: Node
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: Free
6. 点击 **Create Web Service**

### 方法 B: 使用 Render Blueprint（自动配置）

1. 在你的 GitHub 仓库根目录创建 `render.yaml` 文件
2. 使用我准备的配置模板（已在 workspace）
3. 在 Render 点击 **New Blueprint Instance**
4. 选择你的 GitHub 仓库
5. 点击 **Apply**

---

## 步骤 3: 配置环境变量

在 Render Web Service 的 **Environment** 标签页添加：
- `NODE_ENV`: `production`
- `BOT_TOKEN`: 你的 Telegram Bot Token（来自 @BotFather）
- 其他项目需要的环境变量...

---

## 步骤 4: 防止休眠

Render 免费层会在 15 分钟无请求后休眠。使用 GitHub Actions 定期唤醒：

1. 创建 `.github/workflows/keep-alive.yml`:
```yaml
name: Keep Render Alive
on:
  schedule:
    - cron: '*/15 * * * *'  # 每15分钟
  workflow_dispatch:      # 手动触发

jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - name: Ping Render App
        run: |
          curl https://你的应用名.onrender.com/health
```

2. 提交到 GitHub 并推送
3. 在 GitHub 仓库启用 Actions

---

## 步骤 5: 获取应用 URL

部署完成后，Render 会提供：
- **Service URL**: `https://moltbot-xxxx.onrender.com`
- **Logs**: 在 Dashboard 查看运行日志

---

## 需要帮助？

告诉我：
1. 你的 GitHub 仓库链接
2. 项目使用的技术栈（Node.js? Python?）
3. 需要配置的环境变量

我会帮你准备具体的配置文件！
