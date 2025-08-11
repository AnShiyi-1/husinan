# 数据库同步问题诊断与修复指南

## 问题分析

当前系统存在数据库架构不匹配问题：

1. **数据库架构不完整**：Supabase中的users表缺少`password`和`phone`字段
2. **存储回退机制**：由于数据库架构问题，所有用户数据暂时存储在内存中的`tempStorage`中
3. **数据持久化缺失**：重启服务器会导致所有用户数据丢失

## 数据库架构修复

### 需要执行的SQL脚本

```sql
-- 修复users表架构
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS password VARCHAR(255),
ADD COLUMN IF NOT EXISTS phone VARCHAR(11) UNIQUE;

-- 添加必要的索引
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);

-- 更新现有数据（如果有的话）
UPDATE users SET password = '$2b$10$example.hashed.password' WHERE password IS NULL;
```

### 验证数据库连接

1. 检查数据库连接状态：
   ```bash
   node -e "const { supabase } = require('./server/config/database.js'); supabase.from('users').select('*').then(console.log).catch(console.error)"
   ```

2. 测试用户注册：
   ```bash
   # 发送验证码
   curl -X POST http://localhost:3001/api/auth/send-sms-code -H "Content-Type: application/json" -d '{"phone":"13800138000"}'
   
   # 使用验证码注册
   curl -X POST http://localhost:3001/api/auth/register-phone -H "Content-Type: application/json" -d '{"phone":"13800138000","code":"收到的验证码","username":"测试用户","password":"test123"}'
   ```

## 当前状态说明

- **临时存储**：用户数据目前存储在内存中的`tempStorage.users`数组中
- **数据库同步**：修复数据库架构后，新用户将直接存储到Supabase
- **数据迁移**：需要手动将现有临时数据迁移到数据库

## 立即解决方案

由于数据库架构修复需要Supabase控制台权限，建议：

1. **临时使用演示模式**：继续通过临时存储进行测试
2. **手动数据库修复**：登录Supabase控制台执行上述SQL脚本
3. **验证修复**：修复后重启服务器验证数据库连接

## 验证步骤

修复完成后，通过以下步骤验证：

1. 访问 http://localhost:3001/api-docs 查看API文档
2. 测试用户注册功能
3. 重启服务器后验证用户数据是否保留
4. 检查Supabase控制台中的数据表

## 注意事项

- 当前使用临时存储，重启服务器会清除所有用户数据
- 数据库修复后，需要重新注册用户
- 确保Supabase配置正确（SUPABASE_URL和SUPABASE_ANON_KEY已设置）