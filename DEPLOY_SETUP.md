# 🚀 GitHub Pages 部署指南

## 当前状态

✅ 网站内容已优化完成
✅ 3 月 11 日 3 份日报已生成
✅ Git 提交已完成

⚠️ **需要配置 GitHub 认证才能推送**

---

## 方法一：使用 SSH 密钥（推荐）

### 1. 生成 SSH 密钥
```bash
ssh-keygen -t ed25519 -C "374331363@qq.com"
# 一路回车即可
```

### 2. 查看公钥
```bash
cat ~/.ssh/id_ed25519.pub
```

### 3. 添加到 GitHub
1. 复制上面的公钥内容
2. 访问 https://github.com/settings/keys
3. 点击 "New SSH key"
4. 粘贴公钥，保存

### 4. 修改 remote 为 SSH
```bash
cd /root/.openclaw/workspace/ai-daily-weekly
git remote set-url origin git@github.com:jyx13121802323/ai-daily-weekly.git
```

### 5. 推送
```bash
git push origin main
```

---

## 方法二：使用 Personal Access Token

### 1. 创建 Token
1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 勾选 `repo` 权限
4. 生成并复制 token

### 2. 推送（使用 token）
```bash
cd /root/.openclaw/workspace/ai-daily-weekly
git push https://<YOUR_TOKEN>@github.com/jyx13121802323/ai-daily-weekly.git main
```

---

## 配置 GitHub Pages

推送成功后：

1. 访问 https://github.com/jyx13121802323/ai-daily-weekly/settings/pages
2. **Source** 选择 `Deploy from a branch`
3. **Branch** 选择 `main`，文件夹选择 `/ (root)`
4. 点击 Save

等待 1-2 分钟，你的网站就会上线：

```
https://jyx13121802323.github.io/ai-daily-weekly/
```

---

## 验证部署

推送成功后，访问以下链接检查：

- 🌐 GitHub Pages: `https://jyx13121802323.github.io/ai-daily-weekly/`
- 📁 仓库地址：`https://github.com/jyx13121802323/ai-daily-weekly`

---

## 自动化更新（可选）

配置完成后，每日日报会自动生成并推送到 GitHub。

可以设置 cron 定时任务：

```bash
# 每天 10:00 自动生成并推送
0 10 * * * cd /root/.openclaw/workspace/ai-daily-weekly && ./scripts/generate-daily.sh && git add -A && git commit -m "chore: daily reports $(date +%Y-%m-%d)" && git push
```

---

**需要帮助？** 告诉我你选择哪种认证方式，我可以帮你完成配置！
