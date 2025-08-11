<template>
  <div class="home">
    <!-- 顶部导航栏 -->
    <header class="app-header">
      <div class="header-left">
        <div class="logo">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M12 2L2 7v10c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-10-5z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          <span>创作画板</span>
        </div>
      </div>
      
      <div class="header-center">
        <div class="quick-actions">
          <button @click="undo" class="action-btn" :disabled="!canUndo" title="撤销">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M3 7v6h6M21 17a9 9 0 00-9-9 9 9 0 00-6 2.3L3 13" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
          <button @click="clearCanvas" class="action-btn" title="清空画布">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
        </div>
      </div>

      <div class="header-right">
        <button @click="exportArtwork" class="export-btn" title="导出作品">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M7 10l5 5 5-5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M12 15V3" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          导出
        </button>
        <button @click="shareArtwork" class="share-btn" title="分享作品">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M4 12v8a2 2 0 002 2h12a2 2 0 002-2v-8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M16 6l-4-4-4 4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M12 2v12" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          分享
        </button>
        <button @click="saveArtwork" class="save-btn" title="保存作品">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor">
            <path d="M19 21H5a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v11a2 2 0 01-2 2z" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M17 21v-8h10v8" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          保存
        </button>
      </div>
    </header>

    <div class="main-layout">
      <!-- 左侧工具面板 - Bento Box 设计 -->
      <aside class="tool-panel" :class="{ collapsed: sidebarCollapsed && isMobile }">
        <!-- 移动端侧边栏切换按钮 -->
        <button 
          v-if="isMobile" 
          class="sidebar-toggle"
          @click="toggleSidebar"
          :title="sidebarCollapsed ? '展开工具栏' : '收起工具栏'"
        >
          {{ sidebarCollapsed ? '▶' : '◀' }}
        </button>
        
        <!-- 工具选择区域 -->
        <div class="bento-card tools-section">
          <h3 class="section-title">工具</h3>
          <div class="tools-grid">
            <div 
              v-for="tool in tools" 
              :key="tool.id"
              :class="['tool-item', { active: currentTool === tool.id }]"
              @click="selectTool(tool.id)"
              :title="tool.name"
            >
              <img v-if="tool.icon.endsWith('.svg')" :src="tool.icon" width="20" height="20" alt="" />
            <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path :d="tool.icon" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- 颜色选择区域 -->
        <div class="bento-card color-section">
          <h3 class="section-title">颜色</h3>
          <div class="color-grid">
            <div 
              v-for="color in colorPresets" 
              :key="color"
              :class="['color-option', { active: currentColor === color }]"
              :style="{ backgroundColor: color }"
              @click="setColor(color)"
            ></div>
          </div>
          <input 
            type="color" 
            v-model="currentColor" 
            class="color-picker"
          />
        </div>

        <!-- 粗细调节区域 -->
        <div class="bento-card size-section">
          <h3 class="section-title">粗细</h3>
          <div class="slider-control">
            <input 
              type="range" 
              v-model="currentWidth" 
              min="1" 
              max="50" 
              class="modern-slider"
            />
            <div class="slider-value">{{ currentWidth }}px</div>
          </div>
        </div>

        <!-- 情绪选择区域 -->
        <div class="bento-card emotion-section">
          <h3 class="section-title">情绪</h3>
          <select v-model="currentEmotion" class="emotion-select">
            <option value="happy">😊 快乐</option>
            <option value="sad">😢 悲伤</option>
            <option value="angry">😠 愤怒</option>
            <option value="calm">😌 平静</option>
            <option value="excited">🤗 兴奋</option>
            <option value="anxious">😰 焦虑</option>
          </select>
        </div>
      </aside>

      <!-- 主画布区域 -->
      <main class="canvas-area">
        <div class="canvas-toolbar">
          <div class="zoom-controls">
            <button @click="zoomOut" class="zoom-btn" title="缩小">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M5 12h14" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
            <span class="zoom-value">{{ Math.round(scale * 100) }}%</span>
            <button @click="zoomIn" class="zoom-btn" title="放大">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M12 5v14m-7-7h14" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
            <button @click="resetZoom" class="zoom-btn" title="重置视图">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M1 4v6h6M23 20v-6h-6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </button>
          </div>
        </div>

        <div class="canvas-container">
          <!-- 图层控制面板 -->
          <div class="layer-control">
            <h3><i class="fas fa-layer-group"></i> 图层</h3>
            <div class="layers-container">
              <div 
                v-for="layer in layers" 
                :key="layer.id"
                class="layer-item"
                :class="{ active: layer.active }"
                @click="selectLayer(layer.id)"
              >
                <span class="layer-name">{{ layer.name }}</span>
                <div class="layer-controls">
                  <input 
                    type="range" 
                    min="0" 
                    max="100" 
                    :value="layer.opacity"
                    @input="updateLayerOpacity(layer.id, $event.target.value)"
                    @click.stop
                    title="透明度"
                  />
                  <button @click.stop="toggleLayerVisibility(layer.id)" title="显示/隐藏">
                    <i :class="layer.visible ? 'fas fa-eye' : 'fas fa-eye-slash'"></i>
                  </button>
                </div>
              </div>
            </div>
            <button class="add-layer-btn" @click="addLayer">
              <i class="fas fa-plus"></i> 添加图层
            </button>
          </div>
          
          <canvas 
            ref="canvas"
            class="drawing-canvas"
            @mousedown="startDrawing"
            @mousemove="draw"
            @mouseup="stopDrawing"
            @mouseleave="stopDrawing"
            @wheel="handleWheel"
            @touchstart="handleTouchStart"
            @touchmove="handleTouchMove"
            @touchend="handleTouchEnd"
          ></canvas>
        </div>
      </main>
    </div>

    <!-- 保存对话框 -->
    <div v-if="showSaveModal" class="modal-overlay" @click="closeSaveModal">
      <div class="modal" @click.stop>
        <h3>保存作品</h3>
        <input 
          v-model="artworkTitle" 
          type="text" 
          placeholder="给作品起个名字..."
          class="modern-input"
          @keyup.enter="confirmSave"
        />
        <div class="modal-actions">
          <button @click="closeSaveModal" class="btn btn-secondary">取消</button>
          <button @click="confirmSave" class="btn btn-primary">保存</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useCanvasStore } from '../stores/canvas'
import { useAuthStore } from '../stores/auth'

export default {
  name: 'Home',
  setup() {
    const canvasStore = useCanvasStore()
    const authStore = useAuthStore()
    return { canvasStore, authStore }
  },
  data() {
    return {
      colorPresets: [
        '#6366f1', '#ec4899', '#10b981', '#f59e0b', 
        '#ef4444', '#8b5cf6', '#06b6d4', '#84cc16',
        '#f97316', '#a855f7', '#14b8a6', '#f43f5e'
      ],
      tools: [
        { id: 'brush', name: '画笔', icon: '/hb.svg' },
        { id: 'pencil', name: '铅笔', icon: '/qb.svg' },
        { id: 'eraser', name: '橡皮擦', icon: '/xpc.svg' },
        { id: 'fill', name: '填充', icon: '/tc.svg' },
        { id: 'line', name: '直线', icon: 'M3 12h18' },
        { id: 'wave', name: '波浪线', icon: 'M3 12c0 0 2-4 6-4s6 4 12 4' },
        { id: 'square', name: '正方形', icon: 'M4 4h16v16H4V4z' },
        { id: 'rectangle', name: '矩形', icon: 'M4 6h16v12H4V6z' },
        { id: 'circle', name: '圆形', icon: 'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z' },
        { id: 'ellipse', name: '椭圆', icon: 'M5 12a7 4.5 0 1014 0 7 4.5 0 10-14 0z' }
      ],
      currentTool: 'brush',
      showSaveModal: false,
      artworkTitle: '',
      canvas: null,
      ctx: null,
      isDrawing: false,
      scale: 1,
      offsetX: 0,
      offsetY: 0,
      isPanning: false,
      lastPanPoint: null,
      startX: 0,
      startY: 0,
      isMobile: false,
      isLandscape: false,
      sidebarCollapsed: false
    }
  },
  computed: {
    currentColor: {
      get() { return this.canvasStore.currentColor },
      set(value) { this.canvasStore.setColor(value) }
    },
    currentWidth: {
      get() { return this.canvasStore.currentWidth },
      set(value) { this.canvasStore.setWidth(parseInt(value)) }
    },
    currentEmotion: {
      get() { return this.canvasStore.currentEmotion },
      set(value) { this.canvasStore.setEmotion(value) }
    },
    canUndo() {
      return this.canvasStore.pathCount > 0
    },
    layers() {
      // 反转图层数组以匹配绘制顺序（新图层在上）
      return [...this.canvasStore.layers].reverse();
    }
  },
  mounted() {
    this.$nextTick(() => {
      try {
        this.setupCanvas()
        this.redrawCanvas()
        
        // 监听store变化重绘画布
        this.$watch(() => this.canvasStore.currentPaths, () => {
          this.redrawCanvas()
        }, { deep: true })
        
        // 监听图层变化重绘画布
        this.$watch(() => this.canvasStore.layers, () => {
          this.redrawCanvas()
        }, { deep: true })
      } catch (error) {
        console.error('Canvas initialization error:', error)
      }
    })
    
    // 检测设备类型和方向
    this.checkDeviceType()
    this.checkOrientation()
    
    // 监听窗口大小变化
    window.addEventListener('resize', this.handleResize)
    window.addEventListener('orientationchange', this.handleOrientationChange)
    
    // 监听媒体查询变化
    this.setupMediaQueryListeners()
    
    // 防止移动端缩放
    this.preventMobileZoom()
  },

  beforeUnmount() {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('orientationchange', this.handleOrientationChange)
    
    if (this.mediaQueryList) {
      this.mediaQueryList.removeEventListener('change', this.handleMediaQueryChange)
    }
  },
  methods: {
    setupCanvas() {
      if (!this.$refs.canvas) {
        console.error('Canvas element not found')
        return
      }
      
      this.canvas = this.$refs.canvas
      this.ctx = this.canvas.getContext('2d')
      
      if (!this.ctx) {
        console.error('Failed to get canvas context')
        return
      }
      
      this.ctx.imageSmoothingEnabled = true
      this.ctx.imageSmoothingQuality = 'high'
      this.resizeCanvas()
      window.addEventListener('resize', this.resizeCanvas)
    },
    
    resizeCanvas() {
      if (!this.canvas || !this.canvas.parentElement || !this.ctx) {
        console.warn('Canvas or context not ready for resize')
        return
      }
      
      try {
        const rect = this.canvas.parentElement.getBoundingClientRect()
        if (rect.width === 0 || rect.height === 0) {
          console.warn('Canvas container has zero dimensions')
          return
        }
        
        this.canvas.width = rect.width * window.devicePixelRatio
        this.canvas.height = rect.height * window.devicePixelRatio
        this.canvas.style.width = rect.width + 'px'
        this.canvas.style.height = rect.height + 'px'
        this.ctx.scale(window.devicePixelRatio, window.devicePixelRatio)
        this.redrawCanvas()
      } catch (error) {
        console.error('Error resizing canvas:', error)
      }
    },
    
    zoomIn() {
      const newScale = Math.min(5, this.scale + 0.1)
      if (newScale !== this.scale) {
        this.scale = newScale
        this.redrawCanvas()
      }
    },
    
    zoomOut() {
      const newScale = Math.max(0.1, this.scale - 0.1)
      if (newScale !== this.scale) {
        this.scale = newScale
        this.redrawCanvas()
      }
    },
    
    handleWheel(e) {
      e.preventDefault()
      const delta = e.deltaY > 0 ? -0.1 : 0.1
      const newScale = Math.max(0.1, Math.min(5, this.scale + delta))
      
      if (newScale !== this.scale) {
        // 以鼠标位置为中心缩放
        const rect = this.canvas.getBoundingClientRect()
        const mouseX = e.clientX - rect.left
        const mouseY = e.clientY - rect.top
        
        this.offsetX = mouseX - (mouseX - this.offsetX) * (newScale / this.scale)
        this.offsetY = mouseY - (mouseY - this.offsetY) * (newScale / this.scale)
        
        this.scale = newScale
        this.redrawCanvas()
      }
    },
    
    resetZoom() {
      this.scale = 1
      this.offsetX = 0
      this.offsetY = 0
      this.redrawCanvas()
    },
    
    getMousePos(e) {
      const rect = this.canvas.getBoundingClientRect()
      return {
        x: (e.clientX - rect.left - this.offsetX) / this.scale,
        y: (e.clientY - rect.top - this.offsetY) / this.scale
      }
    },
    
    getTouchPos(e) {
      const rect = this.canvas.getBoundingClientRect()
      const x = (e.touches[0].clientX - rect.left - this.offsetX) / this.scale
      const y = (e.touches[0].clientY - rect.top - this.offsetY) / this.scale
      return { x, y }
    },
    
    startDrawing(e) {
      this.isDrawing = true
      const pos = this.getMousePos(e)
      this.startX = pos.x
      this.startY = pos.y

      // 如果当前工具是填充，立即执行填充
        if (this.currentTool === 'fill') {
          this.fillArea(e)
          this.isDrawing = false
          return
        }
      
      // 如果当前工具是画笔类，开始绘制路径
      if (this.currentTool === 'brush' || this.currentTool === 'pencil' || this.currentTool === 'eraser') {
        this.canvasStore.startPath()
        this.canvasStore.addPoint({
          x: pos.x,
          y: pos.y,
          pressure: 1,
          timestamp: Date.now()
        })
        this.redrawCanvas()
      }
    },
    
    draw(e) {
      if (!this.isDrawing) return
      
      const pos = this.getMousePos(e)
      
      if (this.currentTool === 'brush' || this.currentTool === 'pencil' || this.currentTool === 'eraser') {
        this.canvasStore.addPoint({
          x: pos.x,
          y: pos.y,
          pressure: 1,
          timestamp: Date.now()
        })
        this.redrawCanvas()
      } else {
        // 实时预览形状
        this.redrawCanvas()
        if (this.currentTool === 'line' || this.currentTool === 'rectangle' || this.currentTool === 'square' || 
            this.currentTool === 'circle' || this.currentTool === 'ellipse' || this.currentTool === 'wave') {
          this.drawShapePreview(pos.x, pos.y)
        }
      }
    },
    
    handleTouch(e) {
      e.preventDefault()
      const touch = e.touches[0]
      
      if (e.type === 'touchstart') {
        this.startDrawing({
          clientX: touch.clientX,
          clientY: touch.clientY
        })
      } else if (e.type === 'touchmove' && this.isDrawing) {
        this.draw({
          clientX: touch.clientX,
          clientY: touch.clientY
        })
      } else if (e.type === 'touchend' || e.type === 'touchcancel') {
        this.stopDrawing()
      }
    },
    
    stopDrawing() {
      if (!this.isDrawing) return
      
      const event = window.event || {}
      const rect = this.canvas.getBoundingClientRect()
      const x = (event.clientX - rect.left - this.offsetX) / this.scale
      const y = (event.clientY - rect.top - this.offsetY) / this.scale
      
      this.isDrawing = false
      
      switch (this.currentTool) {
        case 'brush':
        case 'pencil':
        case 'eraser':
          this.canvasStore.endPath()
          break
        case 'fill':
          this.fillArea(x, y)
          break
        case 'line':
          this.drawLine(this.startX, this.startY, x, y)
          break
        case 'rectangle':
          this.drawRectangle(this.startX, this.startY, x, y)
          break
        case 'square':
          this.drawSquare(this.startX, this.startY, x, y)
          break
        case 'circle':
          this.drawCircle(this.startX, this.startY, x, y)
          break
        case 'ellipse':
          this.drawEllipse(this.startX, this.startY, x, y)
          break
        case 'wave':
          this.drawWave(this.startX, this.startY, x, y)
          break
      }
    },
    
    drawShapePreview(x, y) {
      this.ctx.save()
      this.ctx.translate(this.offsetX, this.offsetY)
      this.ctx.scale(this.scale, this.scale)
      this.ctx.globalAlpha = 0.5
      this.ctx.strokeStyle = this.currentColor
      this.ctx.lineWidth = this.currentWidth
      this.ctx.setLineDash([5, 5])
      
      switch (this.currentTool) {
        case 'line':
          this.ctx.beginPath()
          this.ctx.moveTo(this.startX, this.startY)
          this.ctx.lineTo(x, y)
          this.ctx.stroke()
          break
        case 'rectangle':
          this.ctx.beginPath()
          this.ctx.rect(this.startX, this.startY, x - this.startX, y - this.startY)
          this.ctx.stroke()
          break
        case 'square':
          const size = Math.min(Math.abs(x - this.startX), Math.abs(y - this.startY))
          const signX = x > this.startX ? 1 : -1
          const signY = y > this.startY ? 1 : -1
          this.ctx.beginPath()
          this.ctx.rect(this.startX, this.startY, size * signX, size * signY)
          this.ctx.stroke()
          break
        case 'circle':
          const radius = Math.sqrt(Math.pow(x - this.startX, 2) + Math.pow(y - this.startY, 2))
          this.ctx.beginPath()
          this.ctx.arc(this.startX, this.startY, radius, 0, 2 * Math.PI)
          this.ctx.stroke()
          break
        case 'ellipse':
          const radiusX = Math.abs(x - this.startX)
          const radiusY = Math.abs(y - this.startY)
          this.ctx.beginPath()
          this.ctx.ellipse(this.startX, this.startY, radiusX, radiusY, 0, 0, 2 * Math.PI)
          this.ctx.stroke()
          break
        case 'wave':
          this.drawWaveShape(this.startX, this.startY, x, y, false)
          break
      }
      
      this.ctx.restore()
    },
    
    drawLine(x1, y1, x2, y2) {
      this.canvasStore.startPath()
      this.canvasStore.addPoint({ x: x1, y: y1, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x2, y: y2, pressure: 1, timestamp: Date.now() })
      this.canvasStore.endPath()
    },
    
    drawRectangle(x1, y1, x2, y2) {
      this.canvasStore.startPath()
      this.canvasStore.addPoint({ x: x1, y: y1, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x2, y: y1, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x2, y: y2, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x1, y: y2, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x1, y: y1, pressure: 1, timestamp: Date.now() })
      this.canvasStore.endPath()
    },
    
    drawSquare(x1, y1, x2, y2) {
      const size = Math.min(Math.abs(x2 - x1), Math.abs(y2 - y1))
      const signX = x2 > x1 ? 1 : -1
      const signY = y2 > y1 ? 1 : -1
      
      this.canvasStore.startPath()
      this.canvasStore.addPoint({ x: x1, y: y1, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x1 + size * signX, y: y1, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x1 + size * signX, y: y1 + size * signY, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x1, y: y1 + size * signY, pressure: 1, timestamp: Date.now() })
      this.canvasStore.addPoint({ x: x1, y: y1, pressure: 1, timestamp: Date.now() })
      this.canvasStore.endPath()
    },
    
    drawCircle(x, y, endX, endY) {
      const radius = Math.sqrt(Math.pow(endX - x, 2) + Math.pow(endY - y, 2))
      const steps = 32
      
      this.canvasStore.startPath()
      for (let i = 0; i <= steps; i++) {
        const angle = (i / steps) * 2 * Math.PI
        const px = x + radius * Math.cos(angle)
        const py = y + radius * Math.sin(angle)
        this.canvasStore.addPoint({ x: px, y: py, pressure: 1, timestamp: Date.now() })
      }
      this.canvasStore.endPath()
    },
    
    drawEllipse(x, y, endX, endY) {
      const radiusX = Math.abs(endX - x)
      const radiusY = Math.abs(endY - y)
      const steps = 32
      
      this.canvasStore.startPath()
      for (let i = 0; i <= steps; i++) {
        const angle = (i / steps) * 2 * Math.PI
        const px = x + radiusX * Math.cos(angle)
        const py = y + radiusY * Math.sin(angle)
        this.canvasStore.addPoint({ x: px, y: py, pressure: 1, timestamp: Date.now() })
      }
      this.canvasStore.endPath()
    },
    
    drawWave(x, y, endX, endY) {
      this.drawWaveShape(x, y, endX, endY, true)
    },
    
    drawWaveShape(x1, y1, x2, y2, save = true) {
      const width = Math.abs(x2 - x1)
      const height = Math.abs(y2 - y1)
      const amplitude = height / 2
      const frequency = 3
      const steps = 50
      
      if (save) {
        this.canvasStore.startPath()
      } else {
        this.ctx.beginPath()
        this.ctx.strokeStyle = this.currentColor
        this.ctx.lineWidth = this.currentWidth
        this.ctx.lineCap = 'round'
        this.ctx.lineJoin = 'round'
      }
      
      for (let i = 0; i <= steps; i++) {
        const t = i / steps
        const px = x1 + (x2 - x1) * t
        const py = y1 + amplitude + amplitude * Math.sin(t * frequency * 2 * Math.PI)
        
        if (save) {
          this.canvasStore.addPoint({ x: px, y: py, pressure: 1, timestamp: Date.now() })
        } else {
          if (i === 0) {
            this.ctx.moveTo(px, py)
          } else {
            this.ctx.lineTo(px, py)
          }
        }
      }
      
      if (save) {
        this.canvasStore.endPath()
      } else {
        this.ctx.stroke()
      }
    },
    
    fillArea(x, y) {
      // 获取点击坐标
      const { clickX, clickY } = this.getClickCoordinates(x, y);
      console.log(`🎯 开始填充，点击坐标: (${clickX.toFixed(2)}, ${clickY.toFixed(2)})`);

      // 使用路径级填充算法
      const fillPath = this.createFillPath(clickX, clickY);
      
      if (fillPath) {
        // 立即绘制填充区域
        this.ctx.save();
        this.ctx.fillStyle = this.canvasStore.currentColor;
        this.ctx.fill(fillPath);
        this.ctx.restore();
        
        // 将填充路径保存到store
        this.canvasStore.addFilledArea(clickX, clickY, this.canvasStore.currentColor, fillPath);
        console.log(`🎉 填充完成！颜色: ${this.canvasStore.currentColor}`);
      } else {
        console.log('⚠️ 没有找到可填充区域');
      }
    },
    
    createFillPath(startX, startY) {
      // 真正的轮廓检测填充算法
      const ctx = this.ctx;
      const canvas = this.canvas;
      
      // 获取画布实际尺寸
      const dpr = window.devicePixelRatio || 1;
      
      // 将点击坐标转换为实际像素坐标
      const actualX = Math.round(startX * dpr);
      const actualY = Math.round(startY * dpr);
      
      // 获取当前画布状态
      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
      const data = imageData.data;
      const width = canvas.width;
      const height = canvas.height;
      
      // 确保坐标在画布范围内
      const safeX = Math.max(0, Math.min(width - 1, actualX));
      const safeY = Math.max(0, Math.min(height - 1, actualY));
      
      const startPos = (safeY * width + safeX) * 4;
      
      // 获取起始位置的颜色（背景色）
      const targetR = data[startPos];
      const targetG = data[startPos + 1];
      const targetB = data[startPos + 2];
      
      // 定义容差范围
      const tolerance = 10;
      const isBackgroundColor = (r, g, b, a) => {
        if (a === 0) return true;
        const dr = Math.abs(r - targetR);
        const dg = Math.abs(g - targetG);
        const db = Math.abs(b - targetB);
        return dr <= tolerance && dg <= tolerance && db <= tolerance;
      };
      
      // 洪水填充算法找到所有可填充的像素
      const filledPixels = new Set();
      const stack = [[safeX, safeY]];
      const visited = new Uint8Array(width * height);
      
      while (stack.length > 0) {
        const [x, y] = stack.pop();
        const index = y * width + x;
        
        if (visited[index]) continue;
        visited[index] = 1;
        
        const pos = index * 4;
        const r = data[pos];
        const g = data[pos + 1];
        const b = data[pos + 2];
        const a = data[pos + 3];
        
        if (!isBackgroundColor(r, g, b, a)) continue;
        
        filledPixels.add(`${x},${y}`);
        
        // 检查4个方向
        const directions = [[0, 1], [1, 0], [0, -1], [-1, 0]];
        for (const [dx, dy] of directions) {
          const nx = x + dx;
          const ny = y + dy;
          
          if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
            const newIndex = ny * width + nx;
            if (!visited[newIndex]) {
              stack.push([nx, ny]);
            }
          }
        }
      }
      
      if (filledPixels.size === 0) return null;
      
      // 扫描线算法创建填充路径
      const path = new Path2D();
      const rows = new Map();
      
      // 按行组织像素
      for (const pixel of filledPixels) {
        const [x, y] = pixel.split(',').map(Number);
        if (!rows.has(y)) rows.set(y, []);
        rows.get(y).push(x);
      }
      
      // 为每一行创建水平线段
      for (const [y, xCoords] of rows) {
        const sortedX = xCoords.sort((a, b) => a - b);
        let startX = sortedX[0];
        
        for (let i = 1; i < sortedX.length; i++) {
          if (sortedX[i] - sortedX[i-1] > 1) {
            // 遇到间隔，创建线段
            path.rect(startX / dpr, y / dpr, (sortedX[i-1] - startX + 1) / dpr, 1 / dpr);
            startX = sortedX[i];
          }
        }
        
        // 创建最后一段
        path.rect(startX / dpr, y / dpr, (sortedX[sortedX.length-1] - startX + 1) / dpr, 1 / dpr);
      }
      
      return path;
    },
    
    getClickCoordinates(x, y) {
      // 处理事件对象或坐标参数
      if (typeof x === 'object' && x.clientX !== undefined) {
        const e = x;
        const rect = this.canvas.getBoundingClientRect();
        return {
          clickX: (e.clientX - rect.left - this.offsetX) / this.scale,
          clickY: (e.clientY - rect.top - this.offsetY) / this.scale
        };
      } else {
        const rect = this.canvas.getBoundingClientRect();
        return {
          clickX: (x - rect.left - this.offsetX) / this.scale,
          clickY: (y - rect.top - this.offsetY) / this.scale
        };
      }
    },
    

    
    redrawCanvas() {
      if (!this.ctx) return
      
      const rect = this.canvas.getBoundingClientRect()
      this.ctx.clearRect(0, 0, rect.width, rect.height)
      
      // 绘制背景
      this.ctx.fillStyle = this.canvasStore.backgroundColor
      this.ctx.fillRect(0, 0, rect.width, rect.height)
      
      this.ctx.save()
      this.ctx.translate(this.offsetX, this.offsetY)
      this.ctx.scale(this.scale, this.scale)
      
      // 重新应用所有填充区域（先绘制，作为底层）
      this.canvasStore.reapplyFilledAreas(this.ctx, this.canvas)
      
      // 按照图层顺序绘制所有可见图层的路径（反转顺序，使新图层显示在旧图层之上）
      this.canvasStore.layers
        .filter(layer => layer.visible)
        .slice() // 创建副本
        .reverse() // 反转顺序
        .forEach(layer => {
          // 设置图层透明度
          this.ctx.globalAlpha = layer.opacity / 100;
          
          // 绘制该图层的所有路径
          layer.paths.forEach((path, index) => {
            if (path.points.length < 2) return
            
            // 检查是否有填充颜色
            if (path.hasFill && path.points.length >= 3) {
              // 先填充封闭区域
              this.ctx.beginPath()
              this.ctx.moveTo(path.points[0].x, path.points[0].y)
              for (let i = 1; i < path.points.length; i++) {
                this.ctx.lineTo(path.points[i].x, path.points[i].y)
              }
              // 确保路径闭合
              this.ctx.closePath()
              this.ctx.fillStyle = path.fillColor || path.color
              this.ctx.fill()
              console.log(`🎨 填充路径 ${index}，颜色: ${path.fillColor || path.color}，透明度: ${this.ctx.globalAlpha}`)
            } else {
              console.log(`🔍 路径 ${index} 未设置填充: hasFill=${path.hasFill}`)
            }
            
            // 绘制线条轮廓
            this.ctx.beginPath()
            
            if (path.tool === 'eraser') {
              this.ctx.globalCompositeOperation = 'destination-out'
              this.ctx.strokeStyle = 'rgba(0,0,0,1)'
              this.ctx.lineWidth = path.width * 2
              this.ctx.lineCap = 'round'
              this.ctx.lineJoin = 'round'
            } else {
              this.ctx.globalCompositeOperation = 'source-over'
              this.ctx.strokeStyle = path.color
              this.ctx.lineWidth = path.width
              this.ctx.lineCap = 'round'
              this.ctx.lineJoin = 'round'
            }
            
            this.ctx.moveTo(path.points[0].x, path.points[0].y)
            for (let i = 1; i < path.points.length; i++) {
              this.ctx.lineTo(path.points[i].x, path.points[i].y)
            }
            
            // 只有需要填充时才闭合路径，保持原始线条不变
            if (path.hasFill && path.points.length >= 3) {
              this.ctx.closePath()
            }
            
            this.ctx.stroke()
          });
          
          // 如果是活动图层且正在绘制，绘制当前预览路径
          if (layer.active && this.canvasStore.isDrawing) {
            this.drawCurrentPathForLayer(layer);
          }
        });
      
      // 重置全局透明度
      this.ctx.globalAlpha = 1.0;
      this.ctx.restore()
    },
    
    drawCurrentPathForLayer(layer) {
      // 为特定图层绘制当前预览路径
      if (this.canvasStore.isDrawing && this.canvasStore.currentPath.length > 1) {
        this.ctx.beginPath()
        
        if (this.currentTool === 'eraser') {
          this.ctx.globalCompositeOperation = 'destination-out'
          this.ctx.strokeStyle = 'rgba(0,0,0,1)'
          this.ctx.lineWidth = this.canvasStore.currentWidth * 2
          this.ctx.lineCap = 'round'
          this.ctx.lineJoin = 'round'
        } else if (this.currentTool === 'pencil') {
          this.ctx.globalCompositeOperation = 'source-over'
          this.ctx.strokeStyle = this.canvasStore.currentColor
          this.ctx.lineWidth = this.canvasStore.currentWidth * 0.8
          this.ctx.lineCap = 'butt'
          this.ctx.lineJoin = 'miter'
          this.ctx.shadowBlur = 0
        } else {
          // 画笔
          this.ctx.globalCompositeOperation = 'source-over'
          this.ctx.strokeStyle = this.canvasStore.currentColor
          this.ctx.lineWidth = this.canvasStore.currentWidth
          this.ctx.lineCap = 'round'
          this.ctx.lineJoin = 'round'
          this.ctx.shadowBlur = this.canvasStore.currentWidth * 0.5
          this.ctx.shadowColor = this.canvasStore.currentColor
        }
        
        this.ctx.moveTo(this.canvasStore.currentPath[0].x, this.canvasStore.currentPath[0].y)
        for (let i = 1; i < this.canvasStore.currentPath.length; i++) {
          this.ctx.lineTo(this.canvasStore.currentPath[i].x, this.canvasStore.currentPath[i].y)
        }
        this.ctx.stroke()
      }
    },
    
    // 测试填充功能的方法
    testFillFeature() {
      console.log('🧪 开始测试填充功能...')
      
      // 开始新的路径
      this.canvasStore.startPath()
      
      // 添加点到路径
      const points = [
        { x: 150, y: 150, pressure: 1, timestamp: Date.now() },
        { x: 250, y: 150, pressure: 1, timestamp: Date.now() },
        { x: 250, y: 250, pressure: 1, timestamp: Date.now() },
        { x: 150, y: 250, pressure: 1, timestamp: Date.now() }
      ]
      
      points.forEach(point => {
        this.canvasStore.addPoint(point)
      })
      
      // 结束路径
      this.canvasStore.endPath()
      console.log('✅ 已创建测试矩形')
      
      // 延迟执行填充测试，给用户时间观察
      setTimeout(() => {
        console.log('🎯 准备填充测试矩形...')
        this.fillArea(200, 200)
      }, 1000)
    },
    
    getScaledMousePos(e) {
      const rect = this.canvas.getBoundingClientRect()
      return {
        x: (e.clientX - rect.left - this.offsetX) / this.scale,
        y: (e.clientY - rect.top - this.offsetY) / this.scale
      }
    },
    
    undo() {
      this.canvasStore.undo()
    },
    
    clearCanvas() {
      this.canvasStore.clearCanvas()
    },
    
    saveArtwork() {
      if (!this.authStore.isLoggedIn) {
        window.dispatchEvent(new CustomEvent('open-login-modal'))
        return
      }
      this.showSaveModal = true
    },
    
    closeSaveModal() {
      this.showSaveModal = false
      this.artworkTitle = ''
    },
    
    confirmSave() {
      if (!this.authStore.isLoggedIn) {
        window.dispatchEvent(new CustomEvent('open-login-modal'))
        return
      }
      
      if (!this.artworkTitle.trim()) {
        this.artworkTitle = '未命名作品'
      }
      
      this.canvasStore.saveArtwork(this.artworkTitle)
      this.closeSaveModal()
    },
    
    exportArtwork() {
      if (!this.authStore.isLoggedIn) {
        window.dispatchEvent(new CustomEvent('open-login-modal'))
        return
      }
      
      if (!this.canvas) {
        console.error('Canvas not found')
        return
      }
      
      try {
        // 创建临时canvas来合并所有图层
        const tempCanvas = document.createElement('canvas')
        const tempCtx = tempCanvas.getContext('2d')
        
        // 设置临时canvas尺寸
        const rect = this.canvas.getBoundingClientRect()
        tempCanvas.width = rect.width * window.devicePixelRatio
        tempCanvas.height = rect.height * window.devicePixelRatio
        
        // 绘制白色背景
        tempCtx.fillStyle = '#ffffff'
        tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height)
        
        // 绘制所有图层
        this.canvasStore.layers.forEach(layer => {
          if (layer.visible) {
            tempCtx.globalAlpha = layer.opacity / 100
            layer.paths.forEach(path => {
              if (path.points.length > 1) {
                tempCtx.beginPath()
                tempCtx.strokeStyle = path.color
                tempCtx.lineWidth = path.width
                tempCtx.lineCap = 'round'
                tempCtx.lineJoin = 'round'
                
                tempCtx.moveTo(path.points[0].x * window.devicePixelRatio, path.points[0].y * window.devicePixelRatio)
                for (let i = 1; i < path.points.length; i++) {
                  tempCtx.lineTo(path.points[i].x * window.devicePixelRatio, path.points[i].y * window.devicePixelRatio)
                }
                tempCtx.stroke()
              }
            })
          }
        })
        
        // 创建下载链接
        const link = document.createElement('a')
        link.download = `emotion-canvas-${Date.now()}.png`
        link.href = tempCanvas.toDataURL('image/png')
        link.click()
        
        console.log('作品导出成功')
      } catch (error) {
        console.error('导出失败:', error)
        alert('导出失败，请重试')
      }
    },
    
    shareArtwork() {
      if (!this.authStore.isLoggedIn) {
        window.dispatchEvent(new CustomEvent('open-login-modal'))
        return
      }
      
      if (!this.canvas) {
        console.error('Canvas not found')
        return
      }
      
      try {
        if (navigator.share && navigator.canShare) {
          // 使用Web Share API
          this.canvas.toBlob(async (blob) => {
            if (blob && navigator.canShare({ files: [new File([blob], 'emotion-canvas.png', { type: 'image/png' })] })) {
              try {
                await navigator.share({
                  title: '我的情绪画作',
                  text: '用情绪画板创作的画作',
                  files: [new File([blob], 'emotion-canvas.png', { type: 'image/png' })]
                })
              } catch (error) {
                console.error('分享失败:', error)
                this.shareFallback()
              }
            } else {
              this.shareFallback()
            }
          })
        } else {
          // 降级方案
          this.shareFallback()
        }
      } catch (error) {
        console.error('分享失败:', error)
        this.shareFallback()
      }
    },
    
    shareFallback() {
      // 降级分享方案：复制图片到剪贴板或下载
      try {
        this.canvas.toBlob(async (blob) => {
          if (blob && navigator.clipboard && navigator.clipboard.write) {
            try {
              await navigator.clipboard.write([
                new ClipboardItem({ 'image/png': blob })
              ])
              alert('图片已复制到剪贴板，可以粘贴分享给好友')
            } catch (error) {
              console.error('复制失败:', error)
              this.exportArtwork() // 降级为下载
            }
          } else {
            this.exportArtwork() // 降级为下载
          }
        })
      } catch (error) {
        console.error('分享失败:', error)
        this.exportArtwork() // 降级为下载
      }
    },
    
    setColor(color) {
      this.canvasStore.setColor(color)
    },

    selectTool(toolId) {
      this.currentTool = toolId
    },

    // 响应式方法
    checkDeviceType() {
      this.isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ||
                     window.innerWidth <= 768
    },

    checkOrientation() {
      this.isLandscape = window.innerWidth > window.innerHeight
    },

    handleOrientationChange() {
      setTimeout(() => {
        this.checkOrientation()
        this.handleResize()
      }, 100)
    },

    setupMediaQueryListeners() {
      this.mediaQueryList = window.matchMedia('(max-width: 768px)')
      this.mediaQueryList.addEventListener('change', this.handleMediaQueryChange)
    },

    handleMediaQueryChange(e) {
      this.isMobile = e.matches
      this.handleResize()
    },

    preventMobileZoom() {
      // 防止双击缩放
      let lastTouchEnd = 0
      document.addEventListener('touchend', (event) => {
        const now = (new Date()).getTime()
        if (now - lastTouchEnd <= 300) {
          event.preventDefault()
        }
        lastTouchEnd = now
      }, false)

      // 防止手势缩放
      document.addEventListener('gesturestart', (e) => e.preventDefault())
      document.addEventListener('gesturechange', (e) => e.preventDefault())
      document.addEventListener('gestureend', (e) => e.preventDefault())
    },

    toggleSidebar() {
      this.sidebarCollapsed = !this.sidebarCollapsed
    },

    // 移动端优化的触摸事件
    handleTouchStart(e) {
      if (e.touches.length === 1) {
        const touch = e.touches[0]
        const rect = this.canvas.getBoundingClientRect()
        const x = (touch.clientX - rect.left - this.offsetX) / this.scale
        const y = (touch.clientY - rect.top - this.offsetY) / this.scale
        
        this.startDrawing({ clientX: touch.clientX, clientY: touch.clientY })
      }
    },

    handleTouchMove(e) {
      if (e.touches.length === 1) {
        e.preventDefault()
        const touch = e.touches[0]
        this.draw({ clientX: touch.clientX, clientY: touch.clientY })
      }
    },

    handleTouchEnd(e) {
      this.stopDrawing()
    },
    
    // 图层控制方法
    addLayer() {
      this.canvasStore.addLayer();
    },
    
    selectLayer(layerId) {
      this.canvasStore.setActiveLayer(layerId);
    },
    
    updateLayerOpacity(layerId, opacity) {
      this.canvasStore.updateLayerOpacity(layerId, opacity);
    },
    
    toggleLayerVisibility(layerId) {
      this.canvasStore.toggleLayerVisibility(layerId);
    }
  }
}
</script>

<style scoped>
.home {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f8fafc;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
}

.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 24px;
  background: white;
  border-bottom: 1px solid #e2e8f0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.header-left .logo {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  font-size: 16px;
  color: #1e293b;
}

.header-center .quick-actions {
  display: flex;
  gap: 8px;
}

.header-right {
  display: flex;
  gap: 8px;
}

.header-right .export-btn,
.header-right .share-btn,
.header-right .save-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.header-right .export-btn {
  background: #10b981;
  color: white;
}

.header-right .export-btn:hover {
  background: #059669;
  transform: translateY(-1px);
}

.header-right .share-btn {
  background: #8b5cf6;
  color: white;
}

.header-right .share-btn:hover {
  background: #7c3aed;
  transform: translateY(-1px);
}

.header-right .save-btn {
  background: #3b82f6;
  color: white;
}

.header-right .save-btn:hover {
  background: #2563eb;
  transform: translateY(-1px);
}

.action-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn:hover:not(:disabled) {
  background: #f1f5f9;
  border-color: #cbd5e1;
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.main-layout {
  display: flex;
  flex: 1;
  overflow: hidden;
}

.tool-panel {
  width: 280px;
  padding: 20px;
  background: white;
  border-right: 1px solid #e2e8f0;
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.bento-card {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.section-title {
  font-size: 14px;
  font-weight: 600;
  color: #374151;
  margin-bottom: 12px;
}

.tools-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}

.tool-item {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  color: #6b7280;
  cursor: pointer;
  transition: all 0.2s;
}

.tool-item:hover {
  background: #f3f4f6;
  border-color: #d1d5db;
}

.tool-item.active {
  background: #3b82f6;
  border-color: #3b82f6;
  color: white;
}

.color-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  margin-bottom: 12px;
}

.color-option {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  cursor: pointer;
  border: 2px solid transparent;
  transition: all 0.2s;
}

.color-option:hover {
  transform: scale(1.1);
}

.color-option.active {
  border-color: #3b82f6;
  transform: scale(1.1);
}

.color-picker {
  width: 100%;
  height: 40px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  cursor: pointer;
}

.slider-control {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.modern-slider {
  -webkit-appearance: none;
  appearance: none;
  height: 4px;
  background: #e5e7eb;
  border-radius: 2px;
  outline: none;
}

.modern-slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 20px;
  height: 20px;
  background: #3b82f6;
  border-radius: 50%;
  cursor: pointer;
}

.slider-value {
  text-align: center;
  font-size: 12px;
  color: #6b7280;
  font-weight: 500;
}

.emotion-select {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  background: white;
  font-size: 14px;
  cursor: pointer;
}

.canvas-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.canvas-toolbar {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px;
  background: white;
  border-bottom: 1px solid #e2e8f0;
}

.zoom-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}

.zoom-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s;
}

.zoom-btn:hover {
  background: #f1f5f9;
  border-color: #cbd5e1;
}

.zoom-value {
  font-size: 14px;
  font-weight: 500;
  color: #374151;
  min-width: 50px;
  text-align: center;
}

.canvas-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f8fafc;
  padding: 20px;
}

.drawing-canvas {
  background: white;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  cursor: crosshair;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal {
  background: white;
  padding: 24px;
  border-radius: 12px;
  box-shadow: 0 20px 25px rgba(0, 0, 0, 0.15);
  min-width: 320px;
}

.modal h3 {
  margin: 0 0 16px 0;
  font-size: 18px;
  font-weight: 600;
  color: #1f2937;
}

.modern-input {
  width: 100%;
  padding: 12px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  font-size: 14px;
  margin-bottom: 16px;
}

.modal-actions {
    display: flex;
    gap: 12px;
    justify-content: flex-end;
  }

  .btn {
    padding: 8px 16px;
    border: 1px solid #d1d5db;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
  }

  .btn-secondary {
    background: white;
    color: #374151;
  }

  .btn-secondary:hover {
    background: #f9fafb;
  }

  .btn-primary {
    background: #3b82f6;
    color: white;
    border-color: #3b82f6;
  }

  .btn-primary:hover {
    background: #2563eb;
  }

  /* 图层控制面板样式 */
  .layer-control {
    position: absolute;
    top: 210px;
    right: 15px;
    background: rgba(255, 255, 255, 0.95);
    padding: 12px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    z-index: 20;
    width: 220px;
    max-height: 300px;
    overflow: hidden;
    backdrop-filter: blur(10px);
  }

  .layer-control h3 {
    margin: 0 0 8px 0;
    font-size: 14px;
    font-weight: 600;
    color: #374151;
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .layer-control h3 i {
    color: #6b7280;
  }

  .layers-container {
    max-height: 180px;
    overflow-y: auto;
    margin-top: 8px;
    border: 1px solid #e5e7eb;
    border-radius: 5px;
    background: #f9fafb;
  }

  .layer-item {
    display: flex;
    align-items: center;
    padding: 8px;
    border-bottom: 1px solid #e5e7eb;
    cursor: pointer;
    font-size: 13px;
    transition: all 0.2s;
  }

  .layer-item:last-child {
    border-bottom: none;
  }

  .layer-item:hover {
    background: #f3f4f6;
  }

  .layer-item.active {
    background: #e0e7ff;
    border-left: 3px solid #3b82f6;
  }

  .layer-name {
    flex: 1;
    padding: 0 6px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    font-weight: 500;
    color: #374151;
  }

  .layer-controls {
    display: flex;
    align-items: center;
    gap: 6px;
  }

  .layer-controls input[type="range"] {
    width: 60px;
    height: 3px;
    background: #e5e7eb;
    border-radius: 2px;
    outline: none;
    -webkit-appearance: none;
  }

  .layer-controls input[type="range"]::-webkit-slider-thumb {
    -webkit-appearance: none;
    width: 12px;
    height: 12px;
    background: #3b82f6;
    border-radius: 50%;
    cursor: pointer;
  }

  .layer-controls button {
    background: none;
    border: none;
    cursor: pointer;
    padding: 2px;
    color: #6b7280;
    transition: color 0.2s;
  }

  .layer-controls button:hover {
    color: #374151;
  }

  .add-layer-btn {
    width: 100%;
    padding: 8px;
    margin-top: 8px;
    background: #3b82f6;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 12px;
    transition: background 0.2s;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
  }

  .add-layer-btn:hover {
    background: #2563eb;
  }

  .add-layer-btn i {
    font-size: 12px;
  }

  /* 移动端图层控制面板样式 */
  @media (max-width: 480px) {
    .layer-control {
      position: absolute;
      top: 95px;
      right: 10px;
      width: 180px;
      padding: 10px;
      max-height: 200px;
    }
    
    .layer-control h3 {
      font-size: 12px;
    }
    
    .layers-container {
      max-height: 120px;
    }
    
    .layer-item {
      padding: 6px;
      font-size: 11px;
    }
    
    .layer-name {
      max-width: 80px;
    }
    
    .layer-controls input[type="range"] {
      width: 40px;
    }
    
    .add-layer-btn {
      font-size: 11px;
      padding: 6px;
    }
  }
  
  @media (max-width: 768px) and (orientation: landscape) {
    .layer-control {
      top: 55px;
      right: 10px;
      width: 200px;
      max-height: 150px;
    }
    
    .layers-container {
      max-height: 100px;
    }
  }

/* 平板端响应式设计 */
@media (max-width: 1024px) {
  .tool-panel {
    width: 260px;
  }
  
  .tools-grid {
    grid-template-columns: repeat(3, 1fr);
  }
  
  .color-grid {
    grid-template-columns: repeat(4, 1fr);
  }
}

/* 移动端响应式设计 */
@media (max-width: 768px) {
  .home {
    height: 100dvh; /* 使用动态视口高度 */
  }
  
  .app-header {
    padding: 8px 12px;
    min-height: 48px;
  }
  
  .header-left .logo {
    font-size: 14px;
  }
  
  .header-center .quick-actions {
    gap: 4px;
  }
  
  .header-right {
    gap: 4px;
  }
  
  .header-right .export-btn,
  .header-right .share-btn,
  .header-right .save-btn {
    padding: 6px 8px;
    font-size: 11px;
  }
  
  .header-right .export-btn span,
  .header-right .share-btn span,
  .header-right .save-btn span {
    display: none;
  }
  
  .main-layout {
    flex-direction: column;
  }
  
  .tool-panel {
    width: 100%;
    height: auto;
    max-height: 200px;
    padding: 12px;
    border-right: none;
    border-bottom: 1px solid #e2e8f0;
    flex-direction: row;
    overflow-x: auto;
    overflow-y: hidden;
    gap: 12px;
  }
  
  .bento-card {
    min-width: 140px;
    padding: 12px;
    margin-bottom: 0;
  }
  
  .section-title {
    font-size: 12px;
    margin-bottom: 8px;
  }
  
  .tools-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 6px;
  }
  
  .tool-item {
    width: 36px;
    height: 36px;
  }
  
  .color-grid {
    grid-template-columns: repeat(3, 1fr);
    gap: 6px;
  }
  
  .color-option {
    width: 24px;
    height: 24px;
  }
  
  .modern-slider {
    height: 3px;
  }
  
  .modern-slider::-webkit-slider-thumb {
    width: 16px;
    height: 16px;
  }
  
  .canvas-container {
    padding: 10px;
  }
  
  .drawing-canvas {
    max-width: 100%;
    max-height: calc(100dvh - 200px - 48px - 48px); /* 减去工具栏和头部 */
  }
  
  .zoom-controls {
    gap: 6px;
  }
  
  .zoom-btn {
    width: 28px;
    height: 28px;
  }
  
  .zoom-value {
    font-size: 12px;
    min-width: 40px;
  }
  
  .modal {
    margin: 20px;
    min-width: 280px;
  }
}

/* 小屏手机优化 */
@media (max-width: 480px) {
  .tool-panel {
    max-height: 160px;
    gap: 8px;
  }
  
  .bento-card {
    min-width: 120px;
    padding: 8px;
  }
  
  .tools-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 4px;
  }
  
  .tool-item {
    width: 32px;
    height: 32px;
  }
  
  .color-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .drawing-canvas {
    max-height: calc(100dvh - 160px - 48px - 48px);
  }
}

/* 横屏模式优化 */
@media (max-width: 768px) and (orientation: landscape) {
  .main-layout {
    flex-direction: row;
  }
  
  .tool-panel {
    width: 200px;
    height: 100%;
    flex-direction: column;
    overflow-y: auto;
    overflow-x: hidden;
    border-right: 1px solid #e2e8f0;
    border-bottom: none;
  }
  
  .bento-card {
    min-width: auto;
    width: 100%;
  }
  
  .drawing-canvas {
    max-height: calc(100dvh - 48px - 48px);
  }
}

/* 触控优化 */
@media (hover: none) and (pointer: coarse) {
  .tool-item,
  .color-option,
  .zoom-btn,
  .action-btn,
  .btn {
    min-height: 44px; /* 触控目标最小尺寸 */
    min-width: 44px;
  }
  
  .tool-item {
    width: 44px;
    height: 44px;
  }
  
  .color-option {
    width: 36px;
    height: 36px;
  }
  
  .zoom-btn {
    width: 36px;
    height: 36px;
  }
}

/* 可折叠侧边栏 */
@media (max-width: 768px) {
  .tool-panel {
    position: relative;
    transition: transform 0.3s ease;
  }
  
  .tool-panel.collapsed {
    transform: translateX(-100%);
  }
  
  .sidebar-toggle {
    display: none;
  }
  
  @media (max-width: 768px) {
    .sidebar-toggle {
      display: block;
      position: absolute;
      top: 50%;
      right: -24px;
      transform: translateY(-50%);
      width: 24px;
      height: 48px;
      background: #3b82f6;
      color: white;
      border: none;
      border-radius: 0 8px 8px 0;
      cursor: pointer;
      z-index: 10;
    }
  }
}

/* 字体大小响应式调整 */
@media (max-width: 768px) {
  html {
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  html {
    font-size: 13px;
  }
}

/* 安全区域适配 */
@supports (padding: max(0px)) {
  .home {
    padding-top: env(safe-area-inset-top);
    padding-bottom: env(safe-area-inset-bottom);
    padding-left: env(safe-area-inset-left);
    padding-right: env(safe-area-inset-right);
  }
}

/* 防止页面缩放 */
@media (max-width: 768px) {
  .drawing-canvas {
    touch-action: none; /* 防止双指缩放 */
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }
}
</style>