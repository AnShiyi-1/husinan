# 🚀 情绪画布部署指南

## 方案1：Vercel部署（推荐 - 免费且简单）

### 📋 准备工作
1. 注册 [Vercel账号](https://vercel.com)
2. 安装 [Git](https://git-scm.com/)

### 🎯 一键部署步骤

#### 方法A：GitHub + Vercel（推荐）
1. **创建GitHub仓库**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/你的用户名/绘画软件.git
   git push -u origin main
   ```

2. **Vercel一键部署**
   - 访问 [vercel.com](https://vercel.com)
   - 点击 "New Project"
   - 选择GitHub仓库
   - 点击 "Deploy" 即可

#### 方法B：直接上传部署
1. **压缩项目文件夹**
2. **访问 [vercel.com](https://vercel.com)**
3. **拖拽zip文件到部署区域**

### ⚙️ 环境变量配置
在Vercel项目设置中添加：
```
NODE_ENV=production
JWT_SECRET=your-jwt-secret-key
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key
```

## 方案2：Netlify部署

### 📋 一键部署
1. 访问 [netlify.com](https://netlify.com)
2. 拖拽 `dist` 文件夹到部署区域
3. 设置重定向规则

### ⚙️ 配置重定向
创建 `dist/_redirects` 文件：
```
/api/* https://your-backend.vercel.app/api/:splat 200
/* /index.html 200
```

## 方案3：阿里云/腾讯云部署

### 📋 阿里云OSS部署
1. **上传dist文件夹**
   - 登录阿里云OSS控制台
   - 创建Bucket
   - 上传dist文件夹内容

2. **配置静态网站托管**
   - 设置默认首页为 `index.html`
   - 设置错误页面为 `index.html`

### 📋 腾讯云COS部署
1. **上传dist文件夹**
2. **配置静态网站**
3. **绑定自定义域名**

## 方案4：Docker部署

### 📋 创建Dockerfile
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["node", "server/index.js"]
```

### 🐳 一键部署命令
```bash
# 构建镜像
docker build -t emotion-canvas .

# 运行容器
docker run -d -p 3000:3000 emotion-canvas
```

## 🎯 部署后测试

### ✅ 测试清单
- [ ] 访问首页 http://your-domain.com
- [ ] 测试用户注册/登录
- [ ] 测试绘画功能
- [ ] 测试作品保存
- [ ] 测试情绪分析

### 🔍 调试工具
```bash
# 查看部署日志
vercel logs

# 测试API
curl -X POST https://your-domain.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"123456"}'
```

## 📞 技术支持

### 常见问题
1. **404错误**：检查路由配置
2. **API跨域**：确保CORS配置正确
3. **静态资源**：检查文件路径

### 联系方式
- 部署问题：查看各平台文档
- 代码问题：提交GitHub Issue

## 🎉 恭喜！
选择任意方案，5分钟内即可完成部署！

**推荐顺序**：Vercel → Netlify → 云服务商 → Docker