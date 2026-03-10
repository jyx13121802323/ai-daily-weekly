# 🚀 GitHub Pages 部署指南

## 方式 1：使用 GitHub CLI（推荐）

### 1. 安装 GitHub CLI
```bash
# Ubuntu/Debian
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# 或者使用 snap
sudo snap install gh --classic
```

### 2. 登录 GitHub
```bash
gh auth login
```
按提示操作：
- 选择 GitHub.com
- 选择 HTTPS
- 复制验证码
- 在浏览器登录并粘贴验证码

### 3. 推送代码
```bash
cd /root/.openclaw/workspace/ai-daily-weekly
git remote add origin https://github.com/jyx13121802323/ai-daily-weekly.git
git push -u origin main
```

---

## 方式 2：手动推送（使用 Personal Access Token）

### 1. 创建 Personal Access Token
访问：https://github.com/settings/tokens/new

**配置：**
- **Note:** `ai-daily-weekly-deploy`
- **Expiration:** `No expiration`
- **Select scopes:** ✅ `repo` (Full control of private repositories)

点击 **"Generate token"**，复制生成的 token（类似 `ghp_xxxxxxxxxxxx`）

### 2. 推送代码
```bash
cd /root/.openclaw/workspace/ai-daily-weekly
git remote add origin https://github.com/jyx13121802323/ai-daily-weekly.git
git push -u origin main
```

当提示输入密码时，**粘贴刚才生成的 token**（不会显示字符）

---

## 方式 3：使用 GitHub Desktop（图形界面）

### 1. 下载 GitHub Desktop
访问：https://desktop.github.com/

### 2. 克隆仓库
- File → Clone Repository
- 选择 `jyx13121802323/ai-daily-weekly`
- 选择本地路径

### 3. 复制文件
将生成的文件复制到克隆的仓库目录

### 4. 提交并推送
- 填写 commit 信息
- 点击 "Push origin"

---

## ✅ 启用 GitHub Pages

推送成功后：

### 1. 访问 Settings
https://github.com/jyx13121802323/ai-daily-weekly/settings/pages

### 2. 配置 Pages
- **Source:** Deploy from a branch
- **Branch:** `main` / `/(root)`
- 点击 **Save**

### 3. 等待部署
大约 1-2 分钟后，网站会发布到：

```
https://jyx13121802323.github.io/ai-daily-weekly/
```

---

## 🎯 快速命令参考

```bash
# 查看远程仓库
git remote -v

# 查看状态
git status

# 提交更改
git add -A
git commit -m "Update daily reports"

# 推送
git push origin main

# 查看日志
git log --oneline
```

---

## 📊 自动化更新

### 方案 1：GitHub Actions（推荐）
创建 `.github/workflows/deploy.yml` 自动部署

### 方案 2：本地脚本推送
修改 `scripts/deploy.sh` 自动提交并推送

### 方案 3：手动推送
每天生成报告后手动执行：
```bash
cd /root/.openclaw/workspace/ai-daily-weekly
git add -A
git commit -m "Daily report: $(date +%Y-%m-%d)"
git push origin main
```

---

## 🎉 完成后的网址

**GitHub Pages:** https://jyx13121802323.github.io/ai-daily-weekly/

**可以分享给朋友了！** 🦞
