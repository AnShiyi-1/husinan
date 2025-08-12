import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import api from '@/services/api'

/**
 * 用户认证状态管理（优化版）
 */
export const useAuthStore = defineStore('auth', () => {
  // 状态
  const user = ref(null)
  const token = ref(localStorage.getItem('token') || null)
  const refreshToken = ref(localStorage.getItem('refreshToken') || null)
  const isLoading = ref(false)
  const error = ref(null)
  const loginAttempts = ref(0)
  const lastAttemptTime = ref(0)

  // 计算属性
  const isLoggedIn = computed(() => !!token.value)
  const userId = computed(() => user.value?.id)
  const username = computed(() => user.value?.username || '用户')
  const userAvatar = computed(() => user.value?.avatar || '')
  const canAttemptLogin = computed(() => {
    const now = Date.now()
    const timeDiff = now - lastAttemptTime.value
    // 允许每30秒最多5次尝试
    return loginAttempts.value < 5 || timeDiff > 30000
  })

  /**
   * 设置用户和token（优化版）
   */
  const setUser = (userData, authToken, refreshTokenData = null) => {
    user.value = userData || null
    token.value = authToken || null
    
    if (authToken) {
      localStorage.setItem('token', authToken)
    }
    if (refreshTokenData) {
      refreshToken.value = refreshTokenData
      localStorage.setItem('refreshToken', refreshTokenData)
    }
    
    // 设置API请求头
    if (authToken) {
      api.defaults.headers.common['Authorization'] = `Bearer ${authToken}`
    }
    
    // 重置登录尝试计数
    loginAttempts.value = 0
    lastAttemptTime.value = 0
    
    // 触发自定义事件通知用户状态变化
    window.dispatchEvent(new CustomEvent('auth-state-changed', {
      detail: { user: userData, token: authToken }
    }))
  }

  /**
   * 清除认证信息
   */
  const clearAuth = () => {
    user.value = null
    token.value = null
    refreshToken.value = null
    loginAttempts.value = 0
    lastAttemptTime.value = 0
    error.value = null
    
    localStorage.removeItem('token')
    localStorage.removeItem('refreshToken')
    localStorage.removeItem('rememberMe')
    localStorage.removeItem('lastUsername')
    localStorage.removeItem('failedAttempts')
    
    delete api.defaults.headers.common['Authorization']
    
    // 触发自定义事件通知登出
    window.dispatchEvent(new CustomEvent('auth-state-changed', {
      detail: { user: null, token: null }
    }))
  }

  /**
   * 统一登录方法（网络连接优化版）
   */
  const login = async (credentials) => {
    // 防暴力破解检查
    if (!canAttemptLogin.value) {
      error.value = '登录过于频繁，请稍后再试'
      throw new Error('登录过于频繁')
    }
    
    isLoading.value = true
    error.value = null
    
    // 更新登录尝试计数
    loginAttempts.value++
    lastAttemptTime.value = Date.now()
    
    console.log('🔐 Auth store: 开始登录请求', { username: credentials.username })
    
    try {
      // 网络连接检查
      if (!navigator.onLine) {
        error.value = '网络连接异常，请检查网络后重试'
        throw new Error('NETWORK_ERROR')
      }
      
      // 检查服务器连接
      try {
        await api.get('/health')
      } catch (healthError) {
        console.error('服务器健康检查失败:', healthError)
        error.value = '服务器连接失败，请检查服务器状态'
        throw new Error('SERVER_UNAVAILABLE')
      }
      
      // 验证输入
      if (!credentials.username || !credentials.password) {
        error.value = '请输入用户名和密码'
        throw new Error('INVALID_INPUT')
      }
      
      // 添加超时配置和重试机制
      const response = await api.post('/auth/login', credentials, {
        timeout: 15000, // 15秒超时
        retry: 2,       // 重试2次
        retryDelay: 1000 // 重试延迟1秒
      })
      
      console.log('✅ Auth store: 登录响应成功', response)
      
      // 统一响应格式处理
      let userData, tokenData, expiresIn
      
      if (response.data) {
        // 标准格式
        userData = response.data.user
        tokenData = response.data.token || response.data.access_token
        expiresIn = response.data.expiresIn
      } else {
        // 兼容旧格式
        userData = response.user
        tokenData = response.token
        expiresIn = response.expiresIn
      }
      
      if (!userData || !tokenData) {
        console.error('❌ Auth store: 响应数据格式错误', {
          hasUserData: !!userData,
          hasTokenData: !!tokenData,
          response: response
        })
        throw new Error('服务器响应数据不完整')
      }
      
      // 设置用户状态
      setUser(userData, tokenData)
      
      // 设置记住登录状态
      if (credentials.remember) {
        localStorage.setItem('rememberMe', 'true')
        localStorage.setItem('rememberedUsername', credentials.username)
      } else {
        localStorage.removeItem('rememberMe')
        localStorage.removeItem('rememberedUsername')
      }
      
      // 清除失败计数
      localStorage.removeItem('failedAttempts')
      
      console.log('🎉 Auth store: 登录成功', { userId: userData.id, username: userData.username })
      return { user: userData, token: tokenData, expiresIn }
      
    } catch (err) {
      console.error('❌ Auth store: 登录失败', {
        error: err.message,
        response: err.response?.data,
        status: err.response?.status
      })
      
      let errorMessage = '登录失败，请稍后重试'
      
      // 网络错误处理
      if (err.message === 'NETWORK_ERROR') {
        errorMessage = '网络连接异常，请检查网络后重试'
      } else if (err.message === 'INVALID_INPUT') {
        errorMessage = error.value || '请输入用户名和密码'
      } else if (err.code === 'ECONNABORTED') {
        errorMessage = '网络连接超时，请检查网络后重试'
      } else if (!err.response) {
        errorMessage = '网络连接失败，请检查服务器状态'
      } else {
        // 服务器返回的错误
        const serverError = err.response.data?.error || err.response.data?.message || '登录失败'
        
        // 错误消息映射
        const errorMap = {
          '用户不存在': '账号或密码错误',
          '密码错误': '账号或密码错误',
          '用户名不存在': '账号或密码错误',
          '密码不正确': '账号或密码错误',
          '用户名和密码不能为空': '请输入用户名和密码',
          '用户名长度应为2-20位': '用户名格式不正确（2-20位）',
          '密码长度至少为6位': '密码格式不正确（至少6位）',
          '用户已被禁用': '该账号已被禁用，请联系管理员'
        }
        
        errorMessage = errorMap[serverError] || serverError
      }
      
      error.value = errorMessage
      
      // 记录登录失败次数（带过期时间）
      const failedAttempts = parseInt(localStorage.getItem('failedAttempts') || '0') + 1
      const expiry = Date.now() + (30 * 60 * 1000) // 30分钟后过期
      
      localStorage.setItem('failedAttempts', failedAttempts.toString())
      localStorage.setItem('failedAttemptsExpiry', expiry.toString())
      
      throw new Error(error.value)
    } finally {
      isLoading.value = false
    }
  }



  /**
   * 账号密码注册
   */
  const register = async (userData) => {
    isLoading.value = true
    error.value = null
    
    try {
      // 网络连接检查
      if (!navigator.onLine) {
        error.value = '网络连接异常，请检查网络后重试'
        throw new Error('NETWORK_ERROR')
      }

      const response = await api.post('/auth/register', userData)
      
      // 验证响应数据
      if (!response.data) {
        throw new Error('服务器响应异常')
      }
      
      const userDataResp = response.data?.user || response.data
      const tokenData = response.data?.token || response.data?.access_token
      
      if (!tokenData) {
        throw new Error('注册成功但获取令牌失败')
      }
      
      setUser(userDataResp, tokenData)
      return response.data
    } catch (err) {
      let errorMessage = '注册失败，请稍后重试'
      
      if (err.message === 'NETWORK_ERROR') {
        errorMessage = '网络连接异常，请检查网络后重试'
      } else if (err.code === 'ECONNABORTED') {
        errorMessage = '网络连接超时，请检查网络后重试'
      } else if (err.response?.data?.error) {
        errorMessage = err.response.data.error
      } else if (err.response?.status === 400) {
        errorMessage = err.response.data?.error || '注册信息有误，请检查后重试'
      } else if (err.response?.status === 409) {
        errorMessage = '用户名已被注册，请使用其他用户名'
      } else if (err.response?.status >= 500) {
        errorMessage = '服务器繁忙，请稍后重试'
      }
      
      error.value = errorMessage
      throw err
    } finally {
      isLoading.value = false
    }
  }





  /**
   * 获取当前用户信息
   */
  const fetchUser = async () => {
    // 检查token是否存在
    if (!token.value) {
      console.warn('Auth store: 未找到token，跳过用户信息获取')
      return null
    }
    
    try {
      const response = await api.get('/auth/me')
      
      // 检查响应数据
      if (!response || !response.data) {
        console.warn('Auth store: 用户信息响应数据为空')
        return null
      }
      
      setUser(response.data, token.value)
      return response.data
    } catch (err) {
      if (err.response?.status === 401) {
        clearAuth()
      }
      throw err
    }
  }

  /**
   * 登出
   */
  const logout = async () => {
    try {
      await api.post('/auth/logout')
    } catch (err) {
      console.error('登出失败:', err)
    } finally {
      clearAuth()
    }
  }

  // 初始化：如果有token，获取用户信息
  const initAuth = async () => {
    if (token.value) {
      try {
        await fetchUser()
        console.log('认证状态初始化成功')
      } catch (error) {
        console.warn('获取用户信息失败，清除认证状态')
        clearAuth()
      }
    }
  }

  // 立即执行初始化
  initAuth()

  return {
    // 状态
    user,
    token,
    refreshToken,
    isLoading,
    error,
    loginAttempts,
    lastAttemptTime,
    isLoggedIn,
    userId,
    username,
    userAvatar,
    canAttemptLogin,
    
    // 方法
    setUser,
    login,
    register,
    fetchUser,
    logout,
    clearAuth
  }
})
