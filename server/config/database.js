import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

dotenv.config()

const supabaseUrl = process.env.SUPABASE_URL || 'your-supabase-url'
const supabaseKey = process.env.SUPABASE_ANON_KEY || 'your-supabase-anon-key'

export const supabase = createClient(supabaseUrl, supabaseKey)

// 数据库表结构
export const TABLES = {
  USERS: 'users',
  VERIFICATION_CODES: 'verification_codes',
  ARTWORKS: 'artworks',
  COMMENTS: 'comments'
}

// 错误处理
export const handleDbError = (error) => {
  // 仅在开发环境显示详细错误
  if (process.env.NODE_ENV === 'development') {
    console.error('Database error:', error)
  }
  
  // 返回友好的错误消息，不包含技术细节
  const friendlyMessages = {
    'PGRST116': '请求的资源不存在',
    '23505': '数据已存在，请勿重复操作',
    '23503': '关联数据不存在',
    '22P02': '数据格式错误',
    '42P01': '数据表不存在',
    '28P01': '认证失败'
  }
  
  const errorCode = error.code || ''
  const message = friendlyMessages[errorCode] || 
                 (error.message && error.message.includes('JWT')) ? '身份验证失败' :
                 '操作失败，请稍后重试'
  
  return { error: message }
}