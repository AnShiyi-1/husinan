import express from 'express'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import fs from 'fs'
import path from 'path'
import multer from 'multer'
import { supabase, TABLES, handleDbError } from '../config/database.js'
import { authenticateToken } from '../middleware/auth.js'

// 持久化本地存储文件路径
const STORAGE_FILE = path.join(process.cwd(), 'server', 'temp_storage.json');

// 初始化或加载临时存储
const loadTempStorage = () => {
  try {
    if (fs.existsSync(STORAGE_FILE)) {
      const data = fs.readFileSync(STORAGE_FILE, 'utf8');
      return JSON.parse(data);
    }
  } catch (error) {
    console.error('加载临时存储失败:', error);
  }
  return {
    users: [],
    verificationCodes: []
  };
};

// 保存临时存储到文件
const saveTempStorage = (storage) => {
  try {
    const dir = path.dirname(STORAGE_FILE);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    fs.writeFileSync(STORAGE_FILE, JSON.stringify(storage, null, 2), 'utf8');
  } catch (error) {
    console.error('保存临时存储失败:', error);
  }
};

// 初始化存储
let tempStorage = loadTempStorage();

// 添加一个函数来重新加载tempStorage
const reloadTempStorage = () => {
  console.log('重新加载tempStorage');
  tempStorage = loadTempStorage();
  console.log('重新加载后的tempStorage:', tempStorage);
};

const router = express.Router()
const JWT_SECRET = process.env.JWT_SECRET || 'emotion-canvas-secret-key'

// 头像上传配置
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 2 * 1024 * 1024 }, // 2MB
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('只允许上传图片文件'));
    }
  }
});

// 导出tempStorage以便外部访问
export { tempStorage, reloadTempStorage }

/**
 * @typedef {object} User
 * @property {string} id - 用户ID
 * @property {string} username - 用户名
 * @property {string} avatar - 头像URL
 * @property {number} createdAt - 创建时间戳
 */

/**
 * GET /api/auth/profile
 * @summary 获取用户信息
 * @tags auth
 * @return {User} 200 - 用户信息
 */
router.get('/profile', async (req, res) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '')
    
    if (!token) {
      return res.status(401).json({ error: '未提供令牌' })
    }

    const decoded = jwt.verify(token, JWT_SECRET)
    const userId = decoded.userId

    let user = null
    
    // 尝试从Supabase查询用户信息
    try {
      const { data: dbUser, error } = await supabase
        .from(TABLES.USERS)
        .select('id, username, avatar, created_at')
        .eq('id', userId)
        .single()

      if (!error && dbUser) {
        user = dbUser
      }
    } catch (dbError) {
      console.log('Supabase查询用户信息失败，尝试临时存储')
    }

    // 如果Supabase不可用，从临时存储查找
    if (!user) {
      user = tempStorage.users.find(item => item.id === userId)
    }

    if (!user) {
      return res.status(404).json({ error: '用户不存在' })
    }

    res.json({
      id: user.id,
      username: user.username,
      avatar: user.avatar,
      createdAt: user.created_at
    })

  } catch (error) {
    console.error('获取用户信息失败:', error)
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ error: '无效的令牌' })
    }
    res.status(500).json(handleDbError(error))
  }
})

/**
 * GET /api/auth/me
 * @summary 获取当前用户信息（兼容前端）
 * @tags auth
 * @return {User} 200 - 用户信息
 */
router.get('/me', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    let user = null
    try {
      const { data: dbUser, error } = await supabase
        .from(TABLES.USERS)
        .select('*')
        .eq('id', userId)
        .single()

      if (error && error.code !== 'PGRST116') {
        throw error
      }
      user = dbUser
    } catch (dbError) {
      console.log('Supabase查询失败，尝试临时存储')
      user = tempStorage.users.find(item => item.id === userId)
    }

    if (!user) {
      return res.status(404).json({ error: '用户不存在' })
    }

    res.json({
      id: user.id,
      username: user.username,
      avatar: user.avatar,
      createdAt: user.created_at
    })

  } catch (error) {
    console.error('获取用户信息失败:', error)
    res.status(500).json(handleDbError(error))
  }
})

/**
 * PUT /api/auth/profile
 * @summary 更新用户信息
 * @tags auth
 * @param {User} request.body.required - 更新数据
 * @return {User} 200 - 更新后的用户信息
 */
router.put('/profile', async (req, res) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '')
    
    if (!token) {
      return res.status(401).json({ error: '未提供令牌' })
    }

    const decoded = jwt.verify(token, JWT_SECRET)
    const userId = decoded.userId

    const { username, avatar } = req.body
    const updateData = {}
    
    if (username !== undefined) updateData.username = username
    if (avatar !== undefined) updateData.avatar = avatar
    updateData.updated_at = new Date().toISOString()

    const { data: user, error } = await supabase
      .from(TABLES.USERS)
      .update(updateData)
      .eq('id', userId)
      .select('id, username, avatar, created_at, updated_at')
      .single()

    if (error) {
      throw error
    }

    res.json({
      id: user.id,
      username: user.username,
      avatar: user.avatar,
      createdAt: user.created_at,
      updatedAt: user.updated_at
    })

  } catch (error) {
    console.error('更新用户信息失败:', error)
    res.status(500).json(handleDbError(error))
  }
})

/**
 * POST /api/auth/upload-avatar
 * @summary 上传用户头像
 * @tags auth
 * @param {file} avatar.required - 头像文件
 * @return {object} 200 - 上传成功
 */
router.post('/upload-avatar', authenticateToken, upload.single('avatar'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: '未上传文件' });
    }

    const userId = req.user.userId;
    const file = req.file;
    const fileName = `avatars/${userId}-${Date.now()}.${file.originalname.split('.').pop()}`;

    // 上传到Supabase Storage
    const { data, error } = await supabase.storage
      .from('avatars')
      .upload(fileName, file.buffer, {
        contentType: file.mimetype,
        upsert: false
      });

    if (error) {
      throw error;
    }

    // 获取公开URL
    const { data: { publicUrl } } = supabase.storage
      .from('avatars')
      .getPublicUrl(fileName);

    // 更新用户头像URL
    const { data: user, error: updateError } = await supabase
      .from(TABLES.USERS)
      .update({ avatar: publicUrl, updated_at: new Date().toISOString() })
      .eq('id', userId)
      .select('id, username, avatar, created_at, updated_at')
      .single();

    if (updateError) {
      throw updateError;
    }

    res.json({
      avatar: publicUrl,
      user: {
        id: user.id,
        username: user.username,
        avatar: user.avatar,
        createdAt: user.created_at,
        updatedAt: user.updated_at
      }
    });

  } catch (error) {
    console.error('头像上传失败:', error);
    res.status(500).json(handleDbError(error));
  }
});

/**
 * POST /api/auth/check-username
 * @summary 检查用户名是否已存在
 * @tags auth
 * @param {object} request.body.required - 用户名信息
 * @param {string} request.body.username.required - 用户名
 * @return {object} 200 - 检查结果
 */
router.post('/check-username', async (req, res) => {
  try {
    const { username } = req.body;

    console.log('收到用户名检查请求:', username);

    // 验证用户名
    if (!username || username.length < 2 || username.length > 20) {
      return res.status(400).json({ error: '用户名长度应为2-20位' });
    }

    // 简化的用户名验证 - 只检查基本字符
    if (!/^[a-zA-Z0-9_一-龥]+$/.test(username)) {
      return res.status(400).json({ error: '用户名格式不正确' });
    }

    // 确保tempStorage.users存在且为数组
    if (!Array.isArray(tempStorage.users)) {
      tempStorage.users = [];
    }

    console.log('当前用户列表:', tempStorage.users.map(u => u.username));

    // 检查用户名是否已存在
    const existingUser = tempStorage.users.find(item => item.username === username);

    console.log('检查结果:', existingUser ? '存在' : '不存在');

    res.json({
      exists: !!existingUser,
      message: existingUser ? '用户名已存在' : '用户名可用'
    });

  } catch (error) {
    console.error('检查用户名失败:', error);
    res.status(500).json({ error: '服务器内部错误' });
  }
});

/**
 * POST /api/auth/register
 * @summary 账号密码注册
 * @tags auth
 * @param {object} request.body.required - 注册信息
 * @param {string} request.body.username.required - 用户名
 * @param {string} request.body.password.required - 密码
 * @return {object} 200 - 注册成功
 * @return {object} 400 - 注册失败
 */
router.post('/register', async (req, res) => {
  try {
    const { username, password } = req.body;

    // 验证用户名
    if (!username || username.length < 2 || username.length > 20) {
      return res.status(400).json({ error: '用户名长度应为2-20位' });
    }

    if (!/^[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(username)) {
      return res.status(400).json({ error: '用户名只能包含字母、数字、下划线和中文' });
    }

    // 验证密码
    if (!password || password.length < 6) {
      return res.status(400).json({ error: '密码长度至少为6位' });
    }

    // 检查用户名是否已存在
    let existingUser = null;
    try {
      const { data: user } = await supabase
        .from(TABLES.USERS)
        .select('id')
        .eq('username', username)
        .single();
      existingUser = user;
    } catch (dbError) {
      console.log('Supabase查询失败，检查临时存储');
    }

    // 如果Supabase查询失败或未找到，检查临时存储
    if (!existingUser) {
      // 确保tempStorage.users存在且为数组
      if (!Array.isArray(tempStorage.users)) {
        tempStorage.users = [];
      }
      existingUser = tempStorage.users.find(item => item.username === username);
    }

    if (existingUser) {
      return res.status(400).json({ error: '用户名已存在' });
    }

    // 加密密码
    const hashedPassword = await bcrypt.hash(password, 10);

    // 创建用户对象
    const newUser = {
      id: Date.now().toString(),
      username,
      password: hashedPassword,
      avatar: '',
      created_at: new Date().toISOString()
    };

    // 尝试保存到Supabase
    let createdUser = null;
    try {
      const { data: user, error } = await supabase
        .from(TABLES.USERS)
        .insert(newUser)
        .select()
        .single();

      if (error) throw error;
      createdUser = user;
    } catch (dbError) {
      console.log('保存到Supabase失败，使用临时存储');
      // 保存到临时存储
      tempStorage.users.push({
        ...newUser,
        id: newUser.id.toString()
      });
      saveTempStorage(tempStorage);
      createdUser = newUser;
    }

    // 生成JWT令牌
    const token = jwt.sign(
      { userId: createdUser.id, username: createdUser.username },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    // 返回用户信息和令牌
    res.status(201).json({
      user: {
        id: createdUser.id,
        username: createdUser.username,
        avatar: createdUser.avatar,
        createdAt: createdUser.created_at
      },
      token
    });

  } catch (error) {
    console.error('注册失败:', error);
    res.status(500).json(handleDbError(error));
  }
});

/**
 * POST /api/auth/login
 * @summary 用户名 + 密码登录（优化版）
 * @tags auth
 * @param {object} request.body.required - 登录信息
 * @param {string} request.body.username.required - 用户名
 * @param {string} request.body.password.required - 密码
 * @param {boolean} request.body.remember - 记住登录状态
 * @return {object} 200 - 登录成功
 * @return {object} 400 - 登录失败
 */
router.post('/login', async (req, res) => {
  try {
    const { username, password, remember } = req.body;
    
    // 增强的输入验证
    if (!username || !password) {
      return res.status(400).json({ error: '请输入用户名和密码' });
    }

    // 用户名格式验证
    if (username.length < 2 || username.length > 20) {
      return res.status(400).json({ error: '用户名长度应为2-20位' });
    }

    if (!/^[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(username)) {
      return res.status(400).json({ error: '用户名格式不正确' });
    }

    // 密码长度验证
    if (password.length < 6) {
      return res.status(400).json({ error: '密码长度至少为6位' });
    }

    // 重新加载tempStorage以确保使用最新数据
    reloadTempStorage();

    let user = null;
    
    // 优化的用户查询逻辑
    try {
      const { data: dbUser, error } = await supabase
        .from(TABLES.USERS)
        .select('*')
        .eq('username', username)
        .single();

      if (error && error.code !== 'PGRST116') {
        throw error;
      }
      user = dbUser;
    } catch (dbError) {
      // 仅在调试模式下输出错误日志
      if (process.env.NODE_ENV === 'development') {
        console.log('Supabase查询失败，使用临时存储');
      }
    }

    // 回退到临时存储
    if (!user && Array.isArray(tempStorage.users)) {
      user = tempStorage.users.find(item => item.username === username);
    }

    if (!user) {
      return res.status(401).json({ error: '账号或密码错误' });
    }

    // 验证密码
    if (!user.password) {
      return res.status(401).json({ error: '账号或密码错误' });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: '账号或密码错误' });
    }

    // 生成JWT令牌
    const token = jwt.sign(
      { 
        userId: user.id, 
        username: user.username,
        loginTime: Date.now()
      },
      JWT_SECRET,
      { expiresIn: remember ? '7d' : '24h' }
    );

    res.json({
      user: {
        id: user.id,
        username: user.username,
        avatar: user.avatar,
        createdAt: user.created_at
      },
      token,
      expiresIn: remember ? '7d' : '24h'
    });

  } catch (error) {
    console.error('登录失败:', error);
    res.status(500).json(handleDbError(error));
  }
});

// 导入共享的令牌黑名单
import { getTokenBlacklist, setTokenBlacklist } from '../middleware/auth.js';

// 使用共享的令牌黑名单存储
let tokenBlacklist = getTokenBlacklist();
if (!tokenBlacklist) {
  // 如果还没有初始化，创建一个新的Set并设置为共享
  tokenBlacklist = new Set();
  setTokenBlacklist(tokenBlacklist);
}

/**
 * POST /api/auth/logout
 * @summary 用户登出
 * @tags auth
 * @return {object} 200 - 登出成功
 */
router.post('/logout', (req, res) => {
  // 获取令牌
  const token = req.headers.authorization?.split(' ')[1];
  
  console.log('登出请求 - 收到的令牌:', token);
  
  if (token) {
    // 将令牌添加到黑名单
    tokenBlacklist.add(token);
    console.log('登出请求 - 令牌已添加到黑名单');
    
    // 设置令牌过期时间（24小时后自动从黑名单中移除）
    setTimeout(() => {
      tokenBlacklist.delete(token);
      console.log('登出请求 - 令牌已从黑名单移除');
    }, 24 * 60 * 60 * 1000); // 24小时
  } else {
    console.log('登出请求 - 未提供令牌');
  }
  
  // 返回成功响应
  res.json({ message: '登出成功' });
});

// 调试端点 - 检查tempStorage状态
router.get('/debug-temp-storage', (req, res) => {
  res.json({
    tempStorage
  });
});

export default router