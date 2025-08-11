<template>
  <div class="full-test">
    <h1>全面功能测试</h1>
    
    <!-- 认证状态 -->
    <div class="section">
      <h2>认证状态</h2>
      <p>登录状态: {{ isLoggedIn ? '已登录' : '未登录' }}</p>
      <p v-if="isLoggedIn">用户名: {{ username }}</p>
      <p v-if="isLoggedIn">用户ID: {{ userId }}</p>
      <div class="actions">
        <button @click="login" v-if="!isLoggedIn">登录</button>
        <button @click="logout" v-if="isLoggedIn">登出</button>
      </div>
    </div>

    <!-- 用户艺术品 -->
    <div class="section" v-if="isLoggedIn">
      <h2>用户艺术品</h2>
      <p>加载状态: {{ isLoadingArtworks ? '加载中...' : '已加载' }}</p>
      <div class="artworks-grid" v-if="userArtworks.length > 0">
        <div v-for="artwork in userArtworks" :key="artwork.id" class="artwork-card">
          <h3>{{ artwork.title }}</h3>
          <div class="artwork-preview">{{ artwork.dataUrl }}</div>
          <p>创建时间: {{ new Date(artwork.createdAt).toLocaleString() }}</p>
        </div>
      </div>
      <p v-else-if="!isLoadingArtworks">没有找到艺术品</p>
      <button @click="fetchArtworks">获取艺术品</button>
    </div>

    <!-- 画布测试 -->
    <div class="section">
      <h2>画布测试</h2>
      <canvas ref="canvas" width="400" height="300"></canvas>
      <div class="actions">
        <button @click="drawOnCanvas">绘制</button>
        <button @click="clearCanvas">清除</button>
        <button @click="saveCanvas">保存</button>
      </div>
    </div>
  </div>
</template>

<script>
import { useAuthStore } from '../stores/auth'
import { useCanvasStore } from '../stores/canvas'
import { ref, onMounted, computed }
 from 'vue'
import { api } from '../services/api'

export default {
  name: 'FullTest',
  setup() {
    const authStore = useAuthStore()
    const canvasStore = useCanvasStore()
    const canvasRef = ref(null)
    const ctx = ref(null)
    const isLoadingArtworks = ref(false)
    const userArtworks = ref([])

    const isLoggedIn = computed(() => authStore.isLoggedIn)
    const username = computed(() => authStore.username)
    const userId = computed(() => authStore.userId)

    // 初始化画布
    onMounted(() => {
      if (canvasRef.value) {
        ctx.value = canvasRef.value.getContext('2d')
        console.log('画布已初始化')
      }
    })

    // 登录
    const login = async () => {
      try {
        await authStore.login('1234', '1234')
        console.log('登录成功')
      } catch (error) {
        console.error('登录失败:', error)
      }
    }

    // 登出
    const logout = async () => {
      try {
        await authStore.logout()
        console.log('登出成功')
      } catch (error) {
        console.error('登出失败:', error)
      }
    }

    // 获取艺术品
    const fetchArtworks = async () => {
      isLoadingArtworks.value = true
      try {
        const response = await api.get('/api/artworks')
        userArtworks.value = response.data
        console.log('获取艺术品成功', response.data)
      } catch (error) {
        console.error('获取艺术品失败:', error)
      } finally {
        isLoadingArtworks.value = false
      }
    }

    // 绘制到画布
    const drawOnCanvas = () => {
      if (!ctx.value) return

      // 绘制一个简单的形状
      ctx.value.fillStyle = '#6366f1'
      ctx.value.beginPath()
      ctx.value.arc(200, 150, 50, 0, Math.PI * 2)
      ctx.value.fill()
      console.log('已绘制到画布')
    }

    // 清除画布
    const clearCanvas = () => {
      if (!ctx.value) return

      ctx.value.clearRect(0, 0, canvasRef.value.width, canvasRef.value.height)
      console.log('画布已清除')
    }

    // 保存画布
    const saveCanvas = async () => {
      if (!ctx.value || !isLoggedIn.value) return

      const dataUrl = canvasRef.value.toDataURL('image/png')
      try {
        await api.post('/api/artworks', {
          title: '测试画作',
          dataUrl: dataUrl
        })
        console.log('画布已保存')
        // 刷新艺术品列表
        fetchArtworks()
      } catch (error) {
        console.error('保存画布失败:', error)
      }
    }

    return {
      isLoggedIn,
      username,
      userId,
      login,
      logout,
      canvasRef,
      drawOnCanvas,
      clearCanvas,
      saveCanvas,
      fetchArtworks,
      userArtworks,
      isLoadingArtworks
    }
  }
}
</script>

<style scoped>
.full-test {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem;
}

.section {
  margin-bottom: 2rem;
  padding: 1.5rem;
  background-color: #f5f5f5;
  border-radius: 8px;
}

.actions {
  display: flex;
  gap: 1rem;
  margin-top: 1rem;
}

button {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  background-color: #6366f1;
  color: white;
  cursor: pointer;
  font-size: 1rem;
}

button:hover {
  background-color: #4f46e5;
}

canvas {
  border: 1px solid #ddd;
  margin-top: 1rem;
}

.artworks-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.artwork-card {
  border: 1px solid #ddd;
  padding: 1rem;
  border-radius: 4px;
}

.artwork-preview {
  width: 100%;
  height: 100px;
  background-color: #eee;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 0.5rem;
  overflow: hidden;
}
</style>