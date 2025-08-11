/**
 * 第三方登录服务
 * 处理微信、QQ等OAuth登录
 */

import axios from 'axios'
import qs from 'qs'
import { supabase } from '../config/database.js'
import jwt from 'jsonwebtoken'
import { TABLES } from '../config/tables.js'
import { JWT_SECRET } from '../config/auth.js'
import { oauthConfig } from '../config/oauth.js'

/**
 * 微信登录服务
 */
export class WeChatService {
  /**
   * 获取微信access_token
   */
  static async getAccessToken(code) {
    const url = 'https://api.weixin.qq.com/sns/oauth2/access_token'
    const params = {
      appid: oauthConfig.wechat.appId,
      secret: oauthConfig.wechat.appSecret,
      code,
      grant_type: 'authorization_code'
    }

    try {
      const response = await axios.get(url, { params })
      return response.data
    } catch (error) {
      throw new Error(`微信获取access_token失败: ${error.response?.data?.errmsg || error.message}`)
    }
  }

  /**
   * 获取微信用户信息
   */
  static async getUserInfo(accessToken, openid) {
    const url = 'https://api.weixin.qq.com/sns/userinfo'
    const params = {
      access_token: accessToken,
      openid,
      lang: 'zh_CN'
    }

    try {
      const response = await axios.get(url, { params })
      return response.data
    } catch (error) {
      throw new Error(`微信获取用户信息失败: ${error.response?.data?.errmsg || error.message}`)
    }
  }

  /**
   * 处理微信登录
   */
  static async handleWeChatLogin(code) {
    // 获取access_token
    const tokenData = await this.getAccessToken(code)
    
    if (tokenData.errcode) {
      throw new Error(`微信登录失败: ${tokenData.errmsg}`)
    }

    // 获取用户信息
    const userInfo = await this.getUserInfo(tokenData.access_token, tokenData.openid)

    // 查找或创建用户
    let user = await this.findOrCreateUser({
      openid: tokenData.openid,
      unionid: tokenData.unionid,
      nickname: userInfo.nickname,
      avatar: userInfo.headimgurl,
      provider: 'wechat'
    })

    return { user, tokenData }
  }

  /**
   * 查找或创建微信用户
   */
  static async findOrCreateUser(userData) {
    const { openid, unionid, nickname, avatar } = userData

    try {
      // 首先尝试通过unionid查找
      if (unionid) {
        const { data: existingUser } = await supabase
          .from(TABLES.USERS)
          .select('*')
          .eq('wechat_unionid', unionid)
          .single()

        if (existingUser) {
          return existingUser
        }
      }

      // 通过openid查找
      const { data: existingUserByOpenid } = await supabase
        .from(TABLES.USERS)
        .select('*')
        .eq('wechat_openid', openid)
        .single()

      if (existingUserByOpenid) {
        return existingUserByOpenid
      }

      // 创建新用户
      const { data: newUser, error } = await supabase
        .from(TABLES.USERS)
        .insert([{
          username: nickname || '微信用户',
          avatar: avatar || `https://ui-avatars.com/api/?name=${nickname || '微信用户'}&background=07c160&color=fff`,
          wechat_openid: openid,
          wechat_unionid: unionid,
          provider: 'wechat',
          created_at: new Date().toISOString()
        }])
        .select()
        .single()

      if (error) {
        throw error
      }

      return newUser
    } catch (error) {
      console.error('微信用户处理失败:', error)
      throw error
    }
  }
}

/**
 * QQ登录服务
 */
export class QQService {
  /**
   * 获取QQ access_token
   */
  static async getAccessToken(code) {
    const url = 'https://graph.qq.com/oauth2.0/token'
    const params = {
      grant_type: 'authorization_code',
      client_id: oauthConfig.qq.appId,
      client_secret: oauthConfig.qq.appKey,
      code,
      redirect_uri: oauthConfig.qq.callbackUrl
    }

    try {
      const response = await axios.get(url, { params })
      const result = qs.parse(response.data)
      
      if (result.error) {
        throw new Error(`QQ获取access_token失败: ${result.error_description}`)
      }

      return result
    } catch (error) {
      throw new Error(`QQ获取access_token失败: ${error.message}`)
    }
  }

  /**
   * 获取QQ openid
   */
  static async getOpenId(accessToken) {
    const url = 'https://graph.qq.com/oauth2.0/me'
    const params = { access_token: accessToken }

    try {
      const response = await axios.get(url, { params })
      const match = response.data.match(/"openid":"([^"]+)"/)
      
      if (!match) {
        throw new Error('QQ获取openid失败')
      }

      return JSON.parse(`{${response.data.replace('callback(', '').replace(');', '')}}`)
    } catch (error) {
      throw new Error(`QQ获取openid失败: ${error.message}`)
    }
  }

  /**
   * 获取QQ用户信息
   */
  static async getUserInfo(accessToken, openid) {
    const url = 'https://graph.qq.com/user/get_user_info'
    const params = {
      access_token: accessToken,
      oauth_consumer_key: oauthConfig.qq.appId,
      openid
    }

    try {
      const response = await axios.get(url, { params })
      return response.data
    } catch (error) {
      throw new Error(`QQ获取用户信息失败: ${error.response?.data?.msg || error.message}`)
    }
  }

  /**
   * 处理QQ登录
   */
  static async handleQQLogin(code) {
    // 获取access_token
    const tokenData = await this.getAccessToken(code)
    
    // 获取openid
    const openIdData = await this.getOpenId(tokenData.access_token)

    // 获取用户信息
    const userInfo = await this.getUserInfo(tokenData.access_token, openIdData.openid)

    if (userInfo.ret !== 0) {
      throw new Error(`QQ登录失败: ${userInfo.msg}`)
    }

    // 查找或创建用户
    let user = await this.findOrCreateUser({
      openid: openIdData.openid,
      nickname: userInfo.nickname,
      avatar: userInfo.figureurl_qq_2 || userInfo.figureurl_2,
      provider: 'qq'
    })

    return { user, tokenData: { ...tokenData, ...openIdData } }
  }

  /**
   * 查找或创建QQ用户
   */
  static async findOrCreateUser(userData) {
    const { openid, nickname, avatar } = userData

    try {
      // 通过openid查找
      const { data: existingUser } = await supabase
        .from(TABLES.USERS)
        .select('*')
        .eq('qq_openid', openid)
        .single()

      if (existingUser) {
        return existingUser
      }

      // 创建新用户
      const { data: newUser, error } = await supabase
        .from(TABLES.USERS)
        .insert([{
          username: nickname || 'QQ用户',
          avatar: avatar || `https://ui-avatars.com/api/?name=${nickname || 'QQ用户'}&background=12b7f5&color=fff`,
          qq_openid: openid,
          provider: 'qq',
          created_at: new Date().toISOString()
        }])
        .select()
        .single()

      if (error) {
        throw error
      }

      return newUser
    } catch (error) {
      console.error('QQ用户处理失败:', error)
      throw error
    }
  }
}

/**
 * 生成JWT令牌
 */
export const generateToken = (user) => {
  return jwt.sign(
    { userId: user.id, email: user.email, phone: user.phone },
    JWT_SECRET,
    { expiresIn: '7d' }
  )
}

export default {
  WeChatService,
  QQService,
  generateToken
}