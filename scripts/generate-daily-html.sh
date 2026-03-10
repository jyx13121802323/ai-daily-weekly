#!/bin/bash
# AI Daily Report HTML Generator
# 生成炫酷的 HTML 版本日报

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)
MONTH=$(date +%Y-%m)
MD_FILE="$WORKSPACE/daily-reports/$MONTH/$DATE.md"
HTML_FILE="$WORKSPACE/daily-reports/$MONTH/$DATE.html"

echo "🎨 生成 HTML 日报..."
echo "   日期：$DATE"

# 创建 HTML
cat > "$HTML_FILE" << 'HTMLEOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 技术日报 | {{DATE}}</title>
    <style>
        :root {
            --color-success: #059669;
            --color-success-light: #10B981;
            --color-info: #2563EB;
            --color-purple: #7C3AED;
            --color-warning: #D97706;
            --color-bg: #F8FAFB;
            --color-text: #1C1917;
            --color-text-secondary: #57534E;
            --gradient-hero: linear-gradient(135deg, #059669 0%, #2563EB 50%, #7C3AED 100%);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.07);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.08);
        }
        
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: -apple-system, "SF Pro Display", system-ui, "Noto Sans SC", sans-serif;
            background: var(--color-bg);
            color: var(--color-text);
            line-height: 1.7;
            padding-bottom: 60px;
        }
        
        /* Header */
        .header {
            background: white;
            padding: 40px 20px;
            text-align: center;
            border-bottom: 3px solid transparent;
            border-image: var(--gradient-hero);
            border-image-slice: 1;
            margin-bottom: 30px;
        }
        
        .header-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            background: linear-gradient(135deg, #ECFDF5, #EFF6FF);
            color: var(--color-info);
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 16px;
        }
        
        .header h1 {
            font-size: 32px;
            font-weight: 800;
            background: var(--gradient-hero);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
        }
        
        .header-date {
            color: var(--color-text-secondary);
            font-size: 15px;
        }
        
        /* Container */
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        /* Section */
        .section {
            background: white;
            border-radius: 16px;
            padding: 32px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-md);
            border: 1px solid rgba(0,0,0,0.04);
        }
        
        .section-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 2px solid rgba(5, 150, 105, 0.1);
        }
        
        .section-icon {
            font-size: 28px;
        }
        
        .section h2 {
            font-size: 22px;
            font-weight: 700;
            color: var(--color-text);
        }
        
        /* Hot News Table */
        .news-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        .news-table th {
            background: rgba(5, 150, 105, 0.05);
            padding: 12px 16px;
            text-align: left;
            font-weight: 600;
            color: var(--color-success);
            font-size: 14px;
        }
        
        .news-table td {
            padding: 14px 16px;
            border-bottom: 1px solid rgba(0,0,0,0.04);
        }
        
        .news-table tr:last-child td {
            border-bottom: none;
        }
        
        .news-table tr:hover {
            background: rgba(5, 150, 105, 0.02);
        }
        
        .news-title a {
            color: var(--color-text);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        
        .news-title a:hover {
            color: var(--color-success);
        }
        
        .news-source {
            padding: 4px 10px;
            background: rgba(37, 99, 235, 0.08);
            color: var(--color-info);
            border-radius: 8px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .news-heat {
            font-size: 16px;
        }
        
        /* Paper Card */
        .paper-card {
            background: linear-gradient(135deg, rgba(5,150,105,0.03) 0%, rgba(37,99,235,0.03) 100%);
            border: 1px solid rgba(5, 150, 105, 0.1);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 16px;
        }
        
        .paper-card:last-child {
            margin-bottom: 0;
        }
        
        .paper-title {
            font-size: 17px;
            font-weight: 600;
            color: var(--color-text);
            margin-bottom: 12px;
        }
        
        .paper-title a {
            color: var(--color-info);
            text-decoration: none;
        }
        
        .paper-title a:hover {
            text-decoration: underline;
        }
        
        .paper-meta {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }
        
        .paper-meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: var(--color-text-secondary);
        }
        
        .paper-contributions {
            margin-top: 12px;
        }
        
        .paper-contributions h4 {
            font-size: 14px;
            font-weight: 600;
            color: var(--color-success);
            margin-bottom: 8px;
        }
        
        .paper-contributions ul {
            list-style: none;
            padding-left: 0;
        }
        
        .paper-contributions li {
            padding: 4px 0;
            padding-left: 20px;
            position: relative;
            font-size: 14px;
            color: var(--color-text-secondary);
        }
        
        .paper-contributions li::before {
            content: "✓";
            position: absolute;
            left: 0;
            color: var(--color-success);
            font-weight: 700;
        }
        
        /* Tool Grid */
        .tool-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
        }
        
        .tool-card {
            background: white;
            border: 1px solid rgba(0,0,0,0.06);
            border-radius: 12px;
            padding: 20px;
            transition: all 0.2s;
        }
        
        .tool-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            border-color: var(--color-success);
        }
        
        .tool-name {
            font-size: 16px;
            font-weight: 600;
            color: var(--color-text);
            margin-bottom: 8px;
        }
        
        .tool-type {
            display: inline-block;
            padding: 4px 10px;
            background: rgba(124, 58, 237, 0.08);
            color: var(--color-purple);
            border-radius: 8px;
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 12px;
        }
        
        .tool-features {
            font-size: 13px;
            color: var(--color-text-secondary);
            margin-bottom: 12px;
            line-height: 1.5;
        }
        
        .tool-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--color-info);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s;
        }
        
        .tool-link:hover {
            color: var(--color-success);
        }
        
        /* Discussion */
        .discussion-card {
            background: rgba(255, 193, 7, 0.05);
            border-left: 4px solid var(--color-warning);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        
        .discussion-topic {
            font-size: 17px;
            font-weight: 600;
            color: var(--color-text);
            margin-bottom: 12px;
        }
        
        .discussion-meta {
            display: flex;
            gap: 12px;
            margin-bottom: 12px;
            font-size: 13px;
            color: var(--color-text-secondary);
        }
        
        .discussion-views {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        
        .discussion-opinions {
            margin-top: 12px;
        }
        
        .opinion {
            padding: 12px 16px;
            background: white;
            border-radius: 8px;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .opinion-positive {
            border-left: 3px solid var(--color-success);
        }
        
        .opinion-negative {
            border-left: 3px solid var(--color-info);
        }
        
        /* Footer */
        .footer {
            text-align: center;
            padding: 30px 20px;
            color: var(--color-text-secondary);
            font-size: 14px;
            margin-top: 40px;
        }
        
        .footer a {
            color: var(--color-info);
            text-decoration: none;
        }
        
        /* Tags */
        .tags {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 12px;
        }
        
        .tag {
            padding: 4px 10px;
            background: rgba(124, 58, 237, 0.08);
            color: var(--color-purple);
            border-radius: 8px;
            font-size: 12px;
            font-weight: 500;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .header h1 { font-size: 24px; }
            .section { padding: 20px; }
            .news-table { font-size: 13px; }
            .tool-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-badge">
            <span>🤖</span>
            <span>AI 技术日报</span>
        </div>
        <h1>AI Daily Report</h1>
        <p class="header-date">{{DATE}}</p>
    </div>

    <!-- Main Content -->
    <div class="container">
        <!-- Hot News Section -->
        <div class="section">
            <div class="section-header">
                <span class="section-icon">🔥</span>
                <h2>今日热点</h2>
            </div>
            <table class="news-table">
                <thead>
                    <tr>
                        <th width="60%">标题</th>
                        <th width="20%">来源</th>
                        <th width="20%">热度</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="news-title">
                            <a href="https://news.ycombinator.com/" target="_blank">Hacker News AI 热点 - AI 行业持续发展，多个新工具发布</a>
                        </td>
                        <td><span class="news-source">Hacker News</span></td>
                        <td class="news-heat">🔥🔥🔥</td>
                    </tr>
                    <tr>
                        <td class="news-title">
                            <a href="https://news.ycombinator.com/" target="_blank">AI 工具与应用 - 大模型技术不断演进</a>
                        </td>
                        <td><span class="news-source">Hacker News</span></td>
                        <td class="news-heat">🔥🔥</td>
                    </tr>
                    <tr>
                        <td class="news-title">
                            <a href="https://news.ycombinator.com/" target="_blank">大模型最新进展 - 社区讨论热烈</a>
                        </td>
                        <td><span class="news-source">Hacker News</span></td>
                        <td class="news-heat">🔥</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Papers Section -->
        <div class="section">
            <div class="section-header">
                <span class="section-icon">📚</span>
                <h2>论文推荐</h2>
            </div>
            
            <div class="paper-card">
                <h3 class="paper-title">
                    <a href="http://arxiv.org/list/cs.AI/recent" target="_blank">最新 AI 论文 - 多所大学/研究机构</a>
                </h3>
                <div class="paper-meta">
                    <span class="paper-meta-item">🏢 机构：多所大学/研究机构</span>
                    <span class="paper-meta-item">📁 方向：NLP/CV/多模态</span>
                </div>
                <div class="paper-contributions">
                    <h4>核心贡献</h4>
                    <ul>
                        <li>提出新的架构设计</li>
                        <li>性能提升</li>
                    </ul>
                </div>
                <div class="tags">
                    <span class="tag">#NLP</span>
                    <span class="tag">#CV</span>
                    <span class="tag">#多模态</span>
                </div>
            </div>
        </div>

        <!-- Tools Section -->
        <div class="section">
            <div class="section-header">
                <span class="section-icon">🛠️</span>
                <h2>工具/产品</h2>
            </div>
            <div class="tool-grid">
                <div class="tool-card">
                    <h3 class="tool-name">新工具 A</h3>
                    <span class="tool-type">API/平台</span>
                    <p class="tool-features">特点描述：强大的功能，易于集成</p>
                    <a href="#" class="tool-link">查看详情 →</a>
                </div>
                <div class="tool-card">
                    <h3 class="tool-name">新工具 B</h3>
                    <span class="tool-type">开源项目</span>
                    <p class="tool-features">特点描述：社区活跃，文档完善</p>
                    <a href="#" class="tool-link">查看代码 →</a>
                </div>
            </div>
        </div>

        <!-- Discussion Section -->
        <div class="section">
            <div class="section-header">
                <span class="section-icon">💬</span>
                <h2>社区讨论</h2>
            </div>
            
            <div class="discussion-card">
                <h3 class="discussion-topic">AI Agent 的未来</h3>
                <div class="discussion-meta">
                    <span class="discussion-views">👁️ 1.2k 次浏览</span>
                    <span>💭 56 条评论</span>
                    <span>📍 Twitter/知乎</span>
                </div>
                <div class="discussion-opinions">
                    <div class="opinion opinion-positive">
                        <strong>正方观点：</strong>Agent 将改变工作方式，自动化程度会大幅提升
                    </div>
                    <div class="opinion opinion-negative">
                        <strong>反方观点：</strong>还需要技术突破，目前能力有限
                    </div>
                </div>
                <div style="margin-top: 12px;">
                    <a href="#" class="tool-link">参与讨论 →</a>
                </div>
            </div>
        </div>

        <!-- Data & Trends Section -->
        <div class="section">
            <div class="section-header">
                <span class="section-icon">📊</span>
                <h2>数据/趋势</h2>
            </div>
            <div style="padding: 20px; background: rgba(37, 99, 235, 0.05); border-radius: 8px;">
                <p style="margin-bottom: 12px; font-size: 15px;">
                    <strong style="color: var(--color-info);">关键数据：</strong>
                    某公司发布新模型，参数达到 XXXB
                </p>
                <p style="font-size: 15px;">
                    <strong style="color: var(--color-success);">趋势观察：</strong>
                    AI Agent 技术方向热度上升
                </p>
            </div>
        </div>

        <!-- Tomorrow's Focus Section -->
        <div class="section">
            <div class="section-header">
                <span class="section-icon">🎯</span>
                <h2>明日关注</h2>
            </div>
            <div style="display: grid; gap: 12px;">
                <div style="display: flex; align-items: center; gap: 12px; padding: 14px; background: rgba(5, 150, 105, 0.05); border-radius: 8px;">
                    <span style="font-size: 20px;">📅</span>
                    <div>
                        <strong style="color: var(--color-success);">即将发布：</strong>
                        <span style="color: var(--color-text-secondary);">某产品/论文</span>
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 12px; padding: 14px; background: rgba(37, 99, 235, 0.05); border-radius: 8px;">
                    <span style="font-size: 20px;">🎤</span>
                    <div>
                        <strong style="color: var(--color-info);">会议活动：</strong>
                        <span style="color: var(--color-text-secondary);">AI 会议名称</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <p>Generated by <strong>OpenClaw AI Assistant</strong> 🦞</p>
        <p style="margin-top: 8px;">
            <a href="../">← 返回首页</a> | 
            <a href="https://github.com/jyx13121802323/ai-daily-weekly" target="_blank">GitHub</a>
        </p>
    </footer>
</body>
</html>
HTMLEOF

# 替换日期
sed -i "s/{{DATE}}/$DATE/g" "$HTML_FILE"

echo "✅ HTML 日报生成成功！"
echo "   文件：$HTML_FILE"
