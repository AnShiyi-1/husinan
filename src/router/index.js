import { createRouter, createWebHashHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Home from '../views/Home.vue'
import Gallery from '../views/Gallery.vue'
import Profile from '../views/Profile.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import TestAuth from '../views/TestAuth.vue'
import AuthTest from '../views/AuthTest.vue'
import FullTest from '../views/FullTest.vue'

const routes = [
  {
    path: '/full-test',
    name: 'FullTest',
    component: FullTest,
    meta: {
      title: '全面功能测试 - 情绪画布'
    }
  },
  {
    path: '/auth-test',
    name: 'AuthTest',
    component: AuthTest,
    meta: {
      title: '认证测试 - 情绪画布'
    }
  },
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: {
      title: '创作 - 情绪画布'
    }
  },
  {
    path: '/gallery',
    name: 'Gallery',
    component: Gallery,
    meta: {
      title: '画廊 - 情绪画布'
    }
  },
  {
    path: '/create',
    name: 'Create',
    component: () => import('../views/Create.vue'),
    meta: { requiresAuth: true, title: '创作 - 情绪画布' }
  },
  {
    path: '/profile',
    name: 'Profile',
    component: Profile,
    meta: {
      title: '我的 - 情绪画布',
      requiresAuth: true
    }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: {
      title: '登录 - 情绪画布'
    }
  },
  {
    path: '/register',
    name: 'Register',
    component: Register,
    meta: {
      title: '注册 - 情绪画布'
    }
  },
  {
    path: '/test-auth',
    name: 'TestAuth',
    component: TestAuth,
    meta: {
      title: '认证测试 - 情绪画布'
    }
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

// 路由守卫
router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()
  document.title = to.meta.title || '情绪画布'

  // 确保状态完全同步
  if (!authStore.isLoggedIn && authStore.token) {
    // 如果token存在但状态未同步，强制同步
    try {
      await authStore.fetchUser()
    } catch (error) {
      console.error('获取用户信息失败:', error)
      authStore.clearAuth()
    }
  }

  // 检查是否需要登录
  if (to.meta.requiresAuth) {
    // 双重检查：token和状态
    if (!authStore.isLoggedIn || !authStore.token) {
      // 保存当前路径用于登录后重定向
      localStorage.setItem('redirectPath', to.fullPath)
      next('/login')
      return
    }
  }

  // 已登录用户访问登录/注册页面，重定向到画廊
  if (authStore.isLoggedIn && (to.path === '/login' || to.path === '/register')) {
    next('/gallery')
    return
  }

  next()
})

export default router