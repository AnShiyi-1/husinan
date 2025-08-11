# Supabase 数据库设置指南

## 1. 创建Supabase项目

1. 访问 [Supabase官网](https://supabase.com)
2. 注册账号并创建新项目
3. 记录以下信息：
   - 项目URL（格式：https://your-project.supabase.co）
   - 匿名密钥（Anon Key）
   - 服务角色密钥（Service Role Key）

## 2. 数据库表结构

### 用户表 (users)
```sql
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    phone VARCHAR(11) UNIQUE NOT NULL,
    username VARCHAR(50) NOT NULL,
    avatar TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_phone ON users(phone);
```

### 验证码表 (verification_codes)
```sql
CREATE TABLE verification_codes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    phone VARCHAR(11) NOT NULL,
    code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_verification_codes_phone ON verification_codes(phone);
CREATE INDEX idx_verification_codes_expires ON verification_codes(expires_at);
```

## 3. 环境变量配置

复制 `.env.example` 为 `.env` 并填写：

```bash
# Supabase配置
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-role-key

# Twilio短信配置（可选）
TWILIO_ACCOUNT_SID=your-twilio-account-sid
TWILIO_AUTH_TOKEN=your-twilio-auth-token
TWILIO_PHONE_NUMBER=your-twilio-phone-number

# JWT密钥
JWT_SECRET=your-jwt-secret-key
```

## 4. 启用Row Level Security (RLS)

为安全起见，建议启用RLS：

```sql
-- 用户表RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 验证码表RLS
ALTER TABLE verification_codes ENABLE ROW LEVEL SECURITY;

-- 创建清理过期验证码的函数
CREATE OR REPLACE FUNCTION cleanup_expired_codes()
RETURNS void AS $$
BEGIN
    DELETE FROM verification_codes 
    WHERE expires_at < NOW() OR used = TRUE;
END;
$$ language 'plpgsql';
```

## 5. 启动项目

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 启动后端服务器
npm run server
```

## 注意事项

1. **演示模式**：如果没有配置Twilio，系统会使用演示模式，验证码会直接显示在界面上
2. **安全性**：生产环境请务必配置真实的短信服务
3. **数据库权限**：确保Supabase项目的数据库权限配置正确
4. **端口冲突**：如果3001端口被占用，可以在.env中修改PORT值