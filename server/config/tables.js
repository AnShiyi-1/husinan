/**
 * 数据库表名常量定义
 * 统一集中管理所有表名，避免硬编码
 */

export const TABLES = {
  USERS: 'users',
  VERIFICATION_CODES: 'verification_codes',
  ARTWORKS: 'artworks',
  COMMENTS: 'comments',
  USER_OAUTH_ACCOUNTS: 'user_oauth_accounts'
}

// 导出所有表名，方便批量使用
export default TABLES