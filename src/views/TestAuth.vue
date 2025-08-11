<template>
  <div class="test-auth-container">
    <h2>认证状态测试</h2>
    <div class="status-info">
      <p>登录状态: {{ authStore.isLoggedIn ? '已登录' : '未登录' }}</p>
      <p>用户ID: {{ authStore.userId || '无' }}</p>
      <p>用户名: {{ authStore.username || '无' }}</p>
      <p>Token: {{ authStore.token || '无' }}</p>
    </div>
    <div class="actions">
      <button @click="checkAuthStatus">刷新状态</button>
      <button @click="logout">登出</button>
    </div>
  </div>
</template>

<script>
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

export default {
  name: 'TestAuth',
  setup() {
    const authStore = useAuthStore()
    const router = useRouter()
    
    const checkAuthStatus = () => {
      console.log('当前认证状态:', {
        isLoggedIn: authStore.isLoggedIn,
        userId: authStore.userId,
        username: authStore.username,
        token: authStore.token
      })
    }
    
    const logout = async () => {
      await authStore.logout()
      router.push('/login')
    }
    
    return {
      authStore,
      checkAuthStatus,
      logout
    }
  }
}
</script>

<style scoped>
.test-auth-container {
  padding: 20px;
}

.status-info {
  margin: 20px 0;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 5px;
}

.actions {
  margin-top: 20px;
}

button {
  margin-right: 10px;
  padding: 10px 15px;
  background-color: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #66b1ff;
}
</style>