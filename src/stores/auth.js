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
   * 统一登录方法（优化版）
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
    
    console.log('Auth store: 开始登录请求', credentials)
    
    try {
      const response = await api.post('/auth/login', credentials)
      console.log('Auth store: 登录响应', response)
      
      // 处理axios响应拦截器返回的数据格式
      const userData = response.user || response.data?.user
      const tokenData = response.token || response.data?.token
      const expiresIn = response.expiresIn || response.data?.expiresIn
      
      if (!userData || !tokenData) {
        console.error('Auth store: 服务器响应格式错误', response)
        throw new Error('服务器响应格式错误')
      }
      
      setUser(userData, tokenData)
      
      // 设置记住登录状态
      if (credentials.remember) {
        localStorage.setItem('rememberMe', 'true')
      } else {
        localStorage.removeItem('rememberMe')
      }
      
      console.log('Auth store: 登录成功')
      return response.data
    } catch (err) {
      console.error('Auth store: 登录失败', err)
      
      // 根据错误类型提供更友好的错误信息
      const errorMessage = err.response?.data?.error || '登录失败'
      
      // 映射服务器错误信息
      const errorMap = {
        '用户不存在': '账号或密码错误',
        '密码错误': '账号或密码错误',
        '用户名和密码不能为空': '请输入用户名和密码',
        '用户名长度应为2-20位': '用户名长度应为2-20位',
        '密码长度至少为6位': '密码长度至少为6位'
      }
      
      error.value = errorMap[errorMessage] || errorMessage
      
      // 记录登录失败次数
      const failedAttempts = parseInt(localStorage.getItem('failedAttempts') || '0') + 1
      localStorage.setItem('failedAttempts', failedAttempts.toString())
      
      throw err
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
      const response = await api.post('/auth/register', userData)
      const userDataResp = response.data?.user || response.data
      const tokenData = response.data?.token || response.data?.access_token
      setUser(userDataResp, tokenData)
      return response.data
    } catch (err) {
      error.value = err.response?.data?.error || '注册失败，请稍后重试'
      throw err
    } finally {
      isLoading.value = false
    }
  }





  /**
   * 获取当前用户信息
   */
  const fetchUser = async () => {
    if (!token.value) return
    
    try {
      const response = await api.get('/auth/me')
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