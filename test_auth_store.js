// 测试前端认证存储的登录方法

// 模拟Pinia store
const authStore = {
  user: null,
  token: null,
  isLoading: false,
  error: null,
  
  // 模拟登录方法
  login: async (credentials) => {
    console.log('调用登录方法，凭据:', credentials);
    
    try {
      // 模拟API调用
      const response = await fetch('http://localhost:3001/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(credentials)
      });
      
      const data = await response.json();
      console.log('API响应:', data);
      
      if (response.ok && data.user && data.token) {
        // 模拟设置用户和token
        authStore.user = data.user;
        authStore.token = data.token;
        
        console.log('登录成功!');
        console.log('用户:', authStore.user);
        console.log('Token:', authStore.token.substring(0, 20) + '...');
        
        return data;
      } else {
        throw new Error(data.error || '登录失败');
      }
    } catch (err) {
      console.error('登录失败:', err.message);
      throw err;
    }
  }
};

// 测试登录
async function testAuthStoreLogin() {
  try {
    console.log('开始测试认证存储登录...');
    
    const credentials = {
      username: 'testuser',
      password: 'password123',
      remember: false
    };
    
    const result = await authStore.login(credentials);
    console.log('登录测试完成:', result);
  } catch (error) {
    console.error('登录测试失败:', error.message);
  }
}

testAuthStoreLogin();