import axios from 'axios'
import { useAuthStore } from '@/stores/auth'
import { createPinia } from 'pinia'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api'

// 创建pinia实例（延迟创建authStore）
const pinia = createPinia()

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
api.interceptors.response.use(
  (response) => {
    return response.data
  },
  (error) => {
    // 不显示技术性错误到控制台，避免用户看到报警信息
    if (process.env.NODE_ENV === 'development') {
      console.error('API Error:', error)
    }
    
    if (error.response?.status === 401) {
      // 延迟创建authStore实例
      const authStore = useAuthStore(pinia)
      // 使用authStore清除认证状态
      authStore.clearAuth()
      // 使用alert提示用户登录已过期
      alert('登录已过期，请重新登录')
      // 跳转到登录页
      window.location.href = '/login'
    }

    // 统一错误格式，避免显示技术细节
    const errorMessage = error.response?.data?.error || 
                        error.response?.data?.message || 
                        '操作失败，请稍后重试'
    
    error.response.data = { error: errorMessage }
    return Promise.reject(error)
  }
)

// 导出api对象
export { api }

export const artworkService = {
  /**
   * 获取所有作品
   */
  async getArtworks() {
    return api.get('/artworks')
  },

  /**
   * 获取单个作品详情
   * @param {string} id
   */
  async getArtwork(id) {
    return api.get(`/artworks/${id}`)
  },

  /**
   * 创建新作品
   * @param {Object} artwork
   */
  async createArtwork(artwork) {
    return api.post('/artworks', artwork)
  },

  /**
   * 更新作品
   * @param {string} id
   * @param {Object} artwork
   */
  async updateArtwork(id, artwork) {
    return api.put(`/artworks/${id}`, artwork)
  },

  /**
   * 删除作品
   * @param {string} id
   */
  async deleteArtwork(id) {
    return api.delete(`/artworks/${id}`)
  },

  /**
   * 上传缩略图
   * @param {File} file
   */
  async uploadThumbnail(file) {
    const formData = new FormData()
    formData.append('file', file)
    return api.post('/upload/thumbnail', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  }
}

export const emotionService = {
  /**
   * 获取情绪统计数据
   */
  async getEmotionStats() {
    return api.get('/emotions/stats')
  },

  /**
   * 分析绘画情绪
   * @param {Object} artwork
   */
  async analyzeEmotion(artwork) {
    return api.post('/emotions/analyze', artwork)
  }
}

export const authService = {
  /**
   * 用户登录
   * @param {Object} credentials
   */
  async login(credentials) {
    const response = await api.post('/auth/login', credentials)
    if (response.token) {
      localStorage.setItem('token', response.token)
    }
    return response
  },

  /**
   * 用户注册
   * @param {Object} userData
   */
  async register(userData) {
    return api.post('/auth/register', userData)
  },

  /**
   * 获取用户信息
   */
  async getProfile() {
    return api.get('/auth/profile')
  },

  /**
   * 更新用户信息
   * @param {Object} userData
   */
  async updateProfile(userData) {
    return api.put('/auth/profile', userData)
  },



  /**
   * 第三方登录回调
   * @param {string} provider
   * @param {string} code
   */
  async handleOAuthCallback(provider, code) {
    return api.post(`/oauth/${provider}/callback`, { code })
  },

  /**
   * 退出登录
   */
  logout() {
    localStorage.removeItem('token')
    window.location.href = '/'
  }
}

export default api