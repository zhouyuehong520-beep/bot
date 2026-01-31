# GitHub Codespaces 自动唤醒指南

## 🎯 目标

通过 GitHub Actions 定期唤醒你的 Codespace，防止自动休眠（24-48小时硬性限制除外）。

---

## 📋 前置条件

1. **GitHub 个人访问令牌 (PAT)**
   - 访问: https://github.com/settings/tokens
   - 点击 "Generate new token (classic)"
   - 勾选权限:
     - ✅ `codespace` (管理 Codespaces)
     - ✅ `repo` (访问仓库)
   - 生成后复制 token（只显示一次！）

---

## 🔧 配置步骤

### 步骤 1: 添加 PAT 到 GitHub Secrets

1. 进入你的 GitHub 仓库页面
2. 点击 **Settings** → **Secrets and variables** → **Actions**
3. 点击 **New repository secret**
4. 添加以下 secret:
   - Name: `GH_PAT`
   - Value: 你刚生成的 PAT
5. 点击 **Add secret**

### 步骤 2: 更新 Workflow 文件

我已经创建了 `.github/workflows/keep-codespace-alive.yml`

需要更新它以使用 `GH_PAT`:

```yaml
env:
  GITHUB_TOKEN: ${{ secrets.GH_PAT }}  # 改用我们的 PAT
```

### 步骤 3: 推送到 GitHub

```bash
cd /home/codespace/.openclaw/workspace
git add .github/workflows/keep-codespace-alive.yml
git commit -m "Add GitHub Actions to keep Codespace alive"
git push origin main
```

### 步骤 4: 启用 Actions

1. 进入你的 GitHub 仓库
2. 点击 **Actions** 标签
3. 找到 "Keep Codespace Alive" workflow
4. 点击它，确保 workflow 已启用

---

## 🕒 工作原理

- **频率**: 每 10 分钟执行一次
- **操作**: 通过 GitHub API 获取 Codespace 状态（保持活跃）
- **手动触发**: 可以在 Actions 页面手动运行

---

## ⚠️ 重要提醒

### 硬性限制（无法绕过）
- GitHub 会在 **24-48 小时后强制关闭** Codespaces
- 这是 GitHub 的硬性限制，无法通过任何方法绕过

### 软限制（可以通过 Actions 绕过）
- 30 分钟无活动自动休眠 ✅ 可以绕过
- 定期 API 调用会重置这个计时器

---

## 🔍 验证是否工作

1. 访问你的 GitHub 仓库 → Actions
2. 查看 "Keep Codespace Alive" workflow 的运行记录
3. 应该能看到每 10 分钟自动运行一次

---

## 📊 替代方案：延长休眠时间

在 GitHub 设置中可以修改 Codespace 的休眠时间：

1. 访问: https://github.com/settings/codespaces
2. 找到 "Timeout" 或 "Idle timeout" 设置
3. 设置为最长（通常是 24 小时）

---

## 💡 进阶技巧

### 使用 cron 更智能地唤醒

只在白天唤醒（比如 8:00 - 22:00）:

```yaml
on:
  schedule:
    - cron: '0 0-14 * * 1-5'  # 周一到周五，8:00-22:00（UTC时间）
```

### 添加通知

当 Codespace 休眠或唤醒时发送通知到 Telegram（需要额外配置）。

---

## ❓ 常见问题

**Q: 为什么我的 Codespace 还是休眠了？**

A: GitHub 的 24-48 小时硬性限制无法绕过。Actions 只能防止 30 分钟的无活动休眠。

**Q: 我需要一直有 GitHub Personal Access Token 吗？**

A: 是的，但你可以设置 Token 永不过期（或不设置过期时间）。

**Q: 这会消耗我的 GitHub 配额吗？**

A: Actions 的使用是免费的（公开仓库完全免费，私有仓库有免费额度）。

---

## 🚀 开始使用

告诉我你是否已经：
1. ✅ 创建了 GitHub PAT
2. ✅ 添加到了仓库 Secrets

然后我会帮你推送配置并启用！
