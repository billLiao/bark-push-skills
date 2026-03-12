# Bark Push 使用示例

## 基础示例

### 简单文本推送

```bash
./bark_push.sh "your-bark-key" "标题" "推送内容"
```

### 带副标题推送

```bash
curl "https://api.day.app/your-key/标题/副标题/正文内容"
```

## 高级示例

### 带跳转链接

```bash
./bark_push.sh "your-key" "新消息" "点击查看详情" --url "https://example.com"
```

### 时效性通知（iOS 15+）

```bash
./bark_push.sh "your-key" "会议提醒" "5分钟后开始" --level "timeSensitive"
```

### 自定义声音

```bash
./bark_push.sh "your-key" "闹钟" "起床啦" --sound "alarm"
```

### 消息分组

```bash
./bark_push.sh "your-key" "订单通知" "您的订单已发货" --group "orders"
```

### 来电模式（循环播放 30 秒）

```bash
curl "https://api.day.app/your-key/紧急/请立即处理?call=1"
```

### 紧急警报

```bash
./bark_push.sh "your-key" "警告" "系统异常" --level "critical"
```

### 自定义图标（iOS 15+）

```bash
./bask_push.sh "your-key" "新消息" "内容" --icon "https://example.com/icon.png"
```

### 组合多个参数

```bash
./bark_push.sh "your-key" "会议提醒" "下午3点" --url "https://meet.example.com" --level "timeSensitive" --sound "meeting" --group "work"
```

## Python 示例

```python
import urllib.request
import urllib.parse

def bark_push(key, title, body, **kwargs):
    """Bark 推送函数"""
    title_encoded = urllib.parse.quote(title)
    body_encoded = urllib.parse.quote(body)
    
    url = f"https://api.day.app/{key}/{title_encoded}/{body_encoded}"
    
    params = []
    if kwargs.get('url'):
        params.append(f"url={urllib.parse.quote(kwargs['url'])}")
    if kwargs.get('level'):
        params.append(f"level={kwargs['level']}")
    if kwargs.get('sound'):
        params.append(f"sound={kwargs['sound']}")
    if kwargs.get('group'):
        params.append(f"group={kwargs['group']}")
    
    if params:
        url += "?" + "&".join(params)
    
    with urllib.request.urlopen(url) as response:
        return response.read()

# 使用示例
bark_push("your-key", "标题", "内容", level="timeSensitive")
```

## Node.js 示例

```javascript
const https = require('https');

function barkPush(key, title, body, options = {}) {
  const params = new URLSearchParams();
  
  if (options.url) params.append('url', options.url);
  if (options.level) params.append('level', options.level);
  if (options.sound) params.append('sound', options.sound);
  if (options.group) params.append('group', options.group);
  
  const encodedTitle = encodeURIComponent(title);
  const encodedBody = encodeURIComponent(body);
  
  let url = `https://api.day.app/${key}/${encodedTitle}/${encodedBody}`;
  if (params.toString()) {
    url += '?' + params.toString();
  }
  
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

// 使用示例
barkPush('your-key', '标题', '内容', { level: 'timeSensitive' })
  .then(console.log)
  .catch(console.error);
```

## 常见问题

### Q: 如何获取 Bark Key？
A: 打开 Bark App，点击右上角的添加按钮，选择"添加自定义服务器"，复制测试 URL 中的 key 部分。

### Q: 时效性通知不生效？
A: 需要在 iOS 设置 > 通知 > Bark 中开启"时序性通知"权限。

### Q: 紧急警报不响？
A: 需要在 iOS 设置 > 通知 > Bark 中开启"紧急警报"权限。

### Q: 如何使用自建服务器？
A: 将 URL 中的 `api.day.app` 替换为你的自建服务器地址。