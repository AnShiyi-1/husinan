# 第三方登录集成配置指南

## 概述
本项目已集成手机号、微信和QQ三种登录方式，用户可以选择任意一种方式快速登录。

## 配置步骤

### 1. 微信登录配置

#### 1.1 申请微信开放平台账号
- 访问 [微信开放平台](https://open.weixin.qq.com/)
- 注册开发者账号并完成企业认证
- 创建网站应用，获取 `AppID` 和 `AppSecret`

#### 1.2 配置微信登录
在 `.env` 文件中配置微信登录参数：
```bash
WECHAT_APP_ID=你的微信应用ID
WECHAT_APP_SECRET=你的微信应用密钥
WECHAT_CALLBACK_URL=http://localhost:3001/api/oauth/wechat/callback
```

#### 1.3 设置微信开放平台回调域名
- 在微信开放平台 → 管理中心 → 网站应用 → 修改
- 设置授权回调域为：`localhost`（开发环境）
- 生产环境设置为你的实际域名

### 2. QQ登录配置

#### 2.1 申请QQ互联账号
- 访问 [QQ互联](https://connect.qq.com/)
- 注册开发者账号并完成认证
- 创建网站应用，获取 `AppID` 和 `AppKey`

#### 2.2 配置QQ登录
在 `.env` 文件中配置QQ登录参数：
```bash
QQ_APP_ID=你的QQ应用ID
QQ_APP_KEY=你的QQ应用密钥
QQ_CALLBACK_URL=http://localhost:3001/api/oauth/qq/callback
```

#### 2.3 设置QQ互联回调地址
- 在QQ互联 → 应用管理 → 网站应用 → 修改
- 设置回调地址为：`http://localhost:3001/api/oauth/qq/callback`
- 生产环境设置为你的实际域名

### 3. 数据库配置

#### 3.1 执行数据库迁移
在Supabase控制台执行以下SQL：

```sql
-- 为用户表添加第三方登录字段
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS wechat_openid VARCHAR(255) UNIQUE,
ADD COLUMN IF NOT EXISTS wechat_unionid VARCHAR(255) UNIQUE,
ADD COLUMN IF NOT EXISTS qq_openid VARCHAR(255) UNIQUE,
ADD COLUMN IF NOT EXISTS provider VARCHAR(50) DEFAULT 'local',
ADD COLUMN IF NOT EXISTS provider_data JSONB;

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_users_wechat_openid ON users(wechat_openid);
CREATE INDEX IF NOT EXISTS idx_users_qq_openid ON users(qq_openid);
CREATE INDEX IF NOT EXISTS idx_users_provider ON users(provider);
```

### 4. 前端配置

#### 4.1 更新前端环境变量
确保 `.env` 文件中的前端URL配置正确：
```bash
VITE_API_BASE_URL=http://localhost:3001/api
```

#### 4.2 测试登录功能
启动开发服务器后，访问：
- 微信登录测试：http://localhost:5173/login
- QQ登录测试：http://localhost:5173/login

## 使用方式

### 前端集成示例

#### 使用SocialLogin组件
```vue
<template>
  <div>
    <SocialLogin />
  </div>
</template>

<script>
import SocialLogin from '@/components/auth/SocialLogin.vue'

export default {
  components: {
    SocialLogin
  }
}
</script>
```

#### 自定义登录按钮
```vue
<template>
  <div class="login-buttons">
    <button @click="wechatLogin" class="wechat-btn">微信登录</button>
    <button @click="qqLogin" class="qq-btn">QQ登录</button>
    <button @click="phoneLogin" class="phone-btn">手机号登录</button>
  </div>
</template>

<script>
import api from '@/services/api'

export default {
  methods: {
    async wechatLogin() {
      const { data } = await api.get('/oauth/wechat/url')
      window.location.href = data.url
    },
    
    async qqLogin() {
      const { data } = await api.get('/oauth/qq/url')
      window.location.href = data.url
    },
    
    phoneLogin() {
      // 跳转到手机号登录页面
      this.$router.push('/login/phone')
    }
  }
}
</script>
```

### API接口文档

#### 获取登录URL
- **微信登录URL**: `GET /api/oauth/wechat/url`
- **QQ登录URL**: `GET /api/oauth/qq/url`

#### 直接登录（前端获取code后）
- **微信登录**: `POST /api/oauth/wechat/login`
- **QQ登录**: `POST /api/oauth/qq/login`

#### 手机号登录
- **发送验证码**: `POST /api/auth/send-code`
- **验证登录**: `POST /api/auth/login-with-phone`

## 测试环境

### 开发环境测试
1. 启动后端服务：`npm run server`
2. 启动前端服务：`npm run dev`
3. 访问：`http://localhost:5173/login`

### 生产环境配置
1. 将微信和QQ的回调地址改为生产域名
2. 更新 `.env` 文件中的URL配置
3. 重新部署应用

## 常见问题

### 微信登录问题
- **错误：redirect_uri域名与后台配置不一致**
  - 检查微信开放平台的回调域名设置
  - 确保回调URL与配置完全一致

### QQ登录问题
- **错误：client request's parameters are invalid**
  - 检查QQ互联的回调地址配置
  - 确认AppID和AppKey配置正确

### 数据库问题
- **错误：列不存在**
  - 确保已执行数据库迁移SQL
  - 检查Supabase表结构是否已更新

## 获取帮助

如有配置问题，请检查：
1. 应用配置是否正确
2. 回调域名是否已备案
3. 数据库表结构是否完整
4. 查看控制台错误日志

## 相关文档
- [微信开放平台文档](https://developers.weixin.qq.com/doc/)
- [QQ互联文档](https://wiki.connect.qq.com/)
- [Supabase文档](https://supabase.com/docs)