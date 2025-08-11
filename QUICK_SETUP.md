# 快速设置指南

## 验证码功能已修复！

### 当前状态
✅ **验证码功能已完全可用** - 使用临时存储模式
- 无需数据库配置即可使用
- 所有用户数据保存在内存中（重启后重置）
- 验证码会直接显示在界面上

### 使用演示
1. 输入任意手机号（如：13800138000）
2. 点击"获取验证码"
3. 验证码会显示在界面上（如：123456）
4. 输入验证码即可登录

---

## 配置真实Supabase（可选）

### 1. 创建Supabase项目
1. 访问 https://supabase.com
2. 创建新项目
3. 获取项目URL和密钥

### 2. 配置环境变量
编辑 `.env` 文件：

```bash
# 替换为你的真实Supabase配置
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### 3. 创建数据库表
运行 `server/database/init.sql` 中的SQL脚本，或手动创建：

**用户表：**
```sql
CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  phone VARCHAR(20) UNIQUE NOT NULL,
  username VARCHAR(50) NOT NULL,
  avatar TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**验证码表：**
```sql
CREATE TABLE verification_codes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  phone VARCHAR(20) NOT NULL,
  code VARCHAR(6) NOT NULL,
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  attempts INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 4. 启用Row Level Security (RLS)
在Supabase控制台中为用户表和验证码表启用RLS。

### 5. 重启服务
```bash
# 重启后端服务器
npm run server

# 重启前端开发服务器
npm run dev
```

---

## 当前可用功能
- ✅ 手机号验证码登录
- ✅ 用户信息查看
- ✅ 会话保持（7天有效期）
- ✅ 演示模式（无需配置）

## 注意事项
- 临时存储模式下，重启服务器会清除所有用户数据
- 如需持久化存储，请配置真实的Supabase数据库