# Bark Push Skills

![Bark](https://img.shields.io/badge/Bark-iOS%20Push%20Notification-blue)

Bark Push Skills for nanobot - iOS 推送通知技能

## 概述

Bark 是 iOS 上的推送通知工具，免费、简单、安全，基于 APNs，不耗电。支持自建服务器和加密推送。

## 功能特性

- 📱 iOS 设备推送通知
- 🔗 支持点击跳转 URL
- 🔔 自定义通知声音
- ⏰ 时效性通知（iOS 15+）
- 🚨 紧急警报
- 🔒 加密推送支持
- 📊 消息分组

## 快速开始

### 前置条件

1. 在 iOS 设备安装 [Bark App](https://apps.apple.com/us/app/bark-customed-notifications/id1525733262)
2. 获取 Bark Key（打开 App 后复制测试 URL 中的 key）

### 使用方法

```bash
# 简单推送
./bark_push.sh "your-key" "标题" "内容"

# 带跳转 URL
curl "https://api.day.app/your-key/url?url=https://example.com"

# 时效性通知
curl "https://api.day.app/your-key/提醒?level=timeSensitive"
```

## 项目结构

```
bark-push-skills/
├── README.md           # 项目说明
├── SKILL.md            # 技能详细文档
├── scripts/
│   └── bark_push.sh    # 推送脚本
└── examples/
    └── examples.md     # 使用示例
```

## API 参考

### 基础推送

```
https://api.day.app/{key}/{body}
https://api.day.app/{key}/{title}/{body}
https://api.day.app/{key}/{title}/{subtitle}/{body}
```

### 高级功能

| 功能 | 参数 | 说明 |
|------|------|------|
| 点击跳转 | `?url=https://...` | 打开指定 URL |
| 消息分组 | `?group=groupName` | 消息分组显示 |
| 自定义图标 | `?icon=http://...` | iOS 15+ |
| 自定义声音 | `?sound=alarm` | 使用预设声音 |
| 循环播放 | `?call=1` | 来电模式 30 秒 |
| 加密推送 | `?ciphertext=...` | 加密内容 |
| 时效通知 | `?level=timeSensitive` | 专注模式也可显示 |
| 紧急警报 | `?level=critical` | 忽略静音 |

## 在 nanobot 中使用

此技能已集成到 nanobot，可通过以下方式触发：

- 用户有重要事项需要通知
- 用户明确要求用 Bark 推送
- 需要向 iOS 设备发送推送通知

## 注意事项

1. 首次使用需要获取用户的 Bark Key
2. 时效性通知和紧急警报需要用户在 iOS 设置中授权
3. 自建服务器用户需将 `api.day.app` 替换为自建服务器地址
4. 推送内容建议 URL 编码处理特殊字符

## 许可证

MIT License

## 相关链接

- [Bark App](https://apps.apple.com/us/app/bark-customed-notifications/id1525733262)
- [Bark 官方文档](https://day.app/2018/06/bark-server-document)