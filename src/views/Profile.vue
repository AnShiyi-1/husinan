<template>
  <div class="profile">
    <div class="profile-header">
      <div class="profile-avatar">
        <img 
          v-if="userAvatar" 
          :src="userAvatar" 
          :alt="username"
          class="user-avatar"
        />
        <div v-else class="avatar-placeholder">
          {{ username.charAt(0).toUpperCase() }}
        </div>
        <button class="avatar-upload-btn" @click="uploadAvatar" title="上传头像">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
            <polyline points="7 10 12 15 17 10"/>
            <line x1="12" y1="15" x2="12" y2="3"/>
          </svg>
        </button>
      </div>
      <div class="profile-info">
        <h1>{{ username }}</h1>
        <div class="user-details">
          <p v-if="userEmail" class="user-detail">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
              <polyline points="22,6 12,13 2,6"/>
            </svg>
            {{ userEmail }}
          </p>
          <p v-if="userPhone" class="user-detail">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M22 16.92v3a2 2 0 01-1.11 1.79l-1.78.9A2 2 0 0116.08 21a15.93 15.93 0 01-10-10 2 2 0 01.9-1.78l3-.9A2 2 0 0112.08 7h3a2 2 0 012 2 16 16 0 01-5 5z"/>
            </svg>
            {{ userPhone }}
          </p>
        </div>
        <p class="user-id">用户ID: {{ userId || '请先登录' }}</p>
        <p class="user-bio">用画笔记录情绪，用色彩治愈心灵</p>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M9 11H5a2 2 0 00-2 2v7a2 2 0 002 2h4a2 2 0 002-2v-7a2 2 0 00-2-2z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M17 21v-4a2 2 0 00-2-2H5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M15 5a2.121 2.121 0 01-3 0 2.121 2.121 0 00-3 0 2.121 2.121 0 01-3 0 2.121 2.121 0 00-3 0L3 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ totalArtworks }}</div>
          <div class="stat-label">总作品数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ favoriteEmotion || '暂无' }}</div>
          <div class="stat-label">最常表达</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <circle cx="12" cy="12" r="10" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <polyline points="12 6 12 12 16 14" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ daysSinceStart }}</div>
          <div class="stat-label">创作天数</div>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M21 16V8a2 2 0 00-1-1.73l-7-4a2 2 0 00-2 0l-7 4A2 2 0 003 8v8a2 2 0 001 1.73l7 4a2 2 0 002 0l7-4A2 2 0 0021 16z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <polyline points="3.27 6.96 12 12.01 20.73 6.96" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <line x1="12" y1="22.08" x2="12" y2="12" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ totalStrokes }}</div>
          <div class="stat-label">总笔触数</div>
        </div>
      </div>
    </div>

    <div id="artworks" class="recent-works">
      <div class="works-header">
        <h2>我的作品</h2>
        <div class="works-stats">
          <span class="stat-item">共 {{ userArtworks.length }} 幅作品</span>
        </div>
      </div>
      
      <div v-if="isLoading" class="loading-state">
        <div class="loading-spinner"></div>
        <p>加载作品中...</p>
      </div>
      
      <div v-else-if="userArtworks.length === 0" class="empty-state">
        <div class="empty-icon">🎨</div>
        <h4>还没有作品</h4>
        <p>开始你的第一幅创作，用画笔记录内心的情绪</p>
        <button class="create-btn" @click="$router.push('/')">开始创作</button>
      </div>
      
      <div v-else class="recent-grid">
        <div 
          v-for="artwork in userArtworks" 
          :key="artwork.id"
          class="recent-card"
          @click="loadArtwork(artwork)"
        >
          <div class="recent-preview">
            <img 
              v-if="artwork.thumbnail" 
              :src="artwork.thumbnail" 
              :alt="artwork.title"
              class="artwork-thumbnail"
            />
            <div v-else class="artwork-placeholder">
              <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
                <polyline points="14 2 14 8 20 8"/>
                <line x1="16" y1="13" x2="8" y2="21"/>
                <line x1="8" y1="13" x2="16" y2="21"/>
              </svg>
            </div>
          </div>
          <div class="recent-info">
            <h3>{{ artwork.title || '未命名作品' }}</h3>
            <div class="recent-meta">
              <span class="emotion-badge" :class="artwork.emotion">
                {{ getEmotionLabel(artwork.emotion) }}
              </span>
              <span class="date">{{ formatDate(artwork.createdAt) }}</span>
              <span class="stroke-count">{{ artwork.paths?.length || 0 }} 笔触</span>
            </div>
            <div v-if="artwork.description" class="artwork-description">
              {{ artwork.description }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="emotion-chart">
      <h2>情绪分布</h2>
      <div class="chart-container">
        <div class="chart-bars">
          <div 
            v-for="emotion in emotionStats" 
            :key="emotion.name"
            class="chart-bar"
            :style="{ '--bar-height': emotion.percentage + '%' }"
          >
            <div class="bar-fill" :class="emotion.name"></div>
            <div class="bar-label">{{ emotion.label }}</div>
            <div class="bar-value">{{ emotion.count }}</div>
          </div>
        </div>
      </div>
    </div>

    <div class="achievements">
      <h2>成就解锁</h2>
      <div class="achievements-grid">
        <div 
          v-for="achievement in achievements" 
          :key="achievement.id"
          :class="['achievement-card', { unlocked: achievement.unlocked }]"
        >
          <div class="achievement-icon">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path v-if="achievement.icon === 'first'" d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path v-if="achievement.icon === 'emotion'" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path v-if="achievement.icon === 'streak'" d="M12 2v20M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="achievement-info">
            <h3>{{ achievement.name }}</h3>
            <p>{{ achievement.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useCanvasStore } from '../stores/canvas'
import { useAuthStore } from '../stores/auth'
import { computed, onMounted, ref, watch } from 'vue'
import api from '@/services/api'

export default {
  name: 'Profile',
  setup() {
    const canvasStore = useCanvasStore()
    const authStore = useAuthStore()
    
    const userArtworks = ref([])
    const isLoading = ref(false)
    
    const userAvatar = computed(() => authStore.userAvatar)
    const username = computed(() => authStore.username)
    const userId = computed(() => authStore.userId)
    const userEmail = computed(() => authStore.user?.email || '')
    const userPhone = computed(() => authStore.user?.phone || '')
    
    // 获取用户作品
    const fetchUserArtworks = async () => {
      if (!authStore.userId) return
      
      isLoading.value = true
      try {
        const response = await api.get(`/artworks/user/${authStore.userId}`)
        userArtworks.value = response.data || []
      } catch (error) {
        console.error('获取用户作品失败:', error)
        userArtworks.value = []
      } finally {
        isLoading.value = false
      }
    }
    
    // 页面加载时获取用户作品
    onMounted(() => {
      // 监听认证状态变化事件
      window.addEventListener('auth-state-changed', async (event) => {
        if (event.detail.user) {
          await fetchUserArtworks()
        } else {
          userArtworks.value = []
        }
      })

      if (authStore.isLoggedIn) {
        fetchUserArtworks()
      }
    })

    // 监听登录状态变化
    watch(() => authStore.isLoggedIn, (newVal) => {
      if (newVal) {
        fetchUserArtworks()
      } else {
        userArtworks.value = []
      }
    })
    
    return { 
      canvasStore,
      userAvatar,
      username,
      userId,
      userEmail,
      userPhone,
      userArtworks,
      isLoading,
      fetchUserArtworks
    }
  },
  data() {
    return {
      achievements: [
        {
          id: 1,
          name: '初次创作',
          description: '完成你的第一幅作品',
          icon: 'first',
          unlocked: false
        },
        {
          id: 2,
          name: '情绪大师',
          description: '使用所有6种情绪进行创作',
          icon: 'emotion',
          unlocked: false
        },
        {
          id: 3,
          name: '连续创作',
          description: '连续3天进行创作',
          icon: 'streak',
          unlocked: false
        }
      ]
    }
  },
  computed: {
    artworks() {
      return this.userArtworks
    },
    totalArtworks() {
      return this.artworks.length
    },
    totalStrokes() {
      return this.artworks.reduce((total, artwork) => total + artwork.paths.length, 0)
    },
    emotionStats() {
      const stats = {}
      const emotionMap = {
        happy: { label: '快乐', color: '#10b981' },
        sad: { label: '悲伤', color: '#6366f1' },
        angry: { label: '愤怒', color: '#ef4444' },
        calm: { label: '平静', color: '#06b6d4' },
        excited: { label: '兴奋', color: '#f59e0b' },
        anxious: { label: '焦虑', color: '#8b5cf6' }
      }
      
      // 初始化统计
      Object.keys(emotionMap).forEach(key => {
        stats[key] = 0
      })
      
      // 统计情绪
      this.artworks.forEach(artwork => {
        stats[artwork.emotion] = (stats[artwork.emotion] || 0) + 1
      })
      
      // 计算百分比
      const max = Math.max(...Object.values(stats), 1)
      return Object.entries(stats).map(([name, count]) => ({
        name,
        label: emotionMap[name].label,
        count,
        percentage: Math.round((count / max) * 100)
      }))
    },
    favoriteEmotion() {
      const stats = this.emotionStats
      if (stats.length === 0) return null
      
      const max = Math.max(...stats.map(s => s.count))
      const favorite = stats.find(s => s.count === max)
      return favorite && favorite.count > 0 ? favorite.label : null
    },
    recentArtworks() {
      return this.artworks.slice(0, 6)
    },
    daysSinceStart() {
      if (this.artworks.length === 0) return 0
      
      const firstDate = Math.min(...this.artworks.map(a => a.createdAt))
      const days = Math.floor((Date.now() - firstDate) / (1000 * 60 * 60 * 24))
      return Math.max(days, 1)
    }
  },
  watch: {
    userArtworks: {
      handler() {
        this.checkAchievements()
        this.$nextTick(() => {
          this.renderRecentPreviews()
        })
      },
      deep: true
    }
  },
  mounted() {
    // 初始时如果有数据就检查成就和渲染预览
    if (this.userArtworks.length > 0) {
      this.checkAchievements()
      this.$nextTick(() => {
        this.renderRecentPreviews()
      })
    }
    
    // 确保用户信息已加载
    if (this.authStore.isLoggedIn && !this.userId) {
      this.authStore.fetchUser()
    }
  },
  methods: {
    setCanvasRef(el, artwork) {
      if (el && artwork) {
        this.renderPreview(el, artwork)
      }
    },
    
    renderPreview(canvas, artwork) {
      const ctx = canvas.getContext('2d')
      canvas.width = 300
      canvas.height = 200
      
      // 背景
      ctx.fillStyle = artwork.backgroundColor
      ctx.fillRect(0, 0, 300, 200)
      
      // 缩放比例
      const scale = 0.375 // 300/800, 200/600
      
      // 绘制路径
      artwork.paths.forEach(path => {
        if (path.points.length < 2) return
        
        ctx.beginPath()
        ctx.strokeStyle = path.color
        ctx.lineWidth = path.width * scale
        ctx.lineCap = 'round'
        ctx.lineJoin = 'round'
        
        ctx.moveTo(path.points[0].x * scale, path.points[0].y * scale)
        for (let i = 1; i < path.points.length; i++) {
          ctx.lineTo(path.points[i].x * scale, path.points[i].y * scale)
        }
        ctx.stroke()
      })
    },
    
    renderRecentPreviews() {
      this.$nextTick(() => {
        const canvases = this.$el.querySelectorAll('.mini-canvas')
        canvases.forEach((canvas, index) => {
          const artwork = this.recentArtworks[index]
          if (artwork) {
            this.renderPreview(canvas, artwork)
          }
        })
      })
    },
    
    getEmotionLabel(emotion) {
      const map = {
        happy: '快乐',
        sad: '悲伤',
        angry: '愤怒',
        calm: '平静',
        excited: '兴奋',
        anxious: '焦虑'
      }
      return map[emotion] || emotion
    },
    
    formatDate(timestamp) {
      return new Date(timestamp).toLocaleDateString('zh-CN')
    },
    
    loadArtwork(artwork) {
      this.canvasStore.loadArtwork(artwork.id)
      this.$router.push('/')
    },
    
    checkAchievements() {
      // 检查初次创作
      if (this.totalArtworks > 0) {
        this.achievements[0].unlocked = true
      }
      
      // 检查情绪大师
      const emotions = new Set(this.artworks.map(a => a.emotion))
      if (emotions.size >= 6) {
        this.achievements[1].unlocked = true
      }
      
      // 检查连续创作（简化版，实际应该检查日期连续性）
      if (this.daysSinceStart >= 3) {
        this.achievements[2].unlocked = true
      }
    },
    
    async uploadAvatar() {
      const input = document.createElement('input')
      input.type = 'file'
      input.accept = 'image/*'
      
      input.onchange = async (e) => {
        const file = e.target.files[0]
        if (!file) return
        
        if (file.size > 2 * 1024 * 1024) {
          alert('图片大小不能超过2MB')
          return
        }
        
        const formData = new FormData()
        formData.append('avatar', file)
        
        try {
          const response = await api.post('/auth/upload-avatar', formData, {
            headers: {
              'Content-Type': 'multipart/form-data'
            }
          })
          
          // 更新用户头像
          const authStore = useAuthStore()
          await authStore.fetchUser()
          
          alert('头像上传成功！')
        } catch (error) {
          console.error('头像上传失败:', error)
          alert('头像上传失败，请重试')
        }
      }
      
      input.click()
    }
  }
}
</script>

<style scoped>
.profile {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.profile-header {
  display: flex;
  align-items: center;
  gap: 2rem;
  margin-bottom: 3rem;
  padding: 2rem;
  background-color: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
}

.profile-avatar {
  position: relative;
  width: 80px;
  height: 80px;
}

.user-avatar {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid var(--primary-color);
  box-shadow: var(--shadow-md);
}

.avatar-placeholder {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2rem;
  font-weight: bold;
  box-shadow: var(--shadow-md);
}

.avatar-upload-btn {
  position: absolute;
  bottom: -5px;
  right: -5px;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: var(--primary-color);
  color: white;
  border: 2px solid white;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: var(--shadow-sm);
}

.avatar-upload-btn:hover {
  background: var(--primary-hover);
  transform: scale(1.1);
}

.user-details {
  margin: 0.5rem 0;
}

.user-detail {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin: 0.25rem 0;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.user-detail svg {
  width: 16px;
  height: 16px;
  opacity: 0.7;
}

.profile-info h1 {
  margin: 0 0 0.5rem 0;
  font-size: 2.5rem;
  color: var(--text-primary);
  font-weight: 700;
}

.user-id {
  color: var(--text-secondary);
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  font-family: monospace;
}

.user-bio {
  color: var(--text-secondary);
  margin: 0;
  font-size: 1.1rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 3rem;
}

.stat-card {
  background-color: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.stat-icon {
  color: var(--primary-color);
  background-color: rgba(99, 102, 241, 0.1);
  border-radius: var(--radius-md);
  padding: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-number {
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1;
}

.stat-label {
  color: var(--text-secondary);
  font-size: 0.875rem;
}

.recent-works {
  margin-bottom: 3rem;
}

.recent-works h2 {
  margin: 0 0 1.5rem 0;
  color: var(--text-primary);
  font-size: 1.5rem;
}

.recent-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1rem;
}

.recent-card {
  background-color: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  overflow: hidden;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.recent-card:hover {
  transform: translateY(-2px);
}

.recent-preview {
  aspect-ratio: 3/2;
  background-color: var(--background-color);
}

.mini-canvas {
  width: 100%;
  height: 100%;
  display: block;
}

.recent-info {
  padding: 0.75rem;
}

.recent-info h3 {
  margin: 0 0 0.5rem 0;
  font-size: 0.875rem;
  color: var(--text-primary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.recent-meta {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.emotion-badge {
  padding: 0.125rem 0.5rem;
  border-radius: var(--radius-sm);
  font-size: 0.75rem;
  font-weight: 500;
}

.emotion-badge.happy { background-color: #10b981; color: white; }
.emotion-badge.sad { background-color: #6366f1; color: white; }
.emotion-badge.angry { background-color: #ef4444; color: white; }
.emotion-badge.calm { background-color: #06b6d4; color: white; }
.emotion-badge.excited { background-color: #f59e0b; color: white; }
.emotion-badge.anxious { background-color: #8b5cf6; color: white; }

.date {
  color: var(--text-secondary);
  font-size: 0.75rem;
}

.stroke-count {
  color: var(--primary-color);
  font-size: 0.75rem;
  font-weight: 500;
}

.empty-state {
  text-align: center;
  padding: 3rem 1rem;
  color: var(--text-secondary);
}

.empty-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

.empty-state h4 {
  margin: 0 0 0.5rem 0;
  color: var(--text-primary);
  font-size: 1.5rem;
}

.empty-state p {
  margin: 0 0 1.5rem 0;
  font-size: 1.1rem;
}

.create-btn {
  background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
  color: white;
  border: none;
  padding: 0.75rem 2rem;
  border-radius: 2rem;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: var(--shadow-md);
}

.create-btn:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-lg);
}

.emotion-chart {
  margin-bottom: 3rem;
}

.emotion-chart h2 {
  margin: 0 0 1.5rem 0;
  color: var(--text-primary);
  font-size: 1.5rem;
}

.chart-container {
  background-color: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-lg);
  padding: 2rem;
}

.chart-bars {
  display: flex;
  align-items: end;
  gap: 1rem;
  height: 200px;
}

.chart-bar {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.bar-fill {
  width: 100%;
  height: var(--bar-height);
  border-radius: var(--radius-sm);
  transition: height 0.3s ease;
}

.bar-fill.happy { background-color: #10b981; }
.bar-fill.sad { background-color: #6366f1; }
.bar-fill.angry { background-color: #ef4444; }
.bar-fill.calm { background-color: #06b6d4; }
.bar-fill.excited { background-color: #f59e0b; }
.bar-fill.anxious { background-color: #8b5cf6; }

.bar-label {
  font-size: 0.875rem;
  color: var(--text-secondary);
}

.bar-value {
  font-size: 0.75rem;
  color: var(--text-primary);
  font-weight: 500;
}

.achievements h2 {
  margin: 0 0 1.5rem 0;
  color: var(--text-primary);
  font-size: 1.5rem;
}

.achievements-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1rem;
}

.achievement-card {
  background-color: var(--surface-color);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 1.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  opacity: 0.5;
  transition: all 0.2s ease;
}

.achievement-card.unlocked {
  opacity: 1;
  border-color: var(--primary-color);
}

.achievement-icon {
  color: var(--primary-color);
  background-color: rgba(99, 102, 241, 0.1);
  border-radius: var(--radius-md);
  padding: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.achievement-info h3 {
  margin: 0 0 0.25rem 0;
  color: var(--text-primary);
  font-size: 1rem;
}

.achievement-info p {
  margin: 0;
  color: var(--text-secondary);
  font-size: 0.875rem;
}

@media (max-width: 768px) {
  .profile {
    padding: 1rem;
  }
  
  .profile-header {
    flex-direction: column;
    text-align: center;
    gap: 1rem;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .recent-grid {
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  }
  
  .chart-bars {
    gap: 0.5rem;
  }
}
</style>