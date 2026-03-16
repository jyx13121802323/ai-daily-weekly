#!/bin/bash
# Update index.html with today's AI daily report card
# Usage: bash scripts/update-index-html.sh 2026-03-16 "HN_TITLE1|HN_TITLE2|HN_TITLE3|..."

set -e

TODAY="$1"
HN_TITLES="$2"
INDEX_FILE="index.html"
MONTH=$(date +%Y-%m)
DAY=$(echo "$TODAY" | cut -d'-' -f3)

# Remove leading zero from day for display
DAY_DISPLAY=$(echo "$DAY" | sed 's/^0//')

echo "   📅 Updating index.html for $TODAY..."

# Extract top 3 titles for preview (handle pipe-separated format)
TITLE1=$(echo "$HN_TITLES" | sed -n '1p' | cut -c1-35)
TITLE2=$(echo "$HN_TITLES" | sed -n '2p' | cut -c1-35)
TITLE3=$(echo "$HN_TITLES" | sed -n '3p' | cut -c1-35)

# Generate preview text
PREVIEW="AI 技术最新进展；Hacker News 社区热议；${TITLE1}..."

# Generate tags based on content
TAGS='<span class="tag hot">#HackerNews</span><span class="tag new">#AI 技术</span>'
if echo "$HN_TITLES" | grep -qi "security\|safety"; then
    TAGS="$TAGS<span class=\"tag\">#安全</span>"
fi
if echo "$HN_TITLES" | grep -qi "open.*source\|github"; then
    TAGS="$TAGS<span class=\"tag\">#开源</span>"
fi
if echo "$HN_TITLES" | grep -qi "agent\|autonomous"; then
    TAGS="$TAGS<span class=\"tag hot\">#AI Agent</span>"
fi

# Create today's report card HTML
TODAY_CARD=$(cat << EOF
                <!-- $TODAY -->
                <article class="report-card featured">
                    <div class="report-meta">
                        <span class="report-date">📅 $MONTH-$DAY_DISPLAY</span>
                        <span class="report-type">AI 技术</span>
                    </div>
                    <h3 class="report-title">AI 技术日报 - ${TITLE1}、${TITLE2}</h3>
                    <p class="report-preview">
                        $PREVIEW
                    </p>
                    <div class="report-stats">
                        <span class="report-stat">📝 8 个热点</span>
                        <span class="report-stat">💡 3 篇深度</span>
                        <span class="report-stat">⏱️ 6 分钟阅读</span>
                    </div>
                    <a href="daily-reports/$MONTH/$TODAY-ai-news.html" class="report-link">
                        阅读全文 <span>→</span>
                    </a>
                    <div class="report-tags">
                        $TAGS
                    </div>
                </article>

                <!-- $MONTH-$DAY_DISPLAY (previous) -->
EOF
)

# Check if today's card already exists
if grep -q "$TODAY-ai-news.html" "$INDEX_FILE" 2>/dev/null; then
    echo "   ⚠️ Today's card already exists in index.html"
    exit 0
fi

# Find the position to insert (before the first existing report card comment)
# Look for pattern: <!-- MM-DD -->
FIRST_REPORT_LINE=$(grep -n "<!-- [0-9][0-9]-[0-9][0-9] -->" "$INDEX_FILE" | head -1 | cut -d: -f1)

if [ -z "$FIRST_REPORT_LINE" ]; then
    echo "   ⚠️ Could not find report grid section"
    exit 1
fi

# Create backup
cp "$INDEX_FILE" "$INDEX_FILE.bak"

# Insert today's card before the first existing card
head -n $((FIRST_REPORT_LINE - 1)) "$INDEX_FILE" > "$INDEX_FILE.tmp"
echo "$TODAY_CARD" >> "$INDEX_FILE.tmp"
tail -n +$FIRST_REPORT_LINE "$INDEX_FILE" >> "$INDEX_FILE.tmp"
mv "$INDEX_FILE.tmp" "$INDEX_FILE"

# Remove backup after success
rm -f "$INDEX_FILE.bak"

echo "   ✅ index.html updated successfully"
