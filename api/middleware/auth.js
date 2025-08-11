import jwt from 'jsonwebtoken'
import { JWT_SECRET } from '../config/auth.js'

// 令牌黑名单存储（在实际应用中应使用Redis等外部存储）
let tokenBlacklist = new Set();

// 为了在不同文件间共享黑名单，我们创建一个简单的getter函数
// 在实际应用中应使用外部存储如Redis
export const setTokenBlacklist = (blacklist) => {
  tokenBlacklist = blacklist;
};

export const getTokenBlacklist = () => {
  return tokenBlacklist;
};

/**
 * 认证中间件
 * 验证JWT令牌并设置用户信息
 */
export const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization']
  const token = authHeader && authHeader.split(' ')[1]
  
  console.log('认证请求 - 收到的令牌:', token);
  
  if (!token) {
    return res.status(401).json({ error: '访问令牌缺失' })
  }
  
  // 检查令牌是否在黑名单中
  console.log('认证请求 - 检查令牌是否在黑名单中');
  console.log('认证请求 - 黑名单大小:', tokenBlacklist.size);
  if (tokenBlacklist.has(token)) {
    console.log('认证请求 - 令牌在黑名单中，拒绝访问');
    return res.status(403).json({ error: '令牌已失效，请重新登录' });
  }
  
  console.log('认证请求 - 令牌不在黑名单中，继续验证');
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: '无效的访问令牌' })
    }
    req.user = user
    next()
  })
}

export default authenticateToken