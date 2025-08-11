# Supabase 表格创建指南

## 步骤1：访问Supabase控制台
1. 打开浏览器访问：https://supabase.com/dashboard
2. 登录你的账号
3. 找到项目：`wjoxaesypfhvwrnxfaqh`

## 步骤2：进入SQL编辑器
1. 在左侧菜单点击 **"SQL Editor"**
2. 或者点击 **"Database"** → **"SQL Editor"**

## 步骤3：执行创建表格的SQL
1. 复制以下文件中的完整SQL代码：
   `server/database/complete_init.sql`

2. 在SQL编辑器中粘贴所有代码

3. 点击 **"RUN"** 按钮执行

## 步骤4：验证表格创建成功
1. 在左侧菜单点击 **"Database"**
2. 点击 **"Tables"**
3. 你应该能看到以下表格：
   - users（用户表）
   - verification_codes（验证码表）
   - artworks（作品表）
   - comments（评论表）

## 步骤5：检查表格数据
1. 点击任意表格名称
2. 点击 **"Table"** 标签页查看数据
3. 点击 **"Columns"** 标签页查看字段结构

## 常见问题解决

### 如果执行失败：
1. 检查是否已连接到正确的项目
2. 确认项目URL是否正确：
   `https://wjoxaesypfhvwrnxfaqh.supabase.co`

### 如果表格已存在：
SQL中的 `IF NOT EXISTS` 会跳过已存在的表格，不会报错

### 如何查看表格：
1. 控制台左侧菜单 → Database → Tables
2. 点击表格名称查看详情
3. 使用 **"Insert row"** 添加测试数据

## 测试连接
执行完成后，你的后端服务会自动连接到这些表格。可以通过以下方式测试：

1. 打开前端应用：http://localhost:5173
2. 尝试注册新用户
3. 检查验证码是否正确存储在verification_codes表
4. 创建作品，检查artworks表
5. 添加评论，检查comments表

## 技术支持
如果遇到问题，可以：
1. 查看控制台中的 **"Logs"** 日志
2. 检查 **"Settings"** → **"API"** 中的连接信息
3. 确认.env文件中的配置正确