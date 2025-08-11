# 🎯 Supabase后端部署指南

## ✅ 3步完成部署

### 第1步：注册账号
访问：https://app.supabase.com
使用GitHub登录

### 第2步：创建项目
- 项目名：`emotion-canvas`
- 地区：Singapore (Singapore)
- 设置数据库密码

### 第3步：获取配置信息
创建项目后，在Settings > API中获取：
- **Project URL**: `https://[your-project].supabase.co`
- **Anon Key**: 复制anon public key

## 🚀 一键配置

### 方法1：使用现有脚本
```bash
npm run setup-supabase
```

### 方法2：手动配置
1. 复制`.env.example`为`.env`
2. 填入你的Supabase信息：
```
VITE_SUPABASE_URL=你的Project URL
VITE_SUPABASE_ANON_KEY=你的Anon Key
```

3. 运行数据库初始化：
```bash
npm install @supabase/supabase-js
node setup-supabase.js
```

## 📊 免费额度
- **数据库**：500MB PostgreSQL
- **API请求**：每日200MB
- **文件存储**：1GB
- **边缘函数**：500K次/月

## 🔗 访问地址
- **前端**：你的Vercel域名
- **后端API**：`https://[your-project].supabase.co`
- **数据库**：PostgreSQL实时同步

## ✅ 已准备好的功能
- 用户注册/登录
- 情绪记录存储
- 画布数据保存
- 实时数据同步

**现在就开始！只需要3分钟完成部署。**