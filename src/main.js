import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'
import { useAuthStore } from '@/stores/auth'
import './style.css'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)

// 全局认证状态同步
router.beforeResolve(async (to, from, next) => {
  const authStore = useAuthStore()
  
  // 确保认证状态完全同步
  if (authStore.token && !authStore.user) {
    try {
      await authStore.fetchUser()
    } catch (error) {
      console.error('认证状态同步失败:', error)
      authStore.clearAuth()
    }
  }
  
  next()
})

app.mount('#app')