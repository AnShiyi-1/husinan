// 测试前端登录功能（使用Pinia store）

// 模拟Pinia store
const authStore = {
  user: null,
  token: null,
  isLoading: false,
  error: null,
  
  // 模拟登录方法
  async login(credentials) {
    this.isLoading = true;
    this.error = null;
    
    try {
      // 模拟API调用
      const response = await fetch('http://localhost:3001/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(credentials)
      });
      
      const data = await response.json();
      
      if (response.ok) {
        // 设置用户和令牌
        this.user = data.user;
        this.token = data.token;
        
        // 模拟存储令牌到localStorage
        localStorage.setItem('token', data.token);
        
        console.log('登录成功:', data.user);
        return data;
      } else {
        throw new Error(data.error || '登录失败');
      }
    } catch (err) {
      this.error = err.message;
      console.error('登录失败:', err.message);
      throw err;
    } finally {
      this.isLoading = false;
    }
  }
};

// 测试函数
async function testAuthStoreLogin() {
  try {
    console.log('开始测试前端登录功能（使用Pinia store）...');
    
    // 登录凭据
    const credentials = {
      username: 'testuser',
      password: 'password123'
    };
    
    // 调用登录方法
    const result = await authStore.login(credentials);
    
    // 验证结果
    if (authStore.user && authStore.token) {
      console.log('前端登录测试成功!');
      console.log('用户信息:', authStore.user);
      console.log('访问令牌:', authStore.token);
      return true;
    } else {
      console.error('前端登录测试失败: 用户信息或令牌缺失');
      return false;
    }
  } catch (error) {
    console.error('前端登录测试失败:', error.message);
    return false;
  }
}

// 运行测试
console.log('运行前端登录测试（使用Pinia store）...');
testAuthStoreLogin().then(success => {
  if (success) {
    console.log('测试完成，前端登录功能正常');
  } else {
    console.log('测试完成，前端登录功能异常');
  }
});