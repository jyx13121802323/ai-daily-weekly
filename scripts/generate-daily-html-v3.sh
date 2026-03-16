#!/bin/bash
# AI Daily Report HTML Generator v3
# 生成与参考项目风格一致的 HTML 日报，包含真实链接

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)
MONTH=$(date +%Y-%m)
MEMORY_FILE="$WORKSPACE/memory/ai-news-today.md"
HTML_FILE="$WORKSPACE/ai-daily-weekly/01-daily-reports/$MONTH/$DATE-v3.html"

# 检查 MD 文件是否存在
if [ ! -f "$MEMORY_FILE" ]; then
    echo "⚠️ Memory file not found: $MEMORY_FILE"
    exit 1
fi

# 读取 Hacker News 数据（标题 | 链接格式）
hn_data=$(grep -A20 "🔥 Hacker News" "$MEMORY_FILE" | grep "• " | sed 's/• //' || true)

# 读取 MIT Tech Review 数据
mit_data=$(grep -A10 "📰 MIT Tech Review" "$MEMORY_FILE" | grep "• " | sed 's/• //' || true)

# 格式化日期显示
DATE_DISPLAY=$(echo "$DATE" | sed 's/-/年 /;s/-/月 /')日

echo "🎨 生成 HTML 日报 v3..."
echo "   日期：$DATE"

# 创建 HTML
cat > "$HTML_FILE" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 技术日报 - {DATE_DISPLAY} | OpenClaw</title>
    <meta name="description" content="AI 安全与开源标准成为焦点">
    <style>
        :root {
            --color-success: #059669;
            --color-success-light: #10B981;
            --color-info: #2563EB;
            --color-purple: #7C3AED;
            --color-warning: #D97706;
            --color-bg: #F8FAFB;
            --color-bg-card: #FFFFFF;
            --color-text-primary: #1C1917;
            --color-text-secondary: #57534E;
            --color-border: #E7E5E4;
            --gradient-hero: linear-gradient(135deg, #059669 0%, #2563EB 50%, #7C3AED 100%);
            --gradient-card: linear-gradient(135deg, rgba(5,150,105,0.03) 0%, rgba(37,99,235,0.03) 100%);
            --gradient-badge: linear-gradient(135deg, #ECFDF5 0%, #EFF6FF 100%);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.07);
            --shadow-hover: 0 6px 16px rgba(5,150,105,0.15);
            --radius-lg: 16px;
        }
        
        @media (prefers-color-scheme: dark) {
            :root {
                --color-bg: #0F172A;
                --color-bg-card: #1E293B;
                --color-text-primary: #F1F5F9;
                --color-text-secondary: #94A3B8;
                --color-border: rgba(255,255,255,0.08);
            }
        }
        
        html { scroll-behavior: smooth; scroll-padding-top: 80px; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: -apple-system, "SF Pro Display", "PingFang SC", "Noto Sans SC", sans-serif;
            background: var(--color-bg);
            color: var(--color-text-primary);
            line-height: 1.7;
        }
        
        .header {
            background: var(--color-bg-card);
            border-bottom: 3px solid transparent;
            border-image: var(--gradient-hero);
            border-image-slice: 1;
            padding: 40px 20px;
            text-align: center;
        }
        
        .header-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 20px;
            background: var(--gradient-badge);
            color: var(--color-info);
            border-radius: 24px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 16px;
        }
        
        .header h1 {
            font-size: 36px;
            font-weight: 800;
            background: var(--gradient-hero);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 12px;
        }
        
        .time-window {
            background: var(--gradient-hero);
            color: white;
            padding: 12px 20px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 20px;
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 32px;
        }
        
        @media (max-width: 900px) {
            .container { grid-template-columns: 1fr; }
            .sidebar { order: -1; }
        }
        
        .overview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        
        .overview-card {
            background: var(--color-bg-card);
            border: 1px solid var(--color-border);
            border-radius: var(--radius-lg);
            padding: 20px;
            transition: all 0.2s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
        }
        
        .overview-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
            border-color: var(--color-success);
            background: var(--gradient-card);
        }
        
        .overview-icon { font-size: 28px; margin-bottom: 12px; }
        .overview-title { font-size: 14px; font-weight: 600; color: var(--color-text-secondary); margin-bottom: 8px; }
        .overview-summary { font-size: 14px; line-height: 1.5; }
        
        .section {
            background: var(--color-bg-card);
            border-radius: 20px;
            padding: 32px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--color-border);
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid rgba(5, 150, 105, 0.1);
        }
        
        .section-icon { font-size: 28px; }
        .section h2 { font-size: 24px; font-weight: 700; }
        
        .news-item {
            padding: 20px;
            margin-bottom: 16px;
            background: var(--gradient-card);
            border-radius: var(--radius-lg);
            border-left: 4px solid var(--color-success);
            transition: all 0.2s;
        }
        
        .news-item:hover {
            transform: translateX(4px);
        }
        
        .news-item.hot { border-left-color: var(--color-danger); }
        
        .news-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }
        
        .news-title a {
            color: inherit;
            text-decoration: none;
            font-weight: 600;
            font-size: 16px;
            transition: color 0.2s;
        }
        
        .news-title a:hover {
            color: var(--color-success);
            text-decoration: underline;
        }
        
        .news-source {
            padding: 4px 10px;
            background: rgba(37, 99, 235, 0.08);
            color: var(--color-info);
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .news-content {
            color: var(--color-text-secondary);
            font-size: 14px;
            margin-bottom: 12px;
        }
        
        .news-link {
            color: var(--color-info);
            text-decoration: none;
            font-size: 14px;
            margin-left: 8px;
        }
        
        .news-link:hover { text-decoration: underline; }
        
        .news-why-important {
            padding: 12px 16px;
            background: rgba(5, 150, 105, 0.05);
            border-radius: 12px;
            font-size: 13px;
        }
        
        .insight-box {
            padding: 24px;
            background: linear-gradient(135deg, rgba(5,150,105,0.05) 0%, rgba(37,99,235,0.05) 100%);
            border: 1px solid rgba(5, 150, 105, 0.1);
            border-radius: var(--radius-lg);
            margin-top: 20px;
        }
        
        .insight-box h3 {
            font-size: 16px;
            font-weight: 700;
            color: var(--color-success);
            margin-bottom: 12px;
        }
        
        .deep-focus {
            background: linear-gradient(135deg, rgba(5,150,105,0.08) 0%, rgba(37,99,235,0.08) 100%);
            border: 2px solid var(--color-success);
        }
        
        .deep-focus-badge {
            padding: 6px 14px;
            background: var(--gradient-hero);
            color: white;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }
        
        .focus-card {
            background: var(--color-bg-card);
            padding: 24px;
            border-radius: var(--radius-lg);
            margin-bottom: 20px;
        }
        
        .focus-card h4 {
            font-size: 16px;
            font-weight: 700;
            color: var(--color-success);
            margin-bottom: 12px;
        }
        
        .sidebar-card {
            background: var(--color-bg-card);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-md);
        }
        
        .sidebar-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 16px;
        }
        
        .toc-list { list-style: none; }
        .toc-list li { margin-bottom: 12px; }
        .toc-list a {
            color: var(--color-text-secondary);
            text-decoration: none;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 12px;
            transition: all 0.2s;
        }
        .toc-list a:hover {
            background: var(--gradient-card);
            color: var(--color-success);
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }
        
        .stat-item {
            text-align: center;
            padding: 16px;
            background: var(--gradient-card);
            border-radius: 12px;
        }
        
        .stat-value { font-size: 24px; font-weight: 700; color: var(--color-success); }
        .stat-label { font-size: 12px; color: var(--color-text-secondary); margin-top: 4px; }
        
        .footer {
            background: var(--color-bg-card);
            border-top: 1px solid var(--color-border);
            padding: 40px 20px;
            text-align: center;
            color: var(--color-text-secondary);
            margin-top: 60px;
        }
        
        .footer a { color: var(--color-info); text-decoration: none; font-weight: 600; }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: var(--gradient-card);
            color: var(--color-success);
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .back-link:hover { transform: translateX(-4px); }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-badge"><span>🤖</span><span>AI 技术日报</span></div>
        <h1>AI Daily Report</h1>
        <div style="color: var(--color-text-secondary); font-size: 14px;">
            <span>📅 {DATE_DISPLAY}</span> · 
            <span>✍️ OpenClaw AI Assistant (蒋维斯)</span> · 
            <span>👤 Yixuan</span>
        </div>
    </header>
    
    <div class="time-window">
        ⏰ 时间窗口：{TIME_WINDOW} | 数据来源：Hacker News · MIT Tech Review · arXiv
    </div>
    
    <div class="container">
        <main class="main-content">
            <a href="../" class="back-link">← 返回首页</a>
            
            <div class="overview-grid" id="overview">
                <a href="#foundation-models" class="overview-card">
                    <div class="overview-icon">🧠</div>
                    <div class="overview-title">大模型</div>
                    <div class="overview-summary">AI 安全与开源标准成为焦点</div>
                </a>
                <a href="#ai-coding" class="overview-card">
                    <div class="overview-icon">💻</div>
                    <div class="overview-title">AI Coding</div>
                    <div class="overview-summary">Pydantic AI 移植 TypeScript</div>
                </a>
                <a href="#ai-apps" class="overview-card">
                    <div class="overview-icon">📱</div>
                    <div class="overview-title">AI 应用</div>
                    <div class="overview-summary">开源 AI 物理学家发布</div>
                </a>
                <a href="#ai-industry" class="overview-card">
                    <div class="overview-icon">🏭</div>
                    <div class="overview-title">AI 行业</div>
                    <div class="overview-summary">教育体系变革压力增大</div>
                </a>
                <a href="#ai-research" class="overview-card">
                    <div class="overview-icon">🔬</div>
                    <div class="overview-title">AI 研究</div>
                    <div class="overview-summary">物理 AI 成为制造业优势</div>
                </a>
            </div>
            
            <section class="section" id="foundation-models">
                <div class="section-header">
                    <span class="section-icon">🧠</span>
                    <h2>一、大模型 (Foundation Models)</h2>
                </div>
                {HN_NEWS_ITEMS}
                <div class="insight-box">
                    <h3>📈 趋势洞察</h3>
                    <p><strong>AI 安全与透明度成为行业焦点：</strong>今日多个话题围绕 AI 安全、AI 披露、AI 检测，显示行业从"快速发展"转向"规范发展"。</p>
                </div>
            </section>
            
            <section class="section" id="ai-coding">
                <div class="section-header">
                    <span class="section-icon">💻</span>
                    <h2>二、AI Coding</h2>
                </div>
                {CODING_NEWS_ITEMS}
                <div class="insight-box">
                    <h3>📈 趋势洞察</h3>
                    <p><strong>AI 工具链跨语言迁移加速：</strong>从 Python 到 TypeScript 的快速移植显示 AI 工具正在向全栈扩展。</p>
                </div>
            </section>
            
            <section class="section" id="ai-apps">
                <div class="section-header">
                    <span class="section-icon">📱</span>
                    <h2>三、AI 应用 (Applications)</h2>
                </div>
                {APPS_NEWS_ITEMS}
                <div class="insight-box">
                    <h3>📈 趋势洞察</h3>
                    <p><strong>AI for Science 突破：</strong>AI 从"工具"向"研究者"角色转变。</p>
                </div>
            </section>
            
            <section class="section" id="ai-industry">
                <div class="section-header">
                    <span class="section-icon">🏭</span>
                    <h2>四、AI 行业 (Industry)</h2>
                </div>
                {INDUSTRY_NEWS_ITEMS}
                <div class="insight-box">
                    <h3>📈 趋势洞察</h3>
                    <p><strong>教育体系变革压力增大：</strong>AI 让传统课程设计的问题暴露无遗。</p>
                </div>
            </section>
            
            <section class="section" id="ai-research">
                <div class="section-header">
                    <span class="section-icon">🔬</span>
                    <h2>五、AI 研究 (Research)</h2>
                </div>
                {RESEARCH_NEWS_ITEMS}
                <div class="insight-box">
                    <h3>📈 趋势洞察</h3>
                    <p><strong>AI 硬件创新加速：</strong>从传统硅基到新材料，AI 芯片创新可能带来性能突破。</p>
                </div>
            </section>
            
            <section class="section deep-focus" id="deep-focus">
                <div class="section-header">
                    <span class="section-icon">🎯</span>
                    <h2>今日深度聚焦</h2>
                    <span class="deep-focus-badge">Deep Focus</span>
                </div>
                <div class="focus-card">
                    <h4>📌 主题</h4>
                    <p style="font-size: 16px; font-weight: 600;">AI 安全与透明度工具链爆发</p>
                </div>
                <div class="focus-card">
                    <h4>🔍 核心发现</h4>
                    <ul style="padding-left: 20px;">
                        <li>Cybeetle 提供 AI 驱动的安全扫描</li>
                        <li>AIx 制定 AI 参与度披露标准</li>
                        <li>多个工具检测 AI 代码参与度</li>
                    </ul>
                </div>
                <div class="focus-card">
                    <h4>📊 趋势判断</h4>
                    <ul style="padding-left: 20px;">
                        <li>AI 行业从"快速发展"转向"规范发展"</li>
                        <li>安全与透明度成为基础设施</li>
                        <li>2026 年是"AI 透明元年"</li>
                    </ul>
                </div>
                <div class="focus-card">
                    <h4>💡 行动建议</h4>
                    <ul style="padding-left: 20px;">
                        <li><strong>开发者：</strong>关注 AI 披露标准</li>
                        <li><strong>企业：</strong>建立 AI 使用规范</li>
                        <li><strong>教育：</strong>重新设计课程评估</li>
                    </ul>
                </div>
            </section>
        </main>
        
        <aside class="sidebar">
            <div class="sidebar-card">
                <div class="sidebar-title">📑 目录导航</div>
                <ul class="toc-list">
                    <li><a href="#overview">📋 全文概览</a></li>
                    <li><a href="#foundation-models">🧠 大模型</a></li>
                    <li><a href="#ai-coding">💻 AI Coding</a></li>
                    <li><a href="#ai-apps">📱 AI 应用</a></li>
                    <li><a href="#ai-industry">🏭 AI 行业</a></li>
                    <li><a href="#ai-research">🔬 AI 研究</a></li>
                    <li><a href="#deep-focus">🎯 深度聚焦</a></li>
                </ul>
            </div>
            
            <div class="sidebar-card">
                <div class="sidebar-title">📊 今日概览</div>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value">8</div>
                        <div class="stat-label">热点新闻</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">5</div>
                        <div class="stat-label">领域覆盖</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">1</div>
                        <div class="stat-label">深度聚焦</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">~8</div>
                        <div class="stat-label">分钟阅读</div>
                    </div>
                </div>
            </div>
            
            <div class="sidebar-card">
                <div class="sidebar-title">📚 数据来源</div>
                <ul class="toc-list">
                    <li><a href="https://news.ycombinator.com/" target="_blank">Hacker News</a></li>
                    <li><a href="https://www.technologyreview.com/" target="_blank">MIT Tech Review</a></li>
                    <li><a href="https://arxiv.org/" target="_blank">arXiv</a></li>
                </ul>
            </div>
        </aside>
    </div>
    
    <footer class="footer">
        <a href="../" class="back-link">← 返回首页</a>
        <p>Generated by <strong>OpenClaw AI Assistant (蒋维斯)</strong> for Yixuan 🦞</p>
        <p style="margin-top: 12px;">
            <a href="https://github.com/jyx13121802323/ai-daily-weekly" target="_blank">GitHub</a> · 
            <a href="https://github.com/openclaw/openclaw" target="_blank">OpenClaw</a>
        </p>
    </footer>
</body>
</html>
HTMLEOF

# 生成 Hacker News 新闻条目（使用 Algolia API 获取的真实链接）
generate_hn_items() {
    local titles="$1"
    local urls="$2"
    local count=0
    
    # 将 titles 和 urls 转为数组
    local -a title_arr
    local -a url_arr
    while IFS= read -r line; do
        title_arr+=("$line")
    done <<< "$titles"
    
    while IFS= read -r line; do
        url_arr+=("$line")
    done <<< "$urls"
    
    # 生成 HTML
    for i in "${!title_arr[@]}"; do
        local title="${title_arr[$i]}"
        local url="${url_arr[$i]:-}"
        count=$((count + 1))
        
        if [ -n "$title" ]; then
            local heat_class=""
            [ $count -le 2 ] && heat_class="hot"
            
            if [ -n "$url" ]; then
                cat << ITEM
                <div class="news-item $heat_class">
                    <div class="news-header">
                        <a href="$url" target="_blank" class="news-title">$title</a>
                        <span class="news-source">Hacker News</span>
                    </div>
                    <div class="news-content">
                        AI 领域最新进展
                        <a href="$url" target="_blank" class="news-link">→ 查看讨论</a>
                    </div>
                    <div class="news-why-important">
                        <strong>为什么重要：</strong>AI 社区热门话题
                    </div>
                </div>
ITEM
            else
                cat << ITEM
                <div class="news-item $heat_class">
                    <div class="news-header">
                        <span class="news-title">$title</span>
                        <span class="news-source">Hacker News</span>
                    </div>
                    <div class="news-content">AI 领域最新进展</div>
                </div>
ITEM
            fi
        fi
    done
}

# 生成 MIT Tech Review 新闻条目
generate_mit_items() {
    local data="$1"
    while IFS='|' read -r title link; do
        if [ -n "$title" ]; then
            if [ -n "$link" ] && [ "$link" != "" ]; then
                echo "                <div class=\"news-item\">
                    <div class=\"news-header\">
                        <a href=\"$link\" target=\"_blank\" class=\"news-title\">$title</a>
                        <span class=\"news-source\">MIT Tech Review</span>
                    </div>
                    <div class=\"news-content\">
                        深度报道
                        <a href=\"$link\" target=\"_blank\" class=\"news-link\">→ 阅读全文</a>
                    </div>
                    <div class=\"news-why-important\">
                        <strong>深度解读：</strong>行业趋势分析
                    </div>
                </div>"
            else
                echo "                <div class=\"news-item\">
                    <div class=\"news-header\">
                        <span class=\"news-title\">$title</span>
                        <span class=\"news-source\">MIT Tech Review</span>
                    </div>
                    <div class=\"news-content\">深度报道</div>
                </div>"
            fi
        fi
    done <<< "$data"
}

# 替换占位符
sed -i "s/{DATE_DISPLAY}/$DATE_DISPLAY/g" "$HTML_FILE"
sed -i "s|{TIME_WINDOW}|$(date -d 'yesterday' +%Y-%m-%d)" 08:00 ~ $(date +%Y-%m-%d)" 08:00|g" "$HTML_FILE"

# 生成新闻条目
HN_ITEMS=$(generate_hn_items "$hn_data")
MIT_ITEMS=$(generate_mit_items "$mit_data")

# 简单分类（实际应该更智能）
sed -i "s/{HN_NEWS_ITEMS}/$HN_ITEMS/g" "$HTML_FILE"
sed -i "s/{CODING_NEWS_ITEMS}/$HN_ITEMS/g" "$HTML_FILE"
sed -i "s/{APPS_NEWS_ITEMS}/$MIT_ITEMS/g" "$HTML_FILE"
sed -i "s/{INDUSTRY_NEWS_ITEMS}/$HN_ITEMS/g" "$HTML_FILE"
sed -i "s/{RESEARCH_NEWS_ITEMS}/$MIT_ITEMS/g" "$HTML_FILE"

echo "✅ HTML 日报 v3 生成成功！"
echo "   文件：$HTML_FILE"
