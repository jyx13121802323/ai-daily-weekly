#!/bin/bash
# Setup cron jobs for AI Daily & Weekly Reports

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"

echo "⚙️  设置定时任务..."

# 添加日报任务（每天 10:00）
CRON_DAILY="0 10 * * * cd $WORKSPACE && ./scripts/generate-daily.sh >> /tmp/ai-daily.log 2>&1"

# 添加周报任务（每周五 17:00）
CRON_WEEKLY="0 17 * * 5 cd $WORKSPACE && ./scripts/generate-weekly.sh >> /tmp/ai-weekly.log 2>&1"

# 检查是否已存在
if crontab -l 2>/dev/null | grep -q "generate-daily.sh"; then
    echo "✓ 日报任务已存在"
else
    (crontab -l 2>/dev/null | grep -v "generate-daily.sh"; echo "$CRON_DAILY") | crontab -
    echo "✅ 日报任务已添加（每天 10:00）"
fi

if crontab -l 2>/dev/null | grep -q "generate-weekly.sh"; then
    echo "✓ 周报任务已存在"
else
    (crontab -l 2>/dev/null | grep -v "generate-weekly.sh"; echo "$CRON_WEEKLY") | crontab -
    echo "✅ 周报任务已添加（每周五 17:00）"
fi

echo ""
echo "📋 当前 cron 任务:"
crontab -l 2>/dev/null || echo "（无 cron 任务）"

echo ""
echo "✨ 设置完成！"
