#!/usr/bin/env node

/**
 * Supabase数据库配置脚本
 * 运行此脚本前，请先访问 https://app.supabase.com 创建项目
 */

import fs from 'fs';
import path from 'path';
import readline from 'readline';

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

console.log('🎨 Emotion Canvas - Supabase真实数据库配置');
console.log('==========================================\n');

// 数据库表结构和RLS策略
const SUPABASE_SQL = `-- 创建用户表
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    phone VARCHAR(20) UNIQUE NOT NULL,
    nickname VARCHAR(50),
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建验证码表
CREATE TABLE IF NOT EXISTS verification_codes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    phone VARCHAR(20) NOT NULL,
    code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建绘画作品表
CREATE TABLE IF NOT EXISTS artworks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100),
    description TEXT,
    image_url TEXT NOT NULL,
    emotion_tags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建评论表
CREATE TABLE IF NOT EXISTS comments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    artwork_id UUID REFERENCES artworks(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX idx_verification_codes_phone ON verification_codes(phone);
CREATE INDEX idx_verification_codes_expires ON verification_codes(expires_at);
CREATE INDEX idx_artworks_user ON artworks(user_id);
CREATE INDEX idx_comments_artwork ON comments(artwork_id);

-- 创建更新时间的触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为用户表和作品表添加更新时间触发器
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_artworks_updated_at BEFORE UPDATE ON artworks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 启用RLS（行级安全）
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE verification_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE artworks ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- 创建允许匿名用户注册的策略
CREATE POLICY "允许匿名用户注册" ON users
    FOR INSERT WITH CHECK (true);

-- 创建允许用户查看自己信息的策略
CREATE POLICY "用户查看自己的信息" ON users
    FOR SELECT USING (auth.uid() = id);

-- 创建允许用户更新自己信息的策略
CREATE POLICY "用户更新自己的信息" ON users
    FOR UPDATE USING (auth.uid() = id);

-- 创建验证码插入策略
CREATE POLICY "允许插入验证码" ON verification_codes
    FOR INSERT WITH CHECK (true);

-- 创建验证码查询策略（仅用于验证）
CREATE POLICY "允许查询验证码" ON verification_codes
    FOR SELECT USING (true);

-- 创建作品查看策略（公开查看）
CREATE POLICY "公开查看作品" ON artworks
    FOR SELECT USING (true);

-- 创建作品插入策略（登录用户）
CREATE POLICY "登录用户创建作品" ON artworks
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 创建作品更新策略（仅所有者）
CREATE POLICY "所有者更新作品" ON artworks
    FOR UPDATE USING (auth.uid() = user_id);

-- 创建作品删除策略（仅所有者）
CREATE POLICY "所有者删除作品" ON artworks
    FOR DELETE USING (auth.uid() = user_id);

-- 创建评论查看策略（公开查看）
CREATE POLICY "公开查看评论" ON comments
    FOR SELECT USING (true);

-- 创建评论插入策略（登录用户）
CREATE POLICY "登录用户发表评论" ON comments
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 创建评论更新策略（仅所有者）
CREATE POLICY "所有者更新评论" ON comments
    FOR UPDATE USING (auth.uid() = user_id);

-- 创建评论删除策略（仅所有者）
CREATE POLICY "所有者删除评论" ON comments
    FOR DELETE USING (auth.uid() = user_id);`;

// 询问用户配置信息
function askQuestion(question) {
  return new Promise(resolve => {
    rl.question(question, answer => {
      resolve(answer.trim());
    });
  });
}

async function main() {
  try {
    console.log('📋 步骤1：获取Supabase配置信息');
    console.log('请访问 https://app.supabase.com 并创建项目');
    console.log('在项目的 Settings > API 页面找到以下信息：\n');

    const projectUrl = await askQuestion('请输入Project URL (例如: https://abc123.supabase.co): ');
    const anonKey = await askQuestion('请输入anon public密钥: ');
    const serviceKey = await askQuestion('请输入service_role密钥: ');

    if (!projectUrl || !anonKey || !serviceKey) {
      console.error('❌ 所有配置信息都是必需的！');
      process.exit(1);
    }

    // 更新.env文件
    const envPath = path.join(__dirname, '.env');
    let envContent = fs.readFileSync(envPath, 'utf8');
    
    envContent = envContent
      .replace(/SUPABASE_URL=.*/, `SUPABASE_URL=${projectUrl}`)
      .replace(/SUPABASE_ANON_KEY=.*/, `SUPABASE_ANON_KEY=${anonKey}`)
      .replace(/SUPABASE_SERVICE_ROLE_KEY=.*/, `SUPABASE_SERVICE_ROLE_KEY=${serviceKey}`);

    fs.writeFileSync(envPath, envContent);
    console.log('✅ .env文件已更新！');

    // 创建SQL文件
    const sqlPath = path.join(__dirname, 'supabase-setup.sql');
    fs.writeFileSync(sqlPath, SUPABASE_SQL);
    console.log('✅ supabase-setup.sql文件已创建！');

    console.log('\n📋 步骤2：配置Supabase数据库');
    console.log('1. 访问你的Supabase项目控制台');
    console.log('2. 点击左侧菜单 "SQL Editor"');
    console.log('3. 打开 supabase-setup.sql 文件');
    console.log('4. 复制所有SQL语句并粘贴到SQL编辑器');
    console.log('5. 点击 "RUN" 按钮执行\n');

    console.log('📋 步骤3：重启服务');
    console.log('1. 停止当前运行的后端服务 (Ctrl+C)');
    console.log('2. 重新运行: npm run server\n');

    console.log('🎉 配置完成！');
    console.log('现在可以测试验证码功能了！');

  } catch (error) {
    console.error('❌ 配置失败:', error.message);
  } finally {
    rl.close();
  }
}

// 如果直接运行此脚本
if (import.meta.url === `file://${process.argv[1]}`) {
  main();
}

export { SUPABASE_SQL };