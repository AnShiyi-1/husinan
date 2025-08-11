<template>
  <div class="auth-test">
    <h1>认证状态测试</h1>
    <div class="status-card">
      <h2>登录状态</h2>
      <p>{{ isLoggedIn ? '已登录' : '未登录' }}</p>
    </div>
    <div v-if="isLoggedIn" class="status-card">
      <h2>用户信息</h2>
      <p>用户名: {{ username }}</p>
      <p>用户ID: {{ userId }}</p>
      <p>头像: {{ userAvatar || '无' }}</p>
    </div>
    <div class="actions">
      <button @click="login" v-if="!isLoggedIn">测试登录</button>
      <button @click="logout" v-if="isLoggedIn">测试登出</button>
      <button @click="fetchUser">获取用户信息</button>
    </div>
  </div>
</template>

<script>
import { useAuthStore } from '../stores/auth'
import { ref, computed } from 'vue'

export default {
  name: 'AuthTest',
  setup() {
    const authStore = useAuthStore()

    const isLoggedIn = computed(() => authStore.isLoggedIn)
    const username = computed(() => authStore.username)
    const userId = computed(() => authStore.userId)
    const userAvatar = computed(() => authStore.userAvatar)

    const login = async () => {
      try {
        await authStore.login('1234', '1234')
        console.log('登录成功')
      } catch (error) {
        console.error('登录失败:', error)
      }
    }

    const logout = async () => {
      try {
        await authStore.logout()
        console.log('登出成功')
      } catch (error) {
        console.error('登出失败:', error)
      }
    }

    const fetchUser = async () => {
      try {
        await authStore.fetchUser()
        console.log('获取用户信息成功')
      } catch (error) {
        console.error('获取用户信息失败:', error)
      }
    }

    return {
      isLoggedIn,
      username,
      userId,
      userAvatar,
      login,
      logout,
      fetchUser
    }
  }
}
</script>

<style scoped>
.auth-test {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
}

.status-card {
  background-color: #f5f5f5;
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.actions {
  display: flex;
  gap: 1rem;
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
</style>