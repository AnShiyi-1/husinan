<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2>欢迎回来</h2>
        <p class="login-subtitle">请登录您的账号</p>
      </div>
      
      <form @submit.prevent="handleLogin" class="login-form-content">
        <div class="form-group">
          <label for="username">用户名</label>
          <input
            id="username"
            v-model="loginForm.username"
            type="text"
            placeholder="请输入用户名"
            required
            maxlength="20"
            @blur="validateUsername"
            :class="{ 'error': usernameError }"
          />
          <span v-if="usernameError" class="field-error">{{ usernameError }}</span>
        </div>
        
        <div class="form-group">
          <label for="password">密码</label>
          <div class="password-input-wrapper">
            <input
              id="password"
              v-model="loginForm.password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="请输入密码"
              required
              minlength="6"
              @blur="validatePassword"
              @input="checkPasswordStrength"
              :class="{ 'error': passwordError }"
            />
            <button
              type="button"
              class="password-toggle"
              @click="togglePassword"
              :aria-label="showPassword ? '隐藏密码' : '显示密码'"
            >
              {{ showPassword ? '👁️' : '👁️‍🗨️' }}
            </button>
          </div>
          <div v-if="loginForm.password.length > 0" class="password-strength">
            <div class="strength-bar">
              <div 
                :class="['strength-indicator', passwordStrength]"
                :style="{ width: strengthWidth + '%' }"
              ></div>
            </div>
            <span class="strength-text">{{ strengthText }}</span>
          </div>
          <span v-if="passwordError" class="field-error">{{ passwordError }}</span>
        </div>

        <div class="form-group checkbox-group">
          <label class="checkbox-label">
            <input
              v-model="loginForm.remember"
              type="checkbox"
              class="checkbox-input"
            />
            <span class="checkbox-text">记住登录状态</span>
          </label>
          <router-link to="/forgot-password" class="forgot-link">
            忘记密码？
          </router-link>
        </div>

        <button 
          type="submit" 
          class="login-btn" 
          :disabled="loading || !isFormValid"
          :class="{ 'loading': loading }"
        >
          <span v-if="loading" class="loading-spinner"></span>
          {{ loading ? '登录中...' : '登录' }}
        </button>
        
        <p v-if="error" class="error-message">
          <span class="error-icon">⚠️</span>
          {{ error }}
        </p>
        <p v-if="success" class="success-message">
          <span class="success-icon">✅</span>
          {{ success }}
        </p>
      </form>

      <div class="register-link">
        <p>还没有账号？ <router-link to="/register">立即注册</router-link></p>
      </div>
      
      <div class="test-info" style="margin-top: 1rem; padding: 1rem; background: #f8f9fa; border-radius: 8px; font-size: 0.85rem; color: #666;">
        <p><strong>测试账号：</strong></p>
        <p>用户名：testuser</p>
        <p>密码：123456</p>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

export default {
  name: 'Login',
  setup() {
    const router = useRouter()
    const authStore = useAuthStore()
    
    const loginForm = ref({
      username: '',
      password: '',
      remember: false
    })
    const loading = ref(false)
    const error = ref('')
    const success = ref('')
    const showPassword = ref(false)
    const usernameError = ref('')
    const passwordError = ref('')
    const passwordStrength = ref('')
    const strengthText = ref('')
    const strengthWidth = ref(0)

    // 自动填充已保存的用户名
    onMounted(() => {
      const savedUsername = localStorage.getItem('lastUsername')
      if (savedUsername) {
        loginForm.value.username = savedUsername
      }
    })

    const togglePassword = () => {
      showPassword.value = !showPassword.value
    }

    const validateUsername = () => {
      if (!loginForm.value.username) {
        usernameError.value = '请输入用户名'
        return false
      }
      if (loginForm.value.username.length < 2 || loginForm.value.username.length > 20) {
        usernameError.value = '用户名长度应为2-20位'
        return false
      }
      if (!/^[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(loginForm.value.username)) {
        usernameError.value = '用户名只能包含字母、数字、下划线和中文'
        return false
      }
      usernameError.value = ''
      return true
    }

    const validatePassword = () => {
      if (!loginForm.value.password) {
        passwordError.value = '请输入密码'
        return false
      }
      if (loginForm.value.password.length < 6) {
        passwordError.value = '密码长度至少为6位'
        return false
      }
      passwordError.value = ''
      return true
    }

    const checkPasswordStrength = () => {
      const pwd = loginForm.value.password
      let strength = 0
      
      if (pwd.length >= 6) strength++
      if (pwd.length >= 8) strength++
      if (/[a-z]/.test(pwd)) strength++
      if (/[A-Z]/.test(pwd)) strength++
      if (/[0-9]/.test(pwd)) strength++
      if (/[^a-zA-Z0-9]/.test(pwd)) strength++

      if (pwd.length === 0) {
        passwordStrength.value = ''
        strengthText.value = ''
        strengthWidth.value = 0
        return
      }

      if (strength < 2) {
        passwordStrength.value = 'weak'
        strengthText.value = '弱'
        strengthWidth.value = 33
      } else if (strength < 4) {
        passwordStrength.value = 'medium'
        strengthText.value = '中'
        strengthWidth.value = 66
      } else {
        passwordStrength.value = 'strong'
        strengthText.value = '强'
        strengthWidth.value = 100
      }
    }

    const isFormValid = computed(() => {
      return loginForm.value.username && loginForm.value.password && 
             !usernameError.value && !passwordError.value &&
             loginForm.value.username.length >= 2 && loginForm.value.username.length <= 20 &&
             loginForm.value.password.length >= 6
    })

    const handleLogin = async () => {
      loading.value = true
      error.value = ''
      success.value = ''
      
      if (!validateUsername() || !validatePassword()) {
        loading.value = false
        return
      }

      try {
        console.log('开始登录，提交数据:', loginForm.value)
        const result = await authStore.login(loginForm.value)
        console.log('登录成功，返回结果:', result)
        
        // 确保用户信息已完全同步
        await authStore.fetchUser()
        console.log('用户信息已同步')
        
        // 保存用户名到本地存储
        if (loginForm.value.remember) {
          localStorage.setItem('lastUsername', loginForm.value.username)
        }
        
        success.value = '登录成功！正在跳转...'
        
        // 获取跳转路径
        const redirectPath = localStorage.getItem('redirectPath') || '/profile'
        localStorage.removeItem('redirectPath')
        
        // 立即跳转，避免setTimeout带来的问题
        try {
          await router.replace(redirectPath)
        } catch (err) {
          console.error('路由跳转失败:', err)
          await router.replace('/')
        }
        
      } catch (err) {
        console.error('登录失败:', err)
        error.value = err.response?.data?.error || '登录失败，请检查账号密码'
        if (err.response) {
          console.error('服务器响应:', err.response.status, err.response.data)
        }
      } finally {
        loading.value = false
      }
    }

    return {
      loginForm,
      loading,
      error,
      success,
      showPassword,
      usernameError,
      passwordError,
      passwordStrength,
      strengthText,
      strengthWidth,
      isFormValid,
      handleLogin,
      togglePassword,
      validateUsername,
      validatePassword,
      checkPasswordStrength
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 1rem;
}

.login-box {
  background: white;
  padding: 2.5rem;
  border-radius: 15px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 420px;
}

.login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.login-header h2 {
  color: #333;
  font-size: 1.8rem;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.login-subtitle {
  color: #666;
  font-size: 1rem;
  margin: 0;
}

.login-form-content {
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
  position: relative;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #555;
  font-weight: 500;
  font-size: 0.9rem;
}

.form-group input {
  width: 100%;
  padding: 0.875rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.form-group input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-group input.error {
  border-color: #e74c3c;
}

.form-group input.error:focus {
  border-color: #e74c3c;
  box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
}

.field-error {
  color: #e74c3c;
  font-size: 0.8rem;
  margin-top: 0.25rem;
  display: block;
}

.password-input-wrapper {
  position: relative;
}

.password-toggle {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
  padding: 0;
  color: #666;
}

.password-strength {
  margin-top: 0.5rem;
}

.strength-bar {
  height: 4px;
  background: #f0f0f0;
  border-radius: 2px;
  overflow: hidden;
}

.strength-indicator {
  height: 100%;
  transition: width 0.3s ease, background-color 0.3s ease;
}

.strength-indicator.weak {
  background-color: #e74c3c;
}

.strength-indicator.medium {
  background-color: #f39c12;
}

.strength-indicator.strong {
  background-color: #27ae60;
}

.strength-text {
  font-size: 0.8rem;
  margin-top: 0.25rem;
  display: block;
}

.strength-text:contains('弱') {
  color: #e74c3c;
}

.strength-text:contains('中') {
  color: #f39c12;
}

.strength-text:contains('强') {
  color: #27ae60;
}

.checkbox-group {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.checkbox-label {
  display: flex;
  align-items: center;
  cursor: pointer;
  margin: 0;
}

.checkbox-input {
  width: auto;
  margin-right: 0.5rem;
}

.checkbox-text {
  font-size: 0.9rem;
  color: #555;
}

.forgot-link {
  color: #667eea;
  text-decoration: none;
  font-size: 0.9rem;
}

.forgot-link:hover {
  text-decoration: underline;
}

.login-btn {
  width: 100%;
  padding: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.login-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.login-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.login-btn.loading {
  cursor: wait;
}

.loading-spinner {
  display: inline-block;
  width: 16px;
  height: 16px;
  border: 2px solid #ffffff;
  border-radius: 50%;
  border-top-color: transparent;
  animation: spin 1s linear infinite;
  margin-right: 0.5rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error-message,
.success-message {
  padding: 0.75rem;
  border-radius: 8px;
  margin-top: 1rem;
  display: flex;
  align-items: center;
  font-size: 0.9rem;
}

.error-message {
  background: #fee;
  color: #e74c3c;
  border: 1px solid #fcc;
}

.success-message {
  background: #efe;
  color: #27ae60;
  border: 1px solid #cfc;
}

.error-icon,
.success-icon {
  margin-right: 0.5rem;
  font-size: 1rem;
}

.register-link {
  text-align: center;
  margin-top: 1.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid #eee;
}

.register-link p {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
}

.register-link a {
  color: #667eea;
  text-decoration: none;
  font-weight: 500;
}

.register-link a:hover {
  text-decoration: underline;
}

@media (max-width: 480px) {
  .login-box {
    margin: 1rem;
    padding: 2rem;
  }
  
  .login-header h2 {
    font-size: 1.5rem;
  }
  
  .checkbox-group {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
}
</style>