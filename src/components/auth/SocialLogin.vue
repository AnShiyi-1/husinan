<template>
  <div class="login-container">
      <h2>QQ一键登录</h2>
      <button @click="handleQQLogin" class="social-btn qq">
        <svg class="icon" viewBox="0 0 24 24">
          <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
        </svg>
        QQ登录
      </button>
    </div>
</template>

<script>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import api from '@/services/api'

export default {
  name: 'SocialLogin',
  setup() {
    const router = useRouter()
    const authStore = useAuthStore()
    
    const loading = ref(false)
    const codeCooldown = ref(0)
    
    // 微信登录
    const handleQQLogin = () => {
      window.location.href = '/api/oauth/qq/url'
    }

    return {
      handleQQLogin
    }
  }
}
</script>

<style scoped>
.social-login {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
}

.login-section {
  margin-bottom: 30px;
}

.login-section h3 {
  margin-bottom: 15px;
  color: #333;
  font-size: 18px;
}

.phone-form {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group input {
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 16px;
}

.form-group input:focus {
  outline: none;
  border-color: #007bff;
}

.code-group {
  display: flex;
  gap: 10px;
}

.code-group input {
  flex: 1;
}

.code-btn {
  padding: 12px 16px;
  background: #007bff;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  white-space: nowrap;
}

.code-btn:hover:not(:disabled) {
  background: #0056b3;
}

.code-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.submit-btn {
  padding: 14px;
  background: #28a745;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
}

.submit-btn:hover:not(:disabled) {
  background: #1e7e34;
}

.submit-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.divider {
  text-align: center;
  margin: 30px 0;
  position: relative;
}

.divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0;
  right: 0;
  height: 1px;
  background: #ddd;
}

.divider span {
  background: white;
  padding: 0 15px;
  color: #666;
  font-size: 14px;
  position: relative;
}

.social-section {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.social-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 14px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: white;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.3s;
}

.social-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.social-btn.wechat {
  border-color: #07c160;
  color: #07c160;
}

.social-btn.qq {
  border-color: #12b7f5;
  color: #12b7f5;
}

.social-btn.email {
  border-color: #ff6b6b;
  color: #ff6b6b;
}

.icon {
  width: 20px;
  height: 20px;
  fill: currentColor;
}

@media (max-width: 480px) {
  .social-login {
    padding: 15px;
  }
  
  .social-btn {
    font-size: 14px;
    padding: 12px;
  }
}
</style>