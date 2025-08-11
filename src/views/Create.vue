<template>
  <div class="create-container">
    <div class="background-decoration">
      <div class="decoration-circle circle-1"></div>
      <div class="decoration-circle circle-2"></div>
      <div class="decoration-circle circle-3"></div>
    </div>

    <div class="create-card">
      <div class="create-header">
        <h1>创作新作品</h1>
        <p class="subtitle">用画笔表达您的情绪，创造独特的艺术作品</p>
      </div>

      <div class="canvas-container">
        <canvas 
          ref="canvas" 
          width="800" 
          height="600"
          class="drawing-canvas"
          @mousedown="startDrawing"
          @mousemove="draw"
          @mouseup="stopDrawing"
          @mouseleave="stopDrawing"
        ></canvas>
        
        <div class="canvas-controls">
          <div class="tool-group">
            <label>画笔颜色</label>
            <input 
              type="color" 
              v-model="brushColor" 
              class="color-picker"
            />
          </div>
          
          <div class="tool-group">
            <label>画笔大小</label>
            <input 
              type="range" 
              min="1" 
              max="50" 
              v-model="brushSize" 
              class="size-slider"
            />
            <span>{{ brushSize }}px</span>
          </div>
          
          <div class="tool-group">
            <button @click="clearCanvas" class="btn btn-secondary">清空画布</button>
            <button @click="saveArtwork" class="btn btn-primary">保存作品</button>
          </div>
        </div>
      </div>

      <div class="emotion-selector">
        <h3>选择您的情绪</h3>
        <div class="emotion-tags">
          <button 
            v-for="emotion in emotions" 
            :key="emotion.value"
            @click="selectEmotion(emotion.value)"
            :class="['emotion-tag', { active: selectedEmotion === emotion.value }]"
          >
            {{ emotion.label }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

export default {
  name: 'Create',
  setup() {
    const router = useRouter()
    const authStore = useAuthStore()
    
    const canvas = ref(null)
    const ctx = ref(null)
    const isDrawing = ref(false)
    const brushColor = ref('#000000')
    const brushSize = ref(5)
    const selectedEmotion = ref('')

    const emotions = [
      { value: 'happy', label: '开心' },
      { value: 'sad', label: '难过' },
      { value: 'angry', label: '愤怒' },
      { value: 'peaceful', label: '平静' },
      { value: 'excited', label: '兴奋' },
      { value: 'anxious', label: '焦虑' }
    ]

    onMounted(() => {
      if (canvas.value) {
        ctx.value = canvas.value.getContext('2d')
        // 设置画布背景为白色
        ctx.value.fillStyle = '#ffffff'
        ctx.value.fillRect(0, 0, canvas.value.width, canvas.value.height)
      }
    })

    const startDrawing = (e) => {
      isDrawing.value = true
      draw(e)
    }

    const draw = (e) => {
      if (!isDrawing.value) return
      
      const rect = canvas.value.getBoundingClientRect()
      const x = e.clientX - rect.left
      const y = e.clientY - rect.top

      ctx.value.lineWidth = brushSize.value
      ctx.value.lineCap = 'round'
      ctx.value.strokeStyle = brushColor.value

      ctx.value.lineTo(x, y)
      ctx.value.stroke()
      ctx.value.beginPath()
      ctx.value.moveTo(x, y)
    }

    const stopDrawing = () => {
      isDrawing.value = false
      ctx.value.beginPath()
    }

    const clearCanvas = () => {
      ctx.value.clearRect(0, 0, canvas.value.width, canvas.value.height)
      ctx.value.fillStyle = '#ffffff'
      ctx.value.fillRect(0, 0, canvas.value.width, canvas.value.height)
    }

    const selectEmotion = (emotion) => {
      selectedEmotion.value = emotion
    }

    const saveArtwork = async () => {
      if (!authStore.isLoggedIn) {
        // 触发父组件的登录模态框
        window.dispatchEvent(new CustomEvent('open-login-modal'))
        return
      }

      if (!selectedEmotion.value) {
        alert('请先选择一个情绪标签')
        return
      }

      try {
        const imageData = canvas.value.toDataURL('image/png')
        
        const response = await api.post('/artworks', {
          title: `情绪画作 - ${new Date().toLocaleString()}`,
          emotion: selectedEmotion.value,
          imageData: imageData,
          userId: authStore.user?.id
        })

        if (response.data.success) {
          alert('作品保存成功！')
          router.push('/gallery')
        }
      } catch (error) {
        console.error('保存作品失败:', error)
        alert('保存失败，请重试')
      }
    }

    return {
      canvas,
      brushColor,
      brushSize,
      selectedEmotion,
      emotions,
      startDrawing,
      draw,
      stopDrawing,
      clearCanvas,
      selectEmotion,
      saveArtwork
    }
  }
}
</script>

<style scoped>
.create-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f0ff 0%, #e6d7ff 100%);
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.background-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 1;
}

.decoration-circle {
  position: absolute;
  border-radius: 50%;
  opacity: 0.1;
  animation: float 6s ease-in-out infinite;
}

.circle-1 {
  width: 200px;
  height: 200px;
  background: linear-gradient(135deg, #d8c5ff, #f0e6ff);
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.circle-2 {
  width: 150px;
  height: 150px;
  background: linear-gradient(135deg, #c5b9ff, #e6d7ff);
  top: 60%;
  right: 15%;
  animation-delay: 2s;
}

.circle-3 {
  width: 100px;
  height: 100px;
  background: linear-gradient(135deg, #e6d7ff, #f5f0ff);
  bottom: 20%;
  left: 30%;
  animation-delay: 4s;
}

@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(0deg); }
  50% { transform: translateY(-20px) rotate(180deg); }
}

.create-card {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  max-width: 900px;
  width: 100%;
  z-index: 10;
}

.create-header {
  text-align: center;
  margin-bottom: 2rem;
}

.create-header h1 {
  font-size: 2.5rem;
  color: #333;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #666;
  font-size: 1.1rem;
}

.canvas-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
  margin-bottom: 2rem;
}

.drawing-canvas {
  border: 2px solid #ddd;
  border-radius: 10px;
  cursor: crosshair;
  max-width: 100%;
  height: auto;
}

.canvas-controls {
  display: flex;
  gap: 1rem;
  align-items: center;
  flex-wrap: wrap;
  justify-content: center;
}

.tool-group {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.tool-group label {
  font-weight: 600;
  color: #555;
}

.color-picker {
  width: 50px;
  height: 30px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

.size-slider {
  width: 100px;
}

.btn {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-primary {
  background: linear-gradient(135deg, #d8c5ff, #b794ff);
  color: white;
}

.btn-secondary {
  background: #f8f9fa;
  color: #333;
  border: 1px solid #ddd;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.emotion-selector {
  text-align: center;
}

.emotion-selector h3 {
  color: #333;
  margin-bottom: 1rem;
}

.emotion-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  justify-content: center;
}

.emotion-tag {
  padding: 0.5rem 1rem;
  border: 2px solid #ddd;
  border-radius: 25px;
  background: white;
  color: #666;
  cursor: pointer;
  transition: all 0.3s ease;
}

.emotion-tag:hover {
  border-color: #b794ff;
  color: #b794ff;
}

.emotion-tag.active {
  background: linear-gradient(135deg, #d8c5ff, #b794ff);
  color: white;
  border-color: transparent;
}

@media (max-width: 768px) {
  .create-container {
    padding: 1rem;
  }
  
  .create-card {
    padding: 1rem;
  }
  
  .canvas-controls {
    flex-direction: column;
    align-items: stretch;
  }
  
  .drawing-canvas {
    width: 100%;
    height: 400px;
  }
}
</style>