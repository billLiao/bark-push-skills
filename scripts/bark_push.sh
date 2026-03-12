#!/bin/bash

# bark_push.sh - Bark 推送脚本
# 用法: ./bark_push.sh <key> [title] [body] [options]
# 示例: ./bark_push.sh "your-key" "标题" "内容"

set -e

# 默认值
KEY="${1:-}"
TITLE="${2:-通知}"
BODY="${3:-内容}"
URL=""
LEVEL=""
SOUND=""
GROUP=""
ICON=""

# 解析额外参数
shift 3
while [[ $# -gt 0 ]]; do
    case $1 in
        --url)
            URL="$2"
            shift 2
            ;;
        --level)
            LEVEL="$2"
            shift 2
            ;;
        --sound)
            SOUND="$2"
            shift 2
            ;;
        --group)
            GROUP="$2"
            shift 2
            ;;
        --icon)
            ICON="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# 检查 key
if [[ -z "$KEY" ]]; then
    echo "用法: $0 <key> [title] [body] [--url <url>] [--level <level>] [--sound <sound>] [--group <group>] [--icon <icon>]"
    echo "示例: $0 \"your-key\" \"标题\" \"内容\" --url \"https://example.com\" --level timeSensitive"
    exit 1
fi

# URL 编码函数
url_encode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

# 构建请求 URL
TITLE_ENCODED=$(url_encode "$TITLE")
BODY_ENCODED=$(url_encode "$BODY")

BASE_URL="https://api.day.app/${KEY}/${TITLE_ENCODED}/${BODY_ENCODED}"

# 添加可选参数
if [[ -n "$URL" ]]; then
    URL_ENCODED=$(url_encode "$URL")
    BASE_URL="${BASE_URL}?url=${URL_ENCODED}"
    FIRST_PARAM=true
fi

if [[ -n "$LEVEL" ]]; then
    if [[ -n "$FIRST_PARAM" ]]; then
        BASE_URL="${BASE_URL}&level=${LEVEL}"
    else
        BASE_URL="${BASE_URL}?level=${LEVEL}"
        FIRST_PARAM=true
    fi
fi

if [[ -n "$SOUND" ]]; then
    if [[ -n "$FIRST_PARAM" ]]; then
        BASE_URL="${BASE_URL}&sound=${SOUND}"
    else
        BASE_URL="${BASE_URL}?sound=${SOUND}"
        FIRST_PARAM=true
    fi
fi

if [[ -n "$GROUP" ]]; then
    if [[ -n "$FIRST_PARAM" ]]; then
        BASE_URL="${BASE_URL}&group=${GROUP}"
    else
        BASE_URL="${BASE_URL}?group=${GROUP}"
        FIRST_PARAM=true
    fi
fi

if [[ -n "$ICON" ]]; then
    ICON_ENCODED=$(url_encode "$ICON")
    if [[ -n "$FIRST_PARAM" ]]; then
        BASE_URL="${BASE_URL}&icon=${ICON_ENCODED}"
    else
        BASE_URL="${BASE_URL}?icon=${ICON_ENCODED}"
    fi
fi

# 发送推送
echo "发送推送..."
echo "URL: ${BASE_URL}"

RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY_RESPONSE=$(echo "$RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" == "200" ]]; then
    echo "推送成功!"
    echo "响应: $BODY_RESPONSE"
else
    echo "推送失败! HTTP 状态码: $HTTP_CODE"
    echo "响应: $BODY_RESPONSE"
    exit 1
fi