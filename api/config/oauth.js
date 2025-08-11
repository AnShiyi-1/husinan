/**
 * 第三方登录配置
 * 微信和QQ OAuth配置
 */

export const oauthConfig = {
  // 微信登录配置
  wechat: {
    appId: process.env.WECHAT_APP_ID || 'your_wechat_app_id',
    appSecret: process.env.WECHAT_APP_SECRET || 'your_wechat_app_secret',
    callbackUrl: process.env.WECHAT_CALLBACK_URL || 'http://localhost:3001/api/oauth/wechat/callback',
    scope: 'snsapi_login',
    state: 'wechat_oauth_state'
  },

  // QQ登录配置
  qq: {
    appId: process.env.QQ_APP_ID || 'your_qq_app_id',
    appKey: process.env.QQ_APP_KEY || 'your_qq_app_key',
    callbackUrl: process.env.QQ_CALLBACK_URL || 'http://localhost:3001/api/oauth/qq/callback',
    scope: 'get_user_info',
    state: 'qq_oauth_state'
  },

  // 通用配置
  frontendUrl: process.env.FRONTEND_URL || 'http://localhost:5173',
  cookieDomain: process.env.COOKIE_DOMAIN || 'localhost'
}

export default oauthConfig