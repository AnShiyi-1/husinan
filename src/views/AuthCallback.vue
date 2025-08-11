<template>
  <div class="auth-callback">
    <div class="loading-container">
      <div class="spinner"></div>
      <p>{{ loadingText }}</p>
    </div>
  </div>
</template>

<script>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

export default {
  name: 'AuthCallback',
  setup() {
    const router = useRouter()
    const authStore = useAuthStore()
    const loadingText = ref('正在登录...')

    onMounted(() => {
      handleCallback()
    })

    const handleCallback = () => {
      const urlParams = new URLSearchParams(window.location.search)
      const token = urlParams.get('token')
      const userStr = urlParams.get('user')
      const error = urlParams.get('error')

      if (error) {
        loadingText.value = '登录失败: ' + decodeURIComponent(error)
        setTimeout(() => {
          router.push('/login')
        }, 2000)
        return
      }

      if (token && userStr) {
        try {
          const user = JSON.parse(decodeURIComponent(userStr))
          
          // 保存用户信息到store
          authStore.setUser(user)
          authStore.setToken(token)
          
          loadingText.value = '登录成功，正在跳转...'
          
          setTimeout(() => {
            router.push('/')
          }, 1000)
        } catch (e) {
          loadingText.value = '登录失败，请重试'
          setTimeout(() => {
            router.push('/login')
          }, 2000)
        }
      } else {
        loadingText.value = '登录失败，请重试'
        setTimeout(() => {
          router.push('/login')
        }, 2000)
      }
    }

    return {
      loadingText
    }
  }
}
</script>

<style scoped>
.auth-callback {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.loading-container {
  text-align: center;
  color: white;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top: 4px solid white;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

p {
  font-size: 18px;
  margin: 0;
}
</style>