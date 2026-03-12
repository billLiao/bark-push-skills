# Bark 推送技能

## 概述

Bark 是 iOS 上的推送通知工具，免费、简单、安全，基于 APNs，不耗电。支持自建服务器和加密推送。

## 触发场景

- 用户有重要事项需要通知
- 用户明确要求用 Bark 推送
- 需要向 iOS 设备发送推送通知

## 使用前提

1. 用户已在 iOS 设备安装 Bark App
2. 已获取用户的 Bark Key（打开 App 后复制测试 URL 中的 key）

## 推送方法

### 基础推送（GET 请求）

```
https://api.day.app/{key}/{body}
https://api.day.app/{key}/{title}/{body}
https://api.day.app/{key}/{title}/{subtitle}/{body}
```

**参数说明：**

- `key`: 用户的 Bark Key
- `title`: 推送标题（比 body 稍大）
- `subtitle`: 推送副标题
- `body`: 推送内容，换行使用 `\n`

### POST 请求

参数名与路径参数相同。

### 高级功能

#### 点击跳转 URL

```
https://api.day.app/{key}/url?url=https://www.example.com
```

#### 消息分组

```
https://api.day.app/{key}/group?group=groupName
```

#### 自定义图标（iOS 15+）

```
https://api.day.app/{key}/icon?icon=http://example.com/avatar.jpg
```

#### 自定义声音

```
https://api.day.app/{key}/sound?sound=alarm
```

#### 循环播放声音 30 秒（来电模式）

```
https://api.day.app/{key}/call?call=1
```

#### 加密推送

```
https://api.day.app/{key}/ciphertext?ciphertext=加密内容
```

#### 时效性通知

```
https://api.day.app/{key}/title?level=timeSensitive
```

**level 可选值：**

- `active`: 默认值，立即亮屏显示
- `timeSensitive`: 时效性通知，专注模式下也可显示
- `passive`: 仅添加到通知列表，不亮屏

#### 紧急警报

```
https://api.day.app/{key}/title?level=critical
```

忽略静音和勿扰模式，始终播放声音并显示通知。

## 推送脚本

### 简单推送脚本

```bash
#!/bin/bash

# bark_push.sh - Bark 推送脚本

KEY="${1:-your-bark-key}"
TITLE="${2:-通知}"
BODY="${3:-内容}"

# URL 编码
TITLE_ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$TITLE'))")
BODY_ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$BODY'))")

curl -s "https://api.day.app/${KEY}/${TITLE_ENCODED}/${BODY_ENCODED}"
```

### 使用示例

```bash
# 简单推送
./bark_push.sh "your-key" "标题" "内容"

# 带跳转 URL
curl "https://api.day.app/your-key/url?url=https://example.com"

# 时效性通知
curl "https://api.day.app/your-key/提醒?level=timeSensitive"
```

## 注意事项

1. 首次使用需要获取用户的 Bark Key
2. 时效性通知和紧急警报需要用户在 iOS 设置中授权
3. 自建服务器用户需将 `api.day.app` 替换为自建服务器地址
4. 推送内容建议 URL 编码处理特殊字符