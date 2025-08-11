<template>
  <div class="test-login-container">
    <h2>登录功能测试</h2>
    <form @submit.prevent="handleLogin">
      <div>
        <label>用户名:</label>
        <input v-model="loginForm.username" type="text" required />
      </div>
      <div>
        <label>密码:</label>
        <input v-model="loginForm.password" type="password" required />
      </div>
      <button type="submit">登录</button>
    </form>
    <div v-if="loginResult">
      <h3>登录结果:</h3>
      <pre>{{ loginResult }}</pre>
    </div>
    
    <h2>注册功能测试</h2>
    <form @submit.prevent="handleRegister">
      <div>
        <label>用户名:</label>
        <input v-model="registerForm.username" type="text" required />
      </div>
      <div>
        <label>密码:</label>
        <input v-model="registerForm.password" type="password" required />
      </div>
      <button type="submit">注册</button>
    </form>
    <div v-if="registerResult">
      <h3>注册结果:</h3>
      <pre>{{ registerResult }}</pre>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import api from './src/services/api'

export default {
  name: 'TestLoginFunction',
  setup() {
    const loginForm = ref({
      username: '',
      password: ''
    })
    
    const registerForm = ref({
      username: '',
      password: ''
    })
    
    const loginResult = ref(null)
    const registerResult = ref(null)
    
    const handleLogin = async () => {
      try {
        const response = await api.post('/auth/login', loginForm.value)
        loginResult.value = response
        console.log('登录成功:', response)
      } catch (error) {
        loginResult.value = error.response?.data || error.message
        console.error('登录失败:', error)
      }
    }
    
    const handleRegister = async () => {
      try {
        const response = await api.post('/auth/register', registerForm.value)
        registerResult.value = response
        console.log('注册成功:', response)
      } catch (error) {
        registerResult.value = error.response?.data || error.message
        console.error('注册失败:', error)
      }
    }
    
    return {
      loginForm,
      registerForm,
      loginResult,
      registerResult,
      handleLogin,
      handleRegister
    }
  }
}
</script>

<style scoped>
.test-login-container {
  padding: 20px;
}

form {
  margin-bottom: 20px;
}

div {
  margin-bottom: 10px;
}

input {
  margin-left: 10px;
  padding: 5px;
}

button {
  margin-top: 10px;
  padding: 5px 10px;
}

pre {
  background-color: #f0f0f0;
  padding: 10px;
  white-space: pre-wrap;
}
</style>