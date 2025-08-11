import { defineStore } from 'pinia'

/**
 * @typedef {Object} DrawingPoint
 * @property {number} x - X坐标
 * @property {number} y - Y坐标
 * @property {number} pressure - 压力值
 * @property {number} timestamp - 时间戳
 */

/**
 * @typedef {Object} DrawingPath
 * @property {string} id - 唯一标识符
 * @property {DrawingPoint[]} points - 路径点集合
 * @property {string} color - 颜色
 * @property {number} width - 线条宽度
 * @property {string} emotion - 关联情绪
 * @property {number} timestamp - 创建时间
 */

/**
 * @typedef {Object} Artwork
 * @property {string} id - 作品ID
 * @property {string} title - 标题
 * @property {DrawingPath[]} paths - 所有路径
 * @property {string} emotion - 主要情绪
 * @property {string} backgroundColor - 背景色
 * @property {number} createdAt - 创建时间
 * @property {string} thumbnail - 缩略图URL
 */

export const useCanvasStore = defineStore('canvas', {
  state: () => ({
    /** @type {Array<{id: number, name: string, paths: DrawingPath[], opacity: number, visible: boolean, active: boolean}>} */
    layers: [
      { id: 1, name: '图层 1', paths: [], opacity: 100, visible: true, active: true }
    ],
    
    /** @type {number} */
    nextLayerId: 2,
    
    /** @type {Array<{x: number, y: number, color: string, type: 'fill'}>} */
    filledAreas: [],
    
    /** @type {string} */
    currentColor: '#6366f1',
    
    /** @type {number} */
    currentWidth: 3,
    
    /** @type {string} */
    currentEmotion: 'calm',
    
    /** @type {string} */
    backgroundColor: '#ffffff',
    
    /** @type {boolean} */
    isDrawing: false,
    
    /** @type {DrawingPoint[]} */
    currentPath: [],
    
    /** @type {Artwork[]} */
    savedArtworks: [],
    
    /** @type {Artwork|null} */
    currentArtwork: null,
    
    /** @type {string} */
    currentTool: 'brush'
  }),

  getters: {
    pathCount: (state) => {
      // 计算所有可见图层中的路径总数
      return state.layers
        .filter(layer => layer.visible)
        .reduce((count, layer) => count + layer.paths.length, 0);
    },
    
    activeLayer: (state) => {
      // 获取当前活动图层
      return state.layers.find(layer => layer.active) || state.layers[0];
    },
    
    emotionStats: (state) => {
      const stats = {}
      state.savedArtworks.forEach(artwork => {
        stats[artwork.emotion] = (stats[artwork.emotion] || 0) + 1
      })
      return stats
    },
    
    hasUnsavedChanges: (state) => state.layers.some(layer => layer.paths.length > 0)
  },

  actions: {
    /**
     * 添加新图层
     * @param {string} name - 图层名称
     */
    addLayer(name) {
      const newLayer = {
        id: this.nextLayerId++,
        name: name || `图层 ${this.nextLayerId - 1}`,
        paths: [],
        opacity: 100,
        visible: true,
        active: false
      };
      
      // 新图层位于旧图层之上（数组开头）
      this.layers.unshift(newLayer);
      this.setActiveLayer(newLayer.id);
      
      return newLayer;
    },
    
    /**
     * 删除图层
     * @param {number} layerId - 图层ID
     */
    removeLayer(layerId) {
      if (this.layers.length <= 1) {
        console.warn('不能删除最后一个图层');
        return;
      }
      
      const index = this.layers.findIndex(layer => layer.id === layerId);
      if (index !== -1) {
        this.layers.splice(index, 1);
        
        // 如果删除的是活动图层，设置第一个图层为活动图层
        if (this.layers.length > 0 && !this.layers.some(layer => layer.active)) {
          this.layers[0].active = true;
        }
      }
    },
    
    /**
     * 设置活动图层
     * @param {number} layerId - 图层ID
     */
    setActiveLayer(layerId) {
      this.layers.forEach(layer => {
        layer.active = layer.id === layerId;
      });
    },
    
    /**
     * 更新图层透明度
     * @param {number} layerId - 图层ID
     * @param {number} opacity - 透明度值(0-100)
     */
    updateLayerOpacity(layerId, opacity) {
      const layer = this.layers.find(layer => layer.id === layerId);
      if (layer) {
        layer.opacity = Math.max(0, Math.min(100, parseInt(opacity)));
      }
    },
    
    /**
     * 切换图层可见性
     * @param {number} layerId - 图层ID
     */
    toggleLayerVisibility(layerId) {
      const layer = this.layers.find(layer => layer.id === layerId);
      if (layer) {
        layer.visible = !layer.visible;
      }
    },
    
    /**
     * 重命名图层
     * @param {number} layerId - 图层ID
     * @param {string} name - 新名称
     */
    renameLayer(layerId, name) {
      const layer = this.layers.find(layer => layer.id === layerId);
      if (layer && name) {
        layer.name = name;
      }
    },
    
    /**
     * 开始新的绘画路径
     */
    startPath() {
      this.isDrawing = true
      this.currentPath = []
    },

    /**
     * 添加点到当前路径
     * @param {DrawingPoint} point
     */
    addPoint(point) {
      if (this.isDrawing) {
        this.currentPath.push(point)
      }
    },

    /**
     * 添加路径到指定图层
     * @param {DrawingPath} path - 路径对象
     * @param {number} layerId - 图层ID（可选，默认为活动图层）
     */
    addPath(path, layerId) {
      const targetLayer = layerId ? 
        this.layers.find(layer => layer.id === layerId) : 
        this.activeLayer;
      
      if (targetLayer) {
        targetLayer.paths.push(path);
      }
    },

    /**
     * 结束当前路径并保存到活动图层
     */
    endPath() {
      if (this.currentPath.length > 0) {
        const path = {
          id: Date.now().toString(),
          points: [...this.currentPath],
          color: this.currentTool === 'eraser' ? '#ffffff' : this.currentColor,
          width: this.currentWidth,
          emotion: this.currentEmotion,
          timestamp: Date.now(),
          tool: this.currentTool || 'brush',
          fillColor: null,
          hasFill: false
        };
        
        // 添加路径到活动图层
        const activeLayer = this.activeLayer;
        if (activeLayer) {
          activeLayer.paths.push(path);
        }
      }
      this.isDrawing = false
      this.currentPath = []
    },

    /**
     * 撤销上一步（从活动图层中删除最后一个路径）
     */
    undo() {
      const activeLayer = this.activeLayer;
      if (activeLayer && activeLayer.paths.length > 0) {
        activeLayer.paths.pop();
      }
    },

    /**
     * 清空画布（清空所有图层的路径）
     */
    clearCanvas() {
      this.layers.forEach(layer => {
        layer.paths = [];
      });
      this.filledAreas = [];
      this.currentArtwork = null;
      this.backgroundColor = '#ffffff';
    },

    /**
     * 添加填充区域（存储为路径对象）
     * @param {number} x
     * @param {number} y
     * @param {string} color
     * @param {Path2D} path
     */
    addFilledArea(x, y, color, path) {
      this.filledAreas.push({ x, y, color, path })
    },

    /**
     * 重新应用所有填充区域
     * @param {CanvasRenderingContext2D} ctx
     * @param {HTMLCanvasElement} canvas
     */
    reapplyFilledAreas(ctx, canvas) {
      // 填充区域作为独立的路径存储，与绘画路径共存
      this.filledAreas.forEach(area => {
        ctx.save()
        ctx.fillStyle = area.color
        ctx.globalCompositeOperation = 'source-over'
        ctx.fill(area.path)
        ctx.restore()
      })
    },

    /**
     * 清除所有填充区域
     */
    clearFilledAreas() {
      this.filledAreas = []
    },

    /**
     * 保存当前作品
     * @param {string} title
     */
    saveArtwork(title) {
      // 收集所有图层的路径
      const allPaths = this.layers.flatMap(layer => layer.paths);
      
      const artwork = {
        id: Date.now().toString(),
        title: title || `作品 ${new Date().toLocaleString('zh-CN')}`,
        paths: allPaths,
        filledAreas: [...this.filledAreas],
        emotion: this.currentEmotion,
        backgroundColor: this.backgroundColor,
        createdAt: Date.now(),
        thumbnail: '', // 将由canvas生成
        // 社交功能字段
        likes: 0,
        views: 0,
        comments: [],
        isLiked: false,
        isFeatured: false,
        author: '匿名画家',
        description: ''
      }
      this.savedArtworks.unshift(artwork)
      this.currentArtwork = artwork
      return artwork
    },

    /**
     * 更新作品信息（用于社交功能）
     * @param {Artwork} artwork - 要更新的作品
     */
    updateArtwork(artwork) {
      const index = this.savedArtworks.findIndex(a => a.id === artwork.id)
      if (index !== -1) {
        this.savedArtworks[index] = { ...this.savedArtworks[index], ...artwork }
      }
    },

    /**
     * 加载作品到画布
     * @param {string} artworkId
     */
    loadArtwork(artworkId) {
      const artwork = this.savedArtworks.find(a => a.id === artworkId)
      if (artwork) {
        this.currentPaths = [...artwork.paths]
        this.filledAreas = [...(artwork.filledAreas || [])]
        this.backgroundColor = artwork.backgroundColor
        this.currentEmotion = artwork.emotion
        this.currentArtwork = artwork
      }
    },

    /**
     * 删除作品
     * @param {string} artworkId
     */
    deleteArtwork(artworkId) {
      const index = this.savedArtworks.findIndex(a => a.id === artworkId)
      if (index > -1) {
        this.savedArtworks.splice(index, 1)
      }
    },

    /**
     * 设置当前颜色
     * @param {string} color
     */
    setColor(color) {
      this.currentColor = color
    },

    /**
     * 设置线条宽度
     * @param {number} width
     */
    setWidth(width) {
      this.currentWidth = width
    },

    /**
     * 设置情绪
     * @param {string} emotion
     */
    setEmotion(emotion) {
      this.currentEmotion = emotion
    },

    /**
     * 设置背景色
     * @param {string} color
     */
    setBackgroundColor(color) {
      this.backgroundColor = color
    },

    /**
     * 设置当前工具
     * @param {string} tool
     */
    setTool(tool) {
      this.currentTool = tool
    }
  }
})