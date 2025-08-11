<template>
  <div ref="gallery" class="gallery-community">
    <!-- 背景装饰 -->
    <div class="bg-deco bg-deco-1"></div>
    <div class="bg-deco bg-deco-2"></div>
    
    <!-- 顶部标题区域 -->
    <div class="gallery-header">
      <div class="header-content">
        <h1>
          <i class="fas fa-palette"></i>
          创意画廊
        </h1>
        <p>分享你的绘画灵感，发现更多美好创作</p>
      </div>
      <div class="header-actions">
        <div class="search-bar">
          <i class="fas fa-search"></i>
          <input 
            v-model="searchQuery" 
            type="text" 
            placeholder="搜索作品或作者..."
            class="search-input"
          >
        </div>
        <button @click="openPublishModal" class="create-btn">
          <i class="fas fa-plus"></i>
          发布创意
        </button>
      </div>
    </div>

    <!-- 筛选标签 -->
    <div class="filter-section">
      <div class="filter-tags">
        <button 
          @click="activeFilter = 'all'" 
          :class="['filter-tag', { active: activeFilter === 'all' }]"
        >
          <i class="fas fa-globe"></i>
          全部作品
        </button>
        <button 
          @click="activeFilter = 'trending'" 
          :class="['filter-tag', { active: activeFilter === 'trending' }]"
        >
          <i class="fas fa-fire"></i>
          热门精选
        </button>
        <button 
          @click="activeFilter = 'latest'" 
          :class="['filter-tag', { active: activeFilter === 'latest' }]"
        >
          <i class="fas fa-clock"></i>
          最新发布
        </button>
        <button 
          v-for="emotion in emotionList" 
          :key="emotion.value"
          @click="activeFilter = emotion.value"
          :class="['filter-tag', { active: activeFilter === emotion.value }]"
        >
          <i :class="emotion.icon"></i>
          {{ emotion.label }}
        </button>
      </div>
    </div>

    <!-- 作品网格 -->
    <div class="gallery-grid">
      <div 
        v-for="artwork in filteredArtworks" 
        :key="artwork.id"
        class="artwork-card"
        :class="{ 'featured': artwork.isFeatured }"
      >
        <div class="artwork-preview" @click="viewArtwork(artwork)">
          <canvas 
            :ref="el => setCanvasRef(el, artwork)"
            class="artwork-canvas"
          ></canvas>
          <div class="artwork-overlay">
            <div class="overlay-actions">
              <button class="action-btn like-btn" @click.stop="toggleLike(artwork)">
                <i :class="artwork.isLiked ? 'fas fa-heart' : 'far fa-heart'"></i>
                <span>{{ artwork.likes || 0 }}</span>
              </button>
              <button class="action-btn comment-btn" @click.stop="openComments(artwork)">
                <i class="far fa-comment"></i>
                <span>{{ artwork.comments?.length || 0 }}</span>
              </button>
              <button class="action-btn share-btn" @click.stop="shareArtwork(artwork)">
                <i class="far fa-share-alt"></i>
              </button>
            </div>
          </div>
        </div>
        
        <div class="artwork-content">
          <div class="artwork-header">
            <div class="user-info">
              <div class="user-avatar">
                <i class="fas fa-user"></i>
              </div>
              <div class="user-details">
                <h4 class="artwork-title">{{ artwork.title || '无题作品' }}</h4>
                <span class="username">{{ artwork.author || '匿名画家' }}</span>
              </div>
            </div>
            <div class="artwork-meta">
              <span class="emotion-tag" :class="artwork.emotion">
                <i :class="getEmotionIcon(artwork.emotion)"></i>
                {{ getEmotionLabel(artwork.emotion) }}
              </span>
            </div>
          </div>
          
          <div class="artwork-description">
            <p>{{ artwork.description || '一幅充满情感的艺术作品' }}</p>
          </div>
          
          <div class="artwork-footer">
            <span class="post-time">{{ formatTimeAgo(artwork.createdAt) }}</span>
            <div class="artwork-stats">
              <span><i class="fas fa-eye"></i> {{ artwork.views || 0 }}</span>
              <span><i class="fas fa-heart"></i> {{ artwork.likes || 0 }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="artworks.length === 0" class="empty-state">
      <div class="empty-icon">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor">
          <path d="M9 11H5a2 2 0 00-2 2v7a2 2 0 002 2h4a2 2 0 002-2v-7a2 2 0 00-2-2z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M17 21v-4a2 2 0 00-2-2H5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M15 5a2.121 2.121 0 01-3 0 2.121 2.121 0 00-3 0 2.121 2.121 0 01-3 0 2.121 2.121 0 00-3 0L3 7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
      <h3>还没有作品</h3>
      <p>开始创作你的第一幅情绪画作吧</p>
      <router-link to="/" class="btn btn-primary">开始创作</router-link>
    </div>

    <!-- 作品详情弹窗 -->
    <div v-if="selectedArtwork" class="modal-overlay" @click="closeModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>{{ selectedArtwork.title }}</h2>
          <button @click="closeModal" class="close-btn">&times;</button>
        </div>
        <div class="modal-body">
          <canvas 
            :ref="el => setModalCanvasRef(el, selectedArtwork)"
            class="detail-canvas"
          ></canvas>
          <div class="artwork-details">
            <div class="detail-item">
              <strong>情绪：</strong>
              <span class="emotion-badge" :class="selectedArtwork.emotion">
                {{ getEmotionLabel(selectedArtwork.emotion) }}
              </span>
            </div>
            <div class="detail-item">
              <strong>创建时间：</strong>
              {{ formatDate(selectedArtwork.createdAt, true) }}
            </div>
            <div class="detail-item">
              <strong>路径数量：</strong>
              {{ selectedArtwork.paths.length }}
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="loadArtwork(selectedArtwork)" class="btn btn-primary">
            编辑此作品
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- 发布创意模态框 -->
  <div v-if="showPublishModal" class="modal-overlay" @click="closePublishModal">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h2>发布创意</h2>
        <button class="close-btn" @click="closePublishModal">&times;</button>
      </div>
      
      <div class="modal-body">
        <!-- 模式选择 -->
        <div style="margin-bottom: 2rem;">
          <div style="display: flex; gap: 1rem; margin-bottom: 1rem;">
            <button 
              @click="publishMode = 'upload'"
              :class="['mode-btn', { active: publishMode === 'upload' }]"
              style="flex: 1; padding: 0.75rem; border: 2px solid #D2C2E1; border-radius: 8px; background: transparent; color: #8E44AD; cursor: pointer;"
              :style="publishMode === 'upload' ? 'background: #F3E8FC; color: #8E44AD;' : ''"
            >
              <i class="fas fa-upload"></i> 上传照片
            </button>
            <button 
              @click="publishMode = 'select'"
              :class="['mode-btn', { active: publishMode === 'select' }]"
              style="flex: 1; padding: 0.75rem; border: 2px solid #D2C2E1; border-radius: 8px; background: transparent; color: #8E44AD; cursor: pointer;"
              :style="publishMode === 'select' ? 'background: #F3E8FC; color: #8E44AD;' : ''"
            >
              <i class="fas fa-palette"></i> 我的作品
            </button>
          </div>
        </div>

        <!-- 上传照片模式 -->
        <div v-if="publishMode === 'upload'" style="margin-bottom: 2rem;">
          <input 
            type="file" 
            accept="image/*" 
            @change="handleFileUpload" 
            style="display: none" 
            ref="fileInput"
          >
          <div 
            @click="$refs.fileInput.click()"
            style="border: 2px dashed #D2C2E1; border-radius: 12px; padding: 2rem; text-align: center; cursor: pointer; transition: all 0.3s ease;"
            onmouseover="this.style.background='#F8F6FB'"
            onmouseout="this.style.background='transparent'"
          >
            <i class="fas fa-cloud-upload-alt" style="font-size: 3rem; color: #8E44AD; margin-bottom: 1rem;"></i>
            <p style="color: #8E44AD; margin: 0;">
              {{ selectedFile ? '已选择：' + selectedFile.name : '点击上传照片' }}
            </p>
          </div>
        </div>

        <!-- 选择作品模式 -->
        <div v-if="publishMode === 'select'" style="margin-bottom: 2rem;">
          <div style="max-height: 300px; overflow-y: auto; border: 1px solid #ddd; border-radius: 8px; padding: 1rem;">
            <div v-if="artworks.length === 0" style="text-align: center; color: #95A5A6; padding: 2rem;">
              <i class="fas fa-palette" style="font-size: 2rem; margin-bottom: 1rem;"></i>
              <p>暂无作品，请先创作一些作品</p>
            </div>
            <div 
              v-for="artwork in artworks" 
              :key="artwork.id"
              @click="selectArtworkForPublish(artwork)"
              :class="['artwork-select-item', { selected: selectedWork && selectedWork.id === artwork.id }]"
              style="display: flex; align-items: center; gap: 1rem; padding: 1rem; border-radius: 8px; cursor: pointer; margin-bottom: 0.5rem; border: 1px solid transparent;"
              :style="selectedWork && selectedWork.id === artwork.id ? 'background: #F8F6FB; border: 1px solid #D2C2E1;' : 'background: #F8F6FB;'"
            >
              <canvas 
                :ref="(el) => setCanvasRef(el, artwork)" 
                style="width: 60px; height: 40px; border-radius: 4px;"
              ></canvas>
              <div style="flex: 1;">
                <h4 style="margin: 0; font-size: 0.9rem;">{{ artwork.title || '未命名作品' }}</h4>
                <p style="margin: 0; font-size: 0.8rem; color: #95A5A6;">{{ formatDate(artwork.createdAt) }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- 发布表单 -->
        <div style="margin-bottom: 2rem;">
          <div style="margin-bottom: 1rem;">
            <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #2C3E50;">标题</label>
            <input 
              v-model="publishForm.title" 
              type="text" 
              placeholder="给你的创意起个名字"
              style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"
            >
          </div>
          
          <div style="margin-bottom: 1rem;">
            <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #2C3E50;">描述</label>
            <textarea 
              v-model="publishForm.description" 
              placeholder="分享你的创作灵感..."
              rows="3"
              style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem; resize: vertical;"
            ></textarea>
          </div>
          
          <div style="margin-bottom: 1rem;">
            <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #2C3E50;">情绪</label>
            <select 
              v-model="publishForm.emotion" 
              style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"
            >
              <option v-for="emotion in emotionList" :key="emotion.value" :value="emotion.value">
                {{ emotion.label }}
              </option>
            </select>
          </div>
          
          <div style="margin-bottom: 1rem;">
            <label style="display: block; margin-bottom: 0.5rem; font-weight: 600; color: #2C3E50;">标签</label>
            <input 
              v-model="publishForm.tags" 
              type="text" 
              placeholder="用逗号分隔多个标签"
              style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 8px; font-size: 1rem;"
            >
          </div>
        </div>

        <!-- 预览 -->
        <div v-if="selectedFile || selectedWork" style="margin-bottom: 2rem;">
          <h4 style="margin-bottom: 1rem; color: #2C3E50;">预览</h4>
          <div style="text-align: center;">
            <img 
              v-if="selectedFile" 
              :src="URL.createObjectURL(selectedFile)" 
              style="max-width: 100%; max-height: 200px; border-radius: 8px;"
            >
            <canvas 
              v-if="selectedWork" 
              :ref="(el) => setCanvasRef(el, selectedWork)" 
              style="max-width: 100%; max-height: 200px; border-radius: 8px;"
            ></canvas>
          </div>
        </div>

        <!-- 发布按钮 -->
        <div style="text-align: center;">
          <button 
            @click="publishCreative"
            :disabled="!selectedFile && !selectedWork"
            style="padding: 0.75rem 2rem; background: #8E44AD; color: white; border: none; border-radius: 25px; font-size: 1.1rem; cursor: pointer; transition: all 0.3s ease;"
            :style="(!selectedFile && !selectedWork) ? 'background: #bdc3c7; cursor: not-allowed;' : ''"
          >
            <i class="fas fa-paper-plane"></i> 立即发布
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- 登录模态框 -->
  <div v-if="showLoginModal" class="modal-overlay" @click="closeLoginModal">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h2>账号登录</h2>
        <button class="close-btn" @click="closeLoginModal">&times;</button>
      </div>
      <div class="modal-body">
        <div style="text-align: center; padding: 2rem;">
          <p style="margin-bottom: 1.5rem; color: #666;">请使用账号密码登录</p>
          <router-link 
            to="/login" 
            @click="closeLoginModal"
            class="btn-primary" 
            style="display: inline-block; padding: 0.75rem 2rem; text-decoration: none;"
          >
            前往登录页面
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useCanvasStore } from '../stores/canvas'
import { useAuthStore } from '@/stores/auth'

export default {
  name: 'Gallery',
  setup() {
    const canvasStore = useCanvasStore()
    const authStore = useAuthStore()
    return { canvasStore, authStore }
  },
  data() {
    return {
      activeFilter: 'all',
      searchQuery: '',
      selectedArtwork: null,
      canvasRefs: {},
      showPublishModal: false,
        publishMode: 'upload', // 'upload' 或 'select'
        selectedFile: null,
        selectedWork: null,
        publishForm: {
          title: '',
          description: '',
          emotion: 'happy',
          tags: []
        },
      emotionList: [
        { value: 'happy', label: '快乐', icon: 'fas fa-smile' },
        { value: 'sad', label: '悲伤', icon: 'fas fa-sad-tear' },
        { value: 'angry', label: '愤怒', icon: 'fas fa-angry' },
        { value: 'calm', label: '平静', icon: 'fas fa-leaf' },
        { value: 'excited', label: '兴奋', icon: 'fas fa-star' },
        { value: 'anxious', label: '焦虑', icon: 'fas fa-cloud-rain' }
      ],
      showLoginModal: false,
      showUserMenu: false
    }
  },
  computed: {
    artworks() {
      return this.canvasStore.savedArtworks.map(artwork => ({
        ...artwork,
        likes: artwork.likes || 0,
        views: artwork.views || 0,
        comments: artwork.comments || [],
        isLiked: artwork.isLiked || false,
        isFeatured: artwork.isFeatured || false,
        author: artwork.author || '匿名画家'
      }))
    },
    filteredArtworks() {
      let filtered = this.artworks

      // 搜索过滤
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()
        filtered = filtered.filter(artwork => 
          (artwork.title?.toLowerCase().includes(query) || 
           artwork.description?.toLowerCase().includes(query) ||
           artwork.author?.toLowerCase().includes(query))
        )
      }

      // 情绪过滤
      if (this.activeFilter !== 'all' && this.activeFilter !== 'trending' && this.activeFilter !== 'latest') {
        filtered = filtered.filter(artwork => artwork.emotion === this.activeFilter)
      }

      // 排序
      switch (this.activeFilter) {
        case 'trending':
          return [...filtered].sort((a, b) => (b.likes || 0) - (a.likes || 0))
        case 'latest':
          return [...filtered].sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
        default:
          return [...filtered].sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
      }
    },

    isLoggedIn() {
      return this.authStore.isAuthenticated
    },
    userName() {
      return this.authStore.user?.username || ''
    },
    userAvatar() {
      return this.authStore.user?.avatar || ''
    }
  },
  watch: {
    artworks: {
      handler() {
        this.$nextTick(() => {
          this.renderAllPreviews()
        })
      },
      deep: true
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.renderAllPreviews()
    })
  },
  methods: {
    getEmotionIcon(emotion) {
      const iconMap = {
        happy: 'fas fa-smile',
        sad: 'fas fa-sad-tear',
        angry: 'fas fa-angry',
        calm: 'fas fa-leaf',
        excited: 'fas fa-star',
        anxious: 'fas fa-cloud-rain'
      }
      return iconMap[emotion] || 'fas fa-palette'
    },

    formatTimeAgo(date) {
      const now = new Date()
      const created = new Date(date)
      const diffMs = now - created
      const diffMins = Math.floor(diffMs / 60000)
      const diffHours = Math.floor(diffMs / 3600000)
      const diffDays = Math.floor(diffMs / 86400000)

      if (diffMins < 1) return '刚刚'
      if (diffMins < 60) return `${diffMins}分钟前`
      if (diffHours < 24) return `${diffHours}小时前`
      if (diffDays < 7) return `${diffDays}天前`
      return this.formatDate(date)
    },

    setCanvasRef(el, artwork) {
      if (el && artwork) {
        this.renderPreview(el, artwork)
      }
    },
    
    setModalCanvasRef(el, artwork) {
      if (el && artwork) {
        this.renderPreview(el, artwork, 800, 600)
      }
    },
    
    renderPreview(canvas, artwork, width = 300, height = 200) {
      const ctx = canvas.getContext('2d')
      canvas.width = width
      canvas.height = height
      
      // 背景
      ctx.fillStyle = artwork.backgroundColor || '#ffffff'
      ctx.fillRect(0, 0, width, height)
      
      // 缩放比例
      const scale = Math.min(width / 800, height / 600)
      
      // 绘制路径
      if (artwork.paths) {
        artwork.paths.forEach(path => {
          if (path.points && path.points.length >= 2) {
            ctx.beginPath()
            ctx.strokeStyle = path.color || '#000000'
            ctx.lineWidth = (path.width || 2) * scale
            ctx.lineCap = 'round'
            ctx.lineJoin = 'round'
            
            ctx.moveTo(path.points[0].x * scale, path.points[0].y * scale)
            for (let i = 1; i < path.points.length; i++) {
              ctx.lineTo(path.points[i].x * scale, path.points[i].y * scale)
            }
            ctx.stroke()
          }
        })
      }
    },
    
    toggleLike(artwork) {
      artwork.isLiked = !artwork.isLiked
      artwork.likes = artwork.isLiked ? (artwork.likes || 0) + 1 : Math.max(0, (artwork.likes || 0) - 1)
      this.canvasStore.updateArtwork(artwork)
    },

    openComments(artwork) {
      this.selectedArtwork = artwork
    },

    shareArtwork(artwork) {
      if (!this.authStore.isLoggedIn) {
        window.dispatchEvent(new CustomEvent('open-login-modal'))
        return
      }
      
      const shareData = {
        title: artwork.title || '我的绘画作品',
        text: `我在创意画廊分享了一幅${this.getEmotionLabel(artwork.emotion)}的绘画作品！`,
        url: window.location.href
      }
      
      if (navigator.share) {
        navigator.share(shareData)
      } else {
        navigator.clipboard.writeText(window.location.href)
        alert('链接已复制到剪贴板！')
      }
    },
    
    renderAllPreviews() {
      this.$nextTick(() => {
        // 使用更安全的方式获取DOM元素
        const galleryElement = this.$refs.gallery || this.$el
        if (galleryElement) {
          const canvases = galleryElement.querySelectorAll('.artwork-canvas')
          canvases.forEach((canvas, index) => {
            const artwork = this.filteredArtworks[index]
            if (artwork) {
              this.renderPreview(canvas, artwork)
            }
          })
        }
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
    
    formatDate(timestamp, detailed = false) {
      const date = new Date(timestamp)
      if (detailed) {
        return date.toLocaleString('zh-CN')
      }
      return date.toLocaleDateString('zh-CN')
    },
    
    openPublishModal() {
      if (!this.authStore.isLoggedIn) {
        window.dispatchEvent(new CustomEvent('open-login-modal'))
        return
      }
      this.showPublishModal = true
      this.resetPublishForm()
    },
    
    closePublishModal() {
      this.showPublishModal = false
      this.resetPublishForm()
    },
    
    resetPublishForm() {
      this.publishForm = {
        title: '',
        description: '',
        emotion: 'happy',
        tags: ''
      }
      this.selectedFile = null
      this.selectedWork = null
    },
    
    handleFileUpload(event) {
      const file = event.target.files[0]
      if (file && file.type.startsWith('image/')) {
        this.selectedFile = file
        this.selectedWork = null
      }
    },
    
    selectArtworkForPublish(artwork) {
      this.selectedWork = artwork
      this.selectedFile = null
    },
    
    async publishCreative() {
      if (!this.selectedFile && !this.selectedWork) {
        alert('请选择要发布的图片')
        return
      }
      
      try {
        let artworkData
        
        if (this.selectedFile) {
          // 上传新照片
          const reader = new FileReader()
          artworkData = await new Promise((resolve) => {
            reader.onload = (e) => {
              resolve({
                title: this.publishForm.title || '我的创意作品',
                description: this.publishForm.description,
                emotion: this.publishForm.emotion,
                tags: this.publishForm.tags.split(',').map(tag => tag.trim()).filter(tag => tag),
                imageData: e.target.result,
                createdAt: new Date().toISOString(),
                likes: 0,
                views: 0,
                comments: [],
                isLiked: false,
                author: this.userName || '我'
              })
            }
            reader.readAsDataURL(this.selectedFile)
          })
        } else {
          // 从已有作品中选择
          artworkData = {
            ...this.selectedWork,
            title: this.publishForm.title || this.selectedWork.title,
            description: this.publishForm.description || this.selectedWork.description,
            emotion: this.publishForm.emotion,
            tags: this.publishForm.tags.split(',').map(tag => tag.trim()).filter(tag => tag),
            createdAt: new Date().toISOString(),
            author: this.userName || this.selectedWork.author || '我'
          }
        }
        
        // 保存到画廊
        this.canvasStore.saveArtwork(artworkData)
        this.closePublishModal()
        alert('发布成功！')
        
      } catch (error) {
        console.error('发布失败:', error)
        alert('发布失败，请重试')
      }
    },
    
    openLoginModal() {
      this.showLoginModal = true
    },
    
    closeLoginModal() {
      this.showLoginModal = false
    },
    


    async logout() {
      try {
        await this.authStore.logout()
        this.showUserMenu = false
        alert('已退出登录')
      } catch (error) {
        console.error('退出登录失败:', error)
      }
    },
    
    toggleUserMenu() {
      this.showUserMenu = !this.showUserMenu
    },

    resetLoginForm() {
      this.phone = ''
      this.verificationCode = ''
    },
    
    uploadAvatar() {
      const input = document.createElement('input')
      input.type = 'file'
      input.accept = 'image/*'
      input.onchange = (e) => {
        const file = e.target.files[0]
        if (file) {
          const reader = new FileReader()
          reader.onload = (e) => {
            this.userAvatar = e.target.result
            this.showUserMenu = false
            alert('头像上传成功！')
          }
          reader.readAsDataURL(file)
        }
      }
      input.click()
    },
    
    viewArtwork(artwork) {
      artwork.views = (artwork.views || 0) + 1
      this.canvasStore.updateArtwork(artwork)
      this.selectedArtwork = artwork
    },
    
    closeModal() {
      this.selectedArtwork = null
    },
    
    loadArtwork(artwork) {
      this.canvasStore.loadArtwork(artwork)
      this.$router.push('/')
    },
    
    deleteArtwork(artworkId) {
      if (confirm('确定要删除这个作品吗？')) {
        this.canvasStore.deleteArtwork(artworkId)
      }
    }
  }
}
</script>

<style scoped>
.gallery-community {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8f6fb 0%, #f5f0ff 100%);
  position: relative;
  overflow-x: hidden;
}

/* 背景装饰 */
.bg-deco {
  position: absolute;
  border-radius: 50%;
  filter: blur(40px);
  opacity: 0.3;
  z-index: 1;
}

.bg-deco-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  top: -100px;
  right: -100px;
}

.bg-deco-2 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #D6B3EB, #F3E8FC);
  bottom: -50px;
  left: -50px;
}

/* 顶部标题区域 */
.gallery-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 3rem 2rem 2rem;
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 2;
}

.header-content h1 {
  font-size: 2.5rem;
  font-weight: 700;
  color: #2C3E50;
  margin-bottom: 0.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.header-content h1 i {
  color: #8E44AD;
  font-size: 2rem;
}

.header-content p {
  font-size: 1.2rem;
  color: #59657C;
  font-weight: 400;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.search-bar {
  position: relative;
  display: flex;
  align-items: center;
}

.search-bar i {
  position: absolute;
  left: 1rem;
  color: #95A5A6;
  z-index: 1;
}

.search-input {
  padding: 0.75rem 1rem 0.75rem 2.5rem;
  border: 1px solid rgba(142, 68, 173, 0.2);
  border-radius: 25px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  font-size: 1rem;
  width: 250px;
  transition: all 0.3s ease;
}

.search-input:focus {
  outline: none;
  border-color: #8E44AD;
  box-shadow: 0 0 0 3px rgba(142, 68, 173, 0.1);
  width: 300px;
}

.create-btn {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  color: white;
  border: none;
  border-radius: 25px;
  text-decoration: none;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(142, 68, 173, 0.3);
}

.create-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(142, 68, 173, 0.4);
}

/* 筛选标签 */
.filter-section {
  max-width: 1200px;
  margin: 0 auto 2rem;
  padding: 0 2rem;
  position: relative;
  z-index: 2;
}

.filter-tags {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
  justify-content: center;
}

.filter-tag {
  padding: 0.75rem 1.5rem;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(142, 68, 173, 0.2);
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 500;
  color: #59657C;
  backdrop-filter: blur(10px);
}

.filter-tag:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(142, 68, 173, 0.15);
}

.filter-tag.active {
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  color: white;
  border-color: #8E44AD;
  box-shadow: 0 4px 15px rgba(142, 68, 173, 0.3);
}

/* 作品网格 */
.gallery-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem 3rem;
  position: relative;
  z-index: 2;
}

.artwork-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 18px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(142, 68, 173, 0.08);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.1);
  border: 1px solid rgba(215, 179, 235, 0.15);
  backdrop-filter: blur(10px);
  position: relative;
}

.artwork-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(142, 68, 173, 0.15);
}

.artwork-card.featured {
  border: 2px solid #8E44AD;
  box-shadow: 0 8px 30px rgba(142, 68, 173, 0.2);
}

.artwork-preview {
  position: relative;
  width: 100%;
  height: 240px;
  background: linear-gradient(135deg, #f8f6fb, #f5f0ff);
  overflow: hidden;
}

.artwork-canvas {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 0;
}

.artwork-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.3) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.artwork-preview:hover .artwork-overlay {
  opacity: 1;
}

.overlay-actions {
  display: flex;
  gap: 1rem;
}

.action-btn {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.9);
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.action-btn:hover {
  transform: scale(1.1);
  background: white;
}

.action-btn i {
  font-size: 1.2rem;
  color: #8E44AD;
}

.action-btn span {
  margin-left: 0.5rem;
  font-size: 0.9rem;
  color: #59657C;
}

.artwork-content {
  padding: 1.5rem;
}

.artwork-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1rem;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 1.2rem;
}

.user-details h4 {
  margin: 0 0 0.25rem 0;
  font-size: 1.1rem;
  font-weight: 600;
  color: #2C3E50;
}

.username {
  font-size: 0.9rem;
  color: #59657C;
  font-weight: 500;
}

.artwork-meta {
  display: flex;
  align-items: center;
}

.emotion-tag {
  padding: 0.5rem 0.75rem;
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.emotion-tag.happy { background: #FFE5B4; color: #8B4513; }
.emotion-tag.sad { background: #E6E6FA; color: #4B0082; }
.emotion-tag.angry { background: #FFE4E1; color: #8B0000; }
.emotion-tag.calm { background: #E0F6FF; color: #0066CC; }
.emotion-tag.excited { background: #FFF0F5; color: #FF1493; }
.emotion-tag.anxious { background: #F0F8FF; color: #4169E1; }

.artwork-description {
  margin-bottom: 1rem;
}

.artwork-description p {
  color: #59657C;
  font-size: 0.95rem;
  line-height: 1.5;
  margin: 0;
}

.artwork-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 1rem;
  border-top: 1px solid rgba(210, 194, 225, 0.25);
}

.post-time {
  font-size: 0.85rem;
  color: #95A5A6;
}

.artwork-stats {
  display: flex;
  gap: 1rem;
  font-size: 0.85rem;
  color: #95A5A6;
}

.artwork-stats span {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

/* 弹窗样式更新 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);
  backdrop-filter: blur(5px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 18px;
  max-width: 90%;
  max-height: 90%;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid rgba(210, 194, 225, 0.3);
}

.modal-header h2 {
  margin: 0;
  font-size: 1.5rem;
  color: #2C3E50;
}

.close-btn {
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  color: #95A5A6;
  transition: color 0.3s ease;
}

.close-btn:hover {
  color: #8E44AD;
}

.modal-body {
  padding: 1.5rem;
}

.detail-canvas {
  width: 100%;
  max-width: 800px;
  height: auto;
  border-radius: 10px;
  margin-bottom: 1rem;
}

/* 用户头像样式 */
.user-profile {
  position: relative;
}

.login-btn {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: none;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  color: white;
  font-size: 1.2rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(142, 68, 173, 0.3);
}

.login-btn:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(142, 68, 173, 0.4);
}

.user-avatar-container {
  position: relative;
  cursor: pointer;
}

.avatar-img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #8E44AD;
  transition: all 0.3s ease;
}

.avatar-img:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(142, 68, 173, 0.3);
}

.avatar-placeholder {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 1.2rem;
  border: 2px solid #8E44AD;
  transition: all 0.3s ease;
}

.avatar-placeholder:hover {
  transform: scale(1.1);
  box-shadow: 0 4px 12px rgba(142, 68, 173, 0.3);
}

.user-menu {
  position: absolute;
  top: 50px;
  right: 0;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  padding: 0.5rem 0;
  min-width: 120px;
  z-index: 1000;
}

.user-menu button {
  display: block;
  width: 100%;
  padding: 0.75rem 1rem;
  border: none;
  background: none;
  text-align: left;
  cursor: pointer;
  transition: background 0.2s ease;
  color: #2C3E50;
  font-size: 0.9rem;
}

.user-menu button:hover {
  background: #f8f9fa;
  color: #8E44AD;
}

/* 登录模态框 */
.login-modal {
  text-align: center;
  padding: 2rem;
}

.login-modal h3 {
  margin-bottom: 1.5rem;
  color: #2C3E50;
}

.login-btn-large {
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  color: white;
  border: none;
  border-radius: 25px;
  font-size: 1.1rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.login-btn-large:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(142, 68, 173, 0.3);
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #2C3E50;
  font-weight: 500;
}

.form-input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #D2C2E1;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.form-input:focus {
  outline: none;
  border-color: #8E44AD;
  box-shadow: 0 0 0 3px rgba(142, 68, 173, 0.1);
}

.code-input-group {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.code-input-group .form-input {
  flex: 1;
}

.code-btn {
  padding: 0.75rem 1rem;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
}

.code-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(142, 68, 173, 0.3);
}

.code-btn:disabled {
  background: #D2C2E1;
  cursor: not-allowed;
}

.btn-primary {
  padding: 0.75rem 1.5rem;
  background: linear-gradient(135deg, #8E44AD, #9B59B6);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(142, 68, 173, 0.3);
}

.btn-primary:disabled {
  background: #D2C2E1;
  cursor: not-allowed;
}

.login-tips {
  margin-top: 1.5rem;
  text-align: center;
  color: #59657C;
  font-size: 0.9rem;
}

.login-tips p {
  margin: 0.25rem 0;
}

/* 发布模态框样式 */
.modal-body {
  padding: 2rem;
  max-height: 70vh;
  overflow-y: auto;
}

@media (max-width: 768px) {
  .modal-body {
    padding: 1rem;
  }
  
  .modal-content {
    max-width: 95%;
    max-height: 95%;
  }
  
  .modal-header {
    padding: 1rem;
  }
  
  .modal-header h2 {
    font-size: 1.3rem;
  }
  
  .login-btn,
  .avatar-img,
  .avatar-placeholder {
    width: 36px;
    height: 36px;
    font-size: 1rem;
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .gallery-header {
    flex-direction: column;
    gap: 1.5rem;
    text-align: center;
  }
  
  .header-actions {
    flex-direction: column;
    width: 100%;
  }
  
  .search-input {
    width: 100%;
    max-width: 300px;
  }
  
  .gallery-grid {
    grid-template-columns: 1fr;
    padding: 0 1rem 2rem;
  }
  
  .filter-tags {
    justify-content: flex-start;
    overflow-x: auto;
    padding-bottom: 0.5rem;
  }
  
  .filter-tag {
    white-space: nowrap;
  }
}
</style>