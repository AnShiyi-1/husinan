<template>
  <div class="register-container">
    <div class="register-box">
      <h2>用户注册</h2>
      <form @submit.prevent="handleRegister">
        <div class="form-group">
          <label for="username">账号</label>
          <input
            id="username"
            v-model="registerForm.username"
            type="text"
            placeholder="请输入账号"
            @blur="checkUsername"
            required
          />
          <span v-if="usernameCheck.loading" class="check-loading">检查中...</span>
          <span v-if="usernameCheck.error" class="check-error">{{ usernameCheck.error }}</span>
          <span v-if="usernameCheck.available && usernameCheck.checked" class="check-success">账号可用</span>
        </div>



        <div class="form-group">
          <label for="password">密码</label>
          <input
            id="password"
            v-model="registerForm.password"
            type="password"
            placeholder="请输入密码（至少6位）"
            required
          />
        </div>

        <div class="form-group">
          <label for="confirmPassword">确认密码</label>
          <input
            id="confirmPassword"
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="请再次输入密码"
            required
          />
        </div>

        <button 
          type="submit" 
          class="register-btn" 
          :disabled="loading || !usernameCheck.available"
        >
          {{ loading ? '注册中...' : '注册' }}
        </button>
      </form>

      <div class="login-link">
        已有账号？
        <router-link to="/login">立即登录</router-link>
      </div>

      <div v-if="error" class="error-message">
        {{ error }}
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

export default {
  name: 'Register',
  setup() {
    const router = useRouter()
    const authStore = useAuthStore()
    
    const registerForm = ref({
      username: '',
      password: '',
      confirmPassword: ''
    })
    
    const loading = ref(false)
    const error = ref('')
    
    const usernameCheck = reactive({
      loading: false,
      error: '',
      available: false,
      checked: false
    })

    // 监听用户名变化
    watch(() => registerForm.value.username, () => {
      usernameCheck.available = false
      usernameCheck.error = ''
    })

    let checkTimeout = null
    
    const checkUsername = async () => {
      // 清除之前的定时器
      if (checkTimeout) {
        clearTimeout(checkTimeout)
      }

      if (!registerForm.value.username || registerForm.value.username.length < 2) {
        usernameCheck.error = '账号至少2位'
        usernameCheck.available = false
        usernameCheck.checked = false
        return
      }

      // 添加防抖延迟
      checkTimeout = setTimeout(async () => {
        usernameCheck.loading = true
        usernameCheck.error = ''
        
        try {
          const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3001/api'
          const response = await fetch(`${API_BASE_URL}/auth/check-username`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username: registerForm.value.username })
          })
          
          const data = await response.json()
          usernameCheck.checked = true
          
          if (data.exists) {
            usernameCheck.error = '账号已存在'
            usernameCheck.available = false
          } else {
            usernameCheck.error = ''
            usernameCheck.available = true
          }
        } catch (err) {
          console.error('用户名检查失败:', err)
          usernameCheck.error = ''
          usernameCheck.available = true
          usernameCheck.checked = true
        } finally {
          usernameCheck.loading = false
        }
      }, 500)
    }

    const handleRegister = async () => {
      // 验证表单
      if (registerForm.value.password !== registerForm.value.confirmPassword) {
        error.value = '两次输入的密码不一致'
        return
      }

      if (registerForm.value.password.length < 6) {
        error.value = '密码至少6位'
        return
      }

      loading.value = true
      error.value = ''
      
      try {
        await authStore.register({
          username: registerForm.value.username,
          password: registerForm.value.password
        })
        // 显示注册成功提示
        alert('注册成功！请使用新账号登录')
        // 跳转到登录页面
        router.push('/login')
      } catch (err) {
        error.value = err.response?.data?.error || '注册失败，请稍后重试'
      } finally {
        loading.value = false
      }
    }

    return {
      registerForm,
      loading,
      error,
      usernameCheck,
      checkUsername,
      handleRegister
    }
  }
}
</script>

<style scoped>
.register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.register-box {
  background: white;
  padding: 40px;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #333;
}

.form-group {
  margin-bottom: 20px;
  position: relative;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  color: #555;
  font-weight: 500;
}

.form-group input[type="text"],
.form-group input[type="email"],
.form-group input[type="password"] {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 16px;
  transition: border-color 0.3s;
}

.form-group input[type="text"]:focus,
.form-group input[type="email"]:focus,
.form-group input[type="password"]:focus {
  outline: none;
  border-color: #667eea;
}

.check-loading,
.check-error,
.check-success {
  display: block;
  margin-top: 5px;
  font-size: 12px;
}

.check-loading {
  color: #666;
}

.check-error {
  color: #e74c3c;
}

.check-success {
  color: #27ae60;
}

.register-btn {
  width: 100%;
  padding: 12px;
  background: #667eea;
  color: white;
  border: none;
  border-radius: 5px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.register-btn:hover:not(:disabled) {
  background: #5a6fd8;
}

.register-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.login-link {
  text-align: center;
  margin-top: 20px;
  color: #666;
}

.login-link a {
  color: #667eea;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}

.error-message {
  margin-top: 15px;
  padding: 10px;
  background: #fee;
  color: #c33;
  border-radius: 5px;
  text-align: center;
}
</style>