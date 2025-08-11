<template>
  <div>
    <h2>认证状态测试</h2>
    <p>登录状态: {{ isLoggedIn }}</p>
    <p>用户名: {{ userName }}</p>
    <p>用户头像: {{ userAvatar }}</p>
    <div v-if="userAvatar">
      <img :src="userAvatar" :alt="userName" style="width: 50px; height: 50px; border-radius: 50%;" />
    </div>
    <div v-else>
      <div style="width: 50px; height: 50px; border-radius: 50%; background: #ccc; display: flex; align-items: center; justify-content: center;">
        {{ userName ? userName.charAt(0).toUpperCase() : 'U' }}
      </div>
    </div>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth'

export default {
  name: 'TestAuthState',
  setup() {
    const authStore = useAuthStore()
    
    const isLoggedIn = computed(() => authStore.isLoggedIn)
    const userName = computed(() => authStore.user?.username || '')
    const userAvatar = computed(() => authStore.user?.avatar || '')
    
    return {
      isLoggedIn,
      userName,
      userAvatar
    }
  }
}
</script>