import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './src/App.vue'
import { useAuthStore } from './src/stores/auth.js'

// 创建测试应用
const app = createApp({
  template: `
    <div>
      <h1>认证状态测试</h1>
      <p>已登录: {{ authStore.isLoggedIn }}</p>
      <p>用户名: {{ authStore.username }}</p>
      <p>用户ID: {{ authStore.userId }}</p>
      <button @click="login">模拟登录</button>
      <button @click="logout">模拟登出</button>
    </div>
  `,
  setup() {
    const authStore = useAuthStore()
    
    const login = () => {
      // 模拟登录状态更新
      authStore.setUser({
        id: '1',
        username: 'testuser',
        avatar: 'https://example.com/avatar.jpg'
      }, 'fake-token')
      console.log('登录状态已更新')
    }
    
    const logout = () => {
      authStore.clearAuth()
      console.log('已登出')
    }
    
    return {
      authStore,
      login,
      logout
    }
  }
})

const pinia = createPinia()
app.use(pinia)

// 挂载到DOM
const root = document.createElement('div')
document.body.appendChild(root)
app.mount(root)