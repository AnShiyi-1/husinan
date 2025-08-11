# OAuth第三方登录快速配置指南

## 问题说明
当前微信和QQ登录显示AppID参数错误，是因为使用了占位符而非真实的AppID。以下是获取和配置真实AppID的完整步骤。

## 🔧 微信登录配置

### 1. 注册微信开放平台账号
- 访问：https://open.weixin.qq.com
- 注册开发者账号并完成企业/个人认证

### 2. 创建网站应用
- 登录后进入【管理中心】→【网站应用】
- 点击【创建网站应用】
- 填写应用信息：
  - 应用名称：情绪画布
  - 应用简介：基于情绪识别的绘画创作平台
  - 应用官网：http://localhost:3002
  - 应用回调地址：http://localhost:3001/api/oauth/wechat/callback

### 3. 获取AppID和AppSecret
创建成功后，在应用详情页面获取：
- AppID：以wx开头的一串字符
- AppSecret：对应的密钥

### 4. 配置环境变量
在 `.env` 文件中更新：
```
WECHAT_APP_ID=你的真实微信AppID
WECHAT_APP_SECRET=你的真实微信AppSecret
VITE_WECHAT_APP_ID=你的真实微信AppID
```

## 🔧 QQ登录配置

### 1. 注册QQ互联账号
- 访问：https://connect.qq.com
- 使用QQ账号登录并完成开发者认证

### 2. 创建网站应用
- 进入【应用管理】→【网站应用】
- 点击【创建应用】
- 填写应用信息：
  - 网站名称：情绪画布
  - 网站域名：localhost:3002
  - 网站回调地址：http://localhost:3001/api/oauth/qq/callback
  - 网站图标：上传应用图标

### 3. 获取AppID和AppKey
审核通过后，在应用详情页面获取：
- AppID：纯数字
- AppKey：对应的密钥

### 4. 配置环境变量
在 `.env` 文件中更新：
```
QQ_APP_ID=你的真实QQAppID
QQ_APP_KEY=你的真实QQAppKey
VITE_QQ_APP_ID=你的真实QQAppID
```

## ⚡ 快速验证步骤

### 1. 检查配置
确保 `.env` 文件中包含：
```
# 微信配置
WECHAT_APP_ID=wx1234567890abcdef
WECHAT_APP_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
VITE_WECHAT_APP_ID=wx1234567890abcdef

# QQ配置  
QQ_APP_ID=123456789
QQ_APP_KEY=xxxxxxxxxxxxxxxx
VITE_QQ_APP_ID=123456789
```

### 2. 重启服务
```bash
# 重启前端服务
npm run dev

# 重启后端服务  
npm run server
```

### 3. 测试登录
- 访问 http://localhost:3002
- 点击右上角【登录】
- 选择微信或QQ登录测试

## 📝 注意事项

### 微信登录
- 必须使用备案过的域名（localhost仅开发测试用）
- 需要HTTPS协议（生产环境）
- 回调地址必须与应用设置完全一致

### QQ登录
- localhost域名需要特殊处理
- 确保回调地址格式正确
- 应用需要审核通过才能使用

## 🚀 开发测试方案

如果暂时没有正式AppID，可以使用以下方案：

### 1. 使用测试账号
- 微信：申请测试账号 https://developers.weixin.qq.com/doc/oplatform/Website_App/WeChat_Login/Wechat_Login.html
- QQ：使用测试模式

### 2. 模拟登录
在开发环境中，可以使用邮箱验证码登录作为替代方案。

## 🔍 常见问题排查

### AppID错误
- 检查AppID是否填写正确
- 确认前后端配置一致
- 验证环境变量是否加载

### 回调地址错误
- 确认回调地址与平台设置一致
- 检查是否包含http://前缀
- 验证端口号是否正确

### 网络问题
- 确保能正常访问微信/QQ服务器
- 检查防火墙设置
- 验证DNS解析

配置完成后，微信和QQ登录功能将正常工作！