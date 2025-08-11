-- 完整的绘画软件数据库初始化脚本
-- 包含所有需要的表结构、索引、RLS策略

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    phone VARCHAR(11) UNIQUE NOT NULL,
    username VARCHAR(50) NOT NULL,
    avatar TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 验证码表
CREATE TABLE IF NOT EXISTS verification_codes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    phone VARCHAR(11) NOT NULL,
    code VARCHAR(6) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 作品表
CREATE TABLE IF NOT EXISTS artworks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    image_url TEXT NOT NULL,
    emotion VARCHAR(20),
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 评论表
CREATE TABLE IF NOT EXISTS comments (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    artwork_id UUID NOT NULL REFERENCES artworks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_verification_codes_phone ON verification_codes(phone);
CREATE INDEX IF NOT EXISTS idx_verification_codes_expires ON verification_codes(expires_at);
CREATE INDEX IF NOT EXISTS idx_artworks_user_id ON artworks(user_id);
CREATE INDEX IF NOT EXISTS idx_artworks_created_at ON artworks(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_comments_artwork_id ON comments(artwork_id);
CREATE INDEX IF NOT EXISTS idx_comments_user_id ON comments(user_id);

-- 自动更新时间戳触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_artworks_updated_at BEFORE UPDATE ON artworks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 定期清理过期验证码的函数
CREATE OR REPLACE FUNCTION cleanup_expired_codes()
RETURNS void AS $$
BEGIN
    DELETE FROM verification_codes 
    WHERE expires_at < NOW() OR used = TRUE;
END;
$$ language 'plpgsql';

-- 每分钟清理一次过期验证码的定时任务（需要pg_cron扩展）
-- SELECT cron.schedule('cleanup-codes', '*/1 * * * *', 'SELECT cleanup_expired_codes()');

-- 启用RLS（行级安全）
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE verification_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE artworks ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;

-- 创建RLS策略
-- 用户表策略：用户只能查看和更新自己的信息
CREATE POLICY "用户只能查看和更新自己的信息" ON users
    FOR ALL USING (auth.uid() = id);

-- 验证码表策略：用户只能查看自己的验证码
CREATE POLICY "用户只能查看自己的验证码" ON verification_codes
    FOR ALL USING (phone = current_setting('app.current_user_phone', true));

-- 作品表策略：公开作品所有人可见，私密作品仅作者可见
CREATE POLICY "公开作品所有人可见" ON artworks
    FOR SELECT USING (is_public = TRUE OR user_id = auth.uid());

CREATE POLICY "用户只能修改自己的作品" ON artworks
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "用户只能删除自己的作品" ON artworks
    FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "用户只能创建自己的作品" ON artworks
    FOR INSERT WITH CHECK (user_id = auth.uid());

-- 评论表策略：所有人可见，用户只能修改自己的评论
CREATE POLICY "评论所有人可见" ON comments
    FOR SELECT USING (true);

CREATE POLICY "用户只能创建自己的评论" ON comments
    FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "用户只能修改自己的评论" ON comments
    FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "用户只能删除自己的评论" ON comments
    FOR DELETE USING (user_id = auth.uid());

-- 插入测试数据
INSERT INTO users (phone, username, avatar) VALUES
('13800138000', '测试用户1', 'https://via.placeholder.com/150'),
('13900139000', '测试用户2', 'https://via.placeholder.com/150')
ON CONFLICT (phone) DO NOTHING;

-- 插入测试作品
INSERT INTO artworks (user_id, title, description, image_url, emotion, is_public) VALUES
((SELECT id FROM users WHERE phone = '13800138000'), '我的第一幅画', '这是描述文字', 'https://via.placeholder.com/400x300', 'happy', true),
((SELECT id FROM users WHERE phone = '13900139000'), '心情画作', '表达今天的心情', 'https://via.placeholder.com/400x300', 'sad', true)
ON CONFLICT DO NOTHING;

-- 插入测试评论
INSERT INTO comments (artwork_id, user_id, content) VALUES
((SELECT id FROM artworks LIMIT 1), (SELECT id FROM users WHERE phone = '13900139000'), '很棒的作品！')
ON CONFLICT DO NOTHING;