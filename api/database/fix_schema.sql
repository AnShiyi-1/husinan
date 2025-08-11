-- 修复数据库架构以匹配服务器代码
-- 添加缺失的字段

-- 检查并添加password列
ALTER TABLE users ADD COLUMN IF NOT EXISTS password VARCHAR(255);

-- 检查并添加phone列
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(11);

-- 确保phone列有唯一约束
ALTER TABLE users ADD CONSTRAINT users_phone_unique UNIQUE (phone);

-- 添加索引
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);

-- 更新现有测试数据，添加密码
UPDATE users SET password = '$2b$10$example.hashed.password' WHERE password IS NULL;

-- 验证数据
SELECT id, username, phone, password FROM users LIMIT 5;