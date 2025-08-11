/**
 * 第三方登录路由
 * 微信、QQ OAuth登录接口
 */

import express from 'express'
import { WeChatService, QQService, generateToken } from '../services/oauthService.js'
import { oauthConfig } from '../config/oauth.js'

const router = express.Router()

/**
 * GET /api/oauth/wechat/url
 * @summary 获取微信登录URL
 * @tags oauth
 * @return {object} 200 - 微信登录URL
 */
router.get('/wechat/url', (req, res) => {
  try {
    const state = Math.random().toString(36).substring(2, 15)
    
    // 构建微信登录URL
    const wechatAuthUrl = `https://open.weixin.qq.com/connect/qrconnect?` +
      `appid=${oauthConfig.wechat.appId}&` +
      `redirect_uri=${encodeURIComponent(oauthConfig.wechat.callbackUrl)}&` +
      `response_type=code&` +
      `scope=${oauthConfig.wechat.scope}&` +
      `state=${state}#wechat_redirect`

    res.json({
      url: wechatAuthUrl,
      state
    })
  } catch (error) {
    console.error('生成微信登录URL失败:', error)
    res.status(500).json({ error: '生成微信登录URL失败' })
  }
})

/**
 * GET /api/oauth/wechat/callback
 * @summary 微信登录回调
 * @tags oauth
 * @param {string} code.query.required - 微信授权码
 * @param {string} state.query.required - 状态码
 */
router.get('/wechat/callback', async (req, res) => {
  try {
    const { code, state } = req.query

    if (!code) {
      return res.redirect(`${oauthConfig.frontendUrl}/login?error=微信授权失败`)
    }

    // 处理微信登录
    const { user } = await WeChatService.handleWeChatLogin(code)
    
    // 生成JWT令牌
    const token = generateToken(user)

    // 重定向到前端并附带令牌
    res.redirect(`${oauthConfig.frontendUrl}/auth/callback?token=${token}&user=${encodeURIComponent(JSON.stringify({
      id: user.id,
      username: user.username,
      email: user.email,
      phone: user.phone,
      avatar: user.avatar,
      provider: 'wechat'
    }))}`)

  } catch (error) {
    console.error('微信登录回调处理失败:', error)
    res.redirect(`${oauthConfig.frontendUrl}/login?error=${encodeURIComponent(error.message)}`)
  }
})

/**
 * POST /api/oauth/wechat/login
 * @summary 微信登录（前端直接传code）
 * @tags oauth
 * @param {string} request.body.required - 微信授权码
 * @return {object} 200 - 登录成功信息
 */
router.post('/wechat/login', async (req, res) => {
  try {
    const { code } = req.body

    if (!code) {
      return res.status(400).json({ error: '缺少微信授权码' })
    }

    // 处理微信登录
    const { user } = await WeChatService.handleWeChatLogin(code)
    
    // 生成JWT令牌
    const token = generateToken(user)

    res.json({
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        phone: user.phone,
        avatar: user.avatar,
        provider: 'wechat'
      },
      token
    })

  } catch (error) {
    console.error('微信登录失败:', error)
    res.status(500).json({ error: error.message || '微信登录失败' })
  }
})

/**
 * GET /api/oauth/qq/url
 * @summary 获取QQ登录URL
 * @tags oauth
 * @return {object} 200 - QQ登录URL
 */
router.get('/qq/url', (req, res) => {
  try {
    const state = Math.random().toString(36).substring(2, 15)
    
    // 构建QQ登录URL
    const qqAuthUrl = `https://graph.qq.com/oauth2.0/authorize?` +
      `response_type=code&` +
      `client_id=${oauthConfig.qq.appId}&` +
      `redirect_uri=${encodeURIComponent(oauthConfig.qq.callbackUrl)}&` +
      `state=${state}&` +
      `scope=${oauthConfig.qq.scope}`

    res.json({
      url: qqAuthUrl,
      state
    })
  } catch (error) {
    console.error('生成QQ登录URL失败:', error)
    res.status(500).json({ error: '生成QQ登录URL失败' })
  }
})

/**
 * GET /api/oauth/qq/callback
 * @summary QQ登录回调
 * @tags oauth
 * @param {string} code.query.required - QQ授权码
 * @param {string} state.query.required - 状态码
 */
router.get('/qq/callback', async (req, res) => {
  try {
    const { code, state } = req.query

    if (!code) {
      return res.redirect(`${oauthConfig.frontendUrl}/login?error=QQ授权失败`)
    }

    // 处理QQ登录
    const { user } = await QQService.handleQQLogin(code)
    
    // 生成JWT令牌
    const token = generateToken(user)

    // 重定向到前端并附带令牌
    res.redirect(`${oauthConfig.frontendUrl}/auth/callback?token=${token}&user=${encodeURIComponent(JSON.stringify({
      id: user.id,
      username: user.username,
      email: user.email,
      phone: user.phone,
      avatar: user.avatar,
      provider: 'qq'
    }))}`)

  } catch (error) {
    console.error('QQ登录回调处理失败:', error)
    res.redirect(`${oauthConfig.frontendUrl}/login?error=${encodeURIComponent(error.message)}`)
  }
})

/**
 * POST /api/oauth/qq/login
 * @summary QQ登录（前端直接传code）
 * @tags oauth
 * @param {string} request.body.required - QQ授权码
 * @return {object} 200 - 登录成功信息
 */
router.post('/qq/login', async (req, res) => {
  try {
    const { code } = req.body

    if (!code) {
      return res.status(400).json({ error: '缺少QQ授权码' })
    }

    // 处理QQ登录
    const { user } = await QQService.handleQQLogin(code)
    
    // 生成JWT令牌
    const token = generateToken(user)

    res.json({
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        phone: user.phone,
        avatar: user.avatar,
        provider: 'qq'
      },
      token
    })

  } catch (error) {
    console.error('QQ登录失败:', error)
    res.status(500).json({ error: error.message || 'QQ登录失败' })
  }
})

/**
 * GET /api/oauth/providers
 * @summary 获取支持的第三方登录提供商
 * @tags oauth
 * @return {object} 200 - 支持的登录提供商列表
 */
router.get('/providers', (req, res) => {
  const providers = [
    {
      name: 'wechat',
      displayName: '微信',
      icon: 'wechat',
      enabled: true
    },
    {
      name: 'qq',
      displayName: 'QQ',
      icon: 'qq',
      enabled: true
    }
  ]

  res.json({ providers })
})

export default router