import dotenv from 'dotenv'

dotenv.config()

// JWT 配置
export const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-this-in-production'
export const JWT_EXPIRES_IN = '7d'

// 验证码配置
export const VERIFICATION_CODE_EXPIRES_IN = 5 * 60 * 1000 // 5分钟
export const MAX_VERIFICATION_ATTEMPTS = 3

// 密码重置配置
export const PASSWORD_RESET_EXPIRES_IN = 30 * 60 * 1000 // 30分钟