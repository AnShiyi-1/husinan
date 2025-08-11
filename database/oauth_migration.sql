-- 第三方登录数据库迁移
-- 为用户表添加第三方登录相关字段

-- 添加微信登录字段
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS wechat_openid VARCHAR(255) UNIQUE,
ADD COLUMN IF NOT EXISTS wechat_unionid VARCHAR(255) UNIQUE,
ADD COLUMN IF NOT EXISTS provider VARCHAR(50) DEFAULT 'local',
ADD COLUMN IF NOT EXISTS provider_data JSONB;

-- 添加QQ登录字段
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS qq_openid VARCHAR(255) UNIQUE,
ADD COLUMN IF NOT EXISTS qq_unionid VARCHAR(255) UNIQUE;

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_users_wechat_openid ON users(wechat_openid);
CREATE INDEX IF NOT EXISTS idx_users_wechat_unionid ON users(wechat_unionid);
CREATE INDEX IF NOT EXISTS idx_users_qq_openid ON users(qq_openid);
CREATE INDEX IF NOT EXISTS idx_users_qq_unionid ON users(qq_unionid);
CREATE INDEX IF NOT EXISTS idx_users_provider ON users(provider);

-- 更新现有用户的provider字段
UPDATE users 
SET provider = 'local' 
WHERE provider IS NULL OR provider = '';

-- 创建用户第三方登录关联表（可选，用于支持多个第三方账号绑定）
CREATE TABLE IF NOT EXISTS user_oauth_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  provider VARCHAR(50) NOT NULL,
  provider_user_id VARCHAR(255) NOT NULL,
  provider_data JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(provider, provider_user_id)
);

-- 为用户第三方登录关联表创建索引
CREATE INDEX IF NOT EXISTS idx_user_oauth_user_id ON user_oauth_accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_user_oauth_provider ON user_oauth_accounts(provider);
CREATE INDEX IF NOT EXISTS idx_user_oauth_provider_user_id ON user_oauth_accounts(provider_user_id);